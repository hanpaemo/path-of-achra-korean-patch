from __future__ import annotations

import csv
import json
from pathlib import Path


WORKSPACE_DIR = Path(__file__).resolve().parent
TRANSLATION_DIR = WORKSPACE_DIR / "translation" / "ko"

STRINGS_CSV = TRANSLATION_DIR / "strings-ko.csv"
GLOSSARY_CSV = TRANSLATION_DIR / "glossary-ko.csv"


def load_rows(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def translated_count(rows: list[dict[str, str]], field: str = "korean") -> int:
    return sum(1 for row in rows if row.get(field, "").strip())


def build_summary() -> dict[str, object]:
    strings_rows = load_rows(STRINGS_CSV)
    glossary_rows = load_rows(GLOSSARY_CSV)

    strings_done = translated_count(strings_rows)
    glossary_done = translated_count(glossary_rows)

    return {
        "translation_dir": str(TRANSLATION_DIR),
        "strings": {
            "translated": strings_done,
            "total": len(strings_rows),
            "percent": round((strings_done / len(strings_rows) * 100) if strings_rows else 0.0, 2),
        },
        "glossary": {
            "translated": glossary_done,
            "total": len(glossary_rows),
            "percent": round((glossary_done / len(glossary_rows) * 100) if glossary_rows else 0.0, 2),
        },
    }


def main() -> None:
    missing = [path for path in (STRINGS_CSV, GLOSSARY_CSV) if not path.exists()]
    if missing:
        missing_text = ", ".join(str(path) for path in missing)
        raise FileNotFoundError(f"Missing required CSV file(s): {missing_text}")

    print(json.dumps(build_summary(), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
