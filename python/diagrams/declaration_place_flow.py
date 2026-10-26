"""Placing the flow lens (DDR-VISUAL-FLOWISALENS): one lane per pipeline or workflow inside the full-flow frame, time left to right, each
lane its triggers, its pipeline word, its templates' words and its environments' rhombi, with the spanners over it on the spans layer."""

import html

from . import flow_glyphs
from .declaration_cells import cell, chrome, edge_cell
from .declaration_constants import BAND, FLOW, GAP, PAD, PAGE, SPAN_LABEL, TEXT
from .declaration_finish import finish
from .declaration_vocabulary import LIB, DeclarationError
from .embed_images import data_uri

SPAN_BAR = "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;"
NAME = "text;html=1;align=center;verticalAlign=top;fontSize=10;fontColor=@quiet;"
ENV = 48  # an environment's rhombus, square
SPANNER_ROW = 34  # the row of words over a lane: a span bar and its label
CAP = 12  # an end cap of the full flow, O at its start and 0 at its end


def words():
    """The flow glyphs' words by id, from drawio.yml flow-glyphs."""
    return {g["id"]: g for g in flow_glyphs.glyphs()}


def word_cell(cid, glyph, x, y, theme):
    """A word glyph: an image cell of the word's committed SVG, its tokens resolved for the theme, with no rim of its own."""
    part = int(FLOW["slot-size"])
    image = data_uri(flow_glyphs.ASSETS / f"{glyph}.svg", theme)
    style = f"shape=image;html=1;imageAspect=0;fillColor=none;strokeColor=none;shadow=0;image={image};"
    return cell(cid, "", style, x, y, 3 * part, part)


def name_width(name):
    """The width a name under a glyph takes, about 6 px a character at the name's size."""
    return 6 * len(name) + 8


def named(cells, cid, name, x, w, y):
    """A name centred under a glyph of width w standing at x, its bottom at y."""
    nw = name_width(name)
    cells.append(cell(f"{cid}-name", html.escape(name, quote=False), NAME, x + (w - nw) // 2, y + 4, nw, 14))


def spanner(cells, cid, label, x0, x1, y):
    """A spanner: a span bar on the spans layer with its word above it."""
    cells.append(cell(cid, "", SPAN_BAR, x0, y + 16, max(x1 - x0, 24), 12))
    cells.append(cell(f"{cid}-label", f"<b>{html.escape(label, quote=False)}</b>", SPAN_LABEL, x0, y, max(x1 - x0, 24), 16))


def place_flow(declaration):
    """The flow lens's cells, all from the readers' rows the declaration was handed: the frame captioned with the title holds one lane
    per pipeline, top to bottom in the point's order. A lane reads left to right: its trigger chips, its pipeline word with the lane's
    name, its templates' words, then its environments as rhombi; over it one row of spanners, Review over the triggers of a lane a pull
    request starts, the pipeline type over the pipeline and its templates, Approve over each gated environment. Under the lanes the
    full flow runs from its start O to its end 0, and the readers' edges join the lanes' pipeline words with their word."""
    content = declaration["content"]
    route = content.get("route")
    if not route or not route["lanes"]:
        raise DeclarationError(
            f"the flow slide for {content.get('point')} has no readers' rows; Build-Diagrams hands them over by address, so render it through it"
        )
    theme, glyphs, lib = content["theme"], words(), LIB["glyphs"]
    part, lane_h = int(FLOW["slot-size"]), int(FLOW["lane-height"])
    word_w = 3 * part
    tag = lib["effect"]["tag"]
    rhombus = lib["env-flow"]
    cells: list = []
    drop = chrome(content, cells)
    frame = {"x": PAGE["x"], "y": PAGE["band_y"] + drop, "w": PAGE["width"]}
    left, right = frame["x"] + PAD, frame["x"] + frame["w"] - PAD
    y = frame["y"] + PAD // 2
    pipeline_at = {}  # each lane's pipeline word, (x, centre y), where the readers' edges join it
    used = []
    for lane in route["lanes"]:
        lid, row = lane["id"], y + SPANNER_ROW
        middle = row + (lane_h - SPANNER_ROW) // 2 - part
        x = left
        # The triggers, one chip each, stacked at the lane's start.
        triggers = list(lane.get("triggers") or [])
        chip_w = max([tag["size"][0]] + [7 * len(t) + 12 for t in triggers])
        for n, trigger in enumerate(triggers):
            ty = middle - (len(triggers) * 20) // 2 + n * 20 + part // 2
            cells.append(cell(f"{lid}-trigger-{n + 1}", html.escape(trigger, quote=False), tag["style"], x, ty, chip_w, tag["size"][1]))
        if lane.get("review"):
            spanner(cells, f"{lid}-review", "Review", x, x + chip_w, y)
        x += chip_w + GAP
        templates = list(lane.get("templates") or [])
        environments = list(lane.get("environments") or [])
        # Each glyph takes the room its name under it needs, so no two names touch.
        items = [("pipeline", lid, word_w, f"{lid}-pipeline")]
        for n, template in enumerate(templates):
            glyph = template["kind"] if template["kind"] in glyphs else "step"
            items.append((glyph, template["name"].rsplit("/", 1)[-1], word_w, f"{lid}-template-{n + 1}"))
        for n, environment in enumerate(environments):
            items.append(("env", environment["id"], ENV, f"{lid}-env-{n + 1}"))
        need = sum(max(w, name_width(name)) + GAP for _, name, w, _ in items)
        if x + need > right:
            raise DeclarationError(f"lane {lid} needs {need} px for its glyphs and their names; {right - x} px are left; split the point")
        type_from = type_to = x
        for n, (glyph, name, w, cid) in enumerate(items):
            slot = max(w, name_width(name))
            gx = x + (slot - w) // 2
            if glyph == "env":
                ey = middle + part // 2 - ENV // 2
                cells.append(cell(cid, "", rhombus["style"], gx, ey, ENV, ENV))
                named(cells, cid, name, gx, ENV, ey + ENV)
                if environments[n - 1 - len(templates)].get("approve"):
                    spanner(cells, f"{lid}-approve-{n - len(templates)}", "Approve", x, x + slot, y)
            else:
                cells.append(word_cell(cid, glyph, gx, middle, theme))
                if n == 0:
                    pipeline_at[lid] = (gx, middle + part // 2)
                named(cells, cid, name, gx, w, middle + part)
                used.append(glyph)
                type_to = x + slot
            x += slot + GAP
        spanner(cells, f"{lid}-type", lane.get("type", "unknown"), type_from, type_to, y)
        y += lane_h
    # The full flow: one route from trigger to production, a lane with its start O and end 0 caps.
    flow_y = y + PAD // 2
    cells.append(cell("flow-start", "", "ellipse;html=1;fillColor=none;strokeColor=@ink;strokeWidth=1.6;", left, flow_y, CAP, CAP))
    cells.append(cell("flow-end", "", "ellipse;html=1;fillColor=@ink;strokeColor=@ink;strokeWidth=1.6;", right - CAP, flow_y, CAP, CAP))
    cells.append(cell("flow-label", "<b>full flow</b>", TEXT, left + CAP + 8, flow_y - 18, 120, 16))
    line = LIB["edges"]["flow"]["style"]
    cells.append(edge_cell("flow-line", "", line + "endArrow=none;", "flow-start", "flow-end"))
    known = {lane["id"] for lane in route["lanes"]}
    for edge in route["edges"]:
        if edge["from"] not in known or edge["to"] not in known:
            raise DeclarationError(f"the flow edge {edge['from']} -> {edge['to']} names a lane the rows do not hold")
        word = edge.get("label", "")
        # The edge leaves the source's pipeline word on its left, runs up or down in the gap before the words, and enters the target's.
        (sx, sy), (tx, ty) = pipeline_at[edge["from"]], pipeline_at[edge["to"]]
        run = min(sx, tx) - GAP // 2
        joined = edge_cell(
            f"e-{edge['from']}-{edge['to']}",
            f"<b>{html.escape(word, quote=False)}</b>" if word else "",
            line.replace("shadow=0;", "fontColor=@ink;fontStyle=1;fontSize=11;labelBackgroundColor=@band;shadow=0;")
            + "exitX=0;exitY=0.5;entryX=0;entryY=0.5;",
            f"{edge['from']}-pipeline",
            f"{edge['to']}-pipeline",
        )
        joined["via"] = [[run, sy], [run, ty]]
        cells.append(joined)
    bottom = flow_y + CAP + PAD
    cells.insert(0, cell("frame", "", BAND, frame["x"], frame["y"], frame["w"], bottom - frame["y"]))
    content["flow_words"] = list(dict.fromkeys(used))
    return finish(cells, content, bottom, declaration)
