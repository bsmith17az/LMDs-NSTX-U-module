#!/usr/bin/env python3
import yaml, os, sys, hashlib
from pathlib import Path


def sha256sum(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def main():
    ASSET_ROOT = os.environ.get("ASSET_ROOT")
    if not ASSET_ROOT:
        sys.exit("ERROR: ASSET_ROOT is not set.")
    PROJECT_ASSETS = os.path.join(ASSET_ROOT, "LMD_modelling/NSTX-U Module")

    with open("constant/assets.yaml", 'r') as f:
        assets = yaml.safe_load(f)

    created_links = []
    # Create symlinks for each component
    for component in assets["components"]:
        src = Path(PROJECT_ASSETS) / component["filename"]
        dst = Path(component["target"])
        # Check that the source file exists
        if not os.path.exists(src):
            sys.exit(f"Expected source file does not exist: {src}")
        # Check that the hash of the source file matches the expected hash
        actual_hash = sha256sum(src)
        expected_hash = component["sha256"]
        if not actual_hash == expected_hash:
            sys.exit(f"Hash mismatch creating link for file {dst}.\n Expected: {expected_hash}\n Actual: {actual_hash}")
        dst.parent.mkdir(parents=True, exist_ok=True)
        if dst.exists() or dst.is_symlink():
            dst.unlink()
        dst.symlink_to(src)
        # Remove and re-create all symlinks to ensure they are up-to-date
        if os.path.islink(dst):
            os.remove(dst)
        os.symlink(src, dst)
        created_links.append(dst)

    print("Created links to assets: ", *created_links, sep="\n")

if __name__=="__main__":
    main()