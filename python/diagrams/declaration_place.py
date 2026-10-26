# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The later phases of placing a grid drawing, after place_grid: the span bars, the routed edges and their words, the markers and the
chips, and place itself, the whole of them in order."""

import html

from . import declaration_settings
from .declaration_cells import cell, edge_cell, ladder_rungs
from .declaration_constants import (
    ACTION_LENS,
    BYPASS_DIP,
    CHIP_CORNER,
    EDGE_DEADZONE,
    FLOW_LENS,
    PAGE,
    PROOF_LENS,
    SHIFT_KEY,
    SPAN_LABEL,
    WORD_GAP,
)
from .declaration_edges import edge_word
from .declaration_finish import finish
from .declaration_place_action import place_action
from .declaration_place_flow import place_flow
from .declaration_place_grid import place_grid
from .declaration_routes import (
    LAST_ROUTES,
    WORD_MARGIN,
    auto_corner,
    cross_box,
    drawn_run,
    edge_middle,
    facing,
    keep_out_findings,
    label_spot,
    marker_xy,
    middle_leg,
    plan_aims,
    transition,
)
from .declaration_vocabulary import LIB, DeclarationError


def place_spans(frame):
    """The span bars over what they cover, and the room for them: returns how far the drawing area moved down."""
    content, cells, band_box, upright, drop = frame.content, frame.cells, frame.band_box, frame.upright, frame.drop
    box_of, content_bottom = frame.box_of, frame.content_bottom
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
    # The spans that name their row first, then the others, the narrow spans first and the wide ones stacked above.
    for s in sorted(content["spans"], key=lambda s: ("row" not in s, reach(s)[1] - reach(s)[0])):
        x0, x1, boxes = reach(s)
        if upright(s):
            y0, y1 = min(b["y"] for b in boxes), max(b["y"] + b["h"] for b in boxes)
            bar = cell(
                s["id"],
                "",
                "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;rotation=90;",
                PAGE["x"] + 12,
                y0,
                14,
                y1 - y0,
            )
            label = cell(f"{s['id']}-label", html.escape(s["label"], quote=False), SPAN_LABEL, PAGE["x"] - 4, (y0 + y1) // 2 - 8, 30, 16)
        else:
            # A span sits just above the band of what it covers, so it moves down with the bands under a wrapped subtitle; a span over
            # what an earlier span already covers stacks one level higher (CD over CI).
            taken = {lv for lx0, lx1, lv in span_levels if lx0 < x1 and x0 < lx1}
            level = int(s["row"]) if "row" in s else min(lv for lv in range(len(taken) + 1) if lv not in taken)  # the lowest free level
            if level in taken:
                raise DeclarationError(
                    f"span '{s['id']}' overlaps another span on row {level}; give it a row no span over the same stages holds"
                )
            span_levels.append((x0, x1, level))
            y = min(band_box[band_of(i)]["y"] for i in s["over"]) - 24 - level * 32
            bar = cell(
                s["id"],
                "",
                "shape=crossbar;whiteSpace=wrap;html=1;rounded=1;fillColor=none;strokeColor=@line;strokeWidth=1.5;shadow=0;",
                x0,
                y,
                x1 - x0,
                14,
            )
            label = cell(f"{s['id']}-label", html.escape(s["label"], quote=False), SPAN_LABEL, (x0 + x1) // 2 - 15, y - 18, 30, 16)
        span_cells[s["id"]] = [bar, label]
    for s in content["spans"]:  # in the declared order, so get reads them back in it
        cells.extend(span_cells[s["id"]])
    # Room for the spans: when the topmost span label would reach into the title and subtitle, the whole drawing area moves down by
    # the shortfall; the title, the subtitle and the lens chip stay where they are.
    title_room = PAGE["subtitle_y"] + (drop // 16 + 1) * 16 + 4  # the subtitle's lines, from the drop chrome returned
    labels_top = [c["y"] for c in cells if c["id"].endswith("-label") and any(c["id"] == f"{s['id']}-label" for s in content["spans"])]
    delta = max(0, title_room - min(labels_top)) if labels_top else 0
    if delta:
        for c in cells:  # every y here is absolute; to_xml makes a child's relative to its parent
            if c["id"] not in ("title", "subtitle", "lens-badge", "zoom-badge") and not c["edge"]:  # an edge follows its ends
                c["y"] += delta
        box_of = {k: {**v, "y": v["y"] + delta} for k, v in box_of.items()}
        content_bottom += delta
        # The shift moves the declared layout and waypoints too, and over laid-out bands it cannot be derived again from what is
        # drawn, so the title carries it and get takes it off again.
        next(c for c in cells if c["id"] == "title")["style"] += f"{SHIFT_KEY}={delta};"
    frame.box_of, frame.content_bottom, frame.holder, frame.band_of = box_of, content_bottom, holder, band_of
    return delta


def place_edges(frame, delta, check_routes):
    """The edges, routed and labelled, and the keep-out check of their routes."""
    content, cells, box_of, band_box = frame.content, frame.cells, frame.box_of, frame.band_box
    holder, band_of, ladders = frame.holder, frame.band_of, frame.ladders
    # A ladder's climbs, each pair of consecutive rungs: the edge leaves the rung's top centre, runs up, then right into the next rung's
    # left centre, so one waypoint at (source centre x, target centre y) routes it.
    climbs = {(o[i]["id"], o[i + 1]["id"]) for band in ladders for o in [ladder_rungs(content, band)] for i in range(len(o) - 1)}
    # Edges, markers and chips anchor on the glyphs.
    placed = []  # the pills drawn so far, which a pill beside its line keeps clear of
    # The router: an edge between two cells that no waypoint routes leaves the side they face, at its even share of that side
    # (plan_aims), so edges between aligned cells run straight and edges sharing a side fan out without meeting.
    glyph_style = {g["id"]: LIB["glyphs"][g["kind"]]["style"] for g in content["glyphs"]}
    plain_box = lambda cid: not any(k in glyph_style.get(cid, "") for k in ("ellipse", "rhombus", "hexagon"))
    routable = {
        i: (e["from"], e["to"])
        for i, e in enumerate(content["edges"])
        if e["kind"] != "bypass"
        and not e.get("via")
        and (e["from"], e["to"]) not in climbs
        and e["from"] in box_of
        and e["to"] in box_of
        and e["from"] != e["to"]
    }
    obstacles = {}
    marked = {m["at"]: m.get("corner", "top-left") for m in content["markers"] if m["at"] in box_of}
    for g in content["glyphs"]:
        box = box_of[g["id"]]
        x0, y0, x1, y1 = (
            box["x"] - EDGE_DEADZONE,
            box["y"] - EDGE_DEADZONE,
            box["x"] + box["w"] + EDGE_DEADZONE,
            box["y"] + box["h"] + EDGE_DEADZONE,
        )
        if g["id"] in marked:
            mx, my = marker_xy(box, marked[g["id"]])
            x0, y0, x1, y1 = min(x0, mx), min(y0, my), max(x1, mx + 22), max(y1, my + 22)
        obstacles[g["id"]] = (x0, y0, x1 - x0, y1 - y0)
    # An elbow bends once, and which way it goes is the one that keeps clear of every cell that is no end of it: along the exit row first,
    # unless that runs through a cell and the other way does not.
    orient = {}
    for i, (tail, head) in routable.items():
        a, b = box_of[tail], box_of[head]
        if declaration_settings.EDGE_ROUTE == "elbow" and facing(a, b)[2]:
            ca, cb = (a["x"] + a["w"] / 2, a["y"] + a["h"] / 2), (b["x"] + b["w"] / 2, b["y"] + b["h"] / 2)
            along_row = [{"from": tail, "to": head, "points": [ca, (cb[0], ca[1]), cb]}]
            along_column = [{"from": tail, "to": head, "points": [ca, (ca[0], cb[1]), cb]}]
            if keep_out_findings(along_row, obstacles, holder) and not keep_out_findings(along_column, obstacles, holder):
                orient[i] = "v"
    aims = plan_aims(routable, box_of, plain_box, orient)
    routes = []
    for index, e in enumerate(content["edges"]):
        style = LIB["edges"][e["kind"]]["style"]
        if edge_word(e):
            style = style.replace("shadow=0;", "fontColor=@ink;fontStyle=1;fontSize=11;labelBackgroundColor=@band;shadow=0;")
        eid = f"e-{e['from']}-{e['to']}"
        n = sum(1 for c in cells if c["id"] == eid or c["id"].startswith(eid + "~"))  # a repeat edge between the same pair: e-…~2
        edge = edge_cell(
            eid if not n else f"{eid}~{n + 1}",
            f"<b>{html.escape(edge_word(e), quote=False)}</b>" if edge_word(e) else "",
            style,
            e["from"],
            e["to"],
        )
        edge["via"] = [[x, y + delta] for x, y in e.get("via", [])]  # waypoints move with the drawing area
        if e["kind"] == "bypass":  # out of its source's side, down under the skipped dot, and up into its target's side
            a, b = box_of[e["from"]], box_of[e["to"]]
            low = a["y"] + a["h"] + BYPASS_DIP
            edge["via"] = [[a["x"] + a["w"] + BYPASS_DIP, low], [b["x"] - BYPASS_DIP, low]]
        if (e["from"], e["to"]) in climbs and not e.get("via"):  # up out of the rung's top, then right into the next rung's left
            a, b = box_of[e["from"]], box_of[e["to"]]
            edge["via"] = [[round(a["x"] + a["w"] / 2), round(b["y"] + b["h"] / 2)]]
        a, b = box_of[e["from"]], box_of[e["to"]]
        if index in aims:
            (ex, ey), (nx, ny) = aims[index]["exit"], aims[index]["entry"]
            edge["style"] += f"exitX={ex};exitY={ey};entryX={nx};entryY={ny};"
            start, end = (a["x"] + a["w"] * ex, a["y"] + a["h"] * ey), (b["x"] + b["w"] * nx, b["y"] + b["h"] * ny)
            run = [start, end]
            if aims[index].get("elbow"):  # one bend, a derived route get never reads back
                corner = (start[0], end[1]) if orient.get(index) == "v" else (end[0], start[1])
                run = [start, corner, end]
                edge["via"] = [[round(corner[0]), round(corner[1])]]
                edge["style"] += "catzcElbow=1;"
        else:
            run = drawn_run(
                [(a["x"] + a["w"] / 2, a["y"] + a["h"] / 2), *[(x, y) for x, y in edge["via"]], (b["x"] + b["w"] / 2, b["y"] + b["h"] / 2)],
                a,
                b,
            )
        points = [
            (a["x"] + a["w"] / 2, a["y"] + a["h"] / 2),
            *[(x, y) for x, y in edge["via"]],
            (b["x"] + b["w"] / 2, b["y"] + b["h"] / 2),
        ]
        route = {"from": e["from"], "to": e["to"], "points": run, "pill": None}
        routes.append(route)
        if edge_word(e):
            into = band_of(e["to"]) if e["to"] in holder else e["to"]
            crossing = None
            if into in band_box and (band_of(e["from"]) if e["from"] in holder else e["from"]) != into:
                crossing = cross_box(points, band_box[into])
            # With the pill presentation the word is a pill on the line, at the band border it crosses or at the line's middle,
            # where the arrowhead stays clear; a line too short to hold it gets the same pill beside it; only when no place beside it is free does its word stay bare.
            spot = None
            if declaration_settings.EDGE_LABEL == "pill":
                avoid = [box_of[g["id"]] for g in content["glyphs"]] + placed
                avoid = [(v["x"], v["y"], v["w"], v["h"]) if isinstance(v, dict) else v for v in avoid]
                spot = label_spot(run, edge_word(e), EDGE_DEADZONE, crossing, avoid)
            if spot:
                cells.append(transition(edge, edge_word(e), spot))
                width, height = 6.2 * len(edge_word(e)) + 2 * WORD_MARGIN, 12 + 2 * WORD_MARGIN
                placed.append((spot[0] - width / 2, spot[1] - height / 2, width, height))
                route["pill"] = placed[-1]
            else:
                # A steep edge, one that climbs or falls more than it runs, never carries its word across its own line: the word stands
                # left-aligned, glued 3 px right of the line at its middle, where draw.io and the painter both put an align=left label.
                (x0, y0), (x1, y1) = middle_leg(points)
                if abs(y1 - y0) > abs(x1 - x0):
                    edge["style"] += "align=left;"
                    edge["label_at"] = (0, -WORD_GAP if y1 > y0 else WORD_GAP)
                # The word presentation: a word on a line that crosses into another band becomes a transition bubble on that band's
                # border; a line inside one band keeps its word beside it.
                if declaration_settings.EDGE_LABEL == "word" and crossing:
                    cells.append(transition(edge, edge_word(e), crossing))
        cells.append(edge)
    LAST_ROUTES[:] = routes
    if (
        declaration_settings.FINDINGS_FAIL and check_routes
    ):  # the keep-out zone: a cell that is no end of an edge is a rectangle grown by the deadzone, marker included
        hits = keep_out_findings(routes, obstacles, holder)
        if hits:
            raise DeclarationError("; ".join(hits))


def place_marks(frame, delta):
    """The markers and the chips, anchored on the cells the earlier phases placed."""
    content, cells, box_of = frame.content, frame.cells, frame.box_of
    size = LIB["marks"]["marker"]["size"]
    for m in content["markers"]:
        if m["at"] not in box_of:  # an edge `from->to`: the marker sits halfway along its path, through its waypoints
            s, t = m["at"].split("->")
            via = next(([[x, y + delta] for x, y in e.get("via", [])] for e in content["edges"] if (e["from"], e["to"]) == (s, t)), [])
            mx, my = edge_middle(box_of[s], box_of[t], via)
            cells.append(
                cell(
                    f"mark-{m['number']}",
                    str(m["number"]),
                    LIB["marks"]["marker"]["style"],
                    round(mx - 11),
                    round(my - 11),
                    size[0],
                    size[1],
                )
            )
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
        if c["kind"] == "rule":
            value, style = f"#{content['adrs'].index(c['rule']) + 1}", mark["style"] + ("" if c.get("gated", True) else "dashed=1;")
        else:
            value, style = c["text"], mark["style"]
        # A chip grows to its text, about 7 px a character, so a longer count reads on one line; a short one keeps the mark's size.
        w = max(mark["size"][0], 7 * len(value) + 12)
        cx = box["x"] + 4 + j * 34 if corner.endswith("left") else box["x"] + box["w"] - w - j * 34
        cy = box["y"] - 9 if corner.startswith("top") else box["y"] + box["h"] - 9
        cells.append(cell(f"chip-{c['kind']}-{c['at']}-{k}", value, style, cx, cy, w, mark["size"][1]))


def place(declaration, check_routes=False):
    """Every cell of the model with its absolute geometry: the grid places what the layout does not name; the action lens places
    everything by ring and order."""
    if declaration["content"]["lens"] in (ACTION_LENS, PROOF_LENS):
        return place_action(declaration)
    if declaration["content"]["lens"] == FLOW_LENS:
        return place_flow(declaration)
    frame = place_grid(declaration)
    delta = place_spans(frame)
    place_edges(frame, delta, check_routes)
    place_marks(frame, delta)
    return finish(frame.cells, frame.content, frame.content_bottom, declaration)
