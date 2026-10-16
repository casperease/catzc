# ---
# catzc:
#   derived:
#     path: ".claude/drawio/contact_sheet.py"
#     kind: script
#     language: python
#     filekind: py
#     track: ".claude"
# ---

# cspell:ignore textbbox arialbd
"""Tile every lens variant of a diagram into one review image.

usage: uv run -q --with pillow python contact_sheet.py <lens-folder> [<lens-folder> ...]

For each folder `out/diagrams/lenses/<name>/`, it reads `<name>.<lens>.drawio.png` in lens order (meta, architecture,
implementation, operations, governance). It scales each to a common width, stacks them top to bottom under a lens caption,
and writes `<name>.sheet.png` into the same folder. Missing lenses get a "skipped" row, so the gap stays visible.
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

LENSES = ["meta", "architecture", "implementation", "operations", "governance"]
WIDTH = 1300
CAPTION = 34
BACKGROUND = "#E6ECF2"  # the grey-bluish base layer of every rendered output (.claude/drawio/STYLE.md)


def font(size, bold=True):
    for name in (["arialbd.ttf"] if bold else []) + ["arial.ttf"]:
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            pass
    return ImageFont.load_default()


def sheet(folder):
    folder = Path(folder)
    name = folder.name
    rows = []
    for lens in LENSES:
        png = folder / f"{name}.{lens}.drawio.png"
        if png.exists():
            img = Image.open(png).convert("RGB")
            img = img.resize((WIDTH, round(img.height * WIDTH / img.width)))
        else:
            img = None
        rows.append((lens, img))
    height = sum(CAPTION + (img.height if img else 40) for _, img in rows)
    out = Image.new("RGB", (WIDTH, height), BACKGROUND)
    d = ImageDraw.Draw(out)
    y = 0
    for lens, img in rows:
        d.rectangle([0, y, WIDTH, y + CAPTION], fill="#37474F")
        d.text((12, y + 7), f"{name}  ·  {lens}", font=font(18), fill="#ffffff")
        y += CAPTION
        if img:
            out.paste(img, (0, y))
            y += img.height
        else:
            d.text((12, y + 10), "skipped: nothing honest to show for this lens", font=font(14, False), fill="#666666")
            y += 40
    target = folder / f"{name}.sheet.png"
    out.save(target)
    print(f"ok {target} {out.size[0]}x{out.size[1]} lenses={sum(1 for _, i in rows if i)}/5")


if __name__ == "__main__":
    for arg in sys.argv[1:]:
        sheet(arg)
