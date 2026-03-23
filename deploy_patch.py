from __future__ import annotations

import argparse
import shutil
from pathlib import Path


GAME_DIR = Path(r"D:\SteamLibrary\steamapps\common\Path of Achra")
WORKSPACE_DIR = Path(__file__).resolve().parent

DEFAULT_SOURCE = WORKSPACE_DIR / "build" / "PathofAchra-ko-full.pck"
DEFAULT_TARGET = GAME_DIR / "PathofAchra.pck"
DEFAULT_BACKUP = GAME_DIR / "PathofAchra.pck.original"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Install or restore the Path of Achra Korean patch.")
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE, help="Built full replacement PCK.")
    parser.add_argument("--target", type=Path, default=DEFAULT_TARGET, help="Live game PCK path.")
    parser.add_argument("--backup", type=Path, default=DEFAULT_BACKUP, help="Backup path for the original game PCK.")
    parser.add_argument("--restore", action="store_true", help="Restore from backup instead of installing the patch.")
    return parser.parse_args()


def install_patch(source: Path, target: Path, backup: Path) -> None:
    if not source.exists():
        raise FileNotFoundError(f"Patch source does not exist: {source}")
    if not target.exists():
        raise FileNotFoundError(f"Game target does not exist: {target}")

    backup.parent.mkdir(parents=True, exist_ok=True)
    if not backup.exists():
        shutil.copy2(target, backup)
        print(f"Backed up original PCK to {backup}")

    shutil.copy2(source, target)
    print(f"Installed patch to {target}")


def restore_patch(target: Path, backup: Path) -> None:
    if not backup.exists():
        raise FileNotFoundError(f"Backup does not exist: {backup}")

    shutil.copy2(backup, target)
    print(f"Restored original PCK to {target}")


def main() -> None:
    args = parse_args()
    if args.restore:
        restore_patch(args.target, args.backup)
    else:
        install_patch(args.source, args.target, args.backup)


if __name__ == "__main__":
    main()
