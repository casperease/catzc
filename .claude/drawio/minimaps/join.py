# ---
# catzc:
#   immutable:
#     path: ".claude/drawio/minimaps/join.py"
#     folder: drawio/minimaps
#     name: join
#     filetype: py
#     kind: drawio-kit
#     language: python
#     track: ".claude"
#     tracktype: vendor-settings
#     vendor: claude
#     module: ".claude"
#     moduletype: settings
# ---

# cspell:ignore minimaps mapkey
"""Join the three minimaps into each slide: lay out the sidebar, embed the PNGs, and rebuild the slide.

For every slide of the list: rewrite its source XML's sidebar (the minimap-grid, minimap-tree and minimap-chain image
cells, the lens badge, the ADR chips and a map key below them; .claude/drawio/STYLE.md, "Limits"), embed
<target>/{grid,tree,chain}/<stem>.{grid,tree,chain}.png as data URIs, write the XML back, and build <target>/<stem>.drawio.png. Fails
loudly on any missing piece.

usage (repo root, background):
  timeout 360 uv run -q --with pillow python .claude/drawio/minimaps/join.py --slides <slides.json>
      [--data out/minimaps] [--target docs/.assets/explanation] [--start N --end M]
The optional slice of the slide list keeps each run inside the 360 s background limit.
"""

import argparse
import json
import re
import subprocess
import sys
import textwrap
from pathlib import Path

import describe

REPO = Path(__file__).resolve().parents[3]
TOOLS = REPO / ".claude/drawio"
VIEWS = ("grid", "tree", "chain")
X, WIDTH = 1316, 240
# The sidebar, top to bottom: cell id -> (y, height). The map key follows at MAPKEY_Y, or below taller ADR chips.
SIDEBAR = {
    "minimap-grid": (16, 150),
    "minimap-tree": (182, 180),
    "minimap-chain": (378, 150),
    "lens-badge": (544, 24),
    "supports": (576, 38),
}
MAPKEY_Y = 626
# The dark-theme tokens (.claude/drawio/STYLE.md): ink, panel border, the page, and the legend panel fill, for the sidebar's
# chrome; and the minimap tokens ("Colours (minimaps only)"): the minimap page, idle cell and cell border, which the map
# key's swatches show, so a swatch matches the cell it explains.
INK, BORDER, PAGE, PANEL = "#CDD3DC", "#3A4555", "#1E2430", "#222A36"
MAP_PAGE, MAP_IDLE, MAP_BORDER = "#1C2A24", "#243229", "#3B4D43"
# The sidebar backing (STYLE.md, "sidebar" token): a soft dark brown layer above the page and below everything in the
# sidebar, so the minimap column reads as one region of its own.
SIDEBAR_FILL, SIDEBAR_RIM = "#2E2823", "#453C33"
SIDEBAR_PAD = 12
TEXT = f"text;html=1;align=left;verticalAlign=middle;fontSize=11;fontColor={INK};"


def mix(hue, alpha, base):
    a, b = [tuple(int(h.lstrip("#")[i : i + 2], 16) for i in (0, 2, 4)) for h in (hue, base)]
    return "#" + "".join(f"{round(b[i] + (a[i] - b[i]) * alpha):02X}" for i in range(3))


def cell(cell_id, value, style, y, height, x=X, width=WIDTH):
    return (
        f'<mxCell id="{cell_id}" value="{value}" style="{style}" vertex="1" parent="1">'
        f'<mxGeometry x="{x}" y="{y}" width="{width}" height="{height}" as="geometry" /></mxCell>'
    )


def map_key(palette, concerns, top):
    """The map key at y = top: one swatch per mark the three minimaps share, and the key to their short labels."""
    lit = palette["highlight"]
    rows = [
        ("lit", f"fillColor={lit};strokeColor={lit};", "lit: what the slide's ADRs select"),
        ("touched", f"fillColor={mix(lit, 0.4, MAP_IDLE)};strokeColor={mix(lit, 0.4, MAP_IDLE)};", "lit by passing mentions only"),
        ("adr", f"fillColor={lit};strokeColor={MAP_PAGE};strokeWidth=2;", "lit ADR file (dark rim)"),
        ("idle", f"fillColor={MAP_IDLE};strokeColor={MAP_BORDER};", "idle: not selected, or empty"),
    ]
    abbreviated = [f"{describe.concern_code(c)} {c}" for c in concerns if describe.concern_code(c) != c.upper()]
    key = (
        "Grid columns: a file language's first extension. Value-chain rows: the value-chain stack; columns: "
        + ", ".join(abbreviated)
        + "."
    )
    # The preview renderer does not wrap text, so the key is broken into lines here (11 px text, about 42 characters).
    lines = textwrap.wrap(key, 42)
    codes = "&lt;br&gt;".join(lines)
    height = 28 + len(rows) * 23 + 14 * len(lines) + 10
    cells = [
        cell(
            "mapkey",
            "&lt;b&gt;Map key&lt;/b&gt;",
            f"rounded=1;arcSize=6;whiteSpace=wrap;html=1;align=left;verticalAlign=top;fontSize=11;fontColor={INK};fillColor={PANEL};"
            f"strokeColor={BORDER};spacingLeft=8;spacingTop=2;",
            top,
            height,
        )
    ]
    for i, (key, style, text) in enumerate(rows):
        y = top + 28 + i * 23
        size = 12 if key == "adr" else 16
        cells.append(cell(f"mapkey-{key}", "", "rounded=0;html=1;" + style, y + (18 - size) / 2, size, x=X + 12 + (26 - size) / 2, width=size))
        cells.append(cell(f"mapkey-{key}-text", text, TEXT, y - 1, 20, x=X + 48, width=WIDTH - 56))
    cells.append(cell("mapkey-codes", codes, TEXT.replace("verticalAlign=middle", "verticalAlign=top;whiteSpace=wrap"), top + 28 + len(rows) * 23,
                      14 * len(lines) + 4, x=X + 8, width=WIDTH - 16))
    return "\n    ".join(cells)


def lay_out_sidebar(model, palette, concerns):
    """The sidebar of a slide model: the minimap image cells (minimap-stack renamed minimap-grid, minimap-chain added
    as a copy of it when missing), every sidebar cell at its SIDEBAR slot, and a fresh map key below them."""
    model = model.replace('id="minimap-stack"', 'id="minimap-grid"')
    # The backing layer: dropped and re-added right after the root cells, so it sits lowest in the z-order.
    model = re.sub(r'\s*<mxCell id="sidebar-bg"(?:[^>]*/>|.*?</mxCell>)', "", model, flags=re.DOTALL)
    if 'id="minimap-chain"' not in model:
        grid = re.search(r'<mxCell id="minimap-grid".*?</mxCell>', model, re.DOTALL)
        tree = re.search(r'<mxCell id="minimap-tree".*?</mxCell>', model, re.DOTALL)
        if not grid or not tree:
            raise SystemExit("the slide has no minimap-grid or minimap-tree cell")
        chain = re.sub(r'image=[^;"]*;?', "", grid.group(0).replace('id="minimap-grid"', 'id="minimap-chain"'))
        model = model[: tree.end()] + "\n    " + chain + model[tree.end() :]
    # A minimap cell is an image cell. A template placeholder (a labelled box, no shape=image) becomes one here, so the
    # embed step never meets a cell it cannot fill; the placeholder label goes, the picture is the label.
    for view in VIEWS:
        pattern = re.compile(r'(<mxCell id="minimap-' + view + r'" value=")([^"]*)(" style=")([^"]*)(")')
        match = pattern.search(model)
        if match and (match.group(2) or "shape=image" not in match.group(4)):
            style = match.group(4) if "shape=image" in match.group(4) else "shape=image;imageAspect=0;" + match.group(4)
            model = model[: match.start(2)] + match.group(3) + style + model[match.end(4) :]
    for cell_id, (y, height) in SIDEBAR.items():
        pattern = re.compile(r'(<mxCell id="' + re.escape(cell_id) + r'".*?<mxGeometry\b)([^>]*)(/?>)', re.DOTALL)
        match = pattern.search(model)
        if not match:
            raise SystemExit(f"the slide has no {cell_id} cell")
        attrs = re.sub(r'\s(x|y|width|height)="[^"]*"', "", match.group(2))
        model = model[: match.start(2)] + f' x="{X}" y="{y}" width="{WIDTH}" height="{height}"' + attrs + model[match.end(2) :]
    # Drop the slide's own map key, the panel and its swatch rows (template-slide.xml names the rows mk-*), before adding a fresh one.
    model = re.sub(r'\s*<mxCell id="(?:mapkey|mk-)[^"]*"(?:[^>]*/>|.*?</mxCell>)', "", model, flags=re.DOTALL)
    # The ADR chips grow with their lines (11 px text, 14 px a line); the map key starts below them.
    supports = re.search(r'<mxCell id="supports" value="([^"]*)".*?</mxCell>', model, re.DOTALL)
    lines = supports.group(1).count("&lt;br&gt;") + 1
    height = max(SIDEBAR["supports"][1], lines * 14 + 4)
    model = model.replace(supports.group(0), re.sub(r'height="[^"]*"', f'height="{height}"', supports.group(0), count=1))
    supports = re.search(r'<mxCell id="supports".*?</mxCell>', model, re.DOTALL)
    top = max(MAPKEY_Y, SIDEBAR["supports"][0] + height + 8)
    model = model[: supports.end()] + "\n    " + map_key(palette, concerns, top) + model[supports.end() :]
    return add_sidebar_backing(model)


def add_sidebar_backing(model):
    """The sidebar backing, from 4 px below the top edge to SIDEBAR_PAD below the sidebar's lowest cell (the raster grows
    with the content, so the declared page height is only a floor), first after the root cells so it is lowest in z."""
    page_w = int(re.search(r'pageWidth="(\d+)"', model).group(1))
    page_h = int(re.search(r'pageHeight="(\d+)"', model).group(1))
    bottom = page_h
    for m in re.finditer(r'<mxGeometry x="(-?[\d.]+)" y="(-?[\d.]+)" width="([\d.]+)" height="([\d.]+)"', model):
        x, y, _, h = (float(v) for v in m.groups())
        if x >= X - SIDEBAR_PAD:
            bottom = max(bottom, y + h + SIDEBAR_PAD)
    root = re.search(r'<mxCell id="1" parent="0"\s*/>', model)
    if not root:
        raise SystemExit("the slide has no root cell id=1")
    backing = cell(
        "sidebar-bg", "", f"rounded=1;arcSize=2;html=1;fillColor={SIDEBAR_FILL};strokeColor={SIDEBAR_RIM};shadow=0;",
        4, round(bottom) - 4, x=X - SIDEBAR_PAD, width=page_w - (X - SIDEBAR_PAD) - 4,
    )
    return model[: root.end()] + "\n    " + backing + model[root.end() :]


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    parser.add_argument("--slides", required=True, help="the slide list (JSON: slides[] with id, stem, lens, adrs, xml)")
    parser.add_argument("--data", default="out/minimaps", help="the folder highlights.ps1 wrote (palette, value-chain map)")
    parser.add_argument("--target", default="docs/.assets/explanation", help="the folder of the minimaps and the built slides")
    parser.add_argument("--start", type=int, default=0)
    parser.add_argument("--end", type=int)
    args = parser.parse_args()
    target = REPO / args.target
    palette = json.loads((REPO / args.data / "palette.json").read_text(encoding="utf-8"))
    concerns = describe.shown_chain(json.loads((REPO / args.data / "value-chain-map.json").read_text(encoding="utf-8")))["concerns"]
    slides = json.loads((REPO / args.slides).read_text(encoding="utf-8"))["slides"][args.start : args.end]
    missing = []
    for slide in slides:
        stem = slide["stem"]
        xml = REPO / slide["xml"]
        pngs = {view: target / view / f"{stem}.{view}.png" for view in VIEWS}
        gaps = [str(p) for p in [xml, *pngs.values()] if not p.exists()]
        if gaps:
            missing.append((stem, gaps))
            continue
        xml.write_text(lay_out_sidebar(xml.read_text(encoding="utf-8"), palette, concerns), encoding="utf-8")
        pairs = [f"minimap-{view}={png}" for view, png in pngs.items()]
        subprocess.run([sys.executable, str(TOOLS / "embed_images.py"), str(xml), *pairs], check=True, stdout=subprocess.DEVNULL)
        subprocess.run(
            [sys.executable, str(TOOLS / "drawio_png.py"), str(xml), str(target / f"{stem}.drawio.png"), "--name", slide["lens"]],
            check=True,
            stdout=subprocess.DEVNULL,
        )
    print(f"join.py: joined {len(slides) - len(missing)}/{len(slides)} -> {target}")
    for stem, gaps in missing:
        print("MISSING", stem, gaps)
    sys.exit(1 if missing else 0)


if __name__ == "__main__":
    main()
