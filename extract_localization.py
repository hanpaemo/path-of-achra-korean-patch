from __future__ import annotations

import csv
import json
import struct
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


GAME_DIR = Path(r"D:\SteamLibrary\steamapps\common\Path of Achra")
PCK_PATH = GAME_DIR / "PathofAchra.pck"

WORKSPACE_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = WORKSPACE_DIR / "output"
EXTRACT_DIR = OUTPUT_DIR / "extracted"
REFERENCE_DIR = OUTPUT_DIR / "reference"

TARGET_PREFIXES = ("res://Data/",)
TARGET_PATHS = {
    "res://game-data.json",
    "res://global.gd.remap",
    "res://global.gdc",
    "res://project.binary",
    "res://settings-data.json",
    "res://translate.gd.remap",
    "res://translate.gdc",
}

SCALAR_FIELDS = {
    "Description",
    "Description_Unit",
    "Element",
    "Name",
    "book",
    "brief",
    "description",
    "description_short",
    "description_small",
    "description_start",
    "intro",
    "name",
    "name_color",
    "prayer",
    "recharge_message",
    "rumor",
    "sighting",
    "taunt",
    "text",
    "text_icon",
    "use_recharge_type",
}
LIST_FIELDS = {"phrase", "tags"}


@dataclass(frozen=True)
class PckEntry:
    path: str
    offset: int
    size: int


def ensure_dirs() -> None:
    EXTRACT_DIR.mkdir(parents=True, exist_ok=True)
    REFERENCE_DIR.mkdir(parents=True, exist_ok=True)


def is_target_path(path: str) -> bool:
    return path in TARGET_PATHS or any(path.startswith(prefix) for prefix in TARGET_PREFIXES)


def relative_output_path(pack_path: str) -> Path:
    if pack_path.startswith("res://"):
        pack_path = pack_path[len("res://") :]
    elif pack_path.startswith("user://"):
        pack_path = "@@user@@/" + pack_path[len("user://") :]
    return EXTRACT_DIR / Path(*pack_path.split("/"))


def iter_pck_entries(path: Path) -> tuple[dict[str, int], list[PckEntry]]:
    with path.open("rb") as handle:
        magic = handle.read(4)
        if magic != b"GDPC":
            raise ValueError(f"Unexpected PCK magic: {magic!r}")

        pack_version, engine_major, engine_minor, engine_patch = struct.unpack("<4I", handle.read(16))
        handle.read(16 * 4)
        file_count = struct.unpack("<I", handle.read(4))[0]

        entries: list[PckEntry] = []
        for _ in range(file_count):
            name_len = struct.unpack("<I", handle.read(4))[0]
            name = handle.read(name_len).decode("utf-8", errors="replace").rstrip("\x00")
            padding = (4 - (name_len % 4)) % 4
            if padding:
                handle.read(padding)
            offset = struct.unpack("<Q", handle.read(8))[0]
            size = struct.unpack("<Q", handle.read(8))[0]
            handle.read(16)
            entries.append(PckEntry(name, offset, size))

    header = {
        "pack_format_version": pack_version,
        "engine_major": engine_major,
        "engine_minor": engine_minor,
        "engine_patch": engine_patch,
        "file_count": len(entries),
    }
    return header, entries


def extract_target_files(entries: Iterable[PckEntry]) -> list[dict[str, object]]:
    extracted: list[dict[str, object]] = []
    with PCK_PATH.open("rb") as handle:
        for entry in entries:
            if not is_target_path(entry.path):
                continue

            handle.seek(entry.offset)
            data = handle.read(entry.size)

            out_path = relative_output_path(entry.path)
            out_path.parent.mkdir(parents=True, exist_ok=True)
            out_path.write_bytes(data)

            extracted.append(
                {
                    "path": entry.path,
                    "output_path": str(out_path),
                    "size": entry.size,
                }
            )

    extracted.sort(key=lambda item: item["path"])
    return extracted


def should_keep_string(value: str) -> bool:
    stripped = value.strip()
    if not stripped:
        return False
    if stripped.lower() == "none":
        return False
    if stripped.startswith("res://"):
        return False
    return True


def iter_translatable_values(value: object, field: str) -> Iterable[tuple[str, str]]:
    if field in SCALAR_FIELDS and isinstance(value, str):
        if should_keep_string(value):
            yield "", value
        return

    if field in LIST_FIELDS and isinstance(value, list):
        for index, item in enumerate(value):
            if isinstance(item, str) and should_keep_string(item):
                yield str(index), item


def build_occurrence_rows(extracted_files: Iterable[dict[str, object]]) -> tuple[list[list[object]], list[list[object]], dict[str, object]]:
    occurrence_rows: list[list[object]] = []
    unique_map: dict[str, dict[str, object]] = {}
    table_counts: dict[str, dict[str, object]] = {}
    field_counts: Counter[str] = Counter()

    for extracted in extracted_files:
        pack_path = str(extracted["path"])
        if not pack_path.startswith("res://Data/Table_") or not pack_path.endswith(".json"):
            continue

        file_path = Path(str(extracted["output_path"]))
        table_name = file_path.stem
        payload = json.loads(file_path.read_text(encoding="utf-8"))
        if not isinstance(payload, dict):
            continue

        table_occurrences = 0
        for entry_id, entry in payload.items():
            if not isinstance(entry, dict):
                continue
            for field, value in entry.items():
                for list_index, english in iter_translatable_values(value, field):
                    occurrence_rows.append([table_name, entry_id, field, list_index, english])
                    table_occurrences += 1
                    field_counts[field] += 1

                    unique_entry = unique_map.setdefault(
                        english,
                        {
                            "occurrence_count": 0,
                            "examples": [],
                        },
                    )
                    unique_entry["occurrence_count"] += 1
                    if len(unique_entry["examples"]) < 5:
                        example = f"{table_name}:{entry_id}:{field}"
                        if list_index:
                            example += f"[{list_index}]"
                        unique_entry["examples"].append(example)

        table_counts[table_name] = {
            "entry_count": len(payload),
            "translatable_occurrences": table_occurrences,
        }

    unique_rows = [
        [english, meta["occurrence_count"], " | ".join(meta["examples"])]
        for english, meta in sorted(unique_map.items())
    ]

    summary = {
        "table_counts": table_counts,
        "field_counts": dict(field_counts.most_common()),
        "occurrence_count": len(occurrence_rows),
        "unique_string_count": len(unique_rows),
    }
    return occurrence_rows, unique_rows, summary


def write_csv(path: Path, header: list[str], rows: Iterable[list[object]]) -> None:
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(header)
        writer.writerows(rows)


def main() -> None:
    ensure_dirs()

    header, entries = iter_pck_entries(PCK_PATH)
    extracted_files = extract_target_files(entries)
    occurrence_rows, unique_rows, summary = build_occurrence_rows(extracted_files)

    occurrences_path = REFERENCE_DIR / "strings-occurrences-en.csv"
    unique_path = REFERENCE_DIR / "strings-unique-en.csv"

    write_csv(
        occurrences_path,
        ["table", "entry_id", "field", "index", "english"],
        occurrence_rows,
    )
    write_csv(
        unique_path,
        ["english", "occurrence_count", "examples"],
        unique_rows,
    )

    inventory = {
        "game_dir": str(GAME_DIR),
        "pck_path": str(PCK_PATH),
        "pck_header": header,
        "extracted_files": extracted_files,
        "translation_summary": summary,
        "reference_outputs": {
            "strings_occurrences": str(occurrences_path),
            "strings_unique": str(unique_path),
        },
    }

    inventory_path = OUTPUT_DIR / "inventory.json"
    inventory_path.write_text(
        json.dumps(inventory, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    print(f"Wrote extracted files to {EXTRACT_DIR}")
    print(f"Wrote reference CSVs to {REFERENCE_DIR}")
    print(f"Wrote inventory to {inventory_path}")


if __name__ == "__main__":
    main()
