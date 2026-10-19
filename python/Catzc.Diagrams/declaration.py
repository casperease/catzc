# cspell:ignore minimaps mxfile pnginfo adronly mapkey
"""The declaration of a diagram: its source beside its .drawio.png, and the two directions between them.

A diagram folder holds two files: `diagram.drawio.yml`, the diagram's one source, and `diagram.drawio.png`, the drawing put from it.
The source has three keys: `description:` says in a sentence or two what the diagram shows; `content:` says it in the closed
vocabulary of the kit (bands, spans, groups, glyphs, edges, markers, chips, the legend, the flow and its relation, the theme, the
three minimaps); `layout:` says where a named cell sits (x, y, w, h). A cell without a layout entry is placed by the grid; a cell
with one keeps it; a cell whose id is not in the content is removed. The diagram names no article: articles and slides embed the
png, any number of them, and the build finds them by what embeds it.

put:  the declaration becomes the mxGraphModel XML embedded in the .drawio.png, and the raster is drawn from that XML (drawio_png).
get:  the XML embedded in the .drawio.png becomes the declaration again, written into the source (its description kept), so a
      hand edit in the draw.io editor is folded back before anything else reads it. Both are deterministic: put then get gives the
      same declaration, get then put the same XML.

usage (repo root, background):
  uv run --project python python python/Catzc.Diagrams/declaration.py put <diagram folder> [--xml <out.xml>]
  uv run --project python python python/Catzc.Diagrams/declaration.py get <diagram folder>

Every vocabulary (glyph kinds, edge kinds, span labels, minimap ids, flows, themes, lenses, kinds) is closed: a value outside it
fails validation with the list the author may choose from, so the errors teach the kit.
"""

import html
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import minimaps
import yaml
from drawio_png import DEFAULTS, decode, encode, mxfile_chunk, plain, render, style_map
from PIL import Image
from PIL.PngImagePlugin import PngInfo

KIT = Path(__file__).resolve().parent
SLIDE = "diagram.drawio.png"
SOURCE = "diagram.drawio.yml"  # the diagram's one source: its description, its content and the layout of the cells off the grid
FLOWS = ("left-to-right", "top-to-bottom")
KINDS = tuple(DEFAULTS["kinds"])
CONTENT_KEYS = ("title", "kind", "flow", "relation", "theme", "bands", "spans", "groups", "glyphs", "edges", "markers", "chips", "legend", "minimaps")
PAGE = {"x": 20, "width": 1260, "title_y": 14, "subtitle_y": 44, "span_y": 84, "band_y": 108, "min_height": 640}
GAP, PAD, LABEL_ROW, ROW_GAP, COL_GAP = 20, 20, 40, 36, 40
SIDEBAR_X, SIDEBAR_W = 1316, 240
SIDEBAR = (("minimap-1", 16, 150), ("minimap-2", 182, 180), ("minimap-3", 378, 150))
MAPKEY_Y = 544  # the map key's panel, under the three minimaps
MAPKEY_BOTTOM = MAPKEY_Y + 82 + 16  # its bottom, and the sidebar's pad under it
# The style keys that identify a glyph kind: the shape and the two colours, with the marks that set a variant apart.
SIGNATURE_KEYS = ("shape", "ellipse", "rhombus", "rounded", "arcSize", "fillColor", "strokeColor", "dashed", "strokeWidth", "fontColor", "fontSize", "fontStyle", "align")
TEXT = "text;html=1;align=left;verticalAlign=middle;fontSize=11;fontColor=#949FAE;"
TITLE = "text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=#DDE2E9;"
SUBTITLE = "text;html=1;align=left;verticalAlign=middle;fontSize=12;fontColor=#949FAE;"
BAND = "rounded=1;html=1;arcSize=3;fillColor=#262E3B;strokeColor=#3A4555;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=#B0BAC7;"
LEGEND = "rounded=1;whiteSpace=wrap;html=1;arcSize=6;fillColor=#222A36;strokeColor=#3A4555;align=left;verticalAlign=top;spacing=8;fontSize=11;fontColor=#CDD3DC;"
SPAN_LABEL = "text;html=1;align=center;verticalAlign=middle;fontSize=11;fontStyle=1;fontColor=#B0BAC7;"
ANCHOR = "text;html=1;strokeColor=none;fillColor=none;"
SIDEBAR_BG = "rounded=1;arcSize=2;html=1;fillColor=#2E2823;strokeColor=#453C33;shadow=0;"
MINIMAP = "shape=image;imageAspect=0;rounded=1;arcSize=4;whiteSpace=wrap;html=1;fillColor=#262E3B;strokeColor=#3A4555;dashed=1;fontColor=#949FAE;fontSize=11;"
BADGE = "rounded=0;whiteSpace=wrap;html=1;align=center;verticalAlign=middle;fontSize=12;fontStyle=1;fontColor=#1E2430;fillColor=#E6EAF0;strokeColor=none;"


class DeclarationError(ValueError):
    """A declaration outside the kit's vocabulary, naming what the author may choose from."""


def choices(what, value, allowed):
    raise DeclarationError(f"{what} '{value}' is not one of: {', '.join(allowed)}")


# ---- the glyph library: every kind, its style and its default size, read from assets/glyphs.xml --------------------


def library():
    """The kit's closed vocabulary from the glyph library: glyph kinds, edge kinds, the marker and the chips, each with its verbatim
    style, its legend phrase and its default size."""
    root = ET.parse(KIT / "assets" / "glyphs.xml").getroot()
    cells = {str(c.get("id")): c for c in root.iter("mxCell") if c.get("id")}

    def geometry(c):
        g = c.find("mxGeometry")
        return tuple(int(float(g.get(k, 0))) for k in ("width", "height")) if g is not None else (0, 0)

    glyphs, edges, marks = {}, {}, {}
    for cid, c in cells.items():
        if cid.startswith("g-") and not cid.endswith(("-text", "-tag", "-member", "-holder")):
            kind = cid[2:]
            glyphs[kind] = {"style": c.get("style"), "phrase": plain(c.get("value")), "size": geometry(c)}
        elif cid.startswith("e-") and c.get("edge") == "1":
            kind = cid[2:]
            edges[kind] = {"style": c.get("style"), "phrase": plain(cells[f"{cid}-text"].get("value"))}
        elif cid in ("m-marker", "m-rule", "m-count"):
            kind = cid[2:]
            marks[kind] = {"style": c.get("style"), "phrase": plain(cells[f"{cid}-text"].get("value")), "size": geometry(c)}
    glyphs["commit"]["phrase"] = "commit"
    glyphs.pop("commit-red", None)
    tag = cells["g-type-tag"]
    glyphs["type"]["tag"] = {"style": tag.get("style"), "size": geometry(tag)}
    return {"glyphs": glyphs, "edges": edges, "marks": marks, "module": cells["g-module"].get("style")}


LIB = library()
GLYPH_KINDS = tuple(LIB["glyphs"])
EDGE_KINDS = tuple(LIB["edges"])


def span_vocabulary():
    """Every span label the kit allows, flattened from the vocabularies block of drawio.yml, with the list each came from."""
    words = {}
    for name, entries in DEFAULTS["vocabularies"].items():
        for word in str(entries).split(","):
            word = word.strip()
            if word:
                words.setdefault(word, name)
    return words


# ---- the declaration: read, validate, normalise -------------------------------------------------------------------


def load(folder):
    """The declaration of a diagram folder, from its one source file."""
    source = Path(folder) / SOURCE
    if not source.is_file():
        raise DeclarationError(f"{folder}: no {SOURCE}, the diagram's one source")
    return normalise(yaml.safe_load(source.read_text(encoding="utf-8")) or {}, where=str(source))


def save(folder, declaration):
    """Write a declaration into its folder's source file. The drawing carries no description, so a declaration read back by get
    keeps the description the file already has."""
    source = Path(folder) / SOURCE
    if source.is_file():
        held = normalise(yaml.safe_load(source.read_text(encoding="utf-8")) or {}, where=str(source))
        if not declaration.get("description"):
            declaration = {**declaration, "description": held["description"]}
        # The drawing carries only the ADR codes of `about:` (its subtitle); the rest of the subject is kept from the source.
        about = {"lens": declaration["about"]["lens"], **{key: declaration["about"][key] or held["about"][key] for key in minimaps.ABOUT_KEYS}}
        declaration = {**declaration, "about": about}
    source.write_text(dump(declaration), encoding="utf-8")


TOP_KEYS = ("description", "about", "content", "layout")
ABOUT_KEYS = ("adrs", "lens", "tracks", "languages", "modules", "files")  # the lens, then the subject's lists (minimaps.ABOUT_KEYS)


def normalise(raw, where="the declaration"):
    """The declaration with every default filled, every vocabulary checked, and every list in its canonical shape."""
    if not isinstance(raw, dict) or "content" not in raw:
        raise DeclarationError(f"{where}: a declaration is a map with a description:, a content: section and an optional layout: section")
    for key in raw:
        if key not in TOP_KEYS:
            choices(f"{where}: top-level key", key, TOP_KEYS)
    content = dict(raw["content"] or {})
    for key in content:
        if key not in CONTENT_KEYS:
            choices(f"{where}: content key", key, CONTENT_KEYS)
    out: dict = {"title": str(content.get("title", "")).strip()}
    if not out["title"]:
        raise DeclarationError(f"{where}: content.title is the finding the reader leaves with; it is empty")
    about_raw = raw.get("about") or {}
    if not isinstance(about_raw, dict):
        raise DeclarationError(f"{where}: about is a map of {', '.join(ABOUT_KEYS)}")
    for key in about_raw:
        if key not in ABOUT_KEYS:
            choices(f"{where}: about key", key, ABOUT_KEYS)
    lens = about_raw.get("lens", "meta")
    if lens not in DEFAULTS["lenses"]:
        choices(f"{where}: about.lens", lens, tuple(DEFAULTS["lenses"]))
    out["lens"] = lens
    kind = content.get("kind", KINDS[0])
    if kind not in KINDS:
        choices(f"{where}: kind", kind, KINDS)
    out["kind"] = kind
    flow = content.get("flow", FLOWS[0])
    if flow not in FLOWS:
        choices(f"{where}: flow", flow, FLOWS)
    out["flow"] = flow
    themes = tuple(DEFAULTS["themes"])
    theme = content.get("theme", themes[0])
    if theme not in themes:
        choices(f"{where}: theme", theme, themes)
    out["theme"] = theme
    out["bands"] = [entry(b, ("id", "label"), where, "band") for b in content.get("bands") or []]
    ids = {}
    for b in out["bands"]:
        ids.setdefault(b["id"], "band")
    out["groups"] = [entry(g, ("id", "label", "in"), where, "group") for g in content.get("groups") or []]
    for g in out["groups"]:
        if g["id"] in ids:
            raise DeclarationError(f"{where}: id '{g['id']}' is used twice")
        ids[g["id"]] = "group"
    out["glyphs"] = [entry(g, ("id", "kind", "label", "in"), where, "glyph") for g in content.get("glyphs") or []]
    for g in out["glyphs"]:
        if g["kind"] not in GLYPH_KINDS:
            choices(f"{where}: glyph '{g['id']}' kind", g["kind"], GLYPH_KINDS)
        if g["id"] in ids:
            raise DeclarationError(f"{where}: id '{g['id']}' is used twice")
        ids[g["id"]] = "glyph"
    for item in out["groups"] + out["glyphs"]:
        if item["in"] not in ids or ids[item["in"]] == "glyph":
            holders = [i for i, k in ids.items() if k != "glyph"]
            choices(f"{where}: '{item['id']}' in", item["in"], holders)
    vocabulary = span_vocabulary()
    out["spans"] = []
    for s in content.get("spans") or []:
        span = entry(s, ("id", "label", "over"), where, "span")
        if span["label"] not in vocabulary:
            choices(f"{where}: span '{span['id']}' label", span["label"], tuple(vocabulary))
        span["over"] = [str(o) for o in (span["over"] if isinstance(span["over"], list) else [span["over"]])]
        for band in span["over"]:
            if ids.get(band) != "band":
                choices(f"{where}: span '{span['id']}' over", band, [i for i, k in ids.items() if k == "band"])
        out["spans"].append(span)
    out["edges"] = []
    for e in content.get("edges") or []:
        edge = entry(e, ("from", "to"), where, "edge", optional={"kind": EDGE_KINDS[0], "label": ""})
        if edge["kind"] not in EDGE_KINDS:
            choices(f"{where}: edge {edge['from']} -> {edge['to']} kind", edge["kind"], EDGE_KINDS)
        for end in ("from", "to"):  # an edge joins glyphs or groups: a call into a function frame ends on the frame
            if ids.get(edge[end]) not in ("glyph", "group"):
                choices(f"{where}: edge {end}", edge[end], [i for i, k in ids.items() if k in ("glyph", "group")])
        out["edges"].append(edge)
    out["markers"] = []
    for m in content.get("markers") or []:
        marker = entry(m, ("at", "number"), where, "marker")
        if ids.get(marker["at"]) != "glyph":
            choices(f"{where}: marker at", marker["at"], [i for i, k in ids.items() if k == "glyph"])
        marker["number"] = int(marker["number"])
        out["markers"].append(marker)
    out["chips"] = []
    for c in content.get("chips") or []:
        chip = entry(c, ("at", "kind", "text"), where, "chip")
        if chip["kind"] not in ("rule", "count"):
            choices(f"{where}: chip at '{chip['at']}' kind", chip["kind"], ("rule", "count"))
        if ids.get(chip["at"]) != "glyph":
            choices(f"{where}: chip at", chip["at"], [i for i, k in ids.items() if k == "glyph"])
        out["chips"].append(chip)
    legend = content.get("legend", "auto")
    if legend != "auto":
        phrases = legend_phrases()
        if not isinstance(legend, list):
            raise DeclarationError(f"{where}: legend is auto or a list of the phrases the legend shows")
        for phrase in legend:
            if phrase not in phrases:
                choices(f"{where}: legend phrase", phrase, phrases)
    out["legend"] = legend
    # The one relationship the flow edges mean on this diagram, named in the legend as `flow: <relation>`.
    out["relation"] = str(content.get("relation", "") or "").strip()
    pools = DEFAULTS["minimaps"]
    allowed = tuple(str(pools["ids"]).replace(",", " ").split())
    declared = content.get("minimaps") or str(pools[f"{kind}_default"]).replace(",", " ").split()
    if len(declared) != 3:
        raise DeclarationError(f"{where}: minimaps names exactly three views of: {', '.join(allowed)}; it names {len(declared)}")
    for view in declared:
        if view not in allowed:
            choices(f"{where}: minimap view", view, allowed)
    if len(set(declared)) != 3:
        raise DeclarationError(f"{where}: the three minimaps show three different views")
    out["minimaps"] = [str(v) for v in declared]
    # What the diagram is about: the lens it is drawn through and the subject every minimap is computed from, each name checked
    # against its registry.
    about = {"lens": lens, **{key: [str(v) for v in (about_raw.get(key) or [])] for key in minimaps.ABOUT_KEYS}}
    for problem in minimaps.problems(about):
        raise DeclarationError(f"{where}: {problem}")
    out["adrs"] = about["adrs"]
    layout = {}
    for cid, box in (raw.get("layout") or {}).items():
        if cid not in ids:
            choices(f"{where}: layout cell", cid, tuple(ids))
        if not isinstance(box, dict) or set(box) != {"x", "y", "w", "h"}:
            raise DeclarationError(f"{where}: layout '{cid}' is a map of x, y, w and h")
        layout[cid] = {k: int(box[k]) for k in ("x", "y", "w", "h")}
    # What the diagram shows, in a sentence or two, for whoever meets it outside any article; no article is named here.
    description = " ".join(str(raw.get("description", "") or "").split())
    return {"description": description, "about": about, "content": out, "layout": layout}


def entry(item, keys, where, what, optional=None):
    if not isinstance(item, dict):
        raise DeclarationError(f"{where}: a {what} is a map of {', '.join(keys)}")
    allowed = tuple(keys) + tuple(optional or ())
    for key in item:
        if key not in allowed:
            choices(f"{where}: {what} key", key, allowed)
    out = {}
    for key in keys:
        if key not in item or item[key] in (None, ""):
            raise DeclarationError(f"{where}: a {what} needs {key}")
        out[key] = item[key] if isinstance(item[key], list) else str(item[key])
    for key, default in (optional or {}).items():
        out[key] = str(item.get(key, default))
    return out


def legend_phrases():
    return tuple([g["phrase"] for g in LIB["glyphs"].values()] + [e["phrase"] for e in LIB["edges"].values()] + [m["phrase"] for m in LIB["marks"].values()])


def dump(declaration):
    """The whole declaration as the text of its source file, keys in the kit's order."""
    content = declaration["content"]
    ordered = {k: content[k] for k in CONTENT_KEYS if k in content and content[k] not in ([], {}, "")}
    out = {"description": declaration["description"]} if declaration.get("description") else {}
    about = declaration.get("about") or {}
    out["about"] = {key: about[key] for key in ABOUT_KEYS if about.get(key)}
    out["content"] = ordered
    if declaration.get("layout"):
        out["layout"] = dict(declaration["layout"])
    return yaml.safe_dump(out, sort_keys=False, allow_unicode=True, width=120)


# ---- put: the declaration becomes the model ------------------------------------------------------------------------


def cell(cid, value, style, x, y, w, h, parent="1"):
    return {"id": cid, "value": value, "style": style, "x": x, "y": y, "w": w, "h": h, "parent": parent, "edge": None}


def edge_cell(cid, value, style, source, target):
    return {"id": cid, "value": value, "style": style, "source": source, "target": target, "parent": "1", "edge": True}


def place(declaration):
    """Every cell of the model with its absolute geometry: the grid places what the layout does not name."""
    content, layout = declaration["content"], declaration["layout"]
    glyph_lib = LIB["glyphs"]
    holder = {}
    for item in content["groups"] + content["glyphs"]:
        holder.setdefault(item["in"], []).append(item)

    def size_of(item):
        if item["id"] in layout:
            return layout[item["id"]]["w"], layout[item["id"]]["h"]
        if "kind" in item:
            return glyph_lib[item["kind"]]["size"]
        inner_w, inner_h = grid_size(item["id"])
        return inner_w + 2 * PAD, inner_h + LABEL_ROW + PAD

    def grid_size(holder_id, width=None):
        items = holder.get(holder_id, [])
        if not items:
            return 0, 0
        sizes = [size_of(i) for i in items]
        if width is None:
            columns = max(1, min(len(items), 4))
            width = sum(s[0] for s in sizes[:columns]) + COL_GAP * (columns - 1)
        x = y = row_h = 0
        total_w = 0
        for (w, h) in sizes:
            if x > 0 and x + w > width:
                y += row_h + ROW_GAP
                x, row_h = 0, 0
            x += w + COL_GAP
            row_h = max(row_h, h)
            total_w = max(total_w, x - COL_GAP)
        return total_w, y + row_h

    vertical = content["flow"] == "top-to-bottom"
    has_spans = bool(content["spans"])
    bands = content["bands"]
    cells = []
    # The chrome: title and subtitle.
    # The lens once, as the chip that opens the title row; the subtitle under the title is the ADR codes alone.
    chip_w = 16 + 8 * len(content["lens"])
    cells.append(cell("lens-badge", content["lens"].upper(), BADGE, PAGE["x"], PAGE["title_y"] + 4, chip_w, 22))
    title_x = PAGE["x"] + chip_w + 12
    cells.append(cell("title", content["title"], TITLE, title_x, PAGE["title_y"], PAGE["width"] - (title_x - PAGE["x"]), 30))
    cells.append(cell("subtitle", " · ".join(content["adrs"]), SUBTITLE, PAGE["x"], PAGE["subtitle_y"], PAGE["width"] - 20, 20))
    # The bands along the flow: side by side left to right, or stacked top to bottom.
    band_box = {}
    if vertical:
        left = PAGE["x"] + (50 if has_spans else 0)
        width = PAGE["width"] - (left - PAGE["x"])
        y = PAGE["band_y"] - (24 if not has_spans else 0)
        for b in bands:
            inner_h = grid_size(b["id"], width - 2 * PAD)[1]
            h = max(inner_h + LABEL_ROW + PAD, 120)
            band_box[b["id"]] = layout.get(b["id"], {"x": left, "y": y, "w": width, "h": h})
            y = band_box[b["id"]]["y"] + band_box[b["id"]]["h"] + GAP
        content_bottom = y - GAP
    else:
        n = max(1, len(bands))
        width = (PAGE["width"] - GAP * (n - 1)) // n
        inner = [grid_size(b["id"], width - 2 * PAD) for b in bands]
        h = max([i[1] + LABEL_ROW + PAD for i in inner] + [120])
        top = PAGE["band_y"] if has_spans else PAGE["band_y"] - 24
        x = PAGE["x"]
        for b in bands:
            band_box[b["id"]] = layout.get(b["id"], {"x": x, "y": top, "w": width, "h": h})
            x = band_box[b["id"]]["x"] + band_box[b["id"]]["w"] + GAP
        content_bottom = max([bb["y"] + bb["h"] for bb in band_box.values()] + [top])
    for b in bands:
        bb = band_box[b["id"]]
        cells.append(cell(b["id"], b["label"], BAND, bb["x"], bb["y"], bb["w"], bb["h"]))
    # The span bars over (or beside) the bands they cover.
    for s in content["spans"]:
        boxes = [band_box[b] for b in s["over"]]
        if vertical:
            y0, y1 = min(b["y"] for b in boxes), max(b["y"] + b["h"] for b in boxes)
            bar = cell(s["id"], "", "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=#AAB4C3;strokeWidth=1.5;shadow=0;rotation=90;", PAGE["x"] + 12, y0, 14, y1 - y0)
            label = cell(f"{s['id']}-label", s["label"], SPAN_LABEL, PAGE["x"] - 4, (y0 + y1) // 2 - 8, 30, 16)
        else:
            x0, x1 = min(b["x"] for b in boxes), max(b["x"] + b["w"] for b in boxes)
            bar = cell(s["id"], "", "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=#AAB4C3;strokeWidth=1.5;shadow=0;", x0, PAGE["span_y"], x1 - x0, 14)
            label = cell(f"{s['id']}-label", s["label"], SPAN_LABEL, (x0 + x1) // 2 - 15, PAGE["span_y"] - 18, 30, 16)
        cells.extend([bar, label])
    # The groups and glyphs inside their holders, by the grid unless the layout places them.
    box_of = dict(band_box)

    def fill(holder_id, origin_x, origin_y, width, parent):
        x = y = row_h = 0
        for item in holder.get(holder_id, []):
            w, h = size_of(item)
            if x > 0 and x + w > width:
                y += row_h + ROW_GAP
                x, row_h = 0, 0
            box = layout.get(item["id"]) or {"x": origin_x + x, "y": origin_y + y, "w": w, "h": h}
            box_of[item["id"]] = box
            if "kind" in item:
                cells.append(cell(item["id"], f"<b>{html.escape(item['label'])}</b>", glyph_lib[item["kind"]]["style"], box["x"], box["y"], box["w"], box["h"], parent))
                if item["kind"] == "type":
                    tag = glyph_lib["type"]["tag"]
                    cells.append(cell(f"{item['id']}-tag", "C#", tag["style"], box["x"] + box["w"] - tag["size"][0] - 8, box["y"] - 8, tag["size"][0], tag["size"][1], parent))
            else:
                cells.append(cell(item["id"], item["label"], LIB["module"], box["x"], box["y"], box["w"], box["h"], parent))
                fill(item["id"], box["x"] + PAD, box["y"] + LABEL_ROW, box["w"] - 2 * PAD, item["id"])
            x += w + COL_GAP
            row_h = max(row_h, h)

    for b in bands:
        bb = band_box[b["id"]]
        fill(b["id"], bb["x"] + PAD, bb["y"] + LABEL_ROW, bb["w"] - 2 * PAD, "1")
    # Edges, markers and chips anchor on the glyphs.
    for e in content["edges"]:
        style = LIB["edges"][e["kind"]]["style"]
        if e["label"]:
            style = style.replace("shadow=0;", "fontColor=#CDD3DC;fontStyle=1;fontSize=11;labelBackgroundColor=#262E3B;shadow=0;")
        cells.append(edge_cell(f"e-{e['from']}-{e['to']}", f"<b>{html.escape(e['label'])}</b>" if e["label"] else "", style, e["from"], e["to"]))
    for m in content["markers"]:
        box = box_of[m["at"]]
        size = LIB["marks"]["marker"]["size"]
        kind = next((g["kind"] for g in content["glyphs"] if g["id"] == m["at"]), "")
        # A diamond's corner is empty space, so its marker sits beside its top point; any other glyph's on its top-left corner.
        mx, my = (box["x"] + box["w"] // 2 - 40, box["y"] - 4) if kind == "gate" else (box["x"] - 10, box["y"] - 11)
        cells.append(cell(f"mark-{m['number']}", str(m["number"]), LIB["marks"]["marker"]["style"], mx, my, size[0], size[1]))
    for c in content["chips"]:
        box = box_of[c["at"]]
        mark = LIB["marks"][c["kind"]]
        cx, cy = (box["x"] + box["w"] - 26, box["y"] - 9) if c["kind"] == "rule" else (box["x"] + box["w"] - 18, box["y"] + box["h"] - 9)
        cells.append(cell(f"chip-{c['kind']}-{c['at']}", c["text"], mark["style"], cx, cy, mark["size"][0], mark["size"][1]))
    # The legend below the bands: the kinds the diagram uses, in columns.
    legend_y = content_bottom + GAP
    entries = legend_entries(content)
    rows = 3
    columns = max(1, (len(entries) + rows - 1) // rows)
    col_w = min(240, (PAGE["width"] - 32) // columns)
    legend_h = 30 + rows * 28 if entries else 48
    cells.append(cell("legend", "<b>Legend</b>", LEGEND, PAGE["x"], legend_y, PAGE["width"], legend_h))
    for i, (eid, swatch, phrase) in enumerate(entries):
        col, row = divmod(i, rows)
        sx, sy = PAGE["x"] + 16 + col * col_w, legend_y + 30 + row * 28
        cells.extend(swatch(eid, sx, sy))
        cells.append(cell(f"lg-{eid}-t", phrase, TEXT, sx + 48, sy - 1, col_w - 56, 20))
    # The sidebar: the three minimaps, drawn from their claims and embedded, the lens badge and the map key. The ADR codes live in
    # the subtitle alone.
    height = max(PAGE["min_height"], legend_y + legend_h + GAP, MAPKEY_BOTTOM)
    cells.insert(0, cell("sidebar-bg", "", SIDEBAR_BG, SIDEBAR_X - 12, 4, SIDEBAR_W + 24, height - 8))
    for (cid, y, h), minimap in zip(SIDEBAR, content["minimaps"]):
        image = minimaps.picture(minimap, declaration.get("about") or {k: [] for k in minimaps.ABOUT_KEYS}, SIDEBAR_W, h)
        cells.append(cell(cid, minimap, MINIMAP + f"noLabel=1;image={image};", SIDEBAR_X, y, SIDEBAR_W, h))
    # The map key: the two marks every minimap shares.
    cells.append(cell("mapkey", "<b>Map key</b>", LEGEND, SIDEBAR_X, MAPKEY_Y, SIDEBAR_W, 82))
    for i, (swatch, phrase) in enumerate(((minimaps.LIT, "lit: what this diagram draws"), (minimaps.PANEL, "dim: what sits around it"))):
        y = MAPKEY_Y + 30 + i * 24
        rim = "none" if swatch == minimaps.LIT else minimaps.RIM
        cells.append(cell(f"mk-{i}", "", f"rounded=1;arcSize=20;html=1;fillColor={swatch};strokeColor={rim};shadow=0;", SIDEBAR_X + 12, y, 26, 16))
        cells.append(cell(f"mk-{i}-t", phrase, TEXT, SIDEBAR_X + 48, y - 2, SIDEBAR_W - 56, 20))
    return cells, height


def legend_entries(content):
    """What the legend shows: the glyph kinds, edge kinds and marks the diagram uses, or the phrases the declaration lists."""
    glyphs = LIB["glyphs"]

    def swatch_for(kind):
        style = glyphs[kind]["style"]
        shape = style_map(style).get("shape", "")
        size = {"note": (32, 22), "cylinder3": (28, 26), "hexagon": (40, 22)}.get(shape, (24, 22) if "ellipse" in style else (36, 26) if "rhombus" in style else (40, 18))
        swatch_style = ";".join(p for p in style.split(";") if p and not p.startswith(("whiteSpace", "fontColor", "fontSize", "fontStyle", "boundedLbl", "backgroundOutline", "perimeter")))
        swatch_style = swatch_style.replace("size=14", "size=6").replace("size=8", "size=4") + ";"
        return lambda eid, x, y: [cell(f"lg-{eid}", "", swatch_style, x, y, size[0], size[1])]

    def edge_swatch(kind):
        style = LIB["edges"][kind]["style"]
        return lambda eid, x, y: [
            cell(f"lg-{eid}-a", "", ANCHOR, x, y + 9, 1, 1),
            cell(f"lg-{eid}-b", "", ANCHOR, x + 40, y + 9, 1, 1),
            edge_cell(f"lg-{eid}", "", style, f"lg-{eid}-a", f"lg-{eid}-b"),
        ]

    def mark_swatch(kind, text):
        mark = LIB["marks"][kind]
        return lambda eid, x, y: [cell(f"lg-{eid}", text, mark["style"], x + 4, y - 2, mark["size"][0], mark["size"][1])]

    entries = []
    wanted = content["legend"] if content["legend"] != "auto" else None
    for kind in dict.fromkeys(g["kind"] for g in content["glyphs"]):
        entries.append((kind, swatch_for(kind), glyphs[kind]["phrase"]))
    for kind in dict.fromkeys(e["kind"] for e in content["edges"]):
        phrase = f"flow: {content['relation']}" if kind == "flow" and content["relation"] else LIB["edges"][kind]["phrase"]
        entries.append((f"edge-{kind}", edge_swatch(kind), phrase))
    if content["markers"]:
        entries.append(("marker", mark_swatch("marker", "1"), LIB["marks"]["marker"]["phrase"]))
    for kind in dict.fromkeys(c["kind"] for c in content["chips"]):
        entries.append((f"chip-{kind}", mark_swatch(kind, "#2" if kind == "rule" else "87"), LIB["marks"][kind]["phrase"]))
    if wanted is not None:
        entries = [e for e in entries if e[2] in wanted]
    return entries


def to_xml(cells, height):
    """The mxGraphModel text, one cell a line, in the kit's fixed formatting so the same cells give the same bytes."""
    lines = [
        f'<mxGraphModel dx="1024" dy="768" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1572" pageHeight="{height}" background="#1E2430" math="0" shadow="1">',
        "  <root>",
        '    <mxCell id="0" />',
        '    <mxCell id="1" parent="0" />',
    ]
    origin = {c["id"]: (c["x"], c["y"]) for c in cells if not c["edge"]}
    for c in cells:
        value = html.escape(c["value"], quote=True)
        if c["edge"]:
            lines.append(f'    <mxCell id="{c["id"]}" value="{value}" style="{c["style"]}" edge="1" parent="{c["parent"]}" source="{c["source"]}" target="{c["target"]}">')
            lines.append('      <mxGeometry relative="1" as="geometry" />')
        else:
            px, py = origin.get(c["parent"], (0, 0)) if c["parent"] != "1" else (0, 0)
            lines.append(f'    <mxCell id="{c["id"]}" value="{value}" style="{c["style"]}" vertex="1" parent="{c["parent"]}">')
            lines.append(f'      <mxGeometry x="{c["x"] - px}" y="{c["y"] - py}" width="{c["w"]}" height="{c["h"]}" as="geometry" />')
        lines.append("    </mxCell>")
    lines.extend(["  </root>", "</mxGraphModel>"])
    return "\n".join(lines) + "\n"


def put(declaration):
    """The model XML of a declaration."""
    cells, height = place(declaration)
    return to_xml(cells, height)


def put_png(folder, declaration):
    """put, then the raster: the folder's diagram.drawio.png with the model embedded, drawn by drawio_png."""
    model = put(declaration).strip()
    img = render(ET.fromstring(model)).convert("RGB")
    info = PngInfo()
    info.add_text("mxfile", encode(model, declaration["content"]["lens"]))
    dst = Path(folder) / SLIDE
    img.save(dst, "PNG", pnginfo=info)
    return dst


# ---- get: the model becomes the declaration ------------------------------------------------------------------------


def signature(style):
    s = style_map(style)
    return tuple((k, s.get(k)) for k in SIGNATURE_KEYS if k in s)


def matches(sig, style):
    s = style_map(style)
    return all(s.get(k) == v for k, v in sig)


def model_of(folder):
    """The model embedded in the folder's diagram.drawio.png."""
    return decode(mxfile_chunk(Image.open(Path(folder) / SLIDE))).strip()


def get(model, kind=None):
    """The declaration a model states, in the kit's vocabulary; a cell the vocabulary cannot name fails the direction."""
    root = ET.fromstring(model)
    cells = {str(c.get("id")): c for c in root.iter("mxCell") if c.get("id") not in (None, "0", "1")}
    geo = {}
    for cid, c in cells.items():
        g = c.find("mxGeometry")
        if c.get("edge") == "1" or g is None:
            continue
        x, y = float(g.get("x", 0)), float(g.get("y", 0))
        parent = cells.get(c.get("parent") or "")
        while parent is not None:
            pg = parent.find("mxGeometry")
            if pg is None:
                break
            x, y = x + float(pg.get("x", 0)), y + float(pg.get("y", 0))
            parent = cells.get(parent.get("parent") or "")
        geo[cid] = {"x": int(x), "y": int(y), "w": int(float(g.get("width", 0))), "h": int(float(g.get("height", 0)))}
    glyph_sigs = {k: signature(v["style"]) for k, v in LIB["glyphs"].items()}
    mark_sigs = {k: signature(v["style"]) for k, v in LIB["marks"].items()}
    module_sig = signature(LIB["module"])
    content: dict = {"title": "", "kind": kind or KINDS[0], "flow": FLOWS[0]}
    lens = "meta"
    adrs: list = []
    content.update({"theme": next(iter(DEFAULTS["themes"])), "bands": [], "spans": [], "groups": [], "glyphs": []})
    content.update({"edges": [], "markers": [], "chips": [], "legend": "auto"})
    # The drawing carries each minimap's view, not its claims: save() keeps the claims the source already holds.
    content["minimaps"] = [plain(cells[cid].get("value")) for cid, _, _ in SIDEBAR if cid in cells]
    flow_phrase = plain(cells["lg-edge-flow-t"].get("value")) if "lg-edge-flow-t" in cells else ""
    content["relation"] = flow_phrase[len("flow: ") :] if flow_phrase.startswith("flow: ") else ""
    layout = {}
    unnamed = []
    bands, groups, glyphs, bars, labels, markers, chips = [], [], [], [], [], [], []
    derived = ("sidebar-bg", "legend", "lens-badge", "mapkey")
    lens = plain(cells["lens-badge"].get("value")).lower() if "lens-badge" in cells else lens
    for cid, c in cells.items():
        style, value = c.get("style") or "", plain(c.get("value"))
        if c.get("edge") == "1" or cid in derived or cid.startswith(("lg-", "mk-", "minimap-")) or cid.endswith("-tag"):
            continue
        if cid == "title":
            content["title"] = value
        elif cid == "subtitle":
            adrs = [p.strip() for p in value.split("·") if p.strip()]
        elif matches(signature(BAND), style):
            bands.append(cid)
        elif matches(module_sig, style):
            groups.append(cid)
        elif style_map(style).get("shape") == "crossbar":
            bars.append(cid)
        elif matches(signature(SPAN_LABEL), style):
            labels.append(cid)
        elif matches(mark_sigs["marker"], style) and value.isdigit():
            markers.append(cid)
        elif matches(mark_sigs["rule"], style) or matches(mark_sigs["count"], style):
            chips.append(cid)
        else:
            kinds = [k for k, sig in sorted(glyph_sigs.items(), key=lambda kv: -len(kv[1])) if matches(sig, style)]
            if f"{cid}-tag" in cells and "type" in kinds:
                glyphs.append((cid, "type"))
            elif kinds:
                glyphs.append((cid, kinds[0]))
            else:
                unnamed.append(cid)
    if unnamed:
        raise DeclarationError(f"get cannot name these cells in the kit's vocabulary: {', '.join(unnamed)}")
    inside = lambda inner, outer: outer["x"] <= inner["x"] + inner["w"] / 2 <= outer["x"] + outer["w"] and outer["y"] <= inner["y"] + inner["h"] / 2 <= outer["y"] + outer["h"]
    bands.sort(key=lambda b: (geo[b]["y"], geo[b]["x"]))
    for b in bands:
        content["bands"].append({"id": b, "label": plain(cells[b].get("value"))})
        layout[b] = geo[b]
    if len(bands) > 1 and all(geo[b]["x"] == geo[bands[0]]["x"] for b in bands):
        content["flow"] = "top-to-bottom"

    def holder_of(cid):
        parent = cells[cid].get("parent")
        if parent in groups:
            return parent
        candidates = [b for b in bands if inside(geo[cid], geo[b])]
        return candidates[0] if candidates else (bands[0] if bands else None)

    # Groups and glyphs come holder by holder, depth first (a band, then the groups inside it, each with the groups inside it),
    # row-major inside each holder.
    holders = {h: holder_of(h) for h in groups}
    order = []

    def walk(holder_id):
        order.append(holder_id)
        for g in sorted((g for g in groups if holders[g] == holder_id), key=lambda g: (geo[g]["y"], geo[g]["x"])):
            walk(g)

    for b in bands:
        walk(b)
    rank = {h: i for i, h in enumerate(order)}
    for g in sorted(groups, key=lambda g: (rank[holders[g]], geo[g]["y"], geo[g]["x"])):
        content["groups"].append({"id": g, "label": plain(cells[g].get("value")), "in": holders[g]})
        layout[g] = geo[g]
    for cid, k in sorted(glyphs, key=lambda t: (rank[holder_of(t[0])], geo[t[0]]["y"], geo[t[0]]["x"])):
        content["glyphs"].append({"id": cid, "kind": k, "label": plain(cells[cid].get("value")), "in": holder_of(cid)})
        layout[cid] = geo[cid]
    for bar in bars:
        box = geo[bar]
        vertical = "rotation=90" in (cells[bar].get("style") or "")
        near = [l for l in labels if abs((geo[l]["x"] + geo[l]["w"] / 2) - (box["x"] + box["w"] / 2)) <= 40 and abs((geo[l]["y"] + geo[l]["h"] / 2) - (box["y"] + box["h"] / 2)) <= (box["h"] / 2 + 40 if vertical else 40)]
        over = [b for b in bands if (geo[b]["y"] >= box["y"] - 2 and geo[b]["y"] + geo[b]["h"] <= box["y"] + box["h"] + 2) if vertical] if vertical else [b for b in bands if geo[b]["x"] >= box["x"] - 2 and geo[b]["x"] + geo[b]["w"] <= box["x"] + box["w"] + 2]
        content["spans"].append({"id": bar, "label": plain(cells[near[0]].get("value")) if near else "", "over": over})
    glyph_ids = [g[0] for g in glyphs]
    nearest = lambda box, corner: min(glyph_ids, key=lambda g: abs(corner(geo[g])[0] - (box["x"] + box["w"] / 2)) + abs(corner(geo[g])[1] - (box["y"] + box["h"] / 2))) if glyph_ids else None
    kind_of = dict(glyphs)
    # Where put centres a glyph's marker: beside a diamond's top point, on any other glyph's top-left corner.
    anchor = {g: ((geo[g]["x"] + geo[g]["w"] // 2 - 29, geo[g]["y"] + 7) if kind_of[g] == "gate" else (geo[g]["x"] + 1, geo[g]["y"])) for g in glyph_ids}
    for m in sorted(markers, key=lambda m: int(plain(cells[m].get("value")))):
        centre = (geo[m]["x"] + geo[m]["w"] / 2, geo[m]["y"] + geo[m]["h"] / 2)
        at = min(glyph_ids, key=lambda g: abs(anchor[g][0] - centre[0]) + abs(anchor[g][1] - centre[1]))
        content["markers"].append({"at": at, "number": int(plain(cells[m].get("value")))})
    for ch in chips:
        kind = "rule" if matches(mark_sigs["rule"], cells[ch].get("style") or "") else "count"
        corner = (lambda g: (g["x"] + g["w"], g["y"])) if kind == "rule" else (lambda g: (g["x"] + g["w"], g["y"] + g["h"]))
        content["chips"].append({"at": nearest(geo[ch], corner), "kind": kind, "text": plain(cells[ch].get("value"))})
    edge_sigs = {k: signature(v["style"]) for k, v in LIB["edges"].items()}
    for cid, c in cells.items():
        if c.get("edge") != "1" or cid.startswith("lg-"):
            continue
        kinds = [k for k, sig in sorted(edge_sigs.items(), key=lambda kv: -len(kv[1])) if matches(sig, c.get("style") or "")]
        if not kinds:
            raise DeclarationError(f"get cannot name the edge {cid} in the kit's vocabulary")
        content["edges"].append({"from": c.get("source"), "to": c.get("target"), "kind": kinds[0], "label": plain(c.get("value"))})
    declaration = normalise({"about": {"adrs": adrs, "lens": lens}, "content": content, "layout": layout}, where="the drawing")
    # A cell that sits where the grid would put it needs no layout entry: the layout keeps only what a hand moved.
    grid = {c["id"]: {k: c[k] for k in ("x", "y", "w", "h")} for c in place({"content": declaration["content"], "layout": {}})[0] if not c["edge"]}
    declaration["layout"] = {cid: box for cid, box in declaration["layout"].items() if grid.get(cid) != box}
    return declaration


def main():
    args = sys.argv[1:]
    if len(args) < 2 or args[0] not in ("put", "get"):
        raise SystemExit(__doc__)
    direction, folder = args[0], Path(args[1])
    if direction == "put":
        declaration = load(folder)
        if "--xml" in args:
            Path(args[args.index("--xml") + 1]).write_text(put(declaration), encoding="utf-8")
        dst = put_png(folder, declaration)
        print(f"put {dst}")
    else:
        kind = next((k for k in KINDS if f"/{k}/" in folder.resolve().as_posix()), None)
        save(folder, get(model_of(folder), kind))
        print(f"get {folder / SOURCE}")


if __name__ == "__main__":
    main()
