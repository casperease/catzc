# cspell:ignore minimaps
"""Write out/diagrams/gallery.pdf: every diagram output as one page each, for readers without an HTML viewer.

usage: uv run -q --with pillow python .claude/drawio/gallery_pdf.py

Page order: world maps, lens contact sheets, then fan-out drawings (each followed by its two minimaps when they exist).
Each page is the image scaled to 1600 px wide under a caption bar with its file name. Pillow writes the PDF directly, so no
Markdown or HTML step is needed.
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path("out/diagrams")
WIDTH = 1600
BAR = 44


def font(size):
    for name in ("arialbd.ttf", "arial.ttf"):
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            pass
    return ImageFont.load_default()


def page(path, section):
    img = Image.open(path).convert("RGB")
    scale = min(WIDTH / img.width, 2.0)
    img = img.resize((round(img.width * scale), round(img.height * scale)))
    out = Image.new("RGB", (WIDTH, img.height + BAR + 16), "#ffffff")
    d = ImageDraw.Draw(out)
    d.rectangle([0, 0, WIDTH, BAR], fill="#37474F")
    d.text((14, 11), f"{section}  ·  {path.name}", font=font(20), fill="#ffffff")
    out.paste(img, ((WIDTH - img.width) // 2, BAR + 8))
    return out


fan = ROOT / "fan-out"
items = [(p, "World map") for p in sorted(fan.glob("world-map.*.png"))]
items += [(p, "Lens sheet") for p in sorted(ROOT.glob("lenses/*/*.sheet.png"))]
for p in sorted(fan.glob("*.drawio.png")):
    stem = p.name[: -len(".drawio.png")]
    items.append((p, "Fan-out"))
    items += [(m, "Minimap") for m in (fan / f"minimap-{stem}.stack.png", fan / f"minimap-{stem}.tree.png") if m.exists()]
pages = [page(p, s) for p, s in items]
target = ROOT / "gallery.pdf"
pages[0].save(target, "PDF", save_all=True, append_images=pages[1:], resolution=150)
print(f"ok {target} pages={len(pages)}")
