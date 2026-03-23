from __future__ import annotations

import argparse
import csv
import hashlib
import json
import shutil
import struct
from dataclasses import asdict, dataclass
from pathlib import Path


GAME_DIR = Path(r"D:\SteamLibrary\steamapps\common\Path of Achra")
DEFAULT_PCK_PATH = GAME_DIR / "PathofAchra.pck"

WORKSPACE_DIR = Path(__file__).resolve().parent
DEFAULT_EXTRACTED_DIR = WORKSPACE_DIR / "output" / "extracted"
DEFAULT_TRANSLATION_DIR = WORKSPACE_DIR / "translation" / "ko"
DEFAULT_OUTPUT_DIR = WORKSPACE_DIR / "build"

PATCH_DATA_DIRNAME = "patch_data"
PATCH_PACK_NAME = "PathofAchra-ko-patch.pck"
FULL_PACK_NAME = "PathofAchra-ko-full.pck"
MANIFEST_NAME = "build-manifest.json"
PCK_ALIGNMENT = 16
COPY_CHUNK_SIZE = 1024 * 1024

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
    "title",
    "use_recharge_type",
}
LIST_FIELDS = {"phrase", "tags"}

FONT_AUTO_CANDIDATES = (
    Path("font.ttf"),
    Path("font.otf"),
    Path("font.ttc"),
    Path("font") / "font.ttf",
    Path("font") / "font.otf",
    Path("font") / "font.ttc",
)
FONT_REPLACE_TARGETS = (
    "res://alagard.ttf",
    "res://Fonts/Pixolletta8px.ttf",
    "res://Fonts/SilomBol.ttf",
    "res://Fonts/gothic_pixel.ttf",
    "res://Fonts/honey-room/HoneyRoom.ttf",
)

TSCN_REPLACE_MAP = {
    "res://Scenes/Start_Menu.tscn": "Start_Menu.tscn",
    "res://Scenes/UI_GameMenu.tscn": "UI_GameMenu.tscn",
    "res://Scenes/First_Menu.tscn": "First_Menu.tscn",
    "res://Scenes/Game.tscn": "Game.tscn",
    "res://Scenes/Graveyard.tscn": "Graveyard.tscn",
    "res://Scenes/ScoreScreen.tscn": "ScoreScreen.tscn",
    "res://Scenes/AbilityBook.tscn": "AbilityBook.tscn",
    "res://Scenes/Armory.tscn": "Armory.tscn",
    "res://Scenes/Bestiary.tscn": "Bestiary.tscn",
    "res://Scenes/Credits.tscn": "Credits.tscn",
    "res://Scenes/Feats.tscn": "Feats.tscn",
    "res://Scenes/UI_Inv.tscn": "UI_Inv.tscn",
    "res://Scenes/UI_Level_Up.tscn": "UI_Level_Up.tscn",
    "res://Scenes/UI_Log.tscn": "UI_Log.tscn",
    "res://Scenes/UI_Prestige.tscn": "UI_Prestige.tscn",
    "res://Scenes/UI_Traits_Basic.tscn": "UI_Traits_Basic.tscn",
    "res://Scenes/Universal.tscn": "Universal.tscn",
}

GDC_REPLACE_MAP = {
    "res://translate.gdc": "translate.gdc",
    "res://RouterEvents_OnAttack.gdc": "RouterEvents_OnAttack.gdc",
    "res://RouterEvents_OnDamage.gdc": "RouterEvents_OnDamage.gdc",
    "res://RouterEvents_OnDeath.gdc": "RouterEvents_OnDeath.gdc",
    "res://RouterEvents_OnEnterLevel.gdc": "RouterEvents_OnEnterLevel.gdc",
    "res://RouterEvents_OnHit.gdc": "RouterEvents_OnHit.gdc",
    "res://RouterEvents_OnIntervention.gdc": "RouterEvents_OnIntervention.gdc",
    "res://Scenes/AbilityBook.gdc": "AbilityBook.gdc",
    "res://Scenes/Armory.gdc": "Armory.gdc",
    "res://Scenes/Bestiary.gdc": "Bestiary.gdc",
    "res://Scenes/ButtonAutoLevel.gdc": "ButtonAutoLevel.gdc",
    "res://Scenes/Continent.gdc": "Continent.gdc",
    "res://Scenes/Game.gdc": "Game.gdc",
    "res://Scenes/Enemy.gdc": "Enemy.gdc",
    "res://Scenes/UI_Enemies.gdc": "UI_Enemies.gdc",
    "res://Scenes/DeathScreen.gdc": "DeathScreen.gdc",
    "res://Scenes/Feats.gdc": "Feats.gdc",
    "res://Scenes/Graveyard.gdc": "Graveyard.gdc",
    "res://Scenes/Player.gdc": "Player.gdc",
    "res://Scenes/ScoreScreen.gdc": "ScoreScreen.gdc",
    "res://Scenes/Start_Menu.gdc": "Start_Menu.gdc",
    "res://Scenes/UI_GameMenu.gdc": "UI_GameMenu.gdc",
    "res://Scenes/UI_Inv.gdc": "UI_Inv.gdc",
    "res://Scenes/UI_Inventory.gdc": "UI_Inventory.gdc",
    "res://Scenes/UI_Level_Up.gdc": "UI_Level_Up.gdc",
    "res://Scenes/UI_Prestige.gdc": "UI_Prestige.gdc",
    "res://Scenes/UI_Traits_Basic.gdc": "UI_Traits_Basic.gdc",
    "res://ToolCycler.gdc": "ToolCycler.gdc",
    "res://ToolLevelUp.gdc": "ToolLevelUp.gdc",
    "res://ToolMagicMaker.gdc": "ToolMagicMaker.gdc",
    "res://ToolMessageCreator.gdc": "ToolMessageCreator.gdc",
    "res://ToolPrestigeGiver.gdc": "ToolPrestigeGiver.gdc",
    "res://ToolSpawnUnit.gdc": "ToolSpawnUnit.gdc",
    "res://RouterEvents_OnApplyBuff.gdc": "RouterEvents_OnApplyBuff.gdc",
    "res://RouterEvents_OnRemoveBuff.gdc": "RouterEvents_OnRemoveBuff.gdc",
    "res://Scenes/Tile.gdc": "Tile.gdc",
    "res://Scenes/UI_Log.gdc": "UI_Log.gdc",
    "res://LRacesClasses.gdc": "LRacesClasses.gdc",
    "res://LClasses.gdc": "LClasses.gdc",
    "res://LEnemies.gdc": "LEnemies.gdc",
    "res://LAllies.gdc": "LAllies.gdc",
    "res://ToolPretaMaker.gdc": "ToolPretaMaker.gdc",
    "res://Scenes/First_Menu.gdc": "First_Menu.gdc",
    "res://Process_Queue_Actions_Effects.gdc": "Process_Queue_Actions_Effects.gdc",
    "res://Process_Fight.gdc": "Process_Fight.gdc",
    "res://Scenes/UI.gdc": "UI.gdc",
    "res://Scenes/SummonButton.gdc": "SummonButton.gdc",
    "res://Scenes/GameBars.gdc": "GameBars.gdc",
    "res://Scenes/Button.gdc": "Button.gdc",
    "res://Scenes/Button_Bag.gdc": "Button_Bag.gdc",
    "res://ToolInvokes.gdc": "ToolInvokes.gdc",
    "res://ToolProem.gdc": "ToolProem.gdc",
    "res://ToolStatMods.gdc": "ToolStatMods.gdc",
    "res://ToolMagicMaker.gdc": "ToolMagicMaker.gdc",
    "res://ProcessBuffs.gdc": "ProcessBuffs.gdc",
    "res://Process_Text.gdc": "Process_Text.gdc",
    "res://Process_Queue.gdc": "Process_Queue.gdc",
    "res://RouterEvents_OnDodge.gdc": "RouterEvents_OnDodge.gdc",
    "res://RouterEvents_OnBlock.gdc": "RouterEvents_OnBlock.gdc",
    "res://RouterEvents_OnHeal.gdc": "RouterEvents_OnHeal.gdc",
    "res://RouterEvents_OnInvoke.gdc": "RouterEvents_OnInvoke.gdc",
    "res://RouterEvents_OnMove.gdc": "RouterEvents_OnMove.gdc",
    "res://RouterEvents_OnSpawned.gdc": "RouterEvents_OnSpawned.gdc",
    "res://RouterEvents_Summon.gdc": "RouterEvents_Summon.gdc",
    "res://RouterEvents_GameTurn.gdc": "RouterEvents_GameTurn.gdc",
    "res://RouterEvents_OnLearn.gdc": "RouterEvents_OnLearn.gdc",
    "res://RouterEvents_OnLevelUp.gdc": "RouterEvents_OnLevelUp.gdc",
    "res://RouterEvents_OnPickup.gdc": "RouterEvents_OnPickup.gdc",
    "res://RouterEvents_OnShrugOff.gdc": "RouterEvents_OnShrugOff.gdc",
    "res://StatePlayerSheet.gdc": "StatePlayerSheet.gdc",
    "res://Scenes/UI_God.gdc": "UI_God.gdc",
    "res://Scenes/UI_Popup.gdc": "UI_Popup.gdc",
    "res://Scenes/DeckbuttonGrid.gdc": "DeckbuttonGrid.gdc",
    "res://Scenes/Verse.gdc": "Verse.gdc",
    "res://Scenes/InfoButtons.gdc": "InfoButtons.gdc",
}


@dataclass(frozen=True)
class PckHeader:
    pack_format_version: int
    engine_major: int
    engine_minor: int
    engine_patch: int


@dataclass(frozen=True)
class PckEntry:
    path: str
    offset: int
    size: int
    md5: bytes


@dataclass(frozen=True)
class ReplacementAsset:
    pack_path: str
    disk_path: Path
    data: bytes
    category: str


@dataclass(frozen=True)
class PackWriteItem:
    path: str
    size: int
    md5: bytes
    data: bytes | None = None
    source_entry: PckEntry | None = None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build Korean patch data and PCK outputs for Path of Achra.",
    )
    parser.add_argument(
        "--pck-path",
        type=Path,
        default=DEFAULT_PCK_PATH,
        help="Source PathofAchra.pck to rebuild.",
    )
    parser.add_argument(
        "--extracted-dir",
        type=Path,
        default=DEFAULT_EXTRACTED_DIR,
        help="Directory containing extracted JSON assets.",
    )
    parser.add_argument(
        "--translation-dir",
        type=Path,
        default=DEFAULT_TRANSLATION_DIR,
        help="Directory containing strings-ko.csv and glossary-ko.csv.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory for patch_data, manifest, and built PCK outputs.",
    )
    parser.add_argument(
        "--font-path",
        type=Path,
        help="Optional Hangul-capable font file to copy over the game's shipped font assets.",
    )
    return parser.parse_args()


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def normalize_translation(value: str) -> str:
    return value.replace("\r\n", "\n")


def load_occurrence_overrides(path: Path) -> dict[str, str]:
    overrides: dict[str, str] = {}
    for row in read_rows(path):
        korean = normalize_translation(row["korean"])
        if korean.strip():
            overrides[row["key"]] = korean
    return overrides


def load_glossary_overrides(path: Path) -> dict[str, str]:
    overrides: dict[str, str] = {}
    for row in read_rows(path):
        korean = normalize_translation(row["korean"])
        if korean.strip():
            overrides[row["english"]] = korean
    return overrides


def should_keep_string(value: str) -> bool:
    stripped = value.strip()
    if not stripped:
        return False
    if stripped.lower() == "none":
        return False
    if stripped.startswith("res://"):
        return False
    return True


def occurrence_key(table: str, entry_id: str, field: str, index: str) -> str:
    return "|".join((table, entry_id, field, index))


def relative_output_path(pack_path: str) -> Path:
    if pack_path.startswith("res://"):
        pack_path = pack_path[len("res://") :]
    elif pack_path.startswith("user://"):
        pack_path = "@@user@@/" + pack_path[len("user://") :]
    return Path(*pack_path.split("/"))


def extracted_file_to_pack_path(path: Path, extracted_dir: Path) -> str:
    relative_path = path.resolve().relative_to(extracted_dir.resolve())
    return "res://" + "/".join(relative_path.parts)


def find_font_path(translation_dir: Path, explicit_font_path: Path | None) -> Path | None:
    if explicit_font_path is not None:
        if not explicit_font_path.exists():
            raise FileNotFoundError(f"Font path does not exist: {explicit_font_path}")
        return explicit_font_path

    for candidate in FONT_AUTO_CANDIDATES:
        candidate_path = translation_dir / candidate
        if candidate_path.exists():
            return candidate_path
    return None


def lookup_translation(
    key: str,
    english: str,
    occurrence_overrides: dict[str, str],
    glossary_overrides: dict[str, str],
) -> tuple[str | None, str | None]:
    if key in occurrence_overrides:
        return occurrence_overrides[key], "occurrence"
    if english in glossary_overrides:
        return glossary_overrides[english], "glossary"
    return None, None


def iter_pck_entries(path: Path) -> tuple[PckHeader, list[PckEntry]]:
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
            md5 = handle.read(16)
            entries.append(PckEntry(name, offset, size, md5))

    return PckHeader(pack_version, engine_major, engine_minor, engine_patch), entries


def ensure_output_dir(output_dir: Path) -> Path:
    patch_data_dir = output_dir / PATCH_DATA_DIRNAME
    if output_dir.exists():
        shutil.rmtree(output_dir)
    patch_data_dir.mkdir(parents=True, exist_ok=True)
    return patch_data_dir


def build_json_replacements(
    extracted_dir: Path,
    patch_data_dir: Path,
    occurrence_overrides: dict[str, str],
    glossary_overrides: dict[str, str],
) -> tuple[dict[str, ReplacementAsset], dict[str, object]]:
    replacements: dict[str, ReplacementAsset] = {}
    table_summaries: list[dict[str, object]] = []
    translated_occurrences = 0
    translated_by_source = {"occurrence": 0, "glossary": 0}

    for file_path in sorted((extracted_dir / "Data").glob("Table_*.json")):
        table_name = file_path.stem
        payload = json.loads(file_path.read_text(encoding="utf-8"))
        if not isinstance(payload, dict):
            continue

        file_changed = False
        file_changes = 0

        for entry_id, entry in payload.items():
            if not isinstance(entry, dict):
                continue

            for field, value in list(entry.items()):
                if field in SCALAR_FIELDS and isinstance(value, str) and should_keep_string(value):
                    key = occurrence_key(table_name, entry_id, field, "")
                    translated, source = lookup_translation(key, value, occurrence_overrides, glossary_overrides)
                    if translated is not None and translated != value:
                        entry[field] = translated
                        file_changed = True
                        file_changes += 1
                        translated_occurrences += 1
                        translated_by_source[source] += 1
                    continue

                if field in LIST_FIELDS and isinstance(value, list):
                    list_changed = False
                    new_list = list(value)
                    for index, item in enumerate(value):
                        if not isinstance(item, str) or not should_keep_string(item):
                            continue
                        key = occurrence_key(table_name, entry_id, field, str(index))
                        translated, source = lookup_translation(key, item, occurrence_overrides, glossary_overrides)
                        if translated is not None and translated != item:
                            new_list[index] = translated
                            list_changed = True
                            file_changes += 1
                            translated_occurrences += 1
                            translated_by_source[source] += 1
                    if list_changed:
                        entry[field] = new_list
                        file_changed = True

        if not file_changed:
            continue

        pack_path = extracted_file_to_pack_path(file_path, extracted_dir)
        output_path = patch_data_dir / relative_output_path(pack_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        data = (json.dumps(payload, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
        output_path.write_bytes(data)

        replacements[pack_path] = ReplacementAsset(pack_path, output_path, data, "json")
        table_summaries.append(
            {
                "table": table_name,
                "translated_occurrences": file_changes,
                "pack_path": pack_path,
            }
        )

    summary = {
        "json_file_count": len(table_summaries),
        "translated_occurrences": translated_occurrences,
        "translated_by_source": translated_by_source,
        "tables": table_summaries,
    }
    return replacements, summary


def build_font_replacements(
    translation_dir: Path,
    patch_data_dir: Path,
    explicit_font_path: Path | None,
) -> tuple[dict[str, ReplacementAsset], dict[str, object]]:
    font_path = find_font_path(translation_dir, explicit_font_path)
    if font_path is None:
        return {}, {"enabled": False}

    font_data = font_path.read_bytes()
    replacements: dict[str, ReplacementAsset] = {}
    for pack_path in FONT_REPLACE_TARGETS:
        output_path = patch_data_dir / relative_output_path(pack_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(font_data)
        replacements[pack_path] = ReplacementAsset(pack_path, output_path, font_data, "font")

    summary = {
        "enabled": True,
        "source_font": str(font_path),
        "target_paths": list(FONT_REPLACE_TARGETS),
        "target_count": len(FONT_REPLACE_TARGETS),
        "font_size_bytes": len(font_data),
    }
    return replacements, summary


def build_tscn_replacements(
    patch_data_dir: Path,
    translated_tscn_dir: Path | None = None,
) -> tuple[dict[str, ReplacementAsset], dict[str, object]]:
    if translated_tscn_dir is None:
        translated_tscn_dir = WORKSPACE_DIR / "output" / "translated_tscn"

    replacements: dict[str, ReplacementAsset] = {}
    replaced = []
    for pack_path, tscn_name in TSCN_REPLACE_MAP.items():
        source_path = translated_tscn_dir / tscn_name
        if not source_path.exists():
            continue
        tscn_data = source_path.read_bytes()
        output_path = patch_data_dir / relative_output_path(pack_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(tscn_data)
        replacements[pack_path] = ReplacementAsset(pack_path, output_path, tscn_data, "tscn")
        replaced.append(pack_path)

    summary: dict[str, object] = {
        "enabled": bool(replaced),
        "replaced": replaced,
        "count": len(replaced),
    }
    return replacements, summary


def build_gdc_replacements(
    patch_data_dir: Path,
    compiled_dir: Path | None = None,
) -> tuple[dict[str, ReplacementAsset], dict[str, object]]:
    if compiled_dir is None:
        compiled_dir = WORKSPACE_DIR / "output" / "compiled"

    replacements: dict[str, ReplacementAsset] = {}
    replaced = []
    for pack_path, compiled_name in GDC_REPLACE_MAP.items():
        source_path = compiled_dir / compiled_name
        if not source_path.exists():
            continue
        gdc_data = source_path.read_bytes()
        output_path = patch_data_dir / relative_output_path(pack_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(gdc_data)
        replacements[pack_path] = ReplacementAsset(pack_path, output_path, gdc_data, "gdc")
        replaced.append(pack_path)

    summary: dict[str, object] = {
        "enabled": bool(replaced),
        "replaced": replaced,
        "count": len(replaced),
    }
    return replacements, summary


def name_record_size(path: str) -> tuple[bytes, int]:
    raw = path.encode("utf-8") + b"\x00"
    padded_len = (len(raw) + 3) & ~3  # round up to 4-byte boundary
    name_bytes = raw + b"\x00" * (padded_len - len(raw))
    record_size = 4 + padded_len + 8 + 8 + 16
    return name_bytes, record_size


def align_up(value: int, alignment: int) -> int:
    return (value + alignment - 1) // alignment * alignment


def build_patch_pack_items(replacements: dict[str, ReplacementAsset]) -> list[PackWriteItem]:
    items: list[PackWriteItem] = []
    for asset in sorted(replacements.values(), key=lambda item: item.pack_path):
        items.append(
            PackWriteItem(
                path=asset.pack_path,
                size=len(asset.data),
                md5=hashlib.md5(asset.data).digest(),
                data=asset.data,
            )
        )
    return items


def build_full_pack_items(entries: list[PckEntry], replacements: dict[str, ReplacementAsset]) -> list[PackWriteItem]:
    items: list[PackWriteItem] = []
    for entry in entries:
        replacement = replacements.get(entry.path)
        if replacement is not None:
            items.append(
                PackWriteItem(
                    path=entry.path,
                    size=len(replacement.data),
                    md5=hashlib.md5(replacement.data).digest(),
                    data=replacement.data,
                )
            )
            continue

        items.append(
            PackWriteItem(
                path=entry.path,
                size=entry.size,
                md5=entry.md5,
                source_entry=entry,
            )
        )
    return items


def write_pck(
    output_path: Path,
    header: PckHeader,
    items: list[PackWriteItem],
    original_pck_path: Path | None = None,
) -> None:
    record_data: list[tuple[PackWriteItem, bytes, int, int]] = []
    header_size = 4 + 16 + (16 * 4) + 4
    for item in items:
        name_bytes, record_size = name_record_size(item.path)
        record_data.append((item, name_bytes, len(name_bytes), record_size))
        header_size += record_size

    data_offset = align_up(header_size, PCK_ALIGNMENT)
    written_records: list[tuple[PackWriteItem, bytes, int, int]] = []
    for item, name_bytes, name_len, _ in record_data:
        written_records.append((item, name_bytes, name_len, data_offset))
        data_offset = align_up(data_offset + item.size, PCK_ALIGNMENT)

    with output_path.open("wb") as out_handle:
        out_handle.write(b"GDPC")
        out_handle.write(
            struct.pack(
                "<4I",
                header.pack_format_version,
                header.engine_major,
                header.engine_minor,
                header.engine_patch,
            )
        )
        out_handle.write(b"\x00" * (16 * 4))
        out_handle.write(struct.pack("<I", len(items)))

        for item, name_bytes, name_len, item_offset in written_records:
            out_handle.write(struct.pack("<I", name_len))
            out_handle.write(name_bytes)
            out_handle.write(struct.pack("<Q", item_offset))
            out_handle.write(struct.pack("<Q", item.size))
            out_handle.write(item.md5)

        if out_handle.tell() < written_records[0][3] if written_records else False:
            out_handle.write(b"\x00" * (written_records[0][3] - out_handle.tell()))

        source_handle = original_pck_path.open("rb") if original_pck_path is not None else None
        try:
            for item, _, _, item_offset in written_records:
                if out_handle.tell() < item_offset:
                    out_handle.write(b"\x00" * (item_offset - out_handle.tell()))

                if item.data is not None:
                    out_handle.write(item.data)
                elif item.source_entry is not None and source_handle is not None:
                    source_handle.seek(item.source_entry.offset)
                    remaining = item.source_entry.size
                    while remaining > 0:
                        chunk = source_handle.read(min(COPY_CHUNK_SIZE, remaining))
                        if not chunk:
                            raise IOError(f"Unexpected EOF while copying {item.source_entry.path}")
                        out_handle.write(chunk)
                        remaining -= len(chunk)
                else:
                    raise ValueError(f"No data source available for {item.path}")

                aligned = align_up(out_handle.tell(), PCK_ALIGNMENT)
                if aligned > out_handle.tell():
                    out_handle.write(b"\x00" * (aligned - out_handle.tell()))
        finally:
            if source_handle is not None:
                source_handle.close()


def verify_pack_contains(pck_path: Path, expectations: dict[str, bytes]) -> None:
    _, entries = iter_pck_entries(pck_path)
    entry_map = {entry.path: entry for entry in entries}
    with pck_path.open("rb") as handle:
        for pack_path, expected_data in expectations.items():
            entry = entry_map.get(pack_path)
            if entry is None:
                raise AssertionError(f"Built PCK is missing {pack_path}")
            handle.seek(entry.offset)
            actual = handle.read(entry.size)
            if actual != expected_data:
                raise AssertionError(f"Built PCK data mismatch for {pack_path}")


def write_manifest(
    output_path: Path,
    pck_path: Path,
    extracted_dir: Path,
    translation_dir: Path,
    header: PckHeader,
    replacements: dict[str, ReplacementAsset],
    json_summary: dict[str, object],
    font_summary: dict[str, object],
    patch_pack_path: Path | None,
    full_pack_path: Path | None,
) -> None:
    manifest = {
        "pck_path": str(pck_path),
        "extracted_dir": str(extracted_dir),
        "translation_dir": str(translation_dir),
        "pck_header": asdict(header),
        "replacement_count": len(replacements),
        "replacement_files": [
            {
                "pack_path": asset.pack_path,
                "disk_path": str(asset.disk_path),
                "size": len(asset.data),
                "category": asset.category,
            }
            for asset in sorted(replacements.values(), key=lambda item: item.pack_path)
        ],
        "json_summary": json_summary,
        "font_summary": font_summary,
        "build_outputs": {
            "patch_pack": str(patch_pack_path) if patch_pack_path is not None else None,
            "full_pack": str(full_pack_path) if full_pack_path is not None else None,
        },
    }
    output_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")


def main() -> None:
    args = parse_args()

    occurrence_csv = args.translation_dir / "strings-ko.csv"
    glossary_csv = args.translation_dir / "glossary-ko.csv"
    missing = [path for path in (args.pck_path, args.extracted_dir, occurrence_csv, glossary_csv) if not path.exists()]
    if missing:
        missing_text = ", ".join(str(path) for path in missing)
        raise FileNotFoundError(f"Missing required path(s): {missing_text}")

    occurrence_overrides = load_occurrence_overrides(occurrence_csv)
    glossary_overrides = load_glossary_overrides(glossary_csv)
    patch_data_dir = ensure_output_dir(args.output_dir)

    header, entries = iter_pck_entries(args.pck_path)
    json_replacements, json_summary = build_json_replacements(
        args.extracted_dir,
        patch_data_dir,
        occurrence_overrides,
        glossary_overrides,
    )
    font_replacements, font_summary = build_font_replacements(
        args.translation_dir,
        patch_data_dir,
        args.font_path,
    )
    gdc_replacements, gdc_summary = build_gdc_replacements(patch_data_dir)
    tscn_replacements, tscn_summary = build_tscn_replacements(patch_data_dir)

    replacements = {**json_replacements, **font_replacements, **gdc_replacements, **tscn_replacements}
    patch_pack_path: Path | None = None
    full_pack_path: Path | None = None

    if replacements:
        patch_items = build_patch_pack_items(replacements)
        patch_pack_path = args.output_dir / PATCH_PACK_NAME
        write_pck(patch_pack_path, header, patch_items)
        verify_pack_contains(patch_pack_path, {item.pack_path: item.data for item in replacements.values()})

        full_items = build_full_pack_items(entries, replacements)
        full_pack_path = args.output_dir / FULL_PACK_NAME
        write_pck(full_pack_path, header, full_items, original_pck_path=args.pck_path)
        verify_pack_contains(full_pack_path, {item.pack_path: item.data for item in replacements.values()})

    manifest_path = args.output_dir / MANIFEST_NAME
    write_manifest(
        manifest_path,
        args.pck_path,
        args.extracted_dir,
        args.translation_dir,
        header,
        replacements,
        json_summary,
        font_summary,
        patch_pack_path,
        full_pack_path,
    )

    print(f"Loaded occurrence overrides: {len(occurrence_overrides)}")
    print(f"Loaded glossary overrides: {len(glossary_overrides)}")
    print(f"Replacement files prepared: {len(replacements)}")
    print(f"Patch data directory: {patch_data_dir}")
    if patch_pack_path is not None and full_pack_path is not None:
        print(f"Patch PCK: {patch_pack_path}")
        print(f"Full replacement PCK: {full_pack_path}")
    else:
        print("No translated rows or font overrides were found, so no PCK was built.")
    print(f"Manifest: {manifest_path}")


if __name__ == "__main__":
    main()
