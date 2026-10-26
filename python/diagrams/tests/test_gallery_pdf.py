"""The assets gallery PDF: one page per PNG, and a description page after a PNG that has one.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_gallery_pdf.py
"""

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

import catzc.diagrams
from catzc.diagrams.module_paths import REPO, REPOSITORY_ROOT_VARIABLE, module_file
from PIL import Image

KIT = Path(catzc.diagrams.__file__).resolve().parent
# The mirror's kit is not installed, so the run binds catzc.diagrams to the mirror's folder before it runs the script as a module.
RUN_MIRROR = (
    "import importlib.util, runpy, sys; kit = sys.argv.pop(1); "
    "spec = importlib.util.spec_from_file_location('catzc.diagrams', kit + '/__init__.py', submodule_search_locations=[kit]); "
    "package = importlib.util.module_from_spec(spec); sys.modules['catzc.diagrams'] = package; spec.loader.exec_module(package); "
    "runpy.run_module('catzc.diagrams.gallery_pdf', run_name='__main__', alter_sys=True)"
)
# The mirror is its own repository: a .git marks its root, and the run drops the importer's root so the resolver finds that marker.
MIRROR_ENV = {name: value for name, value in os.environ.items() if name.upper() != REPOSITORY_ROOT_VARIABLE.upper()}
# The files the script reads, at the places the resolver derives from the modules' full names, never spelled.
CARRIERS = module_file("Catzc.Base.Languages", "configs", "file-carriers.yml").relative_to(REPO)
VARIANTS = module_file("Catzc.Base.Variants", "configs", "variants.yml").relative_to(REPO)


def mirror(root):
    """The kit's script and the leaf it imports, under a copy of the repository's layout with the files they read."""
    kit = root / KIT.relative_to(REPO)
    kit.mkdir(parents=True)
    (root / ".git").mkdir()
    for script in ("__init__.py", "gallery_pdf.py", "module_paths.py"):
        shutil.copy2(KIT / script, kit)
    for read in (CARRIERS, VARIANTS):
        (root / read).parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(REPO / read, root / read)
    return kit


def test_two_pngs_one_with_a_companion_make_three_pages(tmp_path):
    # The script reads the repository the resolver finds and writes under the working folder, so it runs from a mirror.
    mirror_kit = mirror(tmp_path)

    assets = tmp_path / "assets" / "widget"
    assets.mkdir(parents=True)
    for name in ("gadget.png", "widget.png"):
        Image.new("RGB", (64, 48), (40, 60, 90)).save(assets / name)
    (assets / "widget.md").write_text("# Widget\n\nThe widget's description.\n", encoding="utf-8")

    done = subprocess.run(
        [sys.executable, "-c", RUN_MIRROR, str(mirror_kit), "--assets", "assets"],
        cwd=tmp_path,
        env=MIRROR_ENV,
        capture_output=True,
        text=True,
        timeout=60,
        check=False,
    )

    assert done.returncode == 0, done.stderr
    pages = re.search(r"pages=(\d+)", done.stdout)
    assert pages is not None, done.stdout
    assert int(pages.group(1)) == 3
    assert (tmp_path / "out" / "diagrams" / "assets-gallery.pdf").is_file()


def test_a_declared_diagram_is_described_by_its_yml_description(tmp_path):
    mirror_kit = mirror(tmp_path)

    assets = tmp_path / "assets"
    assets.mkdir(parents=True)
    Image.new("RGB", (64, 48), (40, 60, 90)).save(assets / "widget-flow.drawio.png")
    (assets / "widget-flow.drawio.yml").write_text("description: >-\n  Widgets flow into gadgets.\ncontent:\n  title: Widgets\n", encoding="utf-8")

    done = subprocess.run(
        [sys.executable, "-c", RUN_MIRROR, str(mirror_kit), "--assets", "assets"],
        cwd=tmp_path,
        env=MIRROR_ENV,
        capture_output=True,
        text=True,
        timeout=60,
        check=False,
    )

    assert done.returncode == 0, done.stderr
    pages = re.search(r"pages=(\d+)", done.stdout)
    assert pages is not None, done.stdout
    assert int(pages.group(1)) == 2
