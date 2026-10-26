# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The normal form of a declaration: every key checked against the kit's vocabulary and every shorthand written out, so put and get see
one shape."""

from . import languages_table, minimaps, query_rows
from .declaration_action_content import action_content
from .declaration_constants import (
    ABOUT_KEYS,
    ACTION_KEYS,
    ACTION_LENS,
    FLOW_KEYS,
    FLOW_LENS,
    CHIP_CORNER,
    COMMIT_SHAPES,
    COMMIT_STATES,
    CONTENT_KEYS,
    CORNERS,
    FLOWS,
    KINDS,
    LADDER_KEYS,
    PROOF_LENS,
    RETIRED_ABOUT_KEYS,
    RULE_KINDS,
    SHORTHAND,
    SPAN_ROW,
    TOP_KEYS,
)
from .declaration_dump import entry, legend_phrases
from .declaration_edges import EDGE_COUNT, between_edge, edge_semantics_findings, orient_edges, relation_pairing
from .declaration_expand import expand_lanes, expand_rows, shown_minimaps
from .declaration_vocabulary import EDGE_KINDS, GLYPH_KINDS, DeclarationError, choices, span_vocabulary
from .drawio_png import DEFAULTS


def about_point(about_raw, where):
    """The point of the tree a slide's query answers for, and the key its rows are filed under: the zoom of a C3 or C4 slide, or the
    flow lens; a point needs one of those."""
    about_raw = about_raw if isinstance(about_raw, dict) else {}
    point, zoom = about_raw.get("point"), about_raw.get("zoom")
    if point is None:
        return None, zoom
    if not isinstance(point, str) or not point.strip():
        raise DeclarationError(f"{where}: about.point is the repository path a C3 or C4 slide's or a flow diagram's query answers for")
    if about_raw.get("lens") == FLOW_LENS:
        return point.strip().strip("/"), FLOW_LENS
    if zoom not in query_rows.QUERY_LEVELS:
        raise DeclarationError(
            f"{where}: about.point belongs to a slide at {' or '.join(query_rows.QUERY_LEVELS)} or under the {FLOW_LENS} lens; "
            f"this one's zoom is {zoom}"
        )
    return point.strip().strip("/"), zoom


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
    # A flow declaration stores its inputs alone: its cells come from the engine readers' rows (DDR-VISUAL-FLOWISALENS).
    if isinstance(raw.get("about"), dict) and raw["about"].get("lens") == FLOW_LENS:
        extra = [key for key in content if key not in FLOW_KEYS]
        if extra:
            raise DeclarationError(f"{where}: a {FLOW_LENS} declaration holds only {' and '.join(FLOW_KEYS)}; it also holds {', '.join(extra)}")
    content, generated = expand_rows(content, where)
    content, lane_generated = expand_lanes(content, where)
    generated |= lane_generated
    # A C3 or C4 slide's cells are its query's rows for its point, written out like rows: (DDR-VISUAL-ZOOMISANAXIS).
    point, zoom = about_point(raw.get("about"), where)
    query_layout = {}
    if point is not None:
        content, query_generated, query_layout = query_rows.expand(content, point, zoom, where)
        generated |= query_generated
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
    # The zoom crosses the lens and has no default: a diagram without one is drawn as before (DDR-VISUAL-ZOOMISANAXIS).
    zoom = about_raw.get("zoom")
    if zoom is not None and str(zoom) not in DEFAULTS["zooms"]:
        choices(f"{where}: about.zoom", str(zoom), tuple(DEFAULTS["zooms"]))
    out["zoom"] = None if zoom is None else str(zoom)
    out["point"] = point
    kind =content.get("kind", KINDS[0])
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
    # The action lens draws its cause, its action and its effects, and the renderer draws every edge; the proof lens draws the action's
    # statement alone; every other lens draws bands.
    if lens in (ACTION_LENS, PROOF_LENS):
        for key in ("bands", "groups", "glyphs", "notes", "edges", "spans", "markers", "chips", "relation", "states", "thick", "ladders") + SHORTHAND:
            if content.get(key):
                raise DeclarationError(
                    f"{where}: content.{key} is the band grammar; the {lens} lens draws an action, and the renderer draws the rest"
                )
        if lens == PROOF_LENS:
            for key in ("cause", "effects", "proof"):
                if key in content:
                    raise DeclarationError(
                        f"{where}: content.{key} belongs to the action lens; the proof lens draws the action's statement alone"
                    )
    else:
        for key in ACTION_KEYS + ("proof",):
            if key in content:
                raise DeclarationError(f"{where}: content.{key} belongs to the action lens; this diagram's lens is {lens}")
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
        lang = str(raw_glyph.get("lang", "") or "").strip() if isinstance(raw_glyph, dict) else ""
        g = entry(
            {k: v for k, v in raw_glyph.items() if k not in extra and k != "lang"} if isinstance(raw_glyph, dict) else raw_glyph,
            ("id", "kind", "label", "in"),
            where,
            "glyph",
        )
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
        if lang:  # the one override of the language tags a glyph's label derives: a language row of the table that has a tag
            if lang not in languages_table.rows():
                choices(f"{where}: glyph '{g['id']}' lang", lang, tuple(languages_table.rows()))
            g["lang"] = lang
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
    # A ladder names a band whose glyphs climb left to right along their forward edges, each rise px above the one before.
    ladders = []
    for raw_ladder in content.get("ladders") or []:
        ladder = entry(raw_ladder, LADDER_KEYS[:2], where, "ladder", optional={"w": "", "h": ""})
        if ids.get(ladder["band"]) != "band":
            choices(f"{where}: ladder band", ladder["band"], [i for i, k in ids.items() if k == "band"])
        if not ladder["rise"].isdigit() or int(ladder["rise"]) < 1:
            raise DeclarationError(f"{where}: ladder '{ladder['band']}' rise is a whole number of px from 1, how far each rung climbs")
        if ladder["band"] in {l["band"] for l in ladders}:
            raise DeclarationError(f"{where}: ladder band '{ladder['band']}' is named twice")
        size = {k: ladder[k] for k in ("w", "h") if ladder[k] != ""}
        if len(size) == 1 or any(not v.isdigit() or int(v) < 1 for v in size.values()):
            raise DeclarationError(f"{where}: ladder '{ladder['band']}' w and h are a rung's size in px, both or neither")
        ladders.append({"band": ladder["band"], "rise": int(ladder["rise"]), **{k: int(v) for k, v in size.items()}})
    if ladders:
        out["ladders"] = ladders
    vocabulary = span_vocabulary()
    out["spans"] = []
    for s in content.get("spans") or []:
        span = entry(s, ("id", "label", "over"), where, "span", optional={"row": SPAN_ROW})
        if span["row"] == SPAN_ROW:
            del span["row"]  # an auto row is never written out
        elif not span["row"].isdigit():
            raise DeclarationError(f"{where}: span '{span['id']}' row {span['row']} is {SPAN_ROW} or a whole number from 0")
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
        if isinstance(e, dict) and "between" in e:
            e = between_edge(e, out, where)
        via = e.get("via") if isinstance(e, dict) else None
        count = str(e.get("count", "") or "").strip() if isinstance(e, dict) else ""
        edge = entry(
            {k: v for k, v in e.items() if k not in ("via", "count")} if isinstance(e, dict) else e,
            ("from", "to"),
            where,
            "edge",
            optional={"kind": EDGE_KINDS[0], "label": ""},
        )
        if not count and EDGE_COUNT.fullmatch(str(edge["label"])):  # a label that is only a count is the edge's count
            count, edge["label"] = str(edge["label"]), ""
        if count:  # `count: n/m`, shown in the edge's pill after its label; it is no label and never decides the direction
            found = EDGE_COUNT.fullmatch(count)
            if not found or int(found.group(1)) > int(found.group(2)):
                raise DeclarationError(f"{where}: edge {edge['from']} -> {edge['to']} count '{count}' is n/m with n at most m, as in 13/28")
            edge["count"] = count
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
    if lens in (ACTION_LENS, PROOF_LENS):
        action_content(content, out, ids, where, lens)
    orient_edges(out, content, where)
    edge_semantics_findings(out, content, where)
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
    if legend == "used" and lens != ACTION_LENS:
        raise DeclarationError(f"{where}: legend: used lists the operators an action diagram draws; this diagram's lens is {lens}")
    if legend not in ("auto", "used"):
        phrases = legend_phrases()
        if not isinstance(legend, list):
            raise DeclarationError(f"{where}: legend is auto or a list of the phrases the legend shows")
        for phrase in legend:
            if phrase not in phrases:
                choices(f"{where}: legend phrase", phrase, phrases)
    out["legend"] = legend
    # The one relationship the flow edges mean on this diagram, named in the legend as `flow: <relation>`.
    out["relation"] = str(content.get("relation", "") or "").strip()
    # Whether the diagram's arrows are steps of one thing between states, the only diagram that may name its own relation.
    states = content.get("states", False)
    if not isinstance(states, bool):
        raise DeclarationError(f"{where}: content.states is true or false, not {states!r}")
    out["states"] = states
    relation_pairing(out, where)
    # What the thick edges reach on this diagram, the legend's phrase for them; empty keeps the library's `to a named set`.
    out["thick"] = str(content.get("thick", "") or "").strip()
    # The three minimaps: the ones the declaration names, or, when it names none, the kind's defaults maps.yml declares, which reach
    # the kit as the folder's minimap data (with_data).
    allowed = tuple(str(DEFAULTS["minimaps"]["ids"]).replace(",", " ").split())
    declared = content.get("minimaps") or []
    # The declaration holds a minimap's inputs only, never its cells: each shown minimap is an id, or { id: { exclude: [cells] } } naming
    # the lit cells its author rejects; the lit cells are computed at build from about.adrs and the citing files.
    if not isinstance(declared, list):
        raise DeclarationError(
            f"{where}: minimaps is a list of the shown minimaps, each an id or {{ id: {{ exclude: [cells] }} }}, never the cells they light"
        )
    if declared and len(declared) != 3:
        raise DeclarationError(f"{where}: minimaps names exactly three views of: {', '.join(allowed)}; it names {len(declared)}")
    out["minimaps"] = []
    for shown in declared:
        if isinstance(shown, dict):
            if len(shown) != 1:
                raise DeclarationError(f"{where}: minimaps lists an entry of {len(shown)} keys; each entry is one id")
            ((view, inputs),) = shown.items()
            inputs = inputs or {}
            if not isinstance(inputs, dict) or set(inputs) - {"exclude"}:
                raise DeclarationError(f"{where}: minimaps.{view} takes only exclude:, a list of the lit cells its author rejects")
            exclude = inputs.get("exclude") or []
            if not isinstance(exclude, list) or not all(isinstance(c, str) and c.strip() for c in exclude):
                raise DeclarationError(f"{where}: minimaps.{view} exclude: is a list of cells, each its axis values joined by /")
            if len(set(exclude)) != len(exclude):
                raise DeclarationError(f"{where}: minimaps.{view} excludes a cell twice")
        else:
            view, exclude = shown, []
        if view not in allowed:
            choices(f"{where}: minimap view", view, allowed)
        if str(view) in shown_minimaps(out["minimaps"]):
            raise DeclarationError(f"{where}: minimaps names '{view}' twice")
        out["minimaps"].append({str(view): {"exclude": [str(c) for c in exclude]}} if exclude else str(view))
    # What the diagram is about: the lens it is drawn through and the ADR codes every minimap is computed from, each checked against
    # the ADR registry.
    about = {"lens": lens, **{key: [str(v) for v in (about_raw.get(key) or [])] for key in minimaps.ABOUT_KEYS}}
    for problem in minimaps.problems(about):
        raise DeclarationError(f"{where}: {problem}")
    out["adrs"] = about["adrs"]
    if out["zoom"] is not None:
        about["zoom"] = out["zoom"]
    if out["point"] is not None:
        about["point"] = out["point"]
    # An action diagram's proof: the accosted file that holds every effect's observation, named relative to the repository root. The
    # drawing cannot carry it, so get leaves it out and save keeps the source's; Test-Diagrams is where it is required and proven.
    proves = about_raw.get("proves")
    if proves is not None and lens != ACTION_LENS:
        raise DeclarationError(f"{where}: about.proves names an action diagram's proof file; this diagram's lens is {lens}")
    if proves is not None:
        if not isinstance(proves, str) or not proves.strip():
            raise DeclarationError(f"{where}: about.proves is the repository path of a <name>.accosted.yml file")
        about["proves"] = proves.strip()
    for chip in out["chips"]:
        if chip["kind"] == "rule" and chip["rule"] not in about["adrs"]:
            choices(f"{where}: rule chip at '{chip['at']}' rule", chip["rule"], about["adrs"])
    layout = {}
    for cid, box in (raw.get("layout") or {}).items():
        if lens == ACTION_LENS and cid != "frame":  # the lens computes every place from ring and order; only the frame is pinned
            choices(f"{where}: layout cell (the action lens places every cell by ring and order)", cid, ("frame",))
        if cid not in ids:
            choices(f"{where}: layout cell", cid, tuple(ids))
        if not isinstance(box, dict) or set(box) != {"x", "y", "w", "h"}:
            raise DeclarationError(f"{where}: layout '{cid}' is a map of x, y, w and h")
        layout[cid] = {k: int(box[k]) for k in ("x", "y", "w", "h")}
    layout.update(query_layout)  # a query slide's lane layout pins its column and band; the source never holds it
    # What the diagram shows, in a sentence or two, for whoever meets it outside any article; no article is named here.
    description = " ".join(str(raw.get("description", "") or "").split())
    return {"description": description, "about": about, "content": out, "layout": layout}
