#!/usr/bin/env python3
"""Sync Cline rules from cline-devops to target projects."""

import argparse
import shutil
from pathlib import Path


def sync_rules(
    source: Path,
    target: Path | str,
    dry_run: bool = True,
) -> None:
    """Sync rules from source to target.
    
    Args:
        source: Source rules directory or file
        target: Target project path (or 'all' for all projects)
        dry_run: If True, only print actions without executing
    """
    source = Path(source).resolve()
    
    if not source.exists():
        raise FileNotFoundError(f"Source not found: {source}")
    
    if target == "all":
        # TODO: Implement sync to all registered projects
        print("Sync to all projects not implemented yet")
        return
    
    target_path = Path(target).resolve()
    
    if not target_path.exists():
        raise FileNotFoundError(f"Target not found: {target_path}")
    
    # Determine destination
    if source.is_file():
        dest = target_path / ".cline" / source.name
    else:
        dest = target_path / ".copilot-instructions.md"
        source = source / ".copilot-instructions.md"
    
    if dry_run:
        print(f"[DRY RUN] Would copy:")
        print(f"  From: {source}")
        print(f"  To:   {dest}")
    else:
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, dest)
        print(f"✅ Synced: {source.name} → {dest}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Sync Cline rules to target projects"
    )
    parser.add_argument(
        "--source",
        type=Path,
        required=True,
        help="Source rules directory or file",
    )
    parser.add_argument(
        "--target",
        required=True,
        help="Target project path (or 'all')",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        default=True,
        help="Print actions without executing (default: True)",
    )
    
    args = parser.parse_args()
    
    try:
        sync_rules(
            source=args.source,
            target=args.target,
            dry_run=args.dry_run,
        )
    except Exception as e:
        print(f"❌ Error: {e}")
        raise


if __name__ == "__main__":
    main()