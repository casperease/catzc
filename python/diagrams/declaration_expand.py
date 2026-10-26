# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The shorthands a declaration expands before it is checked: the minimaps it shows, the cells a lane or a row stands for, and the end
and orientation of its edges."""

from declaration_constants import ACTION_LENS, COMMIT_STATES, EFFECT_KEYS, LANE_KEYS, LANE_SLOT, LANE_SLOTS, SHORTHAND, SOURCE_ONLY
from declaration_dump import entry
from declaration_vocabulary import DeclarationError, choices


def shown_minimaps(entries):
    """The ids of the shown minimaps, in order: each entry of content.minimaps is an id or { id: { exclude: [...] } }."""
    return [next(iter(entry)) if isinstance(entry, dict) else entry for entry in entries or []]


def undrawn(content, declared):
    """A content read back by get, with what the declared source says and its drawing does not show laid over it: the SOURCE_ONLY
    facts, the band order when the layout places every band, and the band of an item the layout places, which get can only guess
    from where it sits (put refuses a place inside another band)."""
    source, layout = declared["content"], declared["layout"]
    out = {**content, **{k: source[k] for k in SOURCE_ONLY}}
    # A ladder is a hint for the grid; the drawing carries only the places it gave, so the source keeps the hint.
    out.pop("ladders", None)
    if source.get("ladders"):
        out["ladders"] = source["ladders"]
        # A ladder routes its climbs itself, so the waypoints the drawing shows on them are the ladder's, never a hand's.
        for ladder in source["ladders"]:
            rungs = {g["id"] for g in source["glyphs"] if g["in"] == ladder["band"]}
            out["edges"] = [
                {k: v for k, v in e.items() if k != "via"} if e["from"] in rungs and e["to"] in rungs else e for e in out["edges"]
            ]
    # An action diagram's where and a used legend are read from the chips and the legend only as far as the drawing tells; the source
    # keeps its own words for both.
    for key in ("where", "legend"):
        if key in source and source["lens"] == ACTION_LENS:
            out[key] = source[key]
    rows = {s["id"]: s["row"] for s in source["spans"] if "row" in s}  # a span's row is its bar's height; the source says which it named
    if rows:
        out["spans"] = [{**s, "row": rows[s["id"]]} if s["id"] in rows else s for s in out["spans"]]
    if source["lens"] == ACTION_LENS:  # what a note's show: hid, its words or its call or observation, stays the source's
        hidden = {e["id"]: {k: v for k, v in e.items() if k in ("says", "proves", "call")} for e in source["effects"]}
        merged = [{**hidden.get(e["id"], {}), **e} for e in out.get("effects", [])]
        out["effects"] = [{k: e[k] for k in EFFECT_KEYS if k in e} for e in merged]
    # The drawing shows which minimaps but not what their author excludes: the source's entries stay while it shows the same three.
    if not content.get("minimaps") or shown_minimaps(content["minimaps"]) == shown_minimaps(source["minimaps"]):
        out["minimaps"] = source["minimaps"]
    if (
        source["bands"]
        and all(b["id"] in layout for b in source["bands"])
        and {b["id"] for b in source["bands"]} == {b["id"] for b in content["bands"]}
    ):
        out["bands"] = source["bands"]
    bands = {b["id"] for b in source["bands"]}
    held = {i["id"]: i["in"] for key in ("groups", "glyphs") for i in source.get(key) or [] if i["id"] in layout and i["in"] in bands}
    for key in ("groups", "glyphs"):
        out[key] = [{**i, "in": held[i["id"]]} if i["id"] in held and i.get("in") in bands else i for i in out.get(key) or []]
    return out


def drawn(content):
    """What a content draws, the same whether it was written with rows or read back from the drawing: its cells keyed by id, its
    edges as a set, and the rest as written."""
    out = {k: v for k, v in content.items() if k not in SHORTHAND + ("generated",)}
    for key in ("groups", "glyphs", "notes"):
        out[key] = {i["id"]: i for i in content.get(key) or []}
    out["spans"] = [
        {k: v for k, v in s.items() if k != "row"} for s in content.get("spans") or []
    ]  # a row is a bar's height, read back by undrawn
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
            commit = entry(
                raw,
                ("id", "step", "label"),
                where,
                "lane commit",
                optional={"row": 0, "slot": LANE_SLOT, "state": COMMIT_STATES[0], "from": ""},
            )
            if not commit["step"].isdigit() or not 1 <= int(commit["step"]) <= steps:
                raise DeclarationError(f"{where}: lane commit '{commit['id']}' step {commit['step']} is not one of 1 to {steps}")
            if commit["row"] not in ("-1", "0", "1"):
                choices(f"{where}: lane commit '{commit['id']}' row", commit["row"], ("-1", "0", "1"))
            if commit["slot"] not in LANE_SLOTS:
                choices(f"{where}: lane commit '{commit['id']}' slot", commit["slot"], LANE_SLOTS)
            glyphs.append(
                {
                    "id": commit["id"],
                    "kind": "commit",
                    "label": commit["label"],
                    "in": band,
                    **({"state": commit["state"]} if commit["state"] != COMMIT_STATES[0] else {}),
                }
            )
            if commit["from"]:
                edges.append({"from": commit["from"], "to": commit["id"], "kind": "flow"})
            generated.add(commit["id"])
        # Any other glyph a lane holds sits at a step too: a gate, an environment slot and the commits occupying it, a code unit.
        for raw in raw_lane.get("glyphs") or []:
            item = entry(raw, ("id", "step", "kind", "label"), where, "lane glyph", optional={"row": 0, "slot": LANE_SLOT})
            if not item["step"].isdigit() or not 1 <= int(item["step"]) <= steps:
                raise DeclarationError(f"{where}: lane glyph '{item['id']}' step {item['step']} is not one of 1 to {steps}")
            if item["row"] not in ("-1", "0", "1"):
                choices(f"{where}: lane glyph '{item['id']}' row", item["row"], ("-1", "0", "1"))
            if item["slot"] not in LANE_SLOTS:
                choices(f"{where}: lane glyph '{item['id']}' slot", item["slot"], LANE_SLOTS)
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
        row = entry(
            {k: v for k, v in raw_row.items() if k != "skip"} if isinstance(raw_row, dict) else raw_row,
            ("id", "template", "label", "in", "start", "steps"),
            where,
            "row",
        )
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
            glyphs.append(
                {"id": dot, "kind": "commit", "label": "x", "in": row["id"], **({"state": state} if state != COMMIT_STATES[0] else {})}
            )
            glyphs.append(
                {
                    "id": drop,
                    "kind": "commit",
                    "label": "x",
                    "in": row["id"],
                    **({"state": template["drop"]} if template["drop"] != COMMIT_STATES[0] else {}),
                }
            )
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
