# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The last of a put: the cells made final, the legend and its entries, and the cells written as the mxGraphModel XML."""

import html

from . import declaration_settings, minimaps
from .declaration_cells import cell, edge_cell, in_paint_order
from .declaration_constants import (
    ACTION_LENS,
    ANCHOR,
    COMMIT_STATES,
    EDGE_DEADZONE,
    GAP,
    KEY,
    LABEL_LEGEND,
    LEGEND,
    MINIMAP,
    OPERATORS,
    PAGE,
    PROOF_LENS,
    PROOF_SHOWN,
    RULE_STYLES,
    SIDEBAR,
    SIDEBAR_BG,
    SIDEBAR_W,
    SIDEBAR_X,
    TEXT,
)
from .declaration_dump import brief
from .declaration_edges import edge_word
from .declaration_expand import shown_minimaps
from .declaration_routes import TRANSITION, commit_style
from .declaration_vocabulary import LIB
from .drawio_png import paint, style_map


def legend_box(cells, cid, caption, entries, x, y, w):
    """One box of the one-legend band: captioned in its upper-left inside corner, its entries in three rows of columns; each swatch is
    centred in a left column of the box's widest swatch, and its words stand left-aligned in the next column. Returns the box's
    height, before the box is drawn to the band's common height by the caller."""
    rows = 3
    columns = max(1, (len(entries) + rows - 1) // rows)
    col_w = min(240, (w - 32) // columns)
    placed = []  # (eid, swatch cells at the origin, bounding box, phrase)
    for eid, swatch, phrase in entries:
        drawn = swatch(eid, 0, 0)
        boxes = [c for c in drawn if not c["edge"]]
        x0, y0 = min(c["x"] for c in boxes), min(c["y"] for c in boxes)
        x1, y1 = max(c["x"] + c["w"] for c in boxes), max(c["y"] + c["h"] for c in boxes)
        placed.append((eid, drawn, (x0, y0, x1 - x0, y1 - y0), phrase))
    swatch_col = max([b[2] for _, _, b, _ in placed] + [40]) + 8
    for i, (eid, drawn, (x0, y0, bw, bh), phrase) in enumerate(placed):
        col, row = divmod(i, rows)
        sx, sy = x + 16 + col * col_w, y + 30 + row * 28
        dx, dy = sx + (swatch_col - bw) / 2 - x0, sy + 10 - bh / 2 - y0  # the swatch centred in its column and on its row
        for c in drawn:
            if not c["edge"]:
                c["x"], c["y"] = round(c["x"] + dx), round(c["y"] + dy)
        cells.extend(drawn)
        cells.append(cell(f"lg-{eid}-t", brief(phrase), TEXT, sx + swatch_col + 8, sy - 1, col_w - swatch_col - 16, 20))
    return 30 + rows * 28 if entries else 48


def finish(cells, content, content_bottom, declaration):
    """The one-legend band under the drawing: one box per segment standing above it, each as wide as its segment and captioned in its
    upper-left inside corner, the map key under the sidebar in the same band; then the sidebar, and every cell in paint order with the
    page height. The band never rises above the sidebar's minimaps, so a short drawing leaves room under itself instead."""
    legend_y = max(content_bottom, SIDEBAR[-1][1] + SIDEBAR[-1][2]) + GAP
    entries = legend_entries(content)
    # The rule key: every rule a chip names, by its number in about.adrs, three to a column under the entries.
    keyed = [r for r in content["adrs"] if any(c["kind"] == "rule" and c["rule"] == r for c in content["chips"])]
    key_rows = (len(keyed) + 2) // 3
    boxes = []  # (cell id, caption, entries, x, w)
    if content["lens"] == ACTION_LENS and any(eid == "proof" for eid, _, _ in entries):
        proof_w = 320
        boxes.append(("legend", "Action", [e for e in entries if e[0] != "proof"], PAGE["x"], PAGE["width"] - proof_w - GAP))
        boxes.append(("legend-proof", "Proof", [e for e in entries if e[0] == "proof"], PAGE["x"] + PAGE["width"] - proof_w, proof_w))
    else:
        boxes.append(("legend", "Proof" if content["lens"] == PROOF_LENS else "Legend", entries, PAGE["x"], PAGE["width"]))
    heights = []
    for cid, caption, box_entries, bx, bw in boxes:
        heights.append(
            legend_box(cells, cid, caption, box_entries, bx, legend_y, bw) + (key_rows * 16 + 8 if keyed and cid == "legend" else 0)
        )
    band_h = max(heights + [82])
    for (cid, caption, _, bx, bw), _ in zip(boxes, heights):
        cells.append(cell(cid, f"<b>{caption}</b>", LEGEND, bx, legend_y, bw, band_h))
    for i, rule in enumerate(keyed):
        col, row = divmod(i, key_rows)
        number = content["adrs"].index(rule) + 1
        cells.append(
            cell(f"lg-key-{number}", f"#{number}  {rule}", KEY, PAGE["x"] + 16 + col * 410, legend_y + 30 + 3 * 28 + row * 16, 400, 16)
        )
    # The map key, the two marks every minimap shares, stands in the same band under the sidebar.
    cells.append(cell("mapkey", "<b>Map key</b>", LEGEND, SIDEBAR_X, legend_y, SIDEBAR_W, band_h))
    for i, (swatch, phrase) in enumerate((("@map-lit", "lit: what this diagram draws"), ("@map-panel", "dim: what sits around it"))):
        y = legend_y + 30 + i * 28
        rim = "none" if swatch == "@map-lit" else "@map-rim"
        cells.append(
            cell(
                f"mk-{i}", "", f"rounded=1;arcSize=20;html=1;fillColor={swatch};strokeColor={rim};shadow=0;", SIDEBAR_X + 23, y + 2, 26, 16
            )
        )
        cells.append(cell(f"mk-{i}-t", phrase, TEXT, SIDEBAR_X + 64, y - 1, SIDEBAR_W - 72, 20))
    # The sidebar: the three minimaps, drawn from their claims and embedded, and the lens badge. The ADR codes live in the subtitle
    # alone.
    height = max(PAGE["min_height"], legend_y + band_h + GAP, SIDEBAR[-1][1] + SIDEBAR[-1][2] + GAP)
    cells.insert(0, cell("sidebar-bg", "", SIDEBAR_BG, SIDEBAR_X - 12, 4, SIDEBAR_W + 24, height - 8))
    # Each minimap is drawn from the data Catzc.Base.Maps computed for the folder (with_data); a declaration put without its folder
    # draws the declared minimaps empty.
    data = declaration.get("minimap_data") or {}
    for (cid, y, h), minimap in zip(SIDEBAR, list(data) or shown_minimaps(content["minimaps"])):
        drawn = data.get(minimap) or {"id": minimap, "axes": [], "cells": [], "lit": []}
        image = minimaps.picture_from(drawn, SIDEBAR_W, h, content["theme"])
        cells.append(cell(cid, minimap, MINIMAP + f"noLabel=1;image={image};", SIDEBAR_X, y, SIDEBAR_W, h))
    return in_paint_order(cells), height


def transition_swatch(eid, x, y):
    return [cell(f"lg-{eid}", "<b>w</b>", TRANSITION, x + 6, y - 2, 24, 24)]


def crossings(content):
    """Whether a band diagram draws a transition bubble: a labelled edge whose ends stand in different bands."""
    holder = {i["id"]: i["in"] for i in content.get("groups", []) + content.get("glyphs", [])}

    def band_of(item):
        while item in holder:
            item = holder[item]
        return item

    return any(edge_word(e) and band_of(e["from"]) != band_of(e["to"]) for e in content.get("edges", []))


def label_entry(content):
    """The legend phrase of the edge-label presentation a band diagram draws, or None: the pill presentation lists its label when any
    edge carries a word, the word presentation lists its transition when a labelled edge crosses a band."""
    if declaration_settings.EDGE_LABEL == "pill":
        return LABEL_LEGEND["pill"] if any(edge_word(e) for e in content.get("edges", [])) else None
    return LABEL_LEGEND["word"] if crossings(content) else None


def legend_entries(content):
    """What the legend shows: the glyph kinds, edge kinds and marks the diagram uses, or the phrases the declaration lists."""
    glyphs = LIB["glyphs"]

    def swatch_for(kind):
        style = glyphs[kind]["style"]
        shape = style_map(style).get("shape", "")
        size = {"note": (32, 22), "cylinder3": (28, 26), "hexagon": (40, 22), "delay": (14, 22)}.get(
            shape, (24, 22) if "ellipse" in style else (36, 26) if "rhombus" in style else (40, 18)
        )
        swatch_style = ";".join(
            p
            for p in style.split(";")
            if p and not p.startswith(("whiteSpace", "fontColor", "fontSize", "fontStyle", "boundedLbl", "backgroundOutline", "perimeter"))
        )
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
    wanted = content["legend"] if isinstance(content["legend"], list) else None
    proof_box = "rounded=1;arcSize=6;html=1;fillColor=@band;strokeColor=@line;shadow=0;"  # the Proof box, small and rimmed to show
    proof_swatch = lambda eid, x, y: [cell(f"lg-{eid}", "", proof_box, x, y + 2, 40, 18)]
    if content["lens"] == PROOF_LENS:  # the statement's glyph and the Proof box
        entries.append(("callsite" if "calls" in content["action"] else "action", swatch_for("action"), glyphs["action"]["phrase"]))
        entries.append(("proof", proof_swatch, "proof: the statement in each engine's words"))
    if content["lens"] == ACTION_LENS:  # the lens's own kinds, its four operators, the story's numbers and its Proof box
        statement = "callsite" if "calls" in content["action"] else "action"
        for kind in ("cause", statement, "ring", "effect"):
            entries.append((kind, swatch_for(kind), glyphs[kind]["phrase"]))
        if content.get("proof", "shown" if PROOF_SHOWN else "hidden") == "shown":
            entries.append(("proof", proof_swatch, "proof: the statement in each engine's words"))
        if any("call" in e for e in content["effects"]):
            member = glyphs["callsite"]["member"]
            swatch = lambda eid, x, y: [cell(f"lg-{eid}", "", member["style"], x, y + 2, 40, 18)]
            entries.append(("execution", swatch, "execution: a triggered command"))
        drawn_words = {"cats", "executes"} | {
            "affects" if "call" in e else "effects" for e in content["effects"] if e.get("after", "action") != "action"
        }
        for word, meaning in OPERATORS.items():
            if content["legend"] != "used" or word in drawn_words:  # legend: used lists the operators the drawing draws
                entries.append((f"edge-{word}", edge_swatch("flow"), f"{word}: {meaning}"))
        entries.append(("marker", mark_swatch("marker", "1"), LIB["marks"]["marker"]["phrase"]))
        if declaration_settings.EDGE_LABEL == "word" and any(
            e.get("after", "action") != "action" for e in content["effects"]
        ):  # a line into the next zone
            entries.append(("transition", transition_swatch, LABEL_LEGEND["word"]))
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
        phrase = (
            f"flow: {content['relation']}"
            if kind == "flow" and content["relation"]
            else content["thick"]
            if kind == "thick" and content.get("thick")
            else LIB["edges"][kind]["phrase"]
        )
        entries.append((f"edge-{kind}", edge_swatch(kind), phrase))
    for kind in dict.fromkeys(r["kind"] for r in content.get("rules") or []):  # a gate rule's line, solid or dashed
        swatch = lambda eid, x, y, style=RULE_STYLES[kind]: [
            cell(f"lg-{eid}-a", "", ANCHOR, x, y + 9, 1, 1),
            cell(f"lg-{eid}-b", "", ANCHOR, x + 40, y + 9, 1, 1),
            edge_cell(f"lg-{eid}", "", style, f"lg-{eid}-a", f"lg-{eid}-b"),
        ]
        entries.append((f"rule-{kind}", swatch, f"{kind} gate"))
    if content["markers"]:
        entries.append(("marker", mark_swatch("marker", "1"), LIB["marks"]["marker"]["phrase"]))
    if label_entry(content):
        entries.append(("transition", transition_swatch, label_entry(content)))
    for kind in dict.fromkeys(c["kind"] for c in content["chips"]):
        entries.append((f"chip-{kind}", mark_swatch(kind, "#2" if kind == "rule" else "87"), LIB["marks"][kind]["phrase"]))
    if any(c["kind"] == "rule" and not c.get("gated", True) for c in content["chips"]):
        mark = LIB["marks"]["rule"]
        dashed = lambda eid, x, y: [cell(f"lg-{eid}", "#2", mark["style"] + "dashed=1;", x + 4, y - 2, mark["size"][0], mark["size"][1])]
        entries.append(("chip-rule-adr", dashed, "dashed rule chip: DRS-only (no gate)"))
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
            # The deadzone: the line stops EDGE_DEADZONE px outside each box it joins, for every head variant (none, one, both).
            zone = "".join(
                f"{end}PerimeterSpacing={EDGE_DEADZONE};" for end in ("source", "target") if c.get(end) not in (None, "", "None")
            )
            style = c["style"] if c["style"].endswith(";") or not c["style"] else c["style"] + ";"
            lines.append(
                f'    <mxCell id="{c["id"]}" value="{value}" style="{paint(style + zone, theme)}" edge="1" parent="{c["parent"]}" source="{c["source"]}" target="{c["target"]}">'
            )
            # A label placed by the kit sits at a fraction along the edge (-1 the source, 1 the target) and a perpendicular offset in px,
            # positive below a rightward edge, as draw.io reads an edge label's relative geometry.
            at = f' x="{c["label_at"][0]}" y="{c["label_at"][1]}"' if c.get("label_at") else ""
            if c.get("via"):
                px, py = origin.get(c["parent"], (0, 0))  # an edge inside a container takes its waypoints relative to it
                lines.append(f'      <mxGeometry{at} relative="1" as="geometry">')
                lines.append('        <Array as="points">')
                lines.extend(f'          <mxPoint x="{x - px}" y="{y - py}" />' for x, y in c["via"])
                lines.append("        </Array>")
                lines.append("      </mxGeometry>")
            else:
                lines.append(f'      <mxGeometry{at} relative="1" as="geometry" />')
        else:
            px, py = origin.get(c["parent"], (0, 0)) if c["parent"] != "1" else (0, 0)
            lines.append(
                f'    <mxCell id="{c["id"]}" value="{value}" style="{paint(c["style"], theme)}" vertex="1" parent="{c["parent"]}">'
            )
            lines.append(f'      <mxGeometry x="{c["x"] - px}" y="{c["y"] - py}" width="{c["w"]}" height="{c["h"]}" as="geometry" />')
        lines.append("    </mxCell>")
    lines.extend(["  </root>", "</mxGraphModel>"])
    return "\n".join(lines) + "\n"
