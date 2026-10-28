# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The first phase of placing a grid drawing: the bands and what stands in them, by the grid unless the layout places them, and a
lane's furniture."""

import html
import math
from types import SimpleNamespace

from . import query_rows
from .declaration_cells import TAGGED_KINDS, cell, chrome, edge_cell, glyph_tags, ladder_rungs
from .declaration_constants import (
    ANCHOR,
    BAND,
    BAND_TITLE,
    BAND_TITLE_HEIGHT,
    BAND_TITLE_INSET,
    COL_GAP,
    COMMIT_BOX,
    COMMIT_BOX_SIZE,
    COMMIT_STATES,
    EDGE_DEADZONE,
    GAP,
    LABEL_HEAD_CLEAR,
    LABEL_ROW,
    LABEL_TAIL_CLEAR,
    LANE_HEIGHT,
    LANE_ROW,
    LANE_SLOT,
    LANE_SLOT_GAP,
    LANE_SLOTS,
    MARK_TEXT,
    NOTE,
    NOTE_WIDTH,
    PAD,
    PAGE,
    ROW_DROP,
    ROW_GAP,
    ROW_PITCH,
    RULE_STYLES,
    TRUNK,
    TRUNK_LABEL,
)
from .declaration_routes import LABEL_RECT, WORD_MARGIN, commit_style, diamond_fit
from .declaration_vocabulary import LIB, DeclarationError


def place_grid(declaration):
    """The bands and what stands in them: the grid places what the layout does not name, a lane's furniture follows; returns the
    frame the later phases of place read and extend."""
    content, layout = declaration["content"], declaration["layout"]
    glyph_lib = LIB["glyphs"]
    holder = {}
    for item in content["groups"] + content["glyphs"] + content.get("notes", []):
        holder.setdefault(item["in"], []).append(item)
    rows = {r["id"]: r for r in content.get("rows") or []}
    lanes = {str(l["band"]): l for l in content.get("lanes") or []}
    ladders = {str(l["band"]): l for l in content.get("ladders") or []}

    def rungs(band_id):
        return ladder_rungs(content, band_id)

    def ladder_place(band_id, item, origin_x, width, w, h):
        """A ladder's rungs spread evenly over the band's width; rung n stands rise px above rung n-1, rung 0 on the band's floor."""
        if band_id not in ladders:
            return None
        order = rungs(band_id)
        n = next(i for i, r in enumerate(order) if r["id"] == item["id"])
        stride = (width - size_of(order[-1])[0]) / (len(order) - 1) if len(order) > 1 else 0
        floor = band_box[band_id]["y"] + band_box[band_id]["h"] - PAD
        return {"x": origin_x + round(n * stride), "y": floor - h - n * int(ladders[band_id]["rise"]), "w": w, "h": h}

    axis = {"h": 0, "bands": set()}  # the shared first-row height of bands side by side, set once they are known

    def size_of(item):
        if item["id"] in layout:
            return layout[item["id"]]["w"], layout[item["id"]]["h"]
        rung = ladders.get(item.get("in"))
        if rung and "w" in rung:  # a ladder's rungs share the size the hint gives
            return int(rung["w"]), int(rung["h"])
        if "text" in item:  # a note: its width, and a line of height per line of text at the width
            lines = sum(max(1, math.ceil(len(line) / 62)) for line in item["text"].split("\n"))
            return NOTE_WIDTH, 24 + 16 * lines
        if item.get("shape") == "box":
            return COMMIT_BOX_SIZE
        if "kind" in item:
            base = glyph_lib[item["kind"]]["size"]
            if "rhombus" in glyph_lib[item["kind"]]["style"]:  # a diamond is as big as its label needs, never smaller than the glyph
                fit = diamond_fit(item["label"])["size"]
                return max(base[0], fit[0]), max(base[1], fit[1])
            if query_rows.drawn_by_query(item["id"]):  # a query's label is a file or module name no author shortened: the box fits it
                return max(base[0], 8 * len(str(item.get("label", ""))) + 24), base[1]
            return base
        inner_w, inner_h = grid_size(item["id"])
        return inner_w + 2 * PAD, inner_h + LABEL_ROW + PAD

    def lane_xy(band_id, step, row, slot=LANE_SLOT):
        """Where a lane's commit at a step and row sits: the steps spread evenly along the band, row 0 on the trunk, +1 above it; a left
        or right slot stands half the slot gap off its step's centre, so two commits of one row sit side by side."""
        bb, lane = band_box[band_id], lanes[band_id]
        dot = glyph_lib["commit"]["size"][0]
        left, right = bb["x"] + PAD + 40, bb["x"] + bb["w"] - PAD - 60 - dot
        stride = (right - left) / (int(lane["steps"]) - 1)
        mid = bb["y"] + LABEL_ROW + (bb["h"] - LABEL_ROW - PAD) // 2 - dot // 2
        return round(left + (step - 1) * stride) + (LANE_SLOTS.index(slot) - 1) * LANE_SLOT_GAP // 2, mid - row * LANE_ROW

    def row_place(holder_id, item, origin_x, origin_y, w, h):
        """A row's dot n sits in column n, its drop under it; a lane's commit at its step and row; anything else in the holder is
        placed by the grid."""
        if holder_id in lanes:
            lane = lanes[holder_id]
            placed = next((c for c in (lane.get("commits") or []) + (lane.get("glyphs") or []) if str(c["id"]) == item["id"]), None)
            if placed is not None:  # centred on its step's column, as a commit dot is
                x, y = lane_xy(holder_id, int(placed["step"]), int(placed.get("row", 0)), str(placed.get("slot", LANE_SLOT)))
                dot = glyph_lib["commit"]["size"]
                return {"x": x + dot[0] // 2 - w // 2, "y": y + dot[1] // 2 - h // 2, "w": w, "h": h}
        if holder_id not in rows:
            return None
        rest = item["id"][len(holder_id) + 1 :]
        n, _, drop = rest.partition("-")
        if not n.isdigit():
            return None
        return {"x": origin_x + int(n) * row_pitch(holder_id), "y": origin_y + (ROW_DROP if drop else 0), "w": w, "h": h}

    def row_pitch(holder_id):
        """A row's dot pitch: ROW_PITCH, or wider where a step's word would not fit as a pill on the line between two dots, so every
        step word is boxed clear of its dots rather than left bare against them."""
        dot = glyph_lib["commit"]["size"][0]
        widest = max((6.2 * len(str(step)) + 2 * WORD_MARGIN for step in rows[holder_id]["steps"]), default=0)
        return max(ROW_PITCH, math.ceil(dot + 2 * EDGE_DEADZONE + widest + LABEL_TAIL_CLEAR + LABEL_HEAD_CLEAR))

    def grid_size(holder_id, width=None):
        if holder_id in rows:  # its dots in a line, its drops in the line under it
            dot = glyph_lib["commit"]["size"]
            return len(rows[holder_id]["steps"]) * row_pitch(holder_id) + dot[0], ROW_DROP + dot[1]
        if holder_id in lanes:  # a lane's height is fixed: its trunk and a branch row above and below it
            return 0, LANE_HEIGHT - LABEL_ROW - PAD
        if holder_id in ladders:  # a ladder's rungs in one row, the last standing rise px per rung above the first
            sizes = [size_of(i) for i in holder.get(holder_id, [])]
            if not sizes:
                return 0, 0
            rise = int(ladders[holder_id]["rise"])
            return sum(s[0] for s in sizes) + COL_GAP * (len(sizes) - 1), max(s[1] for s in sizes) + rise * (len(sizes) - 1)
        items = holder.get(holder_id, [])
        if not items:
            return 0, 0
        if width is None:
            columns = max(1, min(len(items), 4))
            width = sum(size_of(i)[0] for i in items[:columns]) + COL_GAP * (columns - 1)
        grid = grid_rows(holder_id, width, axis["h"] if holder_id in axis["bands"] else 0)
        return grid["w"], grid["h"]

    def grid_rows(holder_id, width, axis_h=0):
        """The ordinary grid of a holder: its items left to right, wrapping at `width`, each item's offset (x, y) with its y centring
        it on the middle of its row, so a ride along the flow runs level instead of jumping with each box's height. The first row is at
        least `axis_h` tall, so the bands side by side centre their first rows on one shared axis. Returns the offsets by item id, the
        grid's w and h, and `first`, the height of the first row alone."""
        rows, x = [[]], 0
        for item in holder.get(holder_id, []):
            w, h = size_of(item)
            if x > 0 and x + w > width:
                rows.append([])
                x = 0
            rows[-1].append((item["id"], x, w, h))
            x += w + COL_GAP
        offsets, y, total_w, first = {}, 0, 0, 0
        for n, row in enumerate(rows):
            row_h = max([h for *_, h in row] + ([axis_h] if n == 0 else []))
            first = row_h if n == 0 else first
            for cid, rx, w, h in row:
                offsets[cid] = (rx, y + (row_h - h) // 2)
                total_w = max(total_w, rx + w)
            y += row_h + (ROW_GAP if n < len(rows) - 1 else 0)
        return {"offsets": offsets, "w": total_w, "h": y, "first": first}

    vertical = content["flow"] == "top-to-bottom"
    has_spans = bool(content["spans"])
    # A span over whole bands stands beside them in a top-to-bottom flow; a span over glyphs of one band lies above that band.
    upright = lambda s: vertical and any(o in {b["id"] for b in content["bands"]} for o in s["over"])
    bands = content["bands"]
    cells = []
    drop = chrome(content, cells)
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
        # Bands side by side share one axis: the tallest first row among them, on which every band centres its first row.
        axis["h"] = max([grid_rows(b["id"], width - 2 * PAD)["first"] for b in bands if b["id"] not in {*rows, *lanes, *ladders}] + [0])
        axis["bands"] = {b["id"] for b in bands}
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
        cells.append(cell(b["id"], "", BAND, bb["x"], bb["y"], bb["w"], bb["h"]))
        title_w = round(len(b["label"]) * 8.5) + 16  # the word's width in bold 12 px, and a margin the edge's end stays clear of
        cells.append(
            cell(
                f"{b['id']}-title",
                html.escape(b["label"], quote=False),
                BAND_TITLE,
                bb["x"] + BAND_TITLE_INSET,
                bb["y"] + BAND_TITLE_INSET,
                title_w,
                BAND_TITLE_HEIGHT,
            )
        )
    # The groups and glyphs inside their holders, by the grid unless the layout places them.
    box_of = dict(band_box)

    def fill(holder_id, origin_x, origin_y, width, parent):
        grid = grid_rows(holder_id, width, axis["h"] if holder_id in axis["bands"] else 0)["offsets"]
        for item in holder.get(holder_id, []):
            w, h = size_of(item)
            x, y = grid[item["id"]]
            box = (
                layout.get(item["id"])
                or row_place(holder_id, item, origin_x, origin_y, w, h)
                or ladder_place(holder_id, item, origin_x, width, w, h)
                or {"x": origin_x + x, "y": origin_y + y, "w": w, "h": h}
            )
            box_of[item["id"]] = box
            if item["id"] in layout and holder_id in band_box:  # a band holds its items by place alone, so a moved item names its band
                cx, cy = box["x"] + box["w"] / 2, box["y"] + box["h"] / 2
                within = [b for b, bb in band_box.items() if bb["x"] <= cx <= bb["x"] + bb["w"] and bb["y"] <= cy <= bb["y"] + bb["h"]]
                if within and holder_id not in within:
                    raise DeclarationError(
                        f"layout places '{item['id']}' in {within[0]}, but its in: is {holder_id}; set in: to the band it "
                        f"sits in, or move it back"
                    )
            if "text" in item:
                text = "<br>".join(html.escape(line, quote=False) for line in item["text"].split("\n"))
                cells.append(cell(item["id"], text, NOTE, box["x"], box["y"], box["w"], box["h"], parent))
            elif "kind" in item:
                style = COMMIT_BOX if item.get("shape") == "box" else glyph_lib[item["kind"]]["style"]
                if item["kind"] == "env" and holder.get(item["id"]):  # an occupied environment names itself left of its occupants
                    style += "align=left;spacingLeft=22;"
                if item["kind"] == "commit":
                    style = commit_style(style, item.get("state", COMMIT_STATES[0]), item.get("ghost", False))
                if "rhombus" in style:  # a diamond's label stands in an invisible text rect inside it, never on its border
                    fit = diamond_fit(item["label"], (box["w"], box["h"]))
                    rect_w, rect_h = fit["rect"]
                    text = "<br>".join(html.escape(line, quote=False) for line in fit["lines"])
                    cells.append(cell(item["id"], "", style, box["x"], box["y"], box["w"], box["h"], parent))
                    cells.append(
                        cell(
                            f"{item['id']}-text",
                            f"<b>{text}</b>",
                            LABEL_RECT,
                            box["x"] + (box["w"] - rect_w) // 2,
                            box["y"] + (box["h"] - rect_h) // 2,
                            rect_w,
                            rect_h,
                            parent,
                        )
                    )
                else:
                    label = "<br>".join(html.escape(line, quote=False) for line in item["label"].split("\n"))  # a box's second line
                    cells.append(cell(item["id"], f"<b>{label}</b>", style, box["x"], box["y"], box["w"], box["h"], parent))
                if item["kind"] in TAGGED_KINDS:
                    # code and type share one shape and a label may name no language, so the glyph itself carries its kind and override
                    mark = f"catzcKind={item['kind']};" + (f"catzcLang={item['lang']};" if item.get("lang") else "")
                    next(c for c in reversed(cells) if c["id"] == item["id"])["style"] += mark
                    cells.extend(glyph_tags(item, box, parent, glyph_lib["type"]["tag"], box_of.get(holder_id)))
                # An environment's occupant commits sit inside it, right of its name, in a row from its right edge inward.
                for n, occupant in enumerate(holder.get(item["id"], [])):
                    d = glyph_lib["commit"]["size"][1]
                    inner = layout.get(occupant["id"]) or {
                        "x": box["x"] + box["w"] - 30 - d - n * (d + 6),
                        "y": box["y"] + (box["h"] - d) // 2,
                        "w": d,
                        "h": d,
                    }
                    box_of[occupant["id"]] = inner
                    occupant_style = commit_style(
                        glyph_lib["commit"]["style"], occupant.get("state", COMMIT_STATES[0]), occupant.get("ghost", False)
                    )
                    cells.append(
                        cell(
                            occupant["id"],
                            f"<b>{html.escape(occupant['label'], quote=False)}</b>",
                            occupant_style,
                            inner["x"],
                            inner["y"],
                            inner["w"],
                            inner["h"],
                            item["id"],
                        )
                    )
            else:
                cells.append(
                    cell(item["id"], html.escape(item["label"], quote=False), LIB["module"], box["x"], box["y"], box["w"], box["h"], parent)
                )
                fill(item["id"], box["x"] + PAD, box["y"] + LABEL_ROW, box["w"] - 2 * PAD, item["id"])

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
            cells.append(
                cell(
                    f"lane-{band}-trunk-label",
                    html.escape(str(lane["trunk"]), quote=False),
                    TRUNK_LABEL,
                    x1 - 160,
                    y_mid + dot + 8,
                    200,
                    18,
                )
            )
        for n, mark in enumerate(lane.get("marks") or []):
            at = box_of[str(mark["at"])]
            cells.append(
                cell(f"lane-{band}-mark-{n}", html.escape(str(mark["text"]), quote=False), MARK_TEXT, at["x"] - 70, at["y"] - 36, 162, 32)
            )
    if lanes:
        # A rule crosses the lanes that share the first lane's steps, and the bands between them; a lane on another axis (git's
        # history) runs under its own steps, so no rule crosses it.
        first = next(iter(lanes.values()))
        stride = lane_xy(first["band"], 2, 0)[0] - lane_xy(first["band"], 1, 0)[0]
        crossed = [band_box[b] for b, lane in lanes.items() if int(lane["steps"]) == int(first["steps"])]
        top, bottom = min(bb["y"] for bb in crossed), max(bb["y"] + bb["h"] for bb in crossed)
        for n, rule in enumerate(content.get("rules") or []):
            x = lane_xy(first["band"], int(rule["after"]), 0)[0] + glyph_lib["commit"]["size"][0] // 2 + stride // 2
            cells.append(cell(f"lane-rule-{n}-a", "", ANCHOR, x, top + LABEL_ROW, 1, 1))
            cells.append(cell(f"lane-rule-{n}-b", "", ANCHOR, x, bottom, 1, 1))
            cells.append(edge_cell(f"lane-rule-{n}", "", RULE_STYLES[rule["kind"]], f"lane-rule-{n}-a", f"lane-rule-{n}-b"))
    return SimpleNamespace(
        content=content,
        cells=cells,
        drop=drop,
        band_box=band_box,
        box_of=box_of,
        content_bottom=content_bottom,
        upright=upright,
        ladders=ladders,
    )
