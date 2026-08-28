#!/usr/bin/env python3

import hashlib, os, sys, yaml
from pathlib import Path

def sha256sum(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def load_assets():
    asset_root = os.environ.get("ASSET_ROOT")
    if not asset_root:
        raise RuntimeError("ASSET_ROOT is not set.")

    project_assets = Path(asset_root) / "LMD_modelling/NSTX-U Module"

    with open("constant/assets.yaml", "r") as f:
        assets = yaml.safe_load(f)

    return project_assets, assets


def validate_assets():
    project_assets, assets = load_assets()

    validated = []

    for component in assets["components"]:
        src = project_assets / component["filename"]

        if not src.exists():
            raise RuntimeError(
                f"Expected source file does not exist: {src}"
            )

        actual_hash = sha256sum(src)
        expected_hash = component["sha256"]

        if actual_hash != expected_hash:
            raise RuntimeError(
                f"Hash mismatch for source file {src}.\n"
                f"Expected: {expected_hash}\n"
                f"Actual:   {actual_hash}"
            )

        validated.append(src)

    return validated


def create_links():
    project_assets, assets = load_assets()

    # Always validate first
    validate_assets()

    created_links = []

    for component in assets["components"]:
        src = project_assets / component["filename"]
        dst = Path(component["target"])

        dst.parent.mkdir(parents=True, exist_ok=True)

        if dst.exists() or dst.is_symlink():
            dst.unlink()

        dst.symlink_to(src)

        created_links.append(dst)

    return created_links

if __name__ == "__main__":
    created_links = create_links()
    print("Created links to assets: ", *created_links, sep="\n")