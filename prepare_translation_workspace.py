from __future__ import annotations

import csv
import shutil
from pathlib import Path


WORKSPACE_DIR = Path(__file__).resolve().parent
REFERENCE_DIR = WORKSPACE_DIR / "output" / "reference"
TRANSLATION_SOURCE_DIR = WORKSPACE_DIR / "translation" / "source"
TRANSLATION_KO_DIR = WORKSPACE_DIR / "translation" / "ko"

OCCURRENCE_REFERENCE = REFERENCE_DIR / "strings-occurrences-en.csv"
UNIQUE_REFERENCE = REFERENCE_DIR / "strings-unique-en.csv"

OCCURRENCE_TEMPLATE = TRANSLATION_KO_DIR / "strings-ko.csv"
UNIQUE_TEMPLATE = TRANSLATION_KO_DIR / "glossary-ko.csv"


def ensure_dirs() -> None:
    TRANSLATION_SOURCE_DIR.mkdir(parents=True, exist_ok=True)
    TRANSLATION_KO_DIR.mkdir(parents=True, exist_ok=True)


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def read_existing_map(path: Path, key_field: str) -> dict[str, dict[str, str]]:
    if not path.exists():
        return {}
    return {row[key_field]: row for row in read_rows(path)}


def copy_reference(path: Path) -> None:
    shutil.copy2(path, TRANSLATION_SOURCE_DIR / path.name)


def occurrence_key(row: dict[str, str]) -> str:
    return "|".join((row["table"], row["entry_id"], row["field"], row["index"]))


def write_occurrence_template() -> None:
    reference_rows = read_rows(OCCURRENCE_REFERENCE)
    existing = read_existing_map(OCCURRENCE_TEMPLATE, "key")

    with OCCURRENCE_TEMPLATE.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["key", "table", "entry_id", "field", "index", "english", "korean"])
        for row in reference_rows:
            key = occurrence_key(row)
            korean = existing.get(key, {}).get("korean", "")
            writer.writerow(
                [
                    key,
                    row["table"],
                    row["entry_id"],
                    row["field"],
                    row["index"],
                    row["english"],
                    korean,
                ]
            )


def write_unique_template() -> None:
    reference_rows = read_rows(UNIQUE_REFERENCE)
    existing = read_existing_map(UNIQUE_TEMPLATE, "english")

    with UNIQUE_TEMPLATE.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["english", "korean", "occurrence_count", "examples"])
        for row in reference_rows:
            writer.writerow(
                [
                    row["english"],
                    existing.get(row["english"], {}).get("korean", ""),
                    row["occurrence_count"],
                    row["examples"],
                ]
            )


def main() -> None:
    ensure_dirs()

    missing = [path for path in (OCCURRENCE_REFERENCE, UNIQUE_REFERENCE) if not path.exists()]
    if missing:
        missing_text = ", ".join(str(path) for path in missing)
        raise FileNotFoundError(f"Missing reference file(s): {missing_text}. Run extract_localization.py first.")

    copy_reference(OCCURRENCE_REFERENCE)
    copy_reference(UNIQUE_REFERENCE)
    write_occurrence_template()
    write_unique_template()

    print(f"Copied reference CSVs to {TRANSLATION_SOURCE_DIR}")
    print(f"Wrote translation templates to {TRANSLATION_KO_DIR}")


if __name__ == "__main__":
    main()
