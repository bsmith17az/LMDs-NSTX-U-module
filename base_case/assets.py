#!/usr/bin/env python3
import hashlib, os, sys, yaml
from pathlib import Path


class AssetError(RuntimeError):
    pass


def sha256sum(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def load_manifest():
    with open("constant/assets.yaml", "r") as f:
        return yaml.safe_load(f)


def project_assets_dir():
    asset_root = os.environ.get("ASSET_ROOT")
    if not asset_root:
        raise AssetError("ASSET_ROOT is not set.")
    return Path(asset_root) / "lmdmodelling/nstxumodule"


def validate_sources():
    """Before linking: every source listed in assets.yaml exists under
    ASSET_ROOT and has the expected hash."""
    project_assets = project_assets_dir()
    manifest = load_manifest()

    errors, validated = [], []
    for component in manifest["components"]:
        src = project_assets / component["filename"]
        if not src.is_file():
            errors.append(f"Source file does not exist: {src}")
            continue
        actual = sha256sum(src)
        if actual != component["sha256"]:
            errors.append(
                f"Hash mismatch for source file {src}\n"
                f"  Expected: {component['sha256']}\n"
                f"  Actual:   {actual}"
            )
            continue
        validated.append(src)

    if errors:
        raise AssetError("Source validation failed:\n" + "\n".join(errors))
    return validated


def validate_links():
    """Before meshing: the files currently at each target path (following
    symlinks) have the hashes listed in assets.yaml."""
    manifest = load_manifest()

    errors = []
    for component in manifest["components"]:
        dst = Path(component["target"])
        name = component["name"]

        if dst.is_symlink() and not dst.exists():
            errors.append(
                f"[{name}] {dst} is a broken link (points to {os.readlink(dst)})"
            )
            continue
        if not dst.exists():
            errors.append(f"[{name}] {dst} does not exist")
            continue

        actual = sha256sum(dst)
        if actual != component["sha256"]:
            where = f" -> {os.readlink(dst)}" if dst.is_symlink() else ""
            errors.append(
                f"[{name}] {dst}{where} does not match assets.yaml\n"
                f"  Expected: {component['sha256']}\n"
                f"  Actual:   {actual}"
            )

    if errors:
        raise AssetError(
            "The files in use do not match assets.yaml:\n"
            + "\n".join(errors)
            + "\nIf assets.yaml was updated, run 'python3 assets.py' to recreate the links."
        )


def create_links():
    project_assets = project_assets_dir()
    manifest = load_manifest()

    # Always validate sources first
    validate_sources()

    created_links = []
    for component in manifest["components"]:
        src = project_assets / component["filename"]
        dst = Path(component["target"])

        dst.parent.mkdir(parents=True, exist_ok=True)
        if dst.exists() or dst.is_symlink():
            dst.unlink()
        dst.symlink_to(src)
        created_links.append(dst)

    # Confirm what we just made is what the manifest says
    validate_links()
    return created_links


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "link"
    try:
        if cmd == "link":
            created = create_links()
            print("Created links to assets: ", *created, sep="\n")
        elif cmd == "check-links":
            validate_links()
            print("Assets in use match assets.yaml.")
        else:
            sys.exit(f"Unknown command '{cmd}'. Use 'link' or 'check-links'.")
    except AssetError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)
