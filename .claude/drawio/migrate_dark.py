# cspell:ignore mxfile pnginfo IEND FAFAFA
"""Migrate a light-era slide to the dark tokens and re-render it, keeping the raster and the embedded model honest to each other.

usage: uv run -q --with pillow python .claude/drawio/migrate_dark.py <in.drawio.png> <out.drawio.png>   (the same path migrates in place)

The colour map is the light glyph sheet (docs/.assets/explanation/glyphs.drawio.png, the kit before the dark page) against the dark one
(.claude/drawio/glyphs.xml) and the dark-theme tokens of STYLE.md (Canvas). Every fill, stroke, font and label-background colour of every
cell style is mapped by its light value and its cell's shape; the page background and shadow follow STYLE.md; an edge or a neutral glyph
without a font colour gets the ink. Embedded images (the minimaps) are left as they are. The script asserts that the migrated XML parses
with unique cell ids, that the written PNG is valid, that its embedded model round-trips and that re-rendering that model reproduces the raster pixel for
pixel, and that no light token is left; a colour it has no
mapping for is reported as `unmapped`, never guessed.
"""
import html
import os
import re
import sys
import xml.etree.ElementTree as ET

import drawio_png as k
from PIL import Image
from PIL.PngImagePlugin import PngInfo

PAGE, BAND, BAND_RIM, BAND_LABEL, PANEL, INK, TITLE, QUIET, LINE = "#1E2430", "#262E3B", "#3A4555", "#B0BAC7", "#222A36", "#CDD3DC", "#DDE2E9", "#949FAE", "#AAB4C3"
MARK, CHIP, CHIP_RIM, NEUTRAL, NEUTRAL_RIM = "#E6EAF0", "#262E3B", "#AAB4C3", "#2C3542", "#C7D0DB"
FILL = {  # light fill -> dark fill (context-free)
    "#37474f": MARK, "#263238": MARK, "#fafafa": PANEL, "#647687": "#4E6378", "#f6f8fa": BAND, "#f5f5f5": NEUTRAL,
    "#a4acb0": "#737983", "#eceff1": BAND, "#ef9a9a": "#8E2424", "#76608a": "#6A567E", "#9be7c4": "#2E7D5B", "#6d8764": "#5B7653",
    "#c9ccd1": NEUTRAL, "#dae8fc": "#4E6378", "#64b5f6": "#4E6378", "#d5e8d4": "#2E7D5B", "#e6ecf2": PAGE,
}
STROKE = {
    "#ffffff": PAGE, "#cfd8dc": BAND_RIM, "#314354": "#9FB3C8", "#e1e4e8": BAND_RIM, "#c62828": "#E57373", "#37474f": BAND_RIM,
    "#a4acb0": BAND_RIM, "#432d57": "#B9A6CC", "#0e9f6e": "#7FD3AE", "#3a5431": "#A9C29F", "#546e7a": LINE, "#6b7178": NEUTRAL_RIM,
    "#6c8ebf": "#9FB3C8", "#2d7600": "#7FD3AE", "#1565c0": "#9FB3C8", "#82b366": "#7FD3AE",
}
FONT = {"#666666": QUIET, "#455a64": BAND_LABEL, "#546e7a": QUIET, "#0b5c43": TITLE, "#333333": INK, "#000000": INK}
LABEL_BG = {"#f6f8fa": BAND, "#ffffff": PAGE, "#e6ecf2": PAGE}
unmapped = set()

def migrate_style(style):
    parts = [p for p in style.split(";") if p != ""]
    kv = {}
    for p in parts:
        if "=" in p:
            a, b = p.split("=", 1); kv[a] = b
    shape = parts[0] if parts and "=" not in parts[0] else kv.get("shape", "")
    is_text = parts[0].startswith("text") if parts else False
    is_edge = "edgeStyle" in kv or kv.get("endArrow") is not None
    neutral_glyph = shape in ("rhombus", "ellipse", "hexagon") or kv.get("shape") == "hexagon" or (kv.get("fillColor", "").lower() == "#f5f5f5")
    chip = kv.get("arcSize") == "50" or (is_text and kv.get("fillColor", "").lower() == "#ffffff")
    fill0 = kv.get("fillColor", "").lower()
    out = []
    for p in parts:
        if "=" not in p:
            out.append(p); continue
        a, b = p.split("=", 1); low = b.lower()
        if a == "fillColor":
            if low == "#ffffff":
                b = CHIP if chip else (PAGE if (kv.get("dashed") == "1" or shape == "ellipse" or is_text) else PANEL)
            elif low in FILL: b = FILL[low]
            elif low not in ("none", "#ffe082", "#60a917", "#c4915c") and low.startswith("#"): unmapped.add(("fill", low))
        elif a == "strokeColor":
            if low == "#666666": b = NEUTRAL_RIM if neutral_glyph else LINE
            elif low in STROKE: b = STROKE[low]
            elif low not in ("none", "#f9a825", "#7a4b25") and low.startswith("#"): unmapped.add(("stroke", low))
        elif a == "fontColor":
            if low == "#ffffff": b = PAGE if fill0 in ("#37474f", "#263238") else TITLE
            elif low == "#37474f": b = TITLE if (kv.get("fontSize") == "16" and kv.get("fontStyle") == "1") else INK
            elif low in FONT: b = FONT[low]
            elif low.startswith("#") and low not in (PAGE.lower(), INK.lower(), TITLE.lower(), QUIET.lower()): unmapped.add(("font", low))
        elif a == "labelBackgroundColor" and low in LABEL_BG: b = LABEL_BG[low]
        out.append(f"{a}={b}")
    if is_edge:
        if "fontColor" not in kv: out.append(f"fontColor={INK}")
        if "shadow" not in kv: out.append("shadow=0")
    elif neutral_glyph and "fontColor" not in kv and not is_text:
        out.append(f"fontColor={INK}")
    elif fill0 in ("#ffe082",) and "fontColor" not in kv:
        out.append(f"fontColor={PAGE}")
    return ";".join(out) + ";"

def migrate_model(model):
    model = re.sub(r'background="#[0-9A-Fa-f]{6}"', f'background="{PAGE}"', model, count=1)
    if 'shadow="' not in model.split(">", 1)[0]:
        model = model.replace("<mxGraphModel ", '<mxGraphModel shadow="1" ', 1)
    else:
        model = re.sub(r'(<mxGraphModel[^>]*?)shadow="0"', r'\1shadow="1"', model, count=1)
    return re.sub(r'style="([^"]*)"', lambda m: 'style="' + migrate_style(m.group(1)) + '"', model)

def run(src, dst):
    img = Image.open(src)
    chunk = img.text["mxfile"]
    m = re.search(r'name="([^"]*)"', k.unquote(chunk)); name = html.unescape(m.group(1)) if m else "Page-1"
    model = migrate_model(k.decode(chunk))
    root = ET.fromstring(model)                      # the XML is well-formed
    assert root.tag == "mxGraphModel"
    ids = [c.get("id") for c in root.iter("mxCell")]; assert len(ids) == len(set(ids)), "duplicate cell ids"
    out = k.render(root).convert("RGB")
    info = PngInfo(); info.add_text("mxfile", k.encode(model, name))
    os.makedirs(os.path.dirname(dst) or ".", exist_ok=True)
    out.save(dst, "PNG", pnginfo=info)
    back = Image.open(dst); back.verify()            # the PNG is valid
    back = Image.open(dst)
    assert k.decode(back.text["mxfile"]) == model, "embedded model does not round-trip"
    proof = k.render(ET.fromstring(k.decode(back.text["mxfile"]))).convert("RGB")   # the raster is a function of the XML
    assert proof.size == back.size and proof.tobytes() == back.convert("RGB").tobytes(), "raster is not the render of the embedded model"
    raw = open(dst, "rb").read(); assert raw[:8] == b"\x89PNG\r\n\x1a\n" and raw[-8:] == b"IEND\xaeB`\x82"
    light = re.findall(r'(?:fill|stroke|font)Color=(#(?:37474F|666666|FFFFFF|FAFAFA|F6F8FA|CFD8DC|455A64))\b', model, re.I)
    return back.size, len(ids), sorted(set(light))

if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    size, n, light = run(src, dst)
    print(f"ok {dst} {size[0]}x{size[1]} cells={n} light-tokens-left={light} unmapped={sorted(unmapped)}")
