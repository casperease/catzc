"""A pwsh module's folder from its full name, the kit's twin of VariantTrack.FolderNameOf (DDR-TRACK-MODULENAMESPACE).

The pwsh track declares its namespace and join in variants.yml; a module's folder is its full name without them, so no path in the kit
spells a module folder: Catzc.Base.Drs lives in pwsh/Base.Drs. The variants file is found by its one place under the modules track,
read once per process. A leaf of the kit that imports none of it, so a script copied out with it still runs.
"""

import re
from functools import cache
from pathlib import Path

import yaml

REPO = Path(__file__).resolve().parents[2]
MODULES_TRACK = "pwsh"


@cache
def _track():
    """The modules track's root folder, namespace and join, from the one variants.yml beneath it."""
    found = sorted((REPO / MODULES_TRACK).glob("*/configs/variants.yml"))
    if len(found) != 1:
        raise FileNotFoundError(f"{MODULES_TRACK}/*/configs/variants.yml: expected one variants file, found {len(found)}")
    track = ((yaml.safe_load(found[0].read_text(encoding="utf-8")) or {}).get("tracks") or {}).get(MODULES_TRACK) or {}
    join = track.get("join")
    return str(track.get("namespace") or ""), "." if join is None else str(join)


def module_folder_name(full_name):
    """The module's folder name: its full name without the track's namespace and join, else the full name unchanged."""
    namespace, join = _track()
    prefix = namespace + join
    return full_name[len(prefix) :] if namespace and full_name.startswith(prefix) and len(full_name) > len(prefix) else full_name


def module_path(full_name, *parts):
    """A file of the module, repository-relative: the module's folder under the modules track, then the parts."""
    return Path(MODULES_TRACK, module_folder_name(full_name), *parts)


def module_file(full_name, *parts):
    """A file of the module, absolute under this repository."""
    return REPO / module_path(full_name, *parts)


CONTRACTS_TRACK = "contracts"


def _normal_form(pascal_dotted):
    """A pascal-dotted folder name in the snake-dotted normal form, the twin of NameCase.ToNormal: DevOps becomes dev_ops."""
    words = re.compile(r"(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])")
    return ".".join(words.sub("_", part).lower() for part in pascal_dotted.split("."))


@cache
def _contracts_version_root():
    """The one contract version folder under the contracts track and the modules track's namespace."""
    namespace, _ = _track()
    found = sorted(p for p in (REPO / CONTRACTS_TRACK / namespace.lower()).glob("*") if p.is_dir())
    if len(found) != 1:
        raise FileNotFoundError(f"{CONTRACTS_TRACK}/{namespace.lower()}/*: expected one contract version, found {len(found)}")
    return found[0]


def contract_file(full_name, *parts):
    """A contract file of the module, absolute: the version folder, then the module's group (the twin of Get-ContractGroup), then the parts."""
    group = MODULES_TRACK + "." + _normal_form(module_folder_name(full_name))
    return _contracts_version_root() / group / Path(*parts)
