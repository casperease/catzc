"""Every kit path starts from module_paths: a module that finds a file from its own __file__ reads the strict editable build copy, which
lacks any file added since the last reinstall, so a new asset is silently missing or stale."""

from catzc.diagrams.module_paths import KIT


def test_no_kit_module_but_module_paths_finds_a_file_from_its_own_location():
    offenders = sorted(
        path.name
        for path in KIT.glob("*.py")
        if path.name != "module_paths.py" and "__file__" in path.read_text(encoding="utf-8")
    )
    assert offenders == [], f"use module_paths.KIT or REPO instead of __file__ in: {', '.join(offenders)}"


def test_the_kit_folder_is_the_source_tree_not_a_build_copy():
    assert (KIT / "configs" / "drawio.yml").is_file()
    assert "build" not in KIT.parts
