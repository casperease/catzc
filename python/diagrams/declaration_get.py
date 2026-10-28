# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The get direction: the mxGraphModel XML embedded in a png read back into the declaration it was put from."""

import re
import xml.etree.ElementTree as ET

from . import query_rows
from .declaration_cells import TAG_ID, TAGGED_KINDS
from .declaration_constants import (
    BAND,
    CHIP_CORNER,
    COMMIT_STATES,
    COMMITS,
    DERIVED,
    DERIVED_PREFIXES,
    FLOWS,
    KINDS,
    PROOF_LENS,
    SIDEBAR,
    SPAN_LABEL,
)
from .declaration_dump import brief
from .declaration_get_action import get_action, get_proof
from .declaration_normalise import normalise
from .declaration_place import place
from .declaration_read import matches, shift_of, signature
from .declaration_routes import auto_corner, edge_middle
from .declaration_vocabulary import LIB, DeclarationError
from .drawio_png import DEFAULTS, plain, style_map


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
    if "lens-badge" in cells and plain(cells["lens-badge"].get("value")).lower() == PROOF_LENS:
        return get_proof(cells, kind)
    if any(matches(glyph_sigs["cause"], c.get("style") or "") for cid, c in cells.items() if not cid.startswith("lg-")):
        return get_action(cells, geo, glyph_sigs, kind)
    palette_fills = {fill.upper(): state for state, (fill, _, _) in COMMITS.items()}
    mark_sigs = {k: signature(v["style"]) for k, v in LIB["marks"].items()}
    module_sig = signature(LIB["module"])
    content: dict = {"title": "", "kind": kind or KINDS[0], "flow": FLOWS[0]}
    lens = "meta"
    rules: list = []
    content.update({"theme": next(iter(DEFAULTS["themes"])), "bands": [], "spans": [], "groups": [], "glyphs": []})
    content.update({"edges": [], "markers": [], "chips": [], "legend": "auto"})
    # The drawing carries each minimap's view, not what its author excludes: save() keeps the source's entries.
    content["minimaps"] = [plain(cells[cid].get("value")) for cid, _, _ in SIDEBAR if cid in cells]
    flow_phrase = plain(cells["lg-edge-flow-t"].get("value")) if "lg-edge-flow-t" in cells else ""
    content["relation"] = (
        flow_phrase[len("flow: ") :] if flow_phrase.startswith("flow: ") and flow_phrase != LIB["edges"]["flow"]["phrase"] else ""
    )
    # Put draws a relation only for a state diagram, so a drawing whose legend names one is a state diagram.
    content["states"] = bool(content["relation"])
    thick_phrase = plain(cells["lg-edge-thick-t"].get("value")) if "lg-edge-thick-t" in cells else ""
    content["thick"] = thick_phrase if thick_phrase and thick_phrase != brief(LIB["edges"]["thick"]["phrase"]) else ""
    layout = {}
    unnamed = []
    bands, groups, glyphs, bars, labels, markers, chips, notes = [], [], [], [], [], [], [], []
    lens = plain(cells["lens-badge"].get("value")).lower() if "lens-badge" in cells else lens
    for cid, c in cells.items():
        style, value = c.get("style") or "", plain(c.get("value"))
        if (
            c.get("edge") == "1"
            or cid in DERIVED
            or cid.startswith(DERIVED_PREFIXES)
            or cid.endswith(("-word", "-title", "-text"))
            or TAG_ID.search(cid)
        ):
            continue
        if cid == "title":
            content["title"] = value
        elif cid == "subtitle":
            rules = [p.strip() for p in value.split("·") if p.strip()]
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
        elif ("ellipse" in style_map(style) or style_map(style).get("commitShape") == "box") and style_map(style).get(
            "fillColor", ""
        ).upper() in palette_fills:
            glyphs.append((cid, "commit"))  # a commit in any palette state, a dot or a box
        else:
            kinds = [k for k, sig in sorted(glyph_sigs.items(), key=lambda kv: -len(kv[1])) if matches(sig, style)]
            marked = style_map(style).get("catzcKind")
            if marked in kinds:  # the tag row carries the glyph's kind: code and type share one shape
                glyphs.append((cid, marked))
            elif kinds:
                glyphs.append((cid, kinds[0]))
            else:
                unnamed.append(cid)
    if unnamed:
        raise DeclarationError(f"get cannot name these cells in the kit's vocabulary: {', '.join(unnamed)}")
    inside = lambda inner, outer: (
        outer["x"] <= inner["x"] + inner["w"] / 2 <= outer["x"] + outer["w"]
        and outer["y"] <= inner["y"] + inner["h"] / 2 <= outer["y"] + outer["h"]
    )
    bands.sort(key=lambda b: (geo[b]["y"], geo[b]["x"]))
    for b in bands:
        content["bands"].append({"id": b, "label": plain(cells[f"{b}-title"].get("value"))})  # a band's title is a box of its own
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

    def rows_of(ids, holder_key):
        """Each id's row among the ids sharing a holder. Boxes are centred on their row's middle, so a row is the run of ids whose centres
        lie within a pixel of one another, never the run of equal tops."""
        row, by_holder = {}, {}
        for i in ids:
            by_holder.setdefault(holder_key(i), []).append(i)
        for members in by_holder.values():
            n, last = -1, None
            for i in sorted(members, key=lambda i: geo[i]["y"] + geo[i]["h"] / 2):
                centre = geo[i]["y"] + geo[i]["h"] / 2
                n += last is None or centre - last > 1
                row[i], last = n, centre
        return row

    group_row = rows_of(groups, lambda g: holders[g])
    for g in sorted(groups, key=lambda g: (rank[holders[g]], group_row[g], geo[g]["x"])):
        content["groups"].append({"id": g, "label": plain(cells[g].get("value")) or " ", "in": holders[g]})  # " ": an untitled frame
        layout[g] = declared(geo[g])

    glyph_row = rows_of([cid for cid, _ in glyphs], holder_of)

    def reading_order(t):  # holder by holder, row-major; an environment's occupants come after the glyphs of the environment's holder
        h = holder_of(t[0])
        return (rank[holder_of(h)], 1, glyph_row[t[0]], geo[t[0]]["x"]) if h in envs else (rank[h], 0, glyph_row[t[0]], geo[t[0]]["x"])

    for cid, k in sorted(glyphs, key=reading_order):
        label = plain(cells[cid].get("value"))
        if f"{cid}-text" in cells:  # a diamond's label stands in its invisible text rect, wrapped at spaces
            label = " ".join(plain(cells[f"{cid}-text"].get("value")).split("\n"))
        glyph = {"id": cid, "kind": k, "label": label, "in": holder_of(cid)}
        if k == "commit":
            s = style_map(cells[cid].get("style"))
            if s.get("commitShape") == "box":
                glyph["shape"] = "box"
            state = palette_fills[s.get("fillColor", "").upper()]
            if state != COMMIT_STATES[0]:
                glyph["state"] = state
            if s.get("dashed") == "1":
                glyph["ghost"] = True
        elif k in TAGGED_KINDS:  # the tag words are derived and never read back; only the override a glyph names is
            lang = style_map(cells[cid].get("style") or "").get("catzcLang")
            if lang:
                glyph["lang"] = lang
        content["glyphs"].append(glyph)
        layout[cid] = declared(geo[cid])
    content["notes"] = []
    note_row = rows_of(notes, holder_of)
    for cid in sorted(notes, key=lambda n: (rank[holder_of(n)], note_row[n], geo[n]["x"])):
        content["notes"].append({"id": cid, "in": holder_of(cid), "text": plain(cells[cid].get("value"))})
        layout[cid] = declared(geo[cid])
    for bar in bars:
        box = geo[bar]
        vertical = "rotation=90" in (cells[bar].get("style") or "")
        near = [
            l
            for l in labels
            if abs((geo[l]["x"] + geo[l]["w"] / 2) - (box["x"] + box["w"] / 2)) <= 40
            and abs((geo[l]["y"] + geo[l]["h"] / 2) - (box["y"] + box["h"] / 2)) <= (box["h"] / 2 + 40 if vertical else 40)
        ]
        if vertical:
            over = [b for b in bands if geo[b]["y"] >= box["y"] - 2 and geo[b]["y"] + geo[b]["h"] <= box["y"] + box["h"] + 2]
        else:
            under = lambda i, box=box: geo[i]["x"] >= box["x"] - 2 and geo[i]["x"] + geo[i]["w"] <= box["x"] + box["w"] + 2
            over = [b for b in bands if under(b)]
            if (
                not over
                or min(geo[b]["x"] for b in over) > box["x"] + 2
                or max(geo[b]["x"] + geo[b]["w"] for b in over) < box["x"] + box["w"] - 2
            ):
                # Narrower than whole bands: the glyphs and groups standing directly in the band under the bar, left to right.
                below = [
                    b
                    for b in bands
                    if geo[b]["y"] > box["y"] and geo[b]["x"] < box["x"] + box["w"] and box["x"] < geo[b]["x"] + geo[b]["w"]
                ]
                band = min(below, key=lambda b: geo[b]["y"] - box["y"]) if below else None

                def band_of(item):  # a glyph or group's band, through any frames it sits in
                    h = holders.get(item) if item in groups else holder_of(item)
                    while h in groups:
                        h = holders[h]
                    return h

                members = [m for m in list(groups) + [g for g, _ in glyphs] if band_of(m) == band and under(m)]
                # The outermost covered items: a member whose frame is itself covered is named through that frame.
                over = sorted(
                    (
                        m
                        for m in members
                        if not (m in holders and holders[m] in members) and not (m not in groups and holder_of(m) in members)
                    ),
                    key=lambda m: geo[m]["x"],
                )
        content["spans"].append({"id": bar, "label": plain(cells[near[0]].get("value")) if near else "", "over": over})
    glyph_ids = [g[0] for g in glyphs]
    kind_of = dict(glyphs)

    # Where put centres a marker: a corner of a box (named), beside a diamond's top point (the default, no name), or the middle of an
    # edge; a band's or group's default marker, beside its name, carries its holder in catzcAt.
    def anchors(g):
        x, y, w, h = geo[g]["x"], geo[g]["y"], geo[g]["w"], geo[g]["h"]
        corners = [
            ("top-left", (x + 1, y)),
            ("top-right", (x + w - 1, y)),
            ("bottom-left", (x + 1, y + h)),
            ("bottom-right", (x + w - 1, y + h)),
        ]
        return ([(None, (x + w // 2 - 29, y + 7))] if kind_of.get(g) == "gate" else []) + corners

    edge_ends = [
        (c.get("source"), c.get("target")) for cid, c in cells.items() if c.get("edge") == "1" and not cid.startswith(("lg-", "lane-"))
    ]
    places = [(g, name, point) for g in glyph_ids + groups + bands for name, point in anchors(g)]
    centre_of = lambda i: (geo[i]["x"] + geo[i]["w"] / 2, geo[i]["y"] + geo[i]["h"] / 2)

    def via_of(c):  # an edge's waypoints on the page: relative to its container when it sits in one
        points = c.find("mxGeometry/Array")
        ox, oy = (geo[c.get("parent")]["x"], geo[c.get("parent")]["y"]) if c.get("parent") in geo else (0, 0)
        return [[float(p.get("x", 0)) + ox, float(p.get("y", 0)) + oy] for p in points.findall("mxPoint")] if points is not None else []

    edge_paths = [
        (c.get("source"), c.get("target"), via_of(c))
        for cid, c in cells.items()
        if c.get("edge") == "1" and not cid.startswith(("lg-", "lane-"))
    ]
    places += [(f"{s}->{t}", "edge", edge_middle(geo[s], geo[t], via)) for s, t, via in edge_paths if s in geo and t in geo]
    for m in sorted(markers, key=lambda m: int(plain(cells[m].get("value")))):
        centre = centre_of(m)
        at, name, _ = min(places, key=lambda p: abs(p[2][0] - centre[0]) + abs(p[2][1] - centre[1]))
        holder = style_map(cells[m].get("style") or "").get("catzcAt")  # a band's or group's marker beside its name, at its default
        if holder in (*bands, *groups):
            at, name = holder, None
        marker = {"at": at, "number": int(plain(cells[m].get("value")))}
        if name not in (None, "edge"):
            sources = [geo[s] for s, t in edge_ends if t == at and s in geo]
            kits = style_map(cells[m].get("style") or "").get("catzcAuto") == "1"  # a corner the kit chose clear of tags and pills
            if not kits and (kind_of.get(at) in (None, "gate") or name != auto_corner(geo[at], sources)):
                marker["corner"] = name
        content["markers"].append(marker)
    # A chip's id is chip-<kind>-<place>-<n>, so the place it sits on is read from the id, in the order put drew them.
    for ch in chips:
        style = cells[ch].get("style") or ""
        kind = "rule" if matches(mark_sigs["rule"], style) else "count"
        at = ch.removeprefix(f"chip-{kind}-").rsplit("-", 1)[0]
        value = plain(cells[ch].get("value"))
        if kind == "rule":
            chip = {"at": at, "kind": "rule", "rule": rules[int(value.lstrip("#")) - 1]}
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
            side = (
                "-right"
                if right and not left
                else "-left"
                if left and not right
                else ("-left" if cx < box["x"] + box["w"] / 2 else "-right")
            )
            corner = ("top" if cy < box["y"] + box["h"] / 2 else "bottom") + side
            corner = style_map(style).get("catzcCorner", corner)  # put names the corner a chip stepped inward from
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
        word = plain(cells[f"{cid}-word"].get("value")) if f"{cid}-word" in cells else ""  # a word moved into its transition bubble
        said = plain(c.get("value")) or word
        counted = re.fullmatch(r"(?:(.*) )?(\d+/\d+)", said)  # the pill reads `<label> <n/m>`: the count is its last word
        edge = {"from": c.get("source"), "to": c.get("target"), "kind": kinds[0], "label": counted.group(1) or "" if counted else said}
        if counted:
            edge["count"] = counted.group(2)
        if (
            via_of(c) and edge["kind"] != "bypass" and "catzcElbow" not in style_map(c.get("style") or "")
        ):  # a bypass's and an elbow's route is the kit's
            edge["via"] = [[int(x), int(y) - shift] for x, y in via_of(c)]  # the waypoints as declared, before span room
        content["edges"].append(edge)
    if "uniformLabel=1" in (
        cells.get("lg-edge-flow-t", {}).get("style") or ""
    ):  # a word the legend says for every flow edge is each one's label
        for edge in content["edges"]:
            if edge["kind"] == "flow" and not edge["label"]:
                edge["label"] = content["relation"]
        content["relation"] = ""
        content["states"] = False  # the word is each edge's label, never a state diagram's relation
    about = {"rules": rules, "lens": lens}
    if "zoom-badge" in cells:  # the zoom badge prints the level, so the drawing carries it back
        about["zoom"] = plain(cells["zoom-badge"].get("value"))
    # The query's cells are its rows', never the source's: the drawing gives them back to nobody (DDR-VISUAL-ZOOMISANAXIS).
    content["glyphs"] = [g for g in content.get("glyphs") or [] if not query_rows.drawn_by_query(g["id"])]
    content["edges"] = [
        e for e in content.get("edges") or [] if not (query_rows.drawn_by_query(e["from"]) or query_rows.drawn_by_query(e["to"]))
    ]
    layout = {cid: box for cid, box in layout.items() if not query_rows.drawn_by_query(cid)}
    content["chips"] = [c for c in content.get("chips") or [] if not query_rows.drawn_by_query(c["at"])]
    declaration = normalise({"about": about, "content": content, "layout": layout}, where="the drawing")
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
