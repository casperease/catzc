# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The get direction of the action and proof lenses: the cells of a drawing read back into their content."""

import re

from .declaration_action_content import cause_radius, cause_sizes, parse_call
from .declaration_constants import ACTION_LENS, KINDS, PROOF_LENS, PROOF_SHOWN, SIDEBAR
from .declaration_normalise import normalise
from .declaration_read import matches, signature
from .declaration_vocabulary import LIB, DeclarationError
from .drawio_png import DEFAULTS, plain


def cause_read(label, radius):
    """A drawn cause back in the yml: its label, and its size only when the drawn radius names one the label alone would not give."""
    sizes = cause_sizes()
    nearest = min(sizes, key=lambda name: abs(sizes[name] - radius))
    cause = {"label": label}
    if sizes[nearest] != cause_radius(cause):
        cause["size"] = nearest
    return cause


def proof_action(cells):
    """The action a drawing's Proof box states: its cats rows, in order, each the normalized statement after the word cats."""
    rows = sorted((cid for cid in cells if re.fullmatch(r"proof-\d+-cats", cid)), key=lambda cid: int(cid.split("-")[1]))
    calls = [parse_call(plain(cells[cid].get("value")).split(None, 1)[1]) for cid in rows]
    return {"calls": calls} if len(calls) > 1 else {"call": calls[0]}


def get_proof(cells, kind):
    """The proof lens read back: the title and ADR codes from the chrome, and the action from the Proof box's cats rows."""
    value = lambda cid: plain(cells[cid].get("value"))
    if not any(re.fullmatch(r"proof-\d+-cats", cid) for cid in cells):
        raise DeclarationError("get needs the Proof box's cats rows in a proof drawing; none is drawn")
    content = {
        "title": value("title") if "title" in cells else "",
        "kind": kind or KINDS[0],
        "theme": next(iter(DEFAULTS["themes"])),
        "action": proof_action(cells),
        "minimaps": [value(cid) for cid, _, _ in SIDEBAR if cid in cells],
    }
    adrs = [p.strip() for p in value("subtitle").split("·") if p.strip()] if "subtitle" in cells else []
    return normalise({"about": {"rules": adrs, "lens": PROOF_LENS}, "content": content}, where="the drawing")


def get_action(cells, geo, glyph_sigs, kind):
    """The action lens read back: the title and ADR codes from the chrome, the cause's label, the action's call or its call site's rows,
    and each effect's note with its where chip and its proof line; an effect's ring is read from its distance to the action's centre
    and its order from its angle, top to bottom, so a moved note folds back to a ring and an order, never to coordinates."""
    value = lambda cid: plain(cells[cid].get("value"))
    styled = lambda k: [
        cid for cid, c in cells.items() if not cid.startswith(("lg-", "proof")) and matches(glyph_sigs[k], c.get("style") or "")
    ]
    causes = styled("cause")
    actions = list(dict.fromkeys(styled("action") + styled("callsite")))  # the statement: the pill or the call site, one of them
    if len(causes) != 1 or len(actions) != 1:
        raise DeclarationError("get needs one cause and one action or call site in an action drawing")
    action_id = actions[0]
    rows = sorted((cid for cid, c in cells.items() if c.get("parent") == action_id), key=lambda m: geo[m]["y"])
    action = {"calls": [parse_call(value(m)) for m in rows]} if rows else {"call": parse_call(value(action_id))}
    cause, statement = geo[causes[0]], geo[action_id]
    cx, cy = cause["x"], statement["y"] + statement["h"] / 2  # the rings' centre: on the rim, at the statement's height
    # The rings as drawn, each its radii; a note's zone is the first ring its centre lies inside, by the ellipse's own measure.
    rings = sorted(((geo[cid]["w"] / 2, geo[cid]["h"] / 2) for cid in styled("ring")), key=lambda rr: rr[0])
    if not rings:
        raise DeclarationError("get needs the rings of an action drawing; none is drawn")
    # The story's numbers: each marker numbers the box whose top-left corner it sits on; a moved box keeps its number.
    mark_sig = signature(LIB["marks"]["marker"]["style"])
    marks = [(int(value(cid)), geo[cid]) for cid, c in cells.items() if matches(mark_sig, c.get("style") or "") and value(cid).isdigit()]
    number_of = lambda box: min(
        (abs(m["x"] - (box["x"] - 10)) + abs(m["y"] - (box["y"] - 11)), n) for n, m in marks or [(0, {"x": 0, "y": 0})]
    )[1]
    # An effect's direct cause: the source of the edge into it, when that is another effect.
    after_of = {
        c.get("target"): c.get("source")
        for cid, c in cells.items()
        if c.get("edge") == "1" and not cid.startswith(("lg-", "actor-")) and c.get("source") not in ("cause", "action")
    }
    # An execution is drawn as a command row outside the call site; a state change as a note. Either prints its bold words first.
    member_sig = signature(LIB["glyphs"]["callsite"]["member"]["style"])
    executions = [
        cid
        for cid, c in cells.items()
        if c.get("parent") == "1" and not cid.startswith(("lg-", "proof")) and matches(member_sig, c.get("style") or "")
    ]
    effects = []
    for cid in styled("effect") + executions:
        b = geo[cid]
        px, py = b["x"] + b["w"] / 2 - cx, b["y"] + b["h"] / 2 - cy
        drawn = cells[cid].get("value") or ""
        head, _, body = drawn.partition("</b>") if drawn.startswith("<b>") else ("", "", drawn)
        says, line = plain(head), plain(body)
        k = next((k for k, (r, ry) in enumerate(rings, 1) if (px / r) ** 2 + (py / ry) ** 2 <= 1), len(rings))
        effect = {"id": cid, "zone": k}
        if f"{cid}-tag" in cells:  # a chip says the effect's where differs from the diagram's; none says it is the diagram's
            effect["where"] = value(f"{cid}-tag")
        if says and not line:
            effect["show"] = "words"
        elif line and not says:
            effect["show"] = "call"
        if says:
            effect["says"] = says
        if line:
            effect["call" if cid in executions else "proves"] = parse_call(line)
        if cid in after_of:
            effect["after"] = after_of[cid]
        effects.append((k, number_of(b), effect))
    content = {
        "title": value("title") if "title" in cells else "",
        "kind": kind or KINDS[0],
        "theme": next(iter(DEFAULTS["themes"])),
        "cause": cause_read(value(causes[0]), geo[causes[0]]["h"] / 2),
        "action": action,
        "effects": [e for _, _, e in sorted(effects, key=lambda t: t[:2])],
        "minimaps": [value(cid) for cid, _, _ in SIDEBAR if cid in cells],
    }
    if ("proof" in cells) != PROOF_SHOWN:  # the Proof box is drawn or not; the key is kept only where it differs from the default
        content["proof"] = "shown" if "proof" in cells else "hidden"
    adrs = [p.strip() for p in value("subtitle").split("·") if p.strip()] if "subtitle" in cells else []
    return normalise({"about": {"rules": adrs, "lens": ACTION_LENS}, "content": content}, where="the drawing")
