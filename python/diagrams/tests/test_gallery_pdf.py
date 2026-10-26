"""The assets gallery PDF: one page per PNG, and a description page after a PNG that has one.

usage (repo root, background): timeout 120 uv run -q --with pillow==12.3.0 --with pytest==9.1.1 python -m pytest python/catzc_diagrams/tests
"""

import re
import shutil
import subprocess
import sys
from pathlib import Path

from module_paths import module_file
from PIL import Image

KIT = Path(__file__).resolve().parents[1]
REPO = KIT.parents[1]
# The files the script reads, at the places the resolver derives from the modules' full names, never spelled.
CARRIERS = module_file("Catzc.Base.Languages", "configs", "file-carriers.yml").relative_to(REPO)
VARIANTS = module_file("Catzc.Base.Variants", "configs", "variants.yml").relative_to(REPO)


def mirror(root):
    """The kit's script and the leaf it imports, under a copy of the repository's layout with the files they read."""
    kit = root / KIT.relative_to(REPO)
    kit.mkdir(parents=True)
    for script in ("gallery_pdf.py", "module_paths.py"):
        shutil.copy2(KIT / script, kit)
    for read in (CARRIERS, VARIANTS):
        (root / read).parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(REPO / read, root / read)
    return kit


def test_two_pngs_one_with_a_companion_make_three_pages(tmp_path):
    # The script reads the repository from its own place and writes under the working folder, so it runs from a mirror.
    mirror_kit = mirror(tmp_path)

    assets = tmp_path / "assets" / "widget"
    assets.mkdir(parents=True)
    for name in ("gadget.png", "widget.png"):
        Image.new("RGB", (64, 48), (40, 60, 90)).save(assets / name)
    (assets / "widget.md").write_text("# Widget\n\nThe widget's description.\n", encoding="utf-8")

    done = subprocess.run(
        [sys.executable, str(mirror_kit / "gallery_pdf.py"), "--assets", "assets"],
        cwd=tmp_path,
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
        [sys.executable, str(mirror_kit / "gallery_pdf.py"), "--assets", "assets"],
        cwd=tmp_path,
        capture_output=True,
        text=True,
        timeout=60,
        check=False,
    )

    assert done.returncode == 0, done.stderr
    pages = re.search(r"pages=(\d+)", done.stdout)
    assert pages is not None, done.stdout
    assert int(pages.group(1)) == 2
