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
  uv run --project python python python/catzc_diagrams/declaration.py put <diagram folder> [--xml <out.xml>]
  uv run --project python python python/catzc_diagrams/declaration.py get <diagram folder>
  uv run --project python python python/catzc_diagrams/declaration.py check <diagram folder>...
  uv run --project python python python/catzc_diagrams/declaration.py sync <diagram folder>
  uv run --project python python python/catzc_diagrams/declaration.py tidy <diagram folder>

A pair whose yml and png both moved from the pair committed at git HEAD, and now disagree, is a conflict: check names its cells, the bulk
put skips it, and only put or get by name, the author's pick of the side that wins, clears it. Nothing merges.

Every vocabulary (glyph kinds, edge kinds, span labels, minimap ids, flows, themes, lenses, kinds) is closed: a value outside it
fails validation with the list the author may choose from, so the errors teach the kit.
"""

import html
import io
import itertools
import json
import math
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import NoReturn

import minimap_contract
import minimaps
import yaml
from drawio_png import DEFAULTS, THEMES, decode, encode, mxfile_chunk, paint, plain, render, style_map
from PIL import Image
from PIL.PngImagePlugin import PngInfo

KIT = Path(__file__).resolve().parent
SLIDE = "diagram.drawio.png"
SOURCE = "diagram.drawio.yml"  # the diagram's one source: its description, its content and the layout of the cells off the grid
FLOWS = ("left-to-right", "top-to-bottom")
KINDS = tuple(DEFAULTS["kinds"])
# The cells put derives from the kit and the registries, never from the author: get skips them, and a change to them is stale.
DERIVED = ("sidebar-bg", "legend", "lens-badge", "mapkey")
DERIVED_PREFIXES = ("lg-", "mk-", "minimap-", "lane-")  # lane- is a lane's trunk, its marks and the gate rules: the yml's alone
CONTENT_KEYS = (
    "title", "kind", "flow", "relation", "theme", "bands", "spans", "templates", "rows", "lanes", "rules", "groups", "glyphs", "edges", "markers",
    "chips", "notes", "legend", "minimaps",
)
# A note: a free text block drawn on the panel; `noteBlock=1` lets get tell it from every glyph.
NOTE = "text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;spacing=10;fontSize=11;fontColor=@ink;fillColor=@panel;strokeColor=@panel-rim;rounded=1;arcSize=4;noteBlock=1;"
NOTE_WIDTH = 380
ROW_PITCH, ROW_DROP = 92, 52
BYPASS_DIP = 12  # how far a bypass runs below and beside the dots it joins: halfway down to the drops
SHIFT_KEY = "drawingShift"  # the title's style key for how far span room moved the drawing area down, written only when it did
# The keys an author writes as shorthand: dump writes them back, never the cells they expand to.
SHORTHAND = ("templates", "rows", "lanes", "rules")
LANE_KEYS = ("band", "steps", "trunk", "commits", "glyphs", "marks")
RULE_KINDS = ("manual", "automated")  # a gate rule: a solid red line for a manual gate, a dashed line for an automated one
LANE_HEIGHT, LANE_ROW = 150, 38  # a lane band's height, and how far a branch row sits above or below the trunk
TRUNK = "endArrow=block;html=1;strokeColor=@line;strokeWidth=3;shadow=0;"
TRUNK_LABEL = "text;html=1;align=right;verticalAlign=middle;fontSize=11;fontStyle=1;fontColor=@ink;"
MARK_TEXT = "text;html=1;whiteSpace=wrap;align=center;verticalAlign=bottom;fontSize=10;fontColor=@red-rim;"
RULE_STYLES = {
    "manual": "endArrow=none;html=1;strokeColor=@red-rim;strokeWidth=3;shadow=0;",
    "automated": "endArrow=none;html=1;strokeColor=@line;strokeWidth=2;dashed=1;shadow=0;",
}  # a template row: the step between its dots, and how far below a dot its drop sits
PAGE = {"x": 20, "width": 1260, "title_y": 14, "subtitle_y": 44, "span_y": 84, "band_y": 108, "min_height": 640}
GAP, PAD, LABEL_ROW, ROW_GAP, COL_GAP = 20, 20, 40, 36, 40
SIDEBAR_X, SIDEBAR_W = 1316, 240
SIDEBAR = (("minimap-1", 16, 150), ("minimap-2", 182, 180), ("minimap-3", 378, 150))
MAPKEY_Y = 544  # the map key's panel, under the three minimaps
MAPKEY_BOTTOM = MAPKEY_Y + 82 + 16  # its bottom, and the sidebar's pad under it
# The style keys that identify a glyph kind: the shape and the two colours, with the marks that set a variant apart.
SIGNATURE_KEYS = ("shape", "ellipse", "rhombus", "rounded", "curved", "arcSize", "fillColor", "strokeColor", "dashed", "strokeWidth", "fontColor", "fontSize", "fontStyle", "align")
TEXT = "text;html=1;align=left;verticalAlign=middle;fontSize=11;fontColor=@quiet;"
KEY = "text;html=1;align=left;verticalAlign=middle;fontSize=10;fontStyle=1;fontColor=@band-label;"
# The locked commit palette from drawio.yml: state -> (fill, stroke, digit ink); the first state is a commit's default.
COMMITS = {state: tuple("#" + v for v in str(value).split()) for state, value in DEFAULTS["commits"].items()}
COMMIT_STATES = tuple(COMMITS)
COMMIT_SHAPES = ("dot", "box")  # a commit is a dot unless it is a state drawn as a box
# A commit drawn as a box: a named rounded box the palette colours; `commitShape=box` lets get tell it from a glyph of the same fill.
COMMIT_BOX = "rounded=1;whiteSpace=wrap;html=1;arcSize=12;fontStyle=1;fontSize=12;commitShape=box;"
COMMIT_BOX_SIZE = (134, 50)
GHOST = "strokeWidth=1.2;dashed=1;opacity=60;"
CORNERS = ("top-left", "top-right", "bottom-left", "bottom-right")
CHIP_CORNER = {"rule": "top-right", "count": "bottom-right"}  # where a chip sits unless it names a corner


def marker_xy(box, corner):
    """Where a marker sits on a box's corner: its 22 px disc centred on the corner."""
    x = box["x"] - 10 if corner.endswith("left") else box["x"] + box["w"] - 12
    y = box["y"] - 11 if corner.startswith("top") else box["y"] + box["h"] - 11
    return x, y


def edge_middle(a, b, via):
    """The point halfway along an edge's path, from box a's centre through its waypoints to box b's centre."""
    points = [(a["x"] + a["w"] / 2, a["y"] + a["h"] / 2), *map(tuple, via), (b["x"] + b["w"] / 2, b["y"] + b["h"] / 2)]
    legs = [((p, q), math.dist(p, q)) for p, q in itertools.pairwise(points)]
    left = sum(length for _, length in legs) / 2
    for (p, q), length in legs:
        if left <= length and length:
            return p[0] + (q[0] - p[0]) * left / length, p[1] + (q[1] - p[1]) * left / length
        left -= length
    return points[-1]


def auto_corner(box, sources):
    """The top corner away from the edges that arrive at a glyph: top-left unless they come in from the left."""
    from_left = sources and sum(s["x"] + s["w"] / 2 for s in sources) / len(sources) < box["x"]
    return "top-right" if from_left else "top-left"


def commit_style(base, state, ghost):
    """A commit's style in its palette state: the library commit's shape with the state's fill, stroke and ink, faded when a ghost."""
    fill, stroke, ink = COMMITS[state]
    style = ";".join(p for p in base.split(";") if p and not p.startswith(("fillColor=", "strokeColor=", "fontColor="))) + ";"
    return style + f"fillColor={fill};strokeColor={stroke};fontColor={ink};" + (GHOST if ghost else "")
TITLE = "text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=@title;"
SUBTITLE = "text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=12;fontColor=@quiet;"  # wraps to a second line
BAND = "rounded=1;html=1;arcSize=3;fillColor=@band;strokeColor=@band-rim;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=@band-label;"
LEGEND = "rounded=1;whiteSpace=wrap;html=1;arcSize=6;fillColor=@panel;strokeColor=@panel-rim;align=left;verticalAlign=top;spacing=8;fontSize=11;fontColor=@ink;"
SPAN_LABEL = "text;html=1;align=center;verticalAlign=middle;fontSize=11;fontStyle=1;fontColor=@band-label;"
ANCHOR = "text;html=1;strokeColor=none;fillColor=none;"
SIDEBAR_BG = "rounded=1;arcSize=2;html=1;fillColor=@sidebar;strokeColor=@sidebar-rim;shadow=0;"
MINIMAP = "shape=image;imageAspect=0;rounded=1;arcSize=4;whiteSpace=wrap;html=1;fillColor=@band;strokeColor=@band-rim;dashed=1;fontColor=@quiet;fontSize=11;"
BADGE = "rounded=0;whiteSpace=wrap;html=1;align=center;verticalAlign=middle;fontSize=12;fontStyle=1;fontColor=@mark-ink;fillColor=@mark;strokeColor=none;"


class DeclarationError(ValueError):
    """A declaration outside the kit's vocabulary, naming what the author may choose from."""


def choices(what, value, allowed) -> NoReturn:
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
    """Every span label the kit allows, flattened from the vocabularies block of drawio.yml and the tracks of variants.yml, with the list
    each came from."""
    words = {}
    for name, entries in DEFAULTS["vocabularies"].items():
        for word in str(entries).split(","):
            word = word.strip()
            if word:
                words.setdefault(word, name)
    for track in minimaps.tracks():
        words.setdefault(track, "tracks")
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
        # The drawing carries the ADR codes of `about:` in its subtitle; a drawing without them keeps the source's.
        about = {"lens": declaration["about"]["lens"], **{key: declaration["about"][key] or held["about"][key] for key in minimaps.ABOUT_KEYS}}
        declaration = {**declaration, "about": about, "content": undrawn(declaration["content"], held)}
        # The drawing carries a row only as its expansion: when the drawing still draws what the source's rows expand to, the source
        # keeps its rows (the layout is the drawing's); when it draws something else, the drawing wins.
        generated = held["content"].get("generated") or set()
        if generated:
            old, new = drawn(held["content"]), drawn(declaration["content"])
            mine = lambda d: ({k: d[key].get(k) for key in ("groups", "glyphs") for k in generated if k in d[key]},
                              [e for e in d["edges"] if dict(e)["from"] in generated and dict(e)["to"] in generated])
            if mine(old) == mine(new):
                kept = {k: held["content"][k] for k in SHORTHAND + ("generated",) if k in held["content"]}
                declaration = {**declaration, "content": {**declaration["content"], **kept}}
    source.write_text(dump(declaration), encoding="utf-8")


TOP_KEYS = ("description", "about", "content", "layout")
# Content the drawing cannot carry exactly: the kind is never drawn, a layout can place the bands against the flow, and the legend
# prints the relation without its parenthesis or not at all. get guesses each for a drawing without a source; a source keeps its own.
SOURCE_ONLY = ("kind", "flow", "relation")


def undrawn(content, declared):
    """A content read back by get, with what the declared source says and its drawing does not show laid over it: the SOURCE_ONLY
    facts, the band order when the layout places every band, and the band of an item the layout places, which get can only guess
    from where it sits (put refuses a place inside another band)."""
    source, layout = declared["content"], declared["layout"]
    out = {**content, **{k: source[k] for k in SOURCE_ONLY}}
    if source["bands"] and all(b["id"] in layout for b in source["bands"]) and {b["id"] for b in source["bands"]} == {b["id"] for b in content["bands"]}:
        out["bands"] = source["bands"]
    bands = {b["id"] for b in source["bands"]}
    held = {i["id"]: i["in"] for key in ("groups", "glyphs") for i in source.get(key) or [] if i["id"] in layout and i["in"] in bands}
    for key in ("groups", "glyphs"):
        out[key] = [{**i, "in": held[i["id"]]} if i["id"] in held and i.get("in") in bands else i for i in out.get(key) or []]
    return out
ABOUT_KEYS = ("adrs", "lens")  # the subject's ADR codes and the lens it is drawn through
# The subject's former lists: read and ignored, never written back, so a get or a save drops them (the minimaps' rework).
RETIRED_ABOUT_KEYS = ("tracks", "languages", "modules", "files")


def drawn(content):
    """What a content draws, the same whether it was written with rows or read back from the drawing: its cells keyed by id, its
    edges as a set, and the rest as written."""
    out = {k: v for k, v in content.items() if k not in SHORTHAND + ("generated",)}
    for key in ("groups", "glyphs", "notes"):
        out[key] = {i["id"]: i for i in content.get(key) or []}
    out["edges"] = sorted(tuple(sorted(e.items())) for e in content.get("edges") or [])
    return out


def expand_lanes(content, where):
    """The content with each lane's commits written out: a commit glyph in the lane's band per commit, and an edge from a commit's
    `from` to it, a branch leaving or rejoining the trunk. Returns the written-out ids, so dump writes the lane back."""
    lanes = content.get("lanes") or []
    if not lanes:
        return content, set()
    bands = {b["id"] for b in content.get("bands") or [] if isinstance(b, dict)}
    glyphs, edges = list(content.get("glyphs") or []), list(content.get("edges") or [])
    generated = set()
    for raw_lane in lanes:
        if not isinstance(raw_lane, dict):
            raise DeclarationError(f"{where}: a lane is a map of band, steps, and optionally trunk, commits and marks")
        for key in raw_lane:
            if key not in LANE_KEYS:
                choices(f"{where}: lane key", key, LANE_KEYS)
        band, steps = str(raw_lane.get("band", "")), raw_lane.get("steps")
        if band not in bands:
            choices(f"{where}: lane band", band, tuple(sorted(bands)))
        if not isinstance(steps, int) or steps < 2:
            raise DeclarationError(f"{where}: lane '{band}' steps is a whole number of at least 2")
        for raw in raw_lane.get("commits") or []:
            commit = entry(raw, ("id", "step", "label"), where, "lane commit", optional={"row": 0, "state": COMMIT_STATES[0], "from": ""})
            if not commit["step"].isdigit() or not 1 <= int(commit["step"]) <= steps:
                raise DeclarationError(f"{where}: lane commit '{commit['id']}' step {commit['step']} is not one of 1 to {steps}")
            if commit["row"] not in ("-1", "0", "1"):
                choices(f"{where}: lane commit '{commit['id']}' row", commit["row"], ("-1", "0", "1"))
            glyphs.append({"id": commit["id"], "kind": "commit", "label": commit["label"], "in": band,
                           **({"state": commit["state"]} if commit["state"] != COMMIT_STATES[0] else {})})
            if commit["from"]:
                edges.append({"from": commit["from"], "to": commit["id"], "kind": "flow"})
            generated.add(commit["id"])
        # Any other glyph a lane holds sits at a step too: a gate, an environment slot and the commits occupying it, a code unit.
        for raw in raw_lane.get("glyphs") or []:
            item = entry(raw, ("id", "step", "kind", "label"), where, "lane glyph", optional={"row": 0})
            if not item["step"].isdigit() or not 1 <= int(item["step"]) <= steps:
                raise DeclarationError(f"{where}: lane glyph '{item['id']}' step {item['step']} is not one of 1 to {steps}")
            if item["row"] not in ("-1", "0", "1"):
                choices(f"{where}: lane glyph '{item['id']}' row", item["row"], ("-1", "0", "1"))
            glyphs.append({"id": item["id"], "kind": item["kind"], "label": item["label"], "in": band})
            generated.add(item["id"])
        mine = {str(c["id"]) for c in raw_lane.get("commits") or [] if isinstance(c, dict)}
        for raw in raw_lane.get("marks") or []:
            mark = entry(raw, ("at", "text"), where, "lane mark")
            if mark["at"] not in mine:
                choices(f"{where}: lane mark at", mark["at"], tuple(sorted(mine)))
    return {**content, "glyphs": glyphs, "edges": edges}, generated


def expand_rows(content, where):
    """The content with each row of a lane template written out: a frame named by the row, a commit dot per step in the state
    the template gives the step (the row's start state first), an edge between neighbours labelled with the step, and a drop from
    every dot to a dot in the template's drop state. The written-out cells carry ids from the row's id; returns them as well, so
    dump writes the row back, never its expansion."""
    templates, rows = content.get("templates") or {}, content.get("rows") or []
    if not rows:
        return content, set()
    if not isinstance(templates, dict) or not isinstance(rows, list):
        raise DeclarationError(f"{where}: templates is a map of name: {{ states, drop }}, and rows a list of rows")
    groups, glyphs, edges = list(content.get("groups") or []), list(content.get("glyphs") or []), list(content.get("edges") or [])
    generated = set()
    for raw_row in rows:
        skip = raw_row.get("skip") or [] if isinstance(raw_row, dict) else []
        row = entry({k: v for k, v in raw_row.items() if k != "skip"} if isinstance(raw_row, dict) else raw_row,
                    ("id", "template", "label", "in", "start", "steps"), where, "row")
        if row["template"] not in templates:
            choices(f"{where}: row '{row['id']}' template", row["template"], tuple(templates))
        template = templates[row["template"]]
        if not isinstance(template, dict) or not isinstance(template.get("states"), dict) or not template.get("drop"):
            raise DeclarationError(f"{where}: template '{row['template']}' is a map of states (step: state) and drop (a state)")
        for key in template:
            if key not in ("states", "drop"):
                choices(f"{where}: template '{row['template']}' key", key, ("states", "drop"))
        states = {str(step): str(state) for step, state in template["states"].items()}
        for state in [*states.values(), str(template["drop"]), row["start"]]:
            if state not in COMMIT_STATES:
                choices(f"{where}: template '{row['template']}' state", state, COMMIT_STATES)
        template = {"states": states, "drop": str(template["drop"])}
        for step in row["steps"]:
            if step not in states:
                choices(f"{where}: row '{row['id']}' step", step, tuple(states))
        trail = [row["start"]] + [states[step] for step in row["steps"]]
        groups.append({"id": row["id"], "label": row["label"], "in": row["in"]})
        for n, state in enumerate(trail):
            dot, drop = f"{row['id']}-{n}", f"{row['id']}-{n}-drop"
            glyphs.append({"id": dot, "kind": "commit", "label": "x", "in": row["id"], **({"state": state} if state != COMMIT_STATES[0] else {})})
            glyphs.append({"id": drop, "kind": "commit", "label": "x", "in": row["id"], **({"state": template["drop"]} if template["drop"] != COMMIT_STATES[0] else {})})
            edges.append({"from": dot, "to": drop, "kind": "fail"})
            if n:
                edges.append({"from": f"{row['id']}-{n - 1}", "to": dot, "kind": "flow", "label": row["steps"][n - 1]})
            generated |= {dot, drop}
        # A skipped step: the commit may leave the state before it straight for the state after the next step, a bypass under
        # the dot the step would reach.
        for step in skip if isinstance(skip, list) else [skip]:
            if str(step) not in row["steps"][:-1]:
                choices(f"{where}: row '{row['id']}' skip", str(step), tuple(row["steps"][:-1]))
            n = row["steps"].index(str(step))
            edges.append({"from": f"{row['id']}-{n}", "to": f"{row['id']}-{n + 2}", "kind": "bypass"})
        generated.add(row["id"])
    return {**content, "groups": groups, "glyphs": glyphs, "edges": edges}, generated


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
    content, generated = expand_rows(content, where)
    content, lane_generated = expand_lanes(content, where)
    generated |= lane_generated
    out: dict = {"title": str(content.get("title", "")).strip()}
    # Only a declaration written with rows, lanes or rules carries them, and the ids their expansion wrote.
    for key in SHORTHAND:
        if content.get(key):
            out[key] = content[key]
    if generated or content.get("rules"):
        out["generated"] = generated
    if not out["title"]:
        raise DeclarationError(f"{where}: content.title is the finding the reader leaves with; it is empty")
    about_raw = raw.get("about") or {}
    if not isinstance(about_raw, dict):
        raise DeclarationError(f"{where}: about is a map of {', '.join(ABOUT_KEYS)}")
    for key in about_raw:
        if key not in ABOUT_KEYS and key not in RETIRED_ABOUT_KEYS:
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
    out["glyphs"] = []
    for raw_glyph in content.get("glyphs") or []:
        # A commit carries its state in the locked palette (bvt by default), may be a ghost (faded and dashed), and is a dot unless
        # its shape is box: a state drawn as a named box in its palette colour.
        extra = {k: raw_glyph[k] for k in ("state", "ghost", "shape") if isinstance(raw_glyph, dict) and k in raw_glyph}
        g = entry({k: v for k, v in raw_glyph.items() if k not in extra} if isinstance(raw_glyph, dict) else raw_glyph, ("id", "kind", "label", "in"), where, "glyph")
        if extra and g["kind"] != "commit":
            raise DeclarationError(f"{where}: glyph '{g['id']}' is a {g['kind']}; only a commit takes a state, ghost or shape")
        if extra.get("shape", COMMIT_SHAPES[0]) not in COMMIT_SHAPES:
            choices(f"{where}: commit '{g['id']}' shape", extra["shape"], COMMIT_SHAPES)
        if extra.get("shape", COMMIT_SHAPES[0]) != COMMIT_SHAPES[0]:
            g["shape"] = str(extra["shape"])
        if extra.get("state", COMMIT_STATES[0]) not in COMMIT_STATES:
            choices(f"{where}: commit '{g['id']}' state", extra["state"], COMMIT_STATES)
        if extra.get("state", COMMIT_STATES[0]) != COMMIT_STATES[0]:
            g["state"] = str(extra["state"])
        if extra.get("ghost") is True:
            g["ghost"] = True
        out["glyphs"].append(g)
    for g in out["glyphs"]:
        if g["kind"] not in GLYPH_KINDS:
            choices(f"{where}: glyph '{g['id']}' kind", g["kind"], GLYPH_KINDS)
        if g["id"] in ids:
            raise DeclarationError(f"{where}: id '{g['id']}' is used twice")
        ids[g["id"]] = "glyph"
    for item in out["groups"] + out["glyphs"]:
        # A glyph sits in a band or a group; a commit may also sit in an environment, as its occupant.
        envs = [g["id"] for g in out["glyphs"] if g["kind"] == "env"]
        occupant = item.get("kind") == "commit" and item["in"] in envs
        if item["in"] not in ids or (ids[item["in"]] == "glyph" and not occupant):
            holders = [i for i, k in ids.items() if k != "glyph"] + (envs if item.get("kind") == "commit" else [])
            choices(f"{where}: '{item['id']}' in", item["in"], holders)
    # A note is a free text block in a band or a group, placed like a glyph; its lines are its text's lines.
    out["notes"] = []
    for raw_note in content.get("notes") or []:
        note = entry(raw_note, ("id", "in", "text"), where, "note")
        if note["id"] in ids:
            raise DeclarationError(f"{where}: id '{note['id']}' is used twice")
        if ids.get(note["in"]) not in ("band", "group"):
            choices(f"{where}: note '{note['id']}' in", note["in"], [i for i, k in ids.items() if k in ("band", "group")])
        ids[note["id"]] = "note"
        out["notes"].append(note)
    # A gate rule stands between two steps of the first lane, across every lane: after step n, manual or automated.
    lanes = content.get("lanes") or []
    for raw_rule in content.get("rules") or []:
        rule = entry(raw_rule, ("after", "kind"), where, "rule")
        if not lanes:
            raise DeclarationError(f"{where}: a rule stands between steps of a lane; the diagram declares no lanes")
        if rule["kind"] not in RULE_KINDS:
            choices(f"{where}: rule kind", rule["kind"], RULE_KINDS)
        if not rule["after"].isdigit() or not 1 <= int(rule["after"]) < int(lanes[0]["steps"]):
            raise DeclarationError(f"{where}: rule after {rule['after']} is not a step of 1 to {int(lanes[0]['steps']) - 1}")
    vocabulary = span_vocabulary()
    out["spans"] = []
    for s in content.get("spans") or []:
        span = entry(s, ("id", "label", "over"), where, "span")
        if span["label"] not in vocabulary:
            choices(f"{where}: span '{span['id']}' label", span["label"], tuple(vocabulary))
        span["over"] = [str(o) for o in (span["over"] if isinstance(span["over"], list) else [span["over"]])]
        if not span["over"]:
            raise DeclarationError(f"{where}: span '{span['id']}' stands over nothing; over names bands, or glyphs and groups of one band")
        for item in span["over"]:  # whole bands, or the glyphs and groups of one band the span stands over
            if ids.get(item) is None:
                choices(f"{where}: span '{span['id']}' over", item, tuple(ids))
        out["spans"].append(span)
    out["edges"] = []
    for e in content.get("edges") or []:
        via = e.get("via") if isinstance(e, dict) else None
        edge = entry({k: v for k, v in e.items() if k != "via"} if isinstance(e, dict) else e, ("from", "to"), where, "edge", optional={"kind": EDGE_KINDS[0], "label": ""})
        if via is not None:  # waypoints the edge routes through, in page coordinates: `via: [[x, y], ...]`
            if not isinstance(via, list) or not all(isinstance(p, list) and len(p) == 2 for p in via):
                raise DeclarationError(f"{where}: edge {edge['from']} -> {edge['to']} via is a list of [x, y] points")
            edge["via"] = [[int(p[0]), int(p[1])] for p in via]
        if edge["kind"] not in EDGE_KINDS:
            choices(f"{where}: edge {edge['from']} -> {edge['to']} kind", edge["kind"], EDGE_KINDS)
        for end in ("from", "to"):  # an edge joins glyphs or groups: a call into a function frame ends on the frame
            if ids.get(edge[end]) not in ("glyph", "group"):
                choices(f"{where}: edge {end}", edge[end], [i for i, k in ids.items() if k in ("glyph", "group")])
        out["edges"].append(edge)
    out["markers"] = []
    edge_keys = [f"{e['from']}->{e['to']}" for e in out["edges"]]
    for m in content.get("markers") or []:
        corner = m.get("corner") if isinstance(m, dict) else None
        marker = entry({k: v for k, v in m.items() if k != "corner"} if isinstance(m, dict) else m, ("at", "number"), where, "marker")
        # A marker numbers a glyph, a group, a whole band, or an edge named `from->to` (it sits on the edge's middle).
        if ids.get(marker["at"]) is None and marker["at"] not in edge_keys:
            choices(f"{where}: marker at", marker["at"], tuple(ids) + tuple(edge_keys))
        marker["number"] = int(marker["number"])
        if corner is not None:
            if corner not in CORNERS:
                choices(f"{where}: marker {marker['number']} corner", corner, CORNERS)
            marker["corner"] = corner
        out["markers"].append(marker)
    # A rule chip names a rule the diagram covers and prints its number in about.adrs; dashed (gated: false) when no gate checks it.
    # A count chip prints a number. Either sits on a glyph, a group or a band.
    out["chips"] = []
    for c in content.get("chips") or []:
        chip_kind = c.get("kind") if isinstance(c, dict) else None
        if chip_kind == "rule":
            gated = c.get("gated", True) is not False
            chip = entry({k: v for k, v in c.items() if k not in ("gated", "corner")}, ("at", "kind", "rule"), where, "chip")
            if not gated:
                chip["gated"] = False
        elif chip_kind == "count":
            chip = entry({k: v for k, v in c.items() if k != "corner"}, ("at", "kind", "text"), where, "chip")
        else:
            choices(f"{where}: chip kind", chip_kind, ("rule", "count"))
        if ids.get(chip["at"]) is None:
            choices(f"{where}: chip at", chip["at"], tuple(ids))
        corner = c.get("corner") if isinstance(c, dict) else None
        if corner is not None:
            if corner not in CORNERS:
                choices(f"{where}: chip at '{chip['at']}' corner", corner, CORNERS)
            if corner != CHIP_CORNER[chip["kind"]]:
                chip["corner"] = corner
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
    # The three minimaps: the ones the declaration names, or, when it names none, the kind's defaults maps.yml declares, which reach
    # the kit as the folder's minimap data (with_data).
    allowed = tuple(str(DEFAULTS["minimaps"]["ids"]).replace(",", " ").split())
    declared = content.get("minimaps") or []
    if declared and len(declared) != 3:
        raise DeclarationError(f"{where}: minimaps names exactly three views of: {', '.join(allowed)}; it names {len(declared)}")
    for view in declared:
        if view not in allowed:
            choices(f"{where}: minimap view", view, allowed)
    if declared and len(set(declared)) != 3:
        raise DeclarationError(f"{where}: the three minimaps show three different views")
    out["minimaps"] = [str(v) for v in declared]
    # What the diagram is about: the lens it is drawn through and the ADR codes every minimap is computed from, each checked against
    # the ADR registry.
    about = {"lens": lens, **{key: [str(v) for v in (about_raw.get(key) or [])] for key in minimaps.ABOUT_KEYS}}
    for problem in minimaps.problems(about):
        raise DeclarationError(f"{where}: {problem}")
    out["adrs"] = about["adrs"]
    for chip in out["chips"]:
        if chip["kind"] == "rule" and chip["rule"] not in about["adrs"]:
            choices(f"{where}: rule chip at '{chip['at']}' rule", chip["rule"], about["adrs"])
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


def brief(phrase):
    """A legend phrase as the legend prints it: the name alone, without the explanation in parentheses or after a colon; a flow keeps
    its relation and a commit its state, which are the names."""
    if phrase.startswith(("flow: ", "commit: ")):
        return phrase.split(" (")[0] if not phrase.startswith("commit: ") else phrase
    return phrase.split(" (")[0].split(":")[0].strip()


def legend_phrases():
    return tuple([g["phrase"] for g in LIB["glyphs"].values()] + [e["phrase"] for e in LIB["edges"].values()] + [m["phrase"] for m in LIB["marks"].values()])


def dump(declaration):
    """The whole declaration as the text of its source file, keys in the kit's order."""
    content = dict(declaration["content"])
    # A row's written-out cells are its expansion, never the source: the row is written, and they are left out.
    generated = declaration.get("generated") or content.get("generated") or set()
    if generated:
        for key in ("groups", "glyphs"):
            content[key] = [i for i in content[key] if i["id"] not in generated]
        content["edges"] = [e for e in content["edges"] if e["from"] not in generated or e["to"] not in generated]
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


LAYERS = tuple(DEFAULTS["layers"])  # the paint order, back to front, declared once in drawio.yml


def layer_of(c):
    """The paint layer of a placed cell, one of LAYERS."""
    style = c["style"]
    if c["edge"]:
        return "lines" if c["id"].startswith("lane-") or style_map(style).get("curved") == "1" else "edges"
    if c["id"] in ("sidebar-bg", "mapkey") or style in (BAND, LEGEND, NOTE):
        return "panels"
    if style == LIB["module"]:
        return "frames"
    if "shape=crossbar" in style:
        return "spans"
    if c["id"].startswith(("mark-", "chip-")) or c["id"].endswith("-tag"):
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


def place(declaration):
    """Every cell of the model with its absolute geometry: the grid places what the layout does not name."""
    content, layout = declaration["content"], declaration["layout"]
    glyph_lib = LIB["glyphs"]
    holder = {}
    for item in content["groups"] + content["glyphs"] + content.get("notes", []):
        holder.setdefault(item["in"], []).append(item)
    rows = {r["id"]: r for r in content.get("rows") or []}
    lanes = {str(l["band"]): l for l in content.get("lanes") or []}

    def size_of(item):
        if item["id"] in layout:
            return layout[item["id"]]["w"], layout[item["id"]]["h"]
        if "text" in item:  # a note: its width, and a line of height per line of text at the width
            lines = sum(max(1, math.ceil(len(line) / 62)) for line in item["text"].split("\n"))
            return NOTE_WIDTH, 24 + 16 * lines
        if item.get("shape") == "box":
            return COMMIT_BOX_SIZE
        if "kind" in item:
            return glyph_lib[item["kind"]]["size"]
        inner_w, inner_h = grid_size(item["id"])
        return inner_w + 2 * PAD, inner_h + LABEL_ROW + PAD

    def lane_xy(band_id, step, row):
        """Where a lane's commit at a step and row sits: the steps spread evenly along the band, row 0 on the trunk, +1 above it."""
        bb, lane = band_box[band_id], lanes[band_id]
        dot = glyph_lib["commit"]["size"][0]
        left, right = bb["x"] + PAD + 40, bb["x"] + bb["w"] - PAD - 60 - dot
        stride = (right - left) / (int(lane["steps"]) - 1)
        mid = bb["y"] + LABEL_ROW + (bb["h"] - LABEL_ROW - PAD) // 2 - dot // 2
        return round(left + (step - 1) * stride), mid - row * LANE_ROW

    def row_place(holder_id, item, origin_x, origin_y, w, h):
        """A row's dot n sits in column n, its drop under it; a lane's commit at its step and row; anything else in the holder is
        placed by the grid."""
        if holder_id in lanes:
            lane = lanes[holder_id]
            placed = next((c for c in (lane.get("commits") or []) + (lane.get("glyphs") or []) if str(c["id"]) == item["id"]), None)
            if placed is not None:  # centred on its step's column, as a commit dot is
                x, y = lane_xy(holder_id, int(placed["step"]), int(placed.get("row", 0)))
                dot = glyph_lib["commit"]["size"]
                return {"x": x + dot[0] // 2 - w // 2, "y": y + dot[1] // 2 - h // 2, "w": w, "h": h}
        if holder_id not in rows:
            return None
        rest = item["id"][len(holder_id) + 1 :]
        n, _, drop = rest.partition("-")
        if not n.isdigit():
            return None
        return {"x": origin_x + int(n) * ROW_PITCH, "y": origin_y + (ROW_DROP if drop else 0), "w": w, "h": h}

    def grid_size(holder_id, width=None):
        if holder_id in rows:  # its dots in a line, its drops in the line under it
            dot = glyph_lib["commit"]["size"]
            return len(rows[holder_id]["steps"]) * ROW_PITCH + dot[0], ROW_DROP + dot[1]
        if holder_id in lanes:  # a lane's height is fixed: its trunk and a branch row above and below it
            return 0, LANE_HEIGHT - LABEL_ROW - PAD
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
    # A span over whole bands stands beside them in a top-to-bottom flow; a span over glyphs of one band lies above that band.
    upright = lambda s: vertical and any(o in {b["id"] for b in content["bands"]} for o in s["over"])
    bands = content["bands"]
    cells = []
    # The chrome: title and subtitle.
    # The lens once, as the chip that opens the title row; the subtitle under the title is the ADR codes alone.
    chip_w = 16 + 8 * len(content["lens"])
    cells.append(cell("lens-badge", content["lens"].upper(), BADGE, PAGE["x"], PAGE["title_y"] + 4, chip_w, 22))
    title_x = PAGE["x"] + chip_w + 12
    cells.append(cell("title", html.escape(content["title"], quote=False), TITLE, title_x, PAGE["title_y"], PAGE["width"] - (title_x - PAGE["x"]), 30))
    subtitle = " · ".join(content["adrs"])
    lines = max(1, -(-len(subtitle) * 7 // (PAGE["width"] - 20)))  # about 7 px a character at 12 px
    drop = (lines - 1) * 16  # the grid starts the bands this much lower under a wrapped subtitle
    cells.append(cell("subtitle", subtitle, SUBTITLE, PAGE["x"], PAGE["subtitle_y"] - 4, PAGE["width"] - 20, 18 + lines * 16))
    # The bands along the flow: side by side left to right, or stacked top to bottom.
    band_box = {}
    if vertical:
        left = PAGE["x"] + (50 if any(upright(s) for s in content["spans"]) else 0)
        width = PAGE["width"] - (left - PAGE["x"])
        y = PAGE["band_y"] - (24 if not has_spans else 0) + drop
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
        top = (PAGE["band_y"] if has_spans else PAGE["band_y"] - 24) + drop
        x = PAGE["x"]
        for b in bands:
            band_box[b["id"]] = layout.get(b["id"], {"x": x, "y": top, "w": width, "h": h})
            x = band_box[b["id"]]["x"] + band_box[b["id"]]["w"] + GAP
        content_bottom = max([bb["y"] + bb["h"] for bb in band_box.values()] + [top])
    for b in bands:
        bb = band_box[b["id"]]
        cells.append(cell(b["id"], html.escape(b["label"], quote=False), BAND, bb["x"], bb["y"], bb["w"], bb["h"]))
    # The groups and glyphs inside their holders, by the grid unless the layout places them.
    box_of = dict(band_box)

    def fill(holder_id, origin_x, origin_y, width, parent):
        x = y = row_h = 0
        for item in holder.get(holder_id, []):
            w, h = size_of(item)
            if x > 0 and x + w > width:
                y += row_h + ROW_GAP
                x, row_h = 0, 0
            box = layout.get(item["id"]) or row_place(holder_id, item, origin_x, origin_y, w, h) or {"x": origin_x + x, "y": origin_y + y, "w": w, "h": h}
            box_of[item["id"]] = box
            if item["id"] in layout and holder_id in band_box:  # a band holds its items by place alone, so a moved item names its band
                cx, cy = box["x"] + box["w"] / 2, box["y"] + box["h"] / 2
                within = [b for b, bb in band_box.items() if bb["x"] <= cx <= bb["x"] + bb["w"] and bb["y"] <= cy <= bb["y"] + bb["h"]]
                if within and holder_id not in within:
                    raise DeclarationError(f"layout places '{item['id']}' in {within[0]}, but its in: is {holder_id}; set in: to the band it "
                                           f"sits in, or move it back")
            if "text" in item:
                text = "<br>".join(html.escape(line, quote=False) for line in item["text"].split("\n"))
                cells.append(cell(item["id"], text, NOTE, box["x"], box["y"], box["w"], box["h"], parent))
            elif "kind" in item:
                style = COMMIT_BOX if item.get("shape") == "box" else glyph_lib[item["kind"]]["style"]
                if item["kind"] == "env" and holder.get(item["id"]):  # an occupied environment names itself left of its occupants
                    style += "align=left;spacingLeft=22;"
                if item["kind"] == "commit":
                    style = commit_style(style, item.get("state", COMMIT_STATES[0]), item.get("ghost", False))
                label = "<br>".join(html.escape(line, quote=False) for line in item["label"].split("\n"))  # a box's second line
                cells.append(cell(item["id"], f"<b>{label}</b>", style, box["x"], box["y"], box["w"], box["h"], parent))
                if item["kind"] == "type":
                    tag = glyph_lib["type"]["tag"]
                    cells.append(cell(f"{item['id']}-tag", "C#", tag["style"], box["x"] + box["w"] - tag["size"][0] - 8, box["y"] - 8, tag["size"][0], tag["size"][1], parent))
                # An environment's occupant commits sit inside it, right of its name, in a row from its right edge inward.
                for n, occupant in enumerate(holder.get(item["id"], [])):
                    d = glyph_lib["commit"]["size"][1]
                    inner = layout.get(occupant["id"]) or {"x": box["x"] + box["w"] - 30 - d - n * (d + 6), "y": box["y"] + (box["h"] - d) // 2, "w": d, "h": d}
                    box_of[occupant["id"]] = inner
                    occupant_style = commit_style(glyph_lib["commit"]["style"], occupant.get("state", COMMIT_STATES[0]), occupant.get("ghost", False))
                    cells.append(cell(occupant["id"], f"<b>{html.escape(occupant['label'], quote=False)}</b>", occupant_style, inner["x"], inner["y"], inner["w"], inner["h"], item["id"]))
            else:
                cells.append(cell(item["id"], html.escape(item["label"], quote=False), LIB["module"], box["x"], box["y"], box["w"], box["h"], parent))
                fill(item["id"], box["x"] + PAD, box["y"] + LABEL_ROW, box["w"] - 2 * PAD, item["id"])
            x += w + COL_GAP
            row_h = max(row_h, h)

    for b in bands:
        bb = band_box[b["id"]]
        fill(b["id"], bb["x"] + PAD, bb["y"] + LABEL_ROW, bb["w"] - 2 * PAD, "1")
    # A lane's furniture, the yml's alone: its trunk line named at its end, the marks over its commits, and the gate rules across
    # every band, between two steps of the first lane.
    for lane in lanes.values():
        band, (x0, y_mid) = lane["band"], lane_xy(lane["band"], 1, 0)
        x1 = lane_xy(band, int(lane["steps"]), 0)[0]
        dot = glyph_lib["commit"]["size"][0]
        if lane.get("trunk"):
            cells.append(cell(f"lane-{band}-a", "", ANCHOR, x0 - 20, y_mid + dot // 2, 1, 1))
            cells.append(cell(f"lane-{band}-b", "", ANCHOR, x1 + dot + 20, y_mid + dot // 2, 1, 1))
            cells.append(edge_cell(f"lane-{band}-trunk", "", TRUNK, f"lane-{band}-a", f"lane-{band}-b"))
            cells.append(cell(f"lane-{band}-trunk-label", html.escape(str(lane["trunk"]), quote=False), TRUNK_LABEL, x1 - 160, y_mid + dot + 8, 200, 18))
        for n, mark in enumerate(lane.get("marks") or []):
            at = box_of[str(mark["at"])]
            cells.append(cell(f"lane-{band}-mark-{n}", html.escape(str(mark["text"]), quote=False), MARK_TEXT, at["x"] - 70, at["y"] - 36, 162, 32))
    if lanes:
        # A rule crosses the lanes that share the first lane's steps, and the bands between them; a lane on another axis (git's
        # history) runs under its own steps, so no rule crosses it.
        first = next(iter(lanes.values()))
        stride = lane_xy(first["band"], 2, 0)[0] - lane_xy(first["band"], 1, 0)[0]
        axis = [band_box[b] for b, lane in lanes.items() if int(lane["steps"]) == int(first["steps"])]
        top, bottom = min(bb["y"] for bb in axis), max(bb["y"] + bb["h"] for bb in axis)
        for n, rule in enumerate(content.get("rules") or []):
            x = lane_xy(first["band"], int(rule["after"]), 0)[0] + glyph_lib["commit"]["size"][0] // 2 + stride // 2
            cells.append(cell(f"lane-rule-{n}-a", "", ANCHOR, x, top + LABEL_ROW, 1, 1))
            cells.append(cell(f"lane-rule-{n}-b", "", ANCHOR, x, bottom, 1, 1))
            cells.append(edge_cell(f"lane-rule-{n}", "", RULE_STYLES[rule["kind"]], f"lane-rule-{n}-a", f"lane-rule-{n}-b"))
    # The span bars over (or beside) what they cover: whole bands, or glyphs and groups of one band.
    holder = {i["id"]: i["in"] for i in content["groups"] + content["glyphs"]}

    def band_of(item):
        while item in holder:
            item = holder[item]
        return item

    def reach(s):
        boxes = [box_of[i] for i in s["over"]]
        return min(b["x"] for b in boxes), max(b["x"] + b["w"] for b in boxes), boxes

    span_levels, span_cells = [], {}
    for s in sorted(content["spans"], key=lambda s: reach(s)[1] - reach(s)[0]):  # the narrow spans first, the wide ones stack above
        x0, x1, boxes = reach(s)
        if upright(s):
            y0, y1 = min(b["y"] for b in boxes), max(b["y"] + b["h"] for b in boxes)
            bar = cell(s["id"], "", "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;rotation=90;", PAGE["x"] + 12, y0, 14, y1 - y0)
            label = cell(f"{s['id']}-label", html.escape(s["label"], quote=False), SPAN_LABEL, PAGE["x"] - 4, (y0 + y1) // 2 - 8, 30, 16)
        else:
            # A span sits just above the band of what it covers, so it moves down with the bands under a wrapped subtitle; a span over
            # what an earlier span already covers stacks one level higher (CD over CI).
            taken = {lv for lx0, lx1, lv in span_levels if lx0 < x1 and x0 < lx1}
            level = min(lv for lv in range(len(taken) + 1) if lv not in taken)  # the lowest level nothing it overlaps holds
            span_levels.append((x0, x1, level))
            y = min(band_box[band_of(i)]["y"] for i in s["over"]) - 24 - level * 32
            bar = cell(s["id"], "", "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;", x0, y, x1 - x0, 14)
            label = cell(f"{s['id']}-label", html.escape(s["label"], quote=False), SPAN_LABEL, (x0 + x1) // 2 - 15, y - 18, 30, 16)
        span_cells[s["id"]] = [bar, label]
    for s in content["spans"]:  # in the declared order, so get reads them back in it
        cells.extend(span_cells[s["id"]])
    # Room for the spans: when the topmost span label would reach into the title and subtitle, the whole drawing area moves down by
    # the shortfall; the title, the subtitle and the lens chip stay where they are.
    title_room = PAGE["subtitle_y"] + lines * 16 + 4
    labels_top = [c["y"] for c in cells if c["id"].endswith("-label") and any(c["id"] == f"{s['id']}-label" for s in content["spans"])]
    delta = max(0, title_room - min(labels_top)) if labels_top else 0
    if delta:
        for c in cells:  # every y here is absolute; to_xml makes a child's relative to its parent
            if c["id"] not in ("title", "subtitle", "lens-badge") and not c["edge"]:  # an edge follows its ends
                c["y"] += delta
        box_of = {k: {**v, "y": v["y"] + delta} for k, v in box_of.items()}
        content_bottom += delta
        # The shift moves the declared layout and waypoints too, and over laid-out bands it cannot be derived again from what is
        # drawn, so the title carries it and get takes it off again.
        next(c for c in cells if c["id"] == "title")["style"] += f"{SHIFT_KEY}={delta};"
    # Edges, markers and chips anchor on the glyphs.
    for e in content["edges"]:
        style = LIB["edges"][e["kind"]]["style"]
        if e["label"]:
            style = style.replace("shadow=0;", "fontColor=@ink;fontStyle=1;fontSize=11;labelBackgroundColor=@band;shadow=0;")
        eid = f"e-{e['from']}-{e['to']}"
        n = sum(1 for c in cells if c["id"] == eid or c["id"].startswith(eid + "~"))  # a repeat edge between the same pair: e-…~2
        edge = edge_cell(eid if not n else f"{eid}~{n + 1}", f"<b>{html.escape(e['label'], quote=False)}</b>" if e["label"] else "", style, e["from"], e["to"])
        edge["via"] = [[x, y + delta] for x, y in e.get("via", [])]  # waypoints move with the drawing area
        if e["kind"] == "bypass":  # out of its source's side, down under the skipped dot, and up into its target's side
            a, b = box_of[e["from"]], box_of[e["to"]]
            low = a["y"] + a["h"] + BYPASS_DIP
            edge["via"] = [[a["x"] + a["w"] + BYPASS_DIP, low], [b["x"] - BYPASS_DIP, low]]
        cells.append(edge)
    size = LIB["marks"]["marker"]["size"]
    for m in content["markers"]:
        if m["at"] not in box_of:  # an edge `from->to`: the marker sits halfway along its path, through its waypoints
            s, t = m["at"].split("->")
            via = next(([[x, y + delta] for x, y in e.get("via", [])] for e in content["edges"] if (e["from"], e["to"]) == (s, t)), [])
            mx, my = edge_middle(box_of[s], box_of[t], via)
            cells.append(cell(f"mark-{m['number']}", str(m["number"]), LIB["marks"]["marker"]["style"], round(mx - 11), round(my - 11), size[0], size[1]))
            continue
        box = box_of[m["at"]]
        kind = next((g["kind"] for g in content["glyphs"] if g["id"] == m["at"]), "")
        if "corner" in m:
            mx, my = marker_xy(box, m["corner"])
        elif kind == "gate":  # a diamond's corner is empty space, so its marker sits beside its top point
            mx, my = box["x"] + box["w"] // 2 - 40, box["y"] - 4
        elif not kind:  # a band or a group: just inside its top-left corner, so it never widens the page
            mx, my = box["x"] + 4, box["y"] - 11
        else:
            sources = [box_of[e["from"]] for e in content["edges"] if e["to"] == m["at"] and e["from"] in box_of]
            mx, my = marker_xy(box, auto_corner(box, sources))
        cells.append(cell(f"mark-{m['number']}", str(m["number"]), LIB["marks"]["marker"]["style"], mx, my, size[0], size[1]))
    placed, row = {}, {}
    for c in content["chips"]:
        box = box_of[c["at"]]
        mark = LIB["marks"][c["kind"]]
        k = placed[c["at"], c["kind"]] = placed.get((c["at"], c["kind"]), -1) + 1  # the chip's number on its place, for its id
        corner = c.get("corner", CHIP_CORNER[c["kind"]])
        j = row[c["at"], corner] = row.get((c["at"], corner), -1) + 1  # several chips on one corner stand in a row inward
        cx = box["x"] + 4 + j * 34 if corner.endswith("left") else box["x"] + box["w"] - 30 - j * 34
        cy = box["y"] - 9 if corner.startswith("top") else box["y"] + box["h"] - 9
        if c["kind"] == "rule":
            value, style = f"#{content['adrs'].index(c['rule']) + 1}", mark["style"] + ("" if c.get("gated", True) else "dashed=1;")
        else:
            value, style = c["text"], mark["style"]
        cells.append(cell(f"chip-{c['kind']}-{c['at']}-{k}", value, style, cx, cy, mark["size"][0], mark["size"][1]))
    # The legend below the bands: the kinds the diagram uses, in columns.
    legend_y = content_bottom + GAP
    entries = legend_entries(content)
    rows = 3
    columns = max(1, (len(entries) + rows - 1) // rows)
    col_w = min(240, (PAGE["width"] - 32) // columns)
    # The rule key: every rule a chip names, by its number in about.adrs, three to a column under the entries.
    keyed = [r for r in content["adrs"] if any(c["kind"] == "rule" and c["rule"] == r for c in content["chips"])]
    key_rows = (len(keyed) + 2) // 3
    legend_h = (30 + rows * 28 if entries else 48) + (key_rows * 16 + 8 if keyed else 0)
    cells.append(cell("legend", "<b>Legend</b>", LEGEND, PAGE["x"], legend_y, PAGE["width"], legend_h))
    for i, (eid, swatch, phrase) in enumerate(entries):
        col, row = divmod(i, rows)
        sx, sy = PAGE["x"] + 16 + col * col_w, legend_y + 30 + row * 28
        cells.extend(swatch(eid, sx, sy))
        cells.append(cell(f"lg-{eid}-t", brief(phrase), TEXT, sx + 48, sy - 1, col_w - 56, 20))
    for i, rule in enumerate(keyed):
        col, row = divmod(i, key_rows)
        number = content["adrs"].index(rule) + 1
        cells.append(cell(f"lg-key-{number}", f"#{number}  {rule}", KEY, PAGE["x"] + 16 + col * 410, legend_y + 30 + rows * 28 + row * 16, 400, 16))
    # The sidebar: the three minimaps, drawn from their claims and embedded, the lens badge and the map key. The ADR codes live in
    # the subtitle alone.
    height = max(PAGE["min_height"], legend_y + legend_h + GAP, MAPKEY_BOTTOM)
    cells.insert(0, cell("sidebar-bg", "", SIDEBAR_BG, SIDEBAR_X - 12, 4, SIDEBAR_W + 24, height - 8))
    # Each minimap is drawn from the data Catzc.Base.Maps computed for the folder (with_data); a declaration put without its folder
    # draws the declared minimaps empty.
    data = declaration.get("minimap_data") or {}
    for (cid, y, h), minimap in zip(SIDEBAR, list(data) or content["minimaps"]):
        drawn = data.get(minimap) or {"id": minimap, "axes": [], "cells": [], "lit": []}
        image = minimaps.picture_from(drawn, SIDEBAR_W, h, content["theme"])
        cells.append(cell(cid, minimap, MINIMAP + f"noLabel=1;image={image};", SIDEBAR_X, y, SIDEBAR_W, h))
    # The map key: the two marks every minimap shares.
    cells.append(cell("mapkey", "<b>Map key</b>", LEGEND, SIDEBAR_X, MAPKEY_Y, SIDEBAR_W, 82))
    for i, (swatch, phrase) in enumerate((("@map-lit", "lit: what this diagram draws"), ("@map-panel", "dim: what sits around it"))):
        y = MAPKEY_Y + 30 + i * 24
        rim = "none" if swatch == "@map-lit" else "@map-rim"
        cells.append(cell(f"mk-{i}", "", f"rounded=1;arcSize=20;html=1;fillColor={swatch};strokeColor={rim};shadow=0;", SIDEBAR_X + 12, y, 26, 16))
        cells.append(cell(f"mk-{i}-t", phrase, TEXT, SIDEBAR_X + 48, y - 2, SIDEBAR_W - 56, 20))
    return in_paint_order(cells), height


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
        if kind != "commit":
            entries.append((kind, swatch_for(kind), glyphs[kind]["phrase"]))
            continue
        # Commits: one entry per palette state the diagram draws, and one entry for a ghost of any state.
        commits = [g for g in content["glyphs"] if g["kind"] == "commit"]
        for state in dict.fromkeys(g.get("state", COMMIT_STATES[0]) for g in commits):
            style = commit_style(glyphs["commit"]["style"], state, False)
            swatch = lambda eid, x, y, style=style: [cell(f"lg-{eid}", "", style, x + 8, y - 2, 22, 22)]
            entries.append((f"commit-{state}", swatch, f"commit: {state}"))
        ghosts = [g for g in commits if g.get("ghost", False)]
        if ghosts:
            style = commit_style(glyphs["commit"]["style"], ghosts[0].get("state", COMMIT_STATES[0]), True)
            swatch = lambda eid, x, y, style=style: [cell(f"lg-{eid}", "", style, x + 8, y - 2, 22, 22)]
            entries.append(("commit-ghost", swatch, "commit: ghost"))
    for kind in dict.fromkeys(e["kind"] for e in content["edges"]):
        phrase = f"flow: {content['relation']}" if kind == "flow" and content["relation"] else LIB["edges"][kind]["phrase"]
        entries.append((f"edge-{kind}", edge_swatch(kind), phrase))
    for kind in dict.fromkeys(r["kind"] for r in content.get("rules") or []):  # a gate rule's line, solid or dashed
        swatch = lambda eid, x, y, style=RULE_STYLES[kind]: [
            cell(f"lg-{eid}-a", "", ANCHOR, x, y + 9, 1, 1), cell(f"lg-{eid}-b", "", ANCHOR, x + 40, y + 9, 1, 1),
            edge_cell(f"lg-{eid}", "", style, f"lg-{eid}-a", f"lg-{eid}-b")]
        entries.append((f"rule-{kind}", swatch, f"{kind} gate"))
    if content["markers"]:
        entries.append(("marker", mark_swatch("marker", "1"), LIB["marks"]["marker"]["phrase"]))
    for kind in dict.fromkeys(c["kind"] for c in content["chips"]):
        entries.append((f"chip-{kind}", mark_swatch(kind, "#2" if kind == "rule" else "87"), LIB["marks"][kind]["phrase"]))
    if any(c["kind"] == "rule" and not c.get("gated", True) for c in content["chips"]):
        mark = LIB["marks"]["rule"]
        dashed = lambda eid, x, y: [cell(f"lg-{eid}", "#2", mark["style"] + "dashed=1;", x + 4, y - 2, mark["size"][0], mark["size"][1])]
        entries.append(("chip-rule-adr", dashed, "dashed rule chip: ADR-only (no gate)"))
    if wanted is not None:
        entries = [e for e in entries if e[2] in wanted]
    return entries


def to_xml(cells, height, theme=None):
    """The mxGraphModel text, one cell a line, in the kit's fixed formatting so the same cells give the same bytes; every style token
    is written as the theme's colour."""
    lines = [
        f'<mxGraphModel dx="1024" dy="768" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1572" pageHeight="{height}" background="{paint("@page", theme)}" math="0" shadow="1">',
        "  <root>",
        '    <mxCell id="0" />',
        '    <mxCell id="1" parent="0" />',
    ]
    origin = {c["id"]: (c["x"], c["y"]) for c in cells if not c["edge"]}
    for c in cells:
        value = html.escape(c["value"], quote=True)
        if c["edge"]:
            lines.append(f'    <mxCell id="{c["id"]}" value="{value}" style="{paint(c["style"], theme)}" edge="1" parent="{c["parent"]}" source="{c["source"]}" target="{c["target"]}">')
            if c.get("via"):
                px, py = origin.get(c["parent"], (0, 0))  # an edge inside a container takes its waypoints relative to it
                lines.append('      <mxGeometry relative="1" as="geometry">')
                lines.append('        <Array as="points">')
                lines.extend(f'          <mxPoint x="{x - px}" y="{y - py}" />' for x, y in c["via"])
                lines.append("        </Array>")
                lines.append("      </mxGeometry>")
            else:
                lines.append('      <mxGeometry relative="1" as="geometry" />')
        else:
            px, py = origin.get(c["parent"], (0, 0)) if c["parent"] != "1" else (0, 0)
            lines.append(f'    <mxCell id="{c["id"]}" value="{value}" style="{paint(c["style"], theme)}" vertex="1" parent="{c["parent"]}">')
            lines.append(f'      <mxGeometry x="{c["x"] - px}" y="{c["y"] - py}" width="{c["w"]}" height="{c["h"]}" as="geometry" />')
        lines.append("    </mxCell>")
    lines.extend(["  </root>", "</mxGraphModel>"])
    return "\n".join(lines) + "\n"


def put(declaration, theme=None):
    """The model XML of a declaration, in the theme named (the declaration's own theme when none is)."""
    theme = theme or declaration["content"]["theme"]
    cells, height = place({**declaration, "content": {**declaration["content"], "theme": theme}})
    return to_xml(cells, height, theme)


def put_png(folder, declaration, theme=None):
    """put, then the raster: the folder's diagram.drawio.png with the model embedded, drawn by drawio_png. The default theme's
    render is the folder's own png; any other theme renders on demand to out/drawio/themes/<theme>/<folder name>/."""
    theme = theme or declaration["content"]["theme"]
    model = put(with_data(folder, declaration), theme).strip()
    img = render(ET.fromstring(model), page="model").convert("RGB")  # the model's own page: its theme's
    info = PngInfo()
    info.add_text("mxfile", encode(model, declaration["content"]["lens"]))
    dst = Path(folder) / SLIDE if theme == THEMES[0] else KIT.parents[1] / "out" / "drawio" / "themes" / theme / Path(folder).name / SLIDE
    dst.parent.mkdir(parents=True, exist_ok=True)
    img.save(dst, "PNG", pnginfo=info)
    return dst


# ---- get: the model becomes the declaration ------------------------------------------------------------------------


def signature(style):
    s = style_map(paint(style))  # the library's tokens in the default theme, the one a committed drawing is put in
    return tuple((k, s.get(k)) for k in SIGNATURE_KEYS if k in s)


def matches(sig, style):
    s = style_map(style)
    return all(s.get(k) == v for k, v in sig)


def model_of(folder):
    """The model embedded in the folder's diagram.drawio.png."""
    return decode(mxfile_chunk(Image.open(Path(folder) / SLIDE))).strip()


def shift_of(title_style):
    """How far span room moved a drawing area down, from its title's style: 0 when it did not move."""
    return int(style_map(title_style or "").get(SHIFT_KEY, 0))


def get(model, kind=None):
    """The declaration a model states, in the kit's vocabulary; a cell the vocabulary cannot name fails the direction."""
    root = ET.fromstring(model)
    cells = {str(c.get("id")): c for c in root.iter("mxCell") if c.get("id") not in (None, "0", "1")}
    shift = shift_of(cells["title"].get("style")) if "title" in cells else 0
    declared = lambda box: {**box, "y": box["y"] - shift}  # a layout box as the yml declares it, before span room moved it
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
    palette_fills = {fill.upper(): state for state, (fill, _, _) in COMMITS.items()}
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
    bands, groups, glyphs, bars, labels, markers, chips, notes = [], [], [], [], [], [], [], []
    lens = plain(cells["lens-badge"].get("value")).lower() if "lens-badge" in cells else lens
    for cid, c in cells.items():
        style, value = c.get("style") or "", plain(c.get("value"))
        if c.get("edge") == "1" or cid in DERIVED or cid.startswith(DERIVED_PREFIXES) or cid.endswith("-tag"):
            continue
        if cid == "title":
            content["title"] = value
        elif cid == "subtitle":
            adrs = [p.strip() for p in value.split("·") if p.strip()]
        elif style_map(style).get("noteBlock") == "1":
            notes.append(cid)
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
        elif ("ellipse" in style_map(style) or style_map(style).get("commitShape") == "box") and style_map(style).get("fillColor", "").upper() in palette_fills:
            glyphs.append((cid, "commit"))  # a commit in any palette state, a dot or a box
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
        layout[b] = declared(geo[b])
    if len(bands) > 1 and all(geo[b]["x"] == geo[bands[0]]["x"] for b in bands):
        content["flow"] = "top-to-bottom"

    envs = {g for g, k in glyphs if k == "env"}

    def holder_of(cid):
        parent = cells[cid].get("parent")
        if parent in groups or parent in envs:  # a frame, or the environment a commit occupies
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
        content["groups"].append({"id": g, "label": plain(cells[g].get("value")) or " ", "in": holders[g]})  # " ": an untitled frame
        layout[g] = declared(geo[g])
    def reading_order(t):  # holder by holder, row-major; an environment's occupants come after the glyphs of the environment's holder
        h = holder_of(t[0])
        return (rank[holder_of(h)], 1, geo[t[0]]["y"], geo[t[0]]["x"]) if h in envs else (rank[h], 0, geo[t[0]]["y"], geo[t[0]]["x"])

    for cid, k in sorted(glyphs, key=reading_order):
        glyph = {"id": cid, "kind": k, "label": plain(cells[cid].get("value")), "in": holder_of(cid)}
        if k == "commit":
            s = style_map(cells[cid].get("style"))
            if s.get("commitShape") == "box":
                glyph["shape"] = "box"
            state = palette_fills[s.get("fillColor", "").upper()]
            if state != COMMIT_STATES[0]:
                glyph["state"] = state
            if s.get("dashed") == "1":
                glyph["ghost"] = True
        content["glyphs"].append(glyph)
        layout[cid] = declared(geo[cid])
    content["notes"] = []
    for cid in sorted(notes, key=lambda n: (rank[holder_of(n)], geo[n]["y"], geo[n]["x"])):
        content["notes"].append({"id": cid, "in": holder_of(cid), "text": plain(cells[cid].get("value"))})
        layout[cid] = declared(geo[cid])
    for bar in bars:
        box = geo[bar]
        vertical = "rotation=90" in (cells[bar].get("style") or "")
        near = [l for l in labels if abs((geo[l]["x"] + geo[l]["w"] / 2) - (box["x"] + box["w"] / 2)) <= 40 and abs((geo[l]["y"] + geo[l]["h"] / 2) - (box["y"] + box["h"] / 2)) <= (box["h"] / 2 + 40 if vertical else 40)]
        if vertical:
            over = [b for b in bands if geo[b]["y"] >= box["y"] - 2 and geo[b]["y"] + geo[b]["h"] <= box["y"] + box["h"] + 2]
        else:
            under = lambda i, box=box: geo[i]["x"] >= box["x"] - 2 and geo[i]["x"] + geo[i]["w"] <= box["x"] + box["w"] + 2
            over = [b for b in bands if under(b)]
            if not over or min(geo[b]["x"] for b in over) > box["x"] + 2 or max(geo[b]["x"] + geo[b]["w"] for b in over) < box["x"] + box["w"] - 2:
                # Narrower than whole bands: the glyphs and groups standing directly in the band under the bar, left to right.
                below = [b for b in bands if geo[b]["y"] > box["y"] and geo[b]["x"] < box["x"] + box["w"] and box["x"] < geo[b]["x"] + geo[b]["w"]]
                band = min(below, key=lambda b: geo[b]["y"] - box["y"]) if below else None
                def band_of(item):  # a glyph or group's band, through any frames it sits in
                    h = holders.get(item) if item in groups else holder_of(item)
                    while h in groups:
                        h = holders[h]
                    return h

                members = [m for m in list(groups) + [g for g, _ in glyphs] if band_of(m) == band and under(m)]
                # The outermost covered items: a member whose frame is itself covered is named through that frame.
                over = sorted((m for m in members if not (m in holders and holders[m] in members) and not (m not in groups and holder_of(m) in members)), key=lambda m: geo[m]["x"])
        content["spans"].append({"id": bar, "label": plain(cells[near[0]].get("value")) if near else "", "over": over})
    glyph_ids = [g[0] for g in glyphs]
    kind_of = dict(glyphs)
    # Where put centres a marker: a corner of a box (named), beside a diamond's top point or inside a band's or group's top-left
    # corner (the default, no name), or the middle of an edge.
    def anchors(g):
        x, y, w, h = geo[g]["x"], geo[g]["y"], geo[g]["w"], geo[g]["h"]
        corners = [("top-left", (x + 1, y)), ("top-right", (x + w - 1, y)), ("bottom-left", (x + 1, y + h)), ("bottom-right", (x + w - 1, y + h))]
        if g not in kind_of:
            return [(None, (x + 15, y))] + corners
        return ([(None, (x + w // 2 - 29, y + 7))] if kind_of[g] == "gate" else []) + corners

    edge_ends = [(c.get("source"), c.get("target")) for cid, c in cells.items() if c.get("edge") == "1" and not cid.startswith(("lg-", "lane-"))]
    places = [(g, name, point) for g in glyph_ids + groups + bands for name, point in anchors(g)]
    centre_of = lambda i: (geo[i]["x"] + geo[i]["w"] / 2, geo[i]["y"] + geo[i]["h"] / 2)
    def via_of(c):  # an edge's waypoints on the page: relative to its container when it sits in one
        points = c.find("mxGeometry/Array")
        ox, oy = (geo[c.get("parent")]["x"], geo[c.get("parent")]["y"]) if c.get("parent") in geo else (0, 0)
        return [[float(p.get("x", 0)) + ox, float(p.get("y", 0)) + oy] for p in points.findall("mxPoint")] if points is not None else []

    edge_paths = [(c.get("source"), c.get("target"), via_of(c)) for cid, c in cells.items() if c.get("edge") == "1" and not cid.startswith(("lg-", "lane-"))]
    places += [(f"{s}->{t}", "edge", edge_middle(geo[s], geo[t], via)) for s, t, via in edge_paths if s in geo and t in geo]
    for m in sorted(markers, key=lambda m: int(plain(cells[m].get("value")))):
        centre = centre_of(m)
        at, name, _ = min(places, key=lambda p: abs(p[2][0] - centre[0]) + abs(p[2][1] - centre[1]))
        marker = {"at": at, "number": int(plain(cells[m].get("value")))}
        if name not in (None, "edge"):
            sources = [geo[s] for s, t in edge_ends if t == at and s in geo]
            if kind_of.get(at) in (None, "gate") or name != auto_corner(geo[at], sources):
                marker["corner"] = name
        content["markers"].append(marker)
    # A chip's id is chip-<kind>-<place>-<n>, so the place it sits on is read from the id, in the order put drew them.
    for ch in chips:
        style = cells[ch].get("style") or ""
        kind = "rule" if matches(mark_sigs["rule"], style) else "count"
        at = ch.removeprefix(f"chip-{kind}-").rsplit("-", 1)[0]
        value = plain(cells[ch].get("value"))
        if kind == "rule":
            chip = {"at": at, "kind": "rule", "rule": adrs[int(value.lstrip("#")) - 1]}
            if style_map(style).get("dashed") == "1":
                chip["gated"] = False
        else:
            chip = {"at": at, "kind": "count", "text": value}
        if at in geo:  # the corner it sits on, named only when it is not the kind's own
            cx, cy = centre_of(ch)
            box, x = geo[at], geo[ch]["x"]
            # A row of chips stands inward from its corner, 34 px a chip, so a chip far along the row still names its row's corner.
            in_row = lambda offset: offset >= 0 and offset % 34 == 0
            right, left = in_row(box["x"] + box["w"] - 30 - x), in_row(x - box["x"] - 4)
            side = "-right" if right and not left else "-left" if left and not right else ("-left" if cx < box["x"] + box["w"] / 2 else "-right")
            corner = ("top" if cy < box["y"] + box["h"] / 2 else "bottom") + side
            if corner != CHIP_CORNER[kind]:
                chip["corner"] = corner
        content["chips"].append(chip)
    edge_sigs = {k: signature(v["style"]) for k, v in LIB["edges"].items()}
    for cid, c in cells.items():
        if c.get("edge") != "1" or cid.startswith(("lg-", "lane-")):
            continue
        kinds = [k for k, sig in sorted(edge_sigs.items(), key=lambda kv: -len(kv[1])) if matches(sig, c.get("style") or "")]
        if not kinds:
            raise DeclarationError(f"get cannot name the edge {cid} in the kit's vocabulary")
        edge = {"from": c.get("source"), "to": c.get("target"), "kind": kinds[0], "label": plain(c.get("value"))}
        if via_of(c) and edge["kind"] != "bypass":  # a bypass's route is the kit's, under the dot it skips
            edge["via"] = [[int(x), int(y) - shift] for x, y in via_of(c)]  # the waypoints as declared, before span room
        content["edges"].append(edge)
    declaration = normalise({"about": {"adrs": adrs, "lens": lens}, "content": content, "layout": layout}, where="the drawing")
    # A cell that sits where the grid would put it needs no layout entry: the layout keeps only what a hand moved.
    # A layout entry stays only where put would not place the cell there anyway, given the entries already kept for what holds it:
    # bands first, then frames from the outside in, then what they hold.
    read, held = declaration["layout"], declaration["content"]
    holder = {i["id"]: i["in"] for key in ("groups", "glyphs", "notes") for i in held.get(key) or []}
    frames = {g["id"] for g in held["groups"]}

    def depth(cid):
        d = 0
        while cid in holder:
            cid, d = holder[cid], d + 1
        return d

    deepest = max((depth(g) for g in frames), default=0)
    level = lambda cid: 0 if cid not in holder else depth(cid) if cid in frames else deepest + 1
    kept: dict = {}
    for lv in sorted({level(cid) for cid in read}):
        gridded = place({"content": held, "layout": kept})[0]
        grid_shift = shift_of(next(c["style"] for c in gridded if c["id"] == "title"))  # the grid's own span room, taken off too
        grid = {c["id"]: {"x": c["x"], "y": c["y"] - grid_shift, "w": c["w"], "h": c["h"]} for c in gridded if not c["edge"]}
        kept.update({cid: box for cid, box in read.items() if level(cid) == lv and grid.get(cid) != box})
    declaration["layout"] = {cid: box for cid, box in read.items() if cid in kept}
    return declaration


def minimap_data(folder):
    """A folder's three minimaps as Catzc.Base.Maps computed them, in order: out/minimaps/<folder>/minimaps.json names the ids and
    <id>.json holds each, checked against the minimap contract. Missing data fails, naming the commands that write it."""
    folder = Path(folder).resolve()
    repo = KIT.parents[1]
    rel = folder.relative_to(repo).as_posix() if folder.is_relative_to(repo) else folder.name
    root = repo / "out" / "minimaps" / rel
    index = root / "minimaps.json"
    if not index.is_file():
        raise DeclarationError(f"{rel}: no minimap data in out/minimaps/{rel}; Build-Diagrams or Test-Diagrams computes it (Write-DiagramMinimapData)")
    return {view: minimap_contract.load_minimap(root / f"{view}.json") for view in json.loads(index.read_text(encoding="utf-8"))}


def with_data(folder, declaration):
    """The declaration with its folder's minimap data, which put draws the sidebar from."""
    return {**declaration, "minimap_data": minimap_data(folder)}


def drift(folder):
    """How a folder's png differs from put of its yml: the drawn cells that differ, and apart from them the cells the kit derives and
    get never reads back (the minimaps, the legend, the map key and the sidebar), which change when a registry or the kit changes and
    so are stale rather than drifted. Both empty when the png is what put would write."""
    changed = changed_cells(model_of(folder), put(with_data(folder, load(folder))).strip())
    stale = [i for i in changed if i in DERIVED or i.startswith(DERIVED_PREFIXES)]
    return [i for i in changed if i not in stale], stale


def changed_cells(one, other):
    """The ids of the cells two models draw differently, sorted; empty when the models are the same."""
    if one == other:
        return []
    ids = lambda model: {str(c.get("id")): ET.tostring(c, encoding="unicode") for c in ET.fromstring(model).iter("mxCell")}
    old, new = ids(one), ids(other)
    return sorted(i for i in old.keys() | new.keys() if old.get(i) != new.get(i))


def committed(folder):
    """The pair as committed at git HEAD: the source's text and the model embedded in the png, read with `git show`. None when the
    folder is outside a repository or either file is not committed: an untracked pair has no base."""
    folder = Path(folder).resolve()
    run = lambda *args: subprocess.run(["git", "-C", str(folder), *args], capture_output=True)
    top = run("rev-parse", "--show-toplevel")
    if top.returncode != 0:
        return None
    rel = folder.relative_to(Path(top.stdout.decode("utf-8").strip()).resolve()).as_posix()
    source, png = run("show", f"HEAD:{rel}/{SOURCE}"), run("show", f"HEAD:{rel}/{SLIDE}")
    if source.returncode != 0 or png.returncode != 0:
        return None
    return source.stdout.decode("utf-8"), decode(mxfile_chunk(Image.open(io.BytesIO(png.stdout)))).strip()


def kind_of(folder):
    """The diagram kind its folder's path names (explanation or reference), or None."""
    return next((k for k in KINDS if f"/{k}/" in Path(folder).resolve().as_posix()), None)


def conflict(folder, base):
    """The cells of a pair whose two sides both moved from the committed pair and now disagree: the yml differs from the base's,
    the png's model differs from the base's, and get of the png states other content than the yml. Empty when only one side moved,
    when the sides agree, or when there is no base (base None: an untracked pair is never a conflict). A conflicted pair is put or
    got only by name, so the author picks the side that wins; nothing merges."""
    if base is None:
        return []
    # The base is compared as data, never validated: it was valid against the registries of its own commit, not today's.
    source, model = load(folder), model_of(folder)
    unmoved = yaml.safe_load((Path(folder) / SOURCE).read_text(encoding="utf-8")) == yaml.safe_load(base[0])
    if unmoved or model == base[1]:
        return []
    back = undrawn(get(model, kind_of(folder))["content"], source)
    if drawn(back) == drawn(source["content"]):
        return []
    # The cells that diverge are drawn ones: a derived cell (a minimap, the legend) is stale at worst, never a side to pick.
    return [i for i in changed_cells(model, put(with_data(folder, source)).strip()) if i not in DERIVED and not i.startswith(DERIVED_PREFIXES)]


def sync(folder, base):
    """The sync after an edit: get when the drawing moved from the base (or there is no base), then put, so the yml and the png
    agree again; put alone when only the yml moved. The directions run, in order. A conflicted pair runs nothing and fails with
    its cells, so the author picks the side by name."""
    both = conflict(folder, base)
    if both:
        raise DeclarationError(f"{folder}: the yml and the png both moved from HEAD and disagree in {', '.join(both)}; put or get it by name")
    ran = []
    if base is None or model_of(folder) != base[1]:
        save(folder, get(model_of(folder), kind_of(folder)))
        ran.append("get")
    put_png(folder, load(folder))
    return ran + ["put"]


def main():
    args = sys.argv[1:]
    if len(args) >= 2 and args[0] == "check":  # one JSON line per folder: conflicted or drifted cells, stale minimaps, or the error
        for folder in args[1:]:
            try:
                both = conflict(folder, committed(folder))
                cells, stale = ([], []) if both else drift(folder)
                print(json.dumps({"folder": folder, "conflict": both, "drift": cells, "stale": stale}))
            except (DeclarationError, OSError, ValueError) as error:
                print(json.dumps({"folder": folder, "error": str(error)}))
        return
    if len(args) == 2 and args[0] == "tidy":  # the source re-saved through the kit: normalised, the retired about keys dropped
        folder = Path(args[1])
        save(folder, load(folder))
        print(f"tidy {folder / SOURCE}")
        return
    if len(args) == 2 and args[0] == "sync":  # one JSON line: the directions run, or the conflict that stopped them
        try:
            print(json.dumps({"folder": args[1], "ran": sync(args[1], committed(args[1]))}))
        except DeclarationError as error:
            print(json.dumps({"folder": args[1], "error": str(error)}))
        return
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
        save(folder, get(model_of(folder), kind_of(folder)))
        print(f"get {folder / SOURCE}")


if __name__ == "__main__":
    main()
