# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The cell records a drawing is made of: a cell and an edge, the language tags of a glyph, the paint order and the chrome of a page."""

import html
import re

import languages_table
from declaration_constants import BADGE, BAND, BAND_TITLE, LEGEND, NOTE, PAGE, SUBTITLE, TITLE
from declaration_vocabulary import LIB
from drawio_png import DEFAULTS, style_map

# ---- put: the declaration becomes the model ------------------------------------------------------------------------


def cell(cid, value, style, x, y, w, h, parent="1"):
    return {"id": cid, "value": value, "style": style, "x": x, "y": y, "w": w, "h": h, "parent": parent, "edge": None}


TAGGED_KINDS = ("code", "private", "runner", "type")  # the glyph kinds that are code: each prints the tags of its label's language
TAG_ID = re.compile(r"-tag(-\d+)?$")


def glyph_tags(item, box, parent, lib):
    """The tag cells of a code glyph: a right-aligned row of small tags on its top edge, in the tag style of the library, their words
    from the language table by the shape of the label (languages_table), never stored in the declaration; a label that names no language gets none."""
    words = languages_table.tags(item["label"], item.get("lang", ""))
    width, height = lib["size"]
    sizes = [max(width, round(6.6 * len(word)) + 10) for word in words]
    x = box["x"] + box["w"] - 8 - sum(sizes) - 3 * (len(words) - 1)
    cells = []
    for n, (word, size) in enumerate(zip(words, sizes)):
        cells.append(
            cell(f"{item['id']}-tag" if n == 0 else f"{item['id']}-tag-{n + 1}", word, lib["style"], x, box["y"] - 8, size, height, parent)
        )
        x += size + 3
    return cells


def edge_cell(cid, value, style, source, target):
    return {"id": cid, "value": value, "style": style, "source": source, "target": target, "parent": "1", "edge": True}


LAYERS = tuple(DEFAULTS["layers"])  # the paint order, back to front, declared once in drawio.yml


def layer_of(c):
    """The paint layer of a placed cell, one of LAYERS."""
    style = c["style"]
    if c["edge"]:
        if c["id"].startswith("actor-"):  # the stick man is drawn last, over everything
            return "labels"
        return "lines" if c["id"].startswith("lane-") or style_map(style).get("curved") == "1" else "edges"
    if c["id"] in ("sidebar-bg", "mapkey") or style in (BAND, LEGEND, NOTE):
        return "panels"
    if c["id"].endswith("-title") and style == BAND_TITLE:
        return "titles"
    if style == LIB["module"]:
        return "frames"
    if "shape=crossbar" in style:
        return "spans"
    if c["id"].startswith(("mark-", "chip-")) or c["id"].endswith("-word") or TAG_ID.search(c["id"]):
        return "marks"
    return "labels" if style.startswith("text;") else "glyphs"


def in_paint_order(cells):
    """The cells as draw.io paints them: each parent, then its children back to front by LAYERS. draw.io paints a frame's whole
    contents where the frame stands, so an edge moves into a frame that holds no frame of its own, where it paints before every glyph:
    the innermost frame holding both its ends when that frame holds none, else the first such frame painted. A legend swatch stays."""
    rank = {layer: n for n, layer in enumerate(LAYERS)}

    def tree():
        children: dict = {}
        for c in cells:
            children.setdefault(c["parent"], []).append(c)
        ordered = []

        def walk(pid):
            for c in sorted(children.get(pid, []), key=lambda c: rank[layer_of(c)]):
                ordered.append(c)
                walk(c["id"])

        walk("1")
        return ordered

    parent_of = {c["id"]: c["parent"] for c in cells if not c["edge"]}
    frames = {c["id"] for c in cells if not c["edge"] and layer_of(c) == "frames"}
    leaves = [c["id"] for c in tree() if c["id"] in frames and not any(parent_of.get(f) == c["id"] for f in frames)]

    def frames_of(cid):  # the frames around a cell, innermost first
        chain = []
        while parent_of.get(cid, "1") != "1":
            cid = parent_of[cid]
            if cid in frames:
                chain.append(cid)
        return chain

    for c in cells:
        if c["edge"] and leaves and not c["id"].startswith("lg-"):
            shared = [f for f in frames_of(c["source"]) if f in frames_of(c["target"])]
            c["parent"] = shared[0] if shared and shared[0] in leaves else leaves[0]
    ordered = tree()
    placed = {id(c) for c in ordered}
    return ordered + [c for c in cells if id(c) not in placed]


def chrome(content, cells):
    """The chrome every diagram opens with: the lens once, as the chip that opens the title row, the title, and under it the subtitle,
    the ADR codes alone. Returns how far a wrapped subtitle drops the drawing area."""
    chip_w = 16 + 8 * len(content["lens"])
    cells.append(cell("lens-badge", content["lens"].upper(), BADGE, PAGE["x"], PAGE["title_y"] + 4, chip_w, 22))
    title_x = PAGE["x"] + chip_w + 12
    cells.append(
        cell(
            "title", html.escape(content["title"], quote=False), TITLE, title_x, PAGE["title_y"], PAGE["width"] - (title_x - PAGE["x"]), 30
        )
    )
    subtitle = " · ".join(content["adrs"])
    lines = max(1, -(-len(subtitle) * 7 // (PAGE["width"] - 20)))  # about 7 px a character at 12 px
    drop = (lines - 1) * 16  # the grid starts the bands this much lower under a wrapped subtitle
    cells.append(cell("subtitle", subtitle, SUBTITLE, PAGE["x"], PAGE["subtitle_y"] - 4, PAGE["width"] - 20, 18 + lines * 16))
    return drop


def ladder_rungs(content, band_id):
    """A ladder band's items in climbing order: a walk along the forward edges between them from each item nothing in the band leads
    to, in declared order, then whatever the walk did not reach. The slide kit's redraw of a ladder reads the same order."""
    items = [i for i in content["groups"] + content["glyphs"] if i["in"] == band_id]
    ids = [i["id"] for i in items]
    nxt = {}
    for e in content["edges"]:
        if e["from"] in ids and e["to"] in ids and e["kind"] != "fail":
            nxt.setdefault(e["from"], e["to"])
    led = set(nxt.values())
    order = []
    for start in [i for i in ids if i not in led] + ids:
        cur = start
        while cur is not None and cur not in order:
            order.append(cur)
            cur = nxt.get(cur)
    by_id = {i["id"]: i for i in items}
    return [by_id[i] for i in order]
