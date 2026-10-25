# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""Placing the action and proof lenses: the cause on the left rim, the effects in zones between rings, the engines of the proof
lens, and the operators and legend box they draw."""

import html
import math
import re

import declaration_settings
from declaration_action_content import call_line, cause_radius, wrap_line
from declaration_cells import cell, chrome, edge_cell
from declaration_constants import (
    ACTION,
    ACTION_CLEARANCE,
    ACTION_LANE,
    ACTION_MARGIN,
    ACTION_WIDTH,
    ACTOR_LINE,
    ANCHOR,
    BAND,
    DEFAULT_SHOW,
    GAP,
    LABEL_ROW,
    PAD,
    PAGE,
    PROOF_ENGINES,
    PROOF_LENS,
    PROOF_ROW,
    PROOF_SHOWN,
    TEXT,
)
from declaration_finish import finish
from declaration_routes import cross_circle, label_spot, marker_xy, transition
from declaration_vocabulary import LIB, DeclarationError


def place_action(declaration):
    """The action lens's cells: one rounded frame captioned with the title; the cause, a half-disc whose flat side sits on the frame's
    left rim; the action right of it, one call or a call site of rows; the rings, one per causal hop, half-rings opening rightward from
    the cause's centre; each effect a note on its ring with its where chip, spread top to bottom in declared order; and the flow edges
    the lens draws itself, cause to action and action to each effect. Nothing but the frame takes a layout entry."""
    content, layout = declaration["content"], declaration["layout"]
    lib = LIB["glyphs"]
    cells: list = []
    drop = chrome(content, cells)
    if content["lens"] == PROOF_LENS:  # the Proof box alone, where the frame would stand
        bottom = proof_cells(cells, content["action"], PAGE["x"], PAGE["band_y"] + drop, PAGE["width"])
        return finish(cells, content, bottom, declaration)
    gap, note_w, radius = int(ACTION["ring-gap"]), int(ACTION["note-width"]), cause_radius(content["cause"])
    action, effects = content["action"], content["effects"]
    site = "calls" in action
    member = lib["callsite"]["member"]
    # Every call wraps at its natural breaks inside the action width, about 7 px a character, and the glyph grows in height to
    # hold the lines; a piece with no break left makes the glyph wider instead, and the width budget below says if that is too much.
    wrapped = [wrap_line(call_line(c), (ACTION_WIDTH - 28) // 7) for c in (action["calls"] if site else [action["call"]])]
    aw = max(lib["callsite" if site else "action"]["size"][0], 28 + 7 * max(len(line) for lines in wrapped for line in lines))
    row_h = [member["size"][1] + 16 * (len(lines) - 1) for lines in wrapped]
    ah = 30 + sum(h + 10 for h in row_h) if site else max(lib["action"]["size"][1], 24 + 16 * len(wrapped[0]))
    per_note = max(1, (note_w - 24) // 7)

    def note_lines(e):  # the says lines, which draw.io wraps itself, and the proof or call lines, wrapped here so a path breaks
        show = e.get("show", DEFAULT_SHOW)
        says = wrap_line(e["says"], per_note) if e.get("says") and show != "call" else []
        line = wrap_line(call_line(e["call"] if "call" in e else e["proves"]), per_note) if show != "words" else []
        return says, line

    def note_h(e):
        says, line = note_lines(e)
        return 24 + 16 * (len(says) + len(line))

    def operator(source, target):  # the edge's word: executes from the action, then affects into an execution, effects into a state
        return "executes" if source == "action" else "affects" if "call" in target else "effects"

    hops = max(e["zone"] for e in effects)
    if gap < note_w + PAD:  # two effects at the same angle on neighbouring rings would overlap: the kit's constants, not the author's
        raise DeclarationError(
            f"drawio.yml action-lens: ring-gap {gap} leaves no room for a note of note-width {note_w} plus {PAD}; raise ring-gap"
        )
    # The rings are centred where the cause's flat side meets the frame's left rim, so they open rightward as half-rings cut by the
    # frame; the action sits right of the cause, and the first ring clears the action's right edge.
    r0 = round(radius * 0.9) + 10 + aw + ACTION_CLEARANCE  # the first ring clears the statement's right edge
    r_max = r0 + hops * gap
    # The frame has a fixed height: an invisible centre lane holds the cause, the action and every note, and the margin above and
    # below it is where the rings crawl up and down before the frame cuts them. The outermost ring spans the whole inner height and
    # the inner rings scale with their radius, so few rings draw flat. A pinned frame (layout: frame) sets another height.
    frame = layout.get("frame") or {
        "x": PAGE["x"],
        "y": PAGE["band_y"] + drop,
        "w": PAGE["width"],
        "h": LABEL_ROW + 2 * max(ACTION_LANE // 2 + ACTION_MARGIN, round(radius * 2.35) + 10) + PAD,  # the head above the lane fits
    }
    inner = frame["h"] - LABEL_ROW - PAD
    half_inner, lane_half = inner // 2, inner // 2 - ACTION_MARGIN
    cx, cy = frame["x"], frame["y"] + LABEL_ROW + inner // 2
    head_cy = cy - round(radius * 1.35)  # the head's centre: its neck, hand and the lane's centre line follow from the body
    reach = r_max + note_w + PAD
    if reach > frame["w"]:
        raise DeclarationError(
            f"the action lens needs {reach} px for {hops} rings and their notes; the frame is {frame['w']} wide: fewer rings, or shorter calls"
        )
    if half_inner < round(radius * 1.35) + radius or lane_half < ah // 2 + 10:  # the head above, the statement in the lane
        raise DeclarationError(f"the centre lane of {2 * lane_half} px cannot hold the cause and the action; pin a taller frame in layout:")
    cells.append(cell("frame", html.escape(content["title"], quote=False), BAND, frame["x"], frame["y"], frame["w"], frame["h"]))
    label = f"<b>{html.escape(content['cause']['label'], quote=False)}</b>"
    # The head, the fragment with the idea in it, stands above the statement, so it may grow sideways over it; the actor's right hand,
    # where the statement is done, falls on the lane's centre line by the body's proportions.
    cells.append(cell("cause", label, lib["cause"]["style"], frame["x"], head_cy - radius, radius, 2 * radius))
    if declaration_settings.ACTOR:
        # The stick man for the onlooker, drawn over everything last: the fragment is his head, and his body hangs from it in four
        # plain lines between anchors, free to overflow the rim and whatever stands near; nothing moves for him, and get skips him.
        sx, top = frame["x"] + round(radius * 0.3), head_cy + radius
        points = {
            "neck": (sx, top),
            "hip": (sx, top + round(radius * 0.7)),
            "hand-l": (sx - round(radius * 0.6), top + round(radius * 0.35)),
            "hand-r": (sx + round(radius * 0.6), top + round(radius * 0.35)),
            "foot-l": (sx - round(radius * 0.45), top + round(radius * 1.6)),
            "foot-r": (sx + round(radius * 0.45), top + round(radius * 1.6)),
        }
        for name, (px, py) in points.items():
            cells.append(cell(f"actor-{name}", "", ANCHOR, px, py, 1, 1))
        for a, b in (("neck", "hip"), ("hand-l", "hand-r"), ("hip", "foot-l"), ("hip", "foot-r")):
            cells.append(edge_cell(f"actor-{a}-{b}", "", ACTOR_LINE, f"actor-{a}", f"actor-{b}"))
    ax, ay = frame["x"] + round(radius * 0.9) + 10, cy - ah // 2  # just right of the actor's right hand
    printed = lambda lines: "<br>".join(html.escape(line, quote=False) for line in lines)
    # The statement, done by the actor's hand: a plain box at the right hand, on the lane's centre line, with no line from the head,
    # since what runs from the head to the hand runs through the body and is not drawn; the word cats stands at the hand.
    style = lib["callsite" if site else "action"]["style"]
    if site:
        cells.append(cell("action", f"<b>{lib['callsite']['phrase']}</b>", style, ax, ay, aw, ah))
        y = ay + 30
        for n, lines in enumerate(wrapped):
            cells.append(cell(f"action-{n + 1}", printed(lines), member["style"], ax + 14, y, aw - 28, row_h[n], "action"))
            y += row_h[n] + 10
    else:
        cells.append(cell("action", printed(wrapped[0]), style, ax, ay, aw, ah))
    cells.append(cell("cats", "<b>cats</b>", TEXT.replace("fontColor=@quiet", "fontColor=@ink"), ax + 26, ay - 22, 40, 18))
    tag, flow, mark = lib["effect"]["tag"], LIB["edges"]["flow"]["style"], LIB["marks"]["marker"]
    labelled = flow.replace("shadow=0;", "fontColor=@ink;fontStyle=1;fontSize=11;labelBackgroundColor=@band;shadow=0;")
    box_of = {
        "cause": {"x": frame["x"], "y": head_cy - radius, "w": radius, "h": 2 * radius},
        "action": {"x": ax, "y": ay, "w": aw, "h": ah},
    }
    zone_of = {"cause": 0, "action": 0}
    # The story's numbers, one per box: the cause, the action, then every effect in its order.
    numbered = [("cause", (cx + 4, head_cy - radius - 11)), ("action", marker_xy({"x": ax, "y": ay, "w": aw, "h": ah}, "top-left"))]
    for k in range(1, hops + 1):
        r_in, r = r0 + (k - 1) * gap, r0 + k * gap
        # A ring is a perfect circle centred on the cause's rim, drawn only where it crosses the frame's inner height: an arc from the
        # inner top boundary to the inner bottom one, mirrored on the centre line, and steeper the further out it stands.
        turn = math.asin(min(1.0, half_inner / r)) / (2 * math.pi)
        style = re.sub(r"(start|end)Angle=[^;]*;", "", lib["ring"]["style"]) + f"startAngle={1 - turn:.4f};endAngle={turn:.4f};"
        cells.append(cell(f"ring-{k}", "", style, cx - r, cy - r, 2 * r, 2 * r))
        # A zone is what lies inside a ring's line and outside the one before it; its effects stand in the lane, spread evenly top to
        # bottom in the story's order, each centred on the zone's middle curve.
        in_zone = [e for e in effects if e["zone"] == k]
        heights = [note_h(e) for e in in_zone]
        if sum(heights) + 24 * (len(in_zone) - 1) > 2 * lane_half:
            raise DeclarationError(
                f"zone {k} holds {len(in_zone)} effects of {sum(heights)} px, more than the centre lane of {2 * lane_half} px; "
                "move one to the next zone, or pin a taller frame in layout:"
            )
        # A zone narrows towards the lane's top and bottom, where its rings curve in; a note stands just right of the zone's inner
        # curve and must end before its outer one, so the notes spread as far as the zone lets them, towards the centre line otherwise.
        # This zone's values are bound as defaults: the curves and the two helpers are only ever called within this pass of the loop.
        inner_edge = (lambda y: r0 - ACTION_CLEARANCE / 2) if k == 1 else (lambda y, r_in=r_in: math.sqrt(max(0.0, r_in**2 - y**2)))
        outer_edge = lambda y, r=r: math.sqrt(max(0.0, r**2 - y**2))
        full_step = (2 * lane_half - sum(heights)) / (len(in_zone) + 1)

        # The notes' top edges, relative to the centre line: 1 spreads them over the lane, 0 packs them at it.
        def tops_at(scale, full_step=full_step, heights=heights, in_zone=in_zone):
            step = 24 + (full_step - 24) * scale
            top, tops = -(sum(heights) + step * (len(in_zone) - 1)) / 2, []
            for h in heights:
                tops.append(top)
                top += h + step
            return tops

        # Each note's left edge, or None when one note does not fit between its zone's curves.
        def fitted(tops, heights=heights, inner_edge=inner_edge, outer_edge=outer_edge):
            boxes = []
            for top, h in zip(tops, heights):
                near = 0.0 if top <= 0 <= top + h else min(abs(top), abs(top + h))
                left = inner_edge(near) + 12
                if left + note_w > outer_edge(max(abs(top), abs(top + h))) - 12:
                    return None
                boxes.append(left)
            return boxes

        best = fitted(tops_at(0.0))
        if best is None:
            raise DeclarationError(
                f"zone {k} cannot hold its {len(in_zone)} effects between its rings; move one to the next zone, or fewer words"
            )
        low, high = 0.0, 1.0
        for _ in range(16):
            mid = (low + high) / 2
            boxes = fitted(tops_at(mid))
            if boxes is None:
                high = mid
            else:
                low, best = mid, boxes
        for e, h, left, top in zip(in_zone, heights, best, tops_at(low)):
            x, y = round(cx + left), round(cy + top)
            said, line = note_lines(e)
            says = f"<b>{html.escape(e['says'], quote=False)}</b>" if said else ""
            text = says + ("<br>" if said and line else "") + printed(line)
            style = member["style"] if "call" in e else lib["effect"]["style"]  # an execution is drawn as a command row, a state as a note
            cells.append(cell(e["id"], text, style, x, y, note_w, h))
            if "where" in e:  # a chip only where the effect's where differs from the diagram's
                cells.append(
                    cell(f"{e['id']}-tag", e["where"], tag["style"], x + note_w - tag["size"][0] - 8, y - 8, tag["size"][0], tag["size"][1])
                )
            source = e.get("after", "action")
            box_of[e["id"]] = {"x": x, "y": y, "w": note_w, "h": h}
            zone_of[e["id"]] = k
            skip = (cy, lane_half, ACTION_MARGIN) if k - zone_of[source] > 1 else None  # a zone skipped: the margin carries the edge
            edge = operator_edge(f"e-{source}-{e['id']}", operator(source, e), labelled, source, e["id"], box_of, skip)
            a, b = box_of[source], box_of[e["id"]]
            line = [
                (a["x"] + a["w"], a["y"] + a["h"] / 2),
                *[(vx, vy) for vx, vy in edge.get("via", [])],
                (b["x"], b["y"] + b["h"] / 2),
            ]
            at = cross_circle(line, (cx, cy), r0 + zone_of[source] * gap) if zone_of[source] >= 1 else None
            if (
                declaration_settings.EDGE_LABEL == "pill"
            ):  # the pill at the first ring the line crosses, or at its middle, where the head stays clear
                at = label_spot(line, operator(source, e), 0, at, [(v["x"], v["y"], v["w"], v["h"]) for v in box_of.values()])
                if at:
                    cells.append(transition(edge, operator(source, e), at))
            elif at:  # the word presentation: a line into a new zone becomes a bubble on the first ring crossed
                cells.append(transition(edge, operator(source, e), at))
            cells.append(edge)
            numbered.append((e["id"], marker_xy({"x": x, "y": y, "w": note_w, "h": h}, "top-left")))
    # The cause reaches its action through cats, always: the edge says so, and the cause's own words never need to.
    for n, (_, (mx, my)) in enumerate(numbered, 1):
        cells.append(cell(f"mark-{n}", str(n), mark["style"], round(mx), round(my), mark["size"][0], mark["size"][1]))
    bottom = frame["y"] + frame["h"]
    if content.get("proof", "shown" if PROOF_SHOWN else "hidden") == "shown":  # the Proof box under the frame, as wide as it
        bottom = proof_cells(cells, content["action"], frame["x"], bottom + GAP, frame["w"])
    return finish(cells, content, bottom, declaration)


def engine_words(call, idiom):
    """A contract-form call in the words an engine runs it as: `pascal` is PowerShell's Verb-Noun with -Parameter 'value', `kebab` the
    POSIX shells' kebab-case command with --parameter 'value'. A true switch stands alone, a false one says so, a number stays bare."""
    ((name, args),) = call.items()
    words = name.split("_")
    if idiom == "pascal":
        head = words[0].capitalize() + ("-" + "".join(w.capitalize() for w in words[1:]) if len(words) > 1 else "")
        parts = [head]
        for key, value in args.items():
            parameter = "-" + "".join(w.capitalize() for w in key.split("_"))
            parts.append(
                parameter
                if value is True
                else f"{parameter}:$false"
                if value is False
                else f"{parameter} '{value}'"
                if isinstance(value, str)
                else f"{parameter} {value}"
            )
    else:
        parts = [name.replace("_", "-")]
        for key, value in args.items():
            parameter = "--" + key.replace("_", "-")
            parts.append(
                parameter
                if value is True
                else f"{parameter} false"
                if value is False
                else f"{parameter} '{value}'"
                if isinstance(value, str)
                else f"{parameter} {value}"
            )
    return " ".join(parts)


def proof_cells(cells, action, x, y, w):
    """The Proof box: captioned Proof, as wide as the frame it stands under, holding for each call of the action its normalized statement,
    the one line cats knows, and under it the words each engine runs that statement as. Returns the box's bottom."""
    calls = action["calls"] if "calls" in action else [action["call"]]
    h = LABEL_ROW + len(calls) * (1 + len(PROOF_ENGINES)) * PROOF_ROW + (len(calls) - 1) * 10 + PAD
    cells.append(cell("proof", "Proof", BAND, x, y, w, h))
    bright = TEXT.replace("fontColor=@quiet", "fontColor=@ink")
    row_y = y + LABEL_ROW - 6
    for n, call in enumerate(calls, 1):
        line = html.escape(call_line(call), quote=False)
        cells.append(cell(f"proof-{n}-cats", f"<b>cats</b>&nbsp;&nbsp;{line}", bright, x + PAD, row_y, w - 2 * PAD, PROOF_ROW))
        row_y += PROOF_ROW
        for engine, idiom in PROOF_ENGINES:
            words = html.escape(engine_words(call, idiom), quote=False)
            cells.append(cell(f"proof-{n}-{engine}", f"<b>{engine}</b>&nbsp;&nbsp;{words}", TEXT, x + PAD, row_y, w - 2 * PAD, PROOF_ROW))
            row_y += PROOF_ROW
        row_y += 10
    return y + h


def operator_edge(cid, word, style, source, target, box_of, skip=None):
    """An operator's edge, drawn from chosen points: it leaves the source's right side at the height nearest its target (a cause at
    its round's apex) and enters the target's left side at the height nearest its source, each clamped inside the middle half of the
    box; its word sits a quarter of the way along, above the line when the edge climbs or runs level, below it when the edge falls.
    An edge that skips a zone (`skip` is the lane's centre line and half-height, and the margin's height) runs through the margin
    instead of behind the notes it passes: up or down beside its source, across the margin, and down or up into its target, with its
    word on the run across."""
    a, b = box_of[source], box_of[target]
    a_mid, b_mid = a["y"] + a["h"] / 2, b["y"] + b["h"] / 2
    clamp = lambda t: round(min(0.75, max(0.25, t)), 2)
    if skip:
        cy, lane_half, margin = skip
        above = b_mid <= cy
        run = cy - lane_half - margin / 2 if above else cy + lane_half + margin / 2
        edge = edge_cell(cid, f"<b>{word}</b>", style + "exitX=1;exitY=0.5;entryX=0;entryY=0.5;", source, target)
        edge["via"] = [[round(a["x"] + a["w"] + 20), round(run)], [round(b["x"] - 20), round(run)]]
        edge["label_at"] = (0, -12 if above else 12)
        return edge
    exit_y = 0.5 if source == "cause" else clamp((b_mid - a["y"]) / a["h"])
    entry_y = clamp((a_mid - b["y"]) / b["h"])
    edge = edge_cell(cid, f"<b>{word}</b>", style + f"exitX=1;exitY={exit_y};entryX=0;entryY={entry_y};", source, target)
    edge["label_at"] = (-0.5, 12 if b_mid > a_mid else -12)  # a level edge reads like a climbing one: the word above
    return edge
