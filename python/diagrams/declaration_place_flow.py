"""Placing the flow lens (DDR-VISUAL-FLOWISALENS): one lane per pipeline or workflow inside the full-flow frame, time left to right, each
lane its triggers, its pipeline word, its templates' words and its environments' rhombi, with the spanners over it on the spans layer."""

import html

from . import flow_glyphs
from .declaration_cells import cell, chrome, edge_cell
from .declaration_constants import BAND, FLOW, GAP, LABEL_ROW, PAD, PAGE, SPAN_LABEL, TEXT
from .declaration_finish import finish
from .declaration_vocabulary import LIB, DeclarationError
from .embed_images import data_uri

SPAN_BAR = "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;"
WORD_LABEL = "verticalLabelPosition=bottom;verticalAlign=top;fontSize=10;fontColor=@quiet;"
SPANNER_ROW = 34  # the row of words over a lane: a span bar and its label
CAP = 12  # an end cap of the full flow, O at its start and 0 at its end


def words():
    """The flow glyphs' words by id, from drawio.yml flow-glyphs."""
    return {g["id"]: g for g in flow_glyphs.glyphs()}


def word_cell(cid, glyph, label, x, y, theme):
    """A word glyph: an image cell of the word's committed SVG, its tokens resolved for the theme, with its label under it."""
    part = int(FLOW["slot-size"])
    image = data_uri(flow_glyphs.ASSETS / f"{glyph}.svg", theme)
    style = f"shape=image;html=1;imageAspect=0;{WORD_LABEL}image={image};"
    return cell(cid, html.escape(label, quote=False), style, x, y, 3 * part, part)


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
    y = frame["y"] + LABEL_ROW
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
        cells.append(word_cell(f"{lid}-pipeline", "pipeline", lid, x, middle, theme))
        used.append("pipeline")
        type_from = x
        x += word_w + GAP
        templates = list(lane.get("templates") or [])
        environments = list(lane.get("environments") or [])
        room = right - x - len(environments) * (48 + GAP)
        step = min(word_w + 4 * GAP, max(word_w + 8, room // max(1, len(templates))))
        if templates and step * len(templates) > room:
            raise DeclarationError(f"lane {lid} holds {len(templates)} templates, more than its {room} px leave room for; split the point")
        for n, template in enumerate(templates):
            glyph = template["kind"] if template["kind"] in glyphs else "step"
            name = template["name"].rsplit("/", 1)[-1]
            cells.append(word_cell(f"{lid}-template-{n + 1}", glyph, name, x, middle, theme))
            used.append(glyph)
            x += step
        spanner(cells, f"{lid}-type", lane.get("type", "unknown"), type_from, x - step + word_w if templates else type_from + word_w, y)
        for n, environment in enumerate(environments):
            ex, ey = x, middle - (48 - part) // 2
            cells.append(cell(f"{lid}-env-{n + 1}", html.escape(environment["id"], quote=False), rhombus["style"], ex, ey, 48, 48))
            if environment.get("approve"):
                spanner(cells, f"{lid}-approve-{n + 1}", "Approve", ex, ex + 48, y)
            x += 48 + GAP
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
        cells.append(edge_cell(f"e-{edge['from']}-{edge['to']}", f"<b>{html.escape(word, quote=False)}</b>" if word else "", line,
                               f"{edge['from']}-pipeline", f"{edge['to']}-pipeline"))
    bottom = flow_y + CAP + PAD
    cells.insert(0, cell("frame", html.escape(content["title"], quote=False), BAND, frame["x"], frame["y"], frame["w"], bottom - frame["y"]))
    content["flow_words"] = list(dict.fromkeys(used))
    return finish(cells, content, bottom, declaration)
