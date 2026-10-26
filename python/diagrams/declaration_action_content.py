# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The action lens's content: a call line in its contract form wrapped and unwrapped at the kit's break characters, and the
zones, effects and cause of an action read into the cells the lens places."""

import re

import yaml

from . import normal_form
from .declaration_constants import (
    ACTION,
    ACTION_KEYS,
    ACTION_LENS,
    DEFAULT_SHOW,
    DEFAULT_WHERE,
    EFFECT_KEYS,
    PROOF_LENS,
    PROOF_SHOWN,
    SHOWS,
    WHERES,
)
from .declaration_dump import _flow, entry
from .declaration_vocabulary import DeclarationError, choices
from .drawio_png import DEFAULTS
from .kit_yaml import load_yaml


def contract_call(raw, where, what):
    """One command in the contract form (ADR-AUTO-ACCOSTED-COMMANDFORM): a mapping of one key, a command's name in the normal form, to
    its arguments, each one literal under its parameter's name; `name:` alone is a call without arguments. The kit checks the shape
    alone and runs nothing: Test-Diagrams proves the name and its arguments against the command contract (ADR-AUTO-ACCOSTED-ONEREADER)."""
    if isinstance(raw, str):
        raw = {raw: None}
    if not isinstance(raw, dict) or len(raw) != 1:
        raise DeclarationError(f"{where}: {what} is one command in the contract form, `name: {{ parameter: literal }}`")
    ((name, args),) = raw.items()
    if not normal_form.accepts(name):
        raise DeclarationError(
            f"{where}: {what} names '{name}'; a command's name is in the repository normal form, {normal_form.configured_case()}"
        )
    if args is None:
        args = {}
    if not isinstance(args, dict):
        raise DeclarationError(f"{where}: {what} '{name}' takes a map of parameter: literal")
    for parameter, value in args.items():
        if isinstance(value, (dict, list)) or value is None:
            raise DeclarationError(f"{where}: {what} '{name}' {parameter} is one literal, never a list, a map or empty")
    return {str(name): {str(k): v for k, v in args.items()}}


def call_line(call):
    """A contract-form command as the one line the drawing prints: `name: { parameter: literal }`, or the name alone."""
    ((name, args),) = call.items()
    return f"{name}: {_flow(args)}" if args else name


def break_chars(key):
    """The characters one wrap-break key of drawio.yml names, in order; the word `space` stands for the blank."""
    return tuple(" " if token == "space" else token for token in DEFAULTS["renderer"][key].split())


def break_class(chars):
    """The characters as the inside of a regular-expression class."""
    return "".join(re.escape(c) for c in chars)


WRAP_GLUED = break_chars("wrap-break-glued")  # break after these; unwrap rejoins with no space
WRAP_SPACED = break_chars("wrap-break-spaced")  # break after these; unwrap rejoins with one space
WRAP_LATE = break_chars("wrap-break-late")  # break after these only when a piece is still too long; unwrap rejoins with no space


def wrap_line(line, per):
    """A printed line wrapped to at most `per` characters a line at its natural breaks: after a `/`, a `,` or a space first, and only
    when a piece is still too long, after a `.` (a path such as `pwsh/Base.Contracts/accosted/contracts.accosted.yml` has no
    space to break at). The drawing prints the lines; get joins them back with unwrap_lines."""
    pieces = []
    first, late = break_class(WRAP_GLUED + WRAP_SPACED), break_class(WRAP_LATE)
    for piece in re.findall(rf"[^{first}]*[{first}]|[^{first}]+", line):
        pieces.extend(re.findall(rf"[^{late}]*[{late}]|[^{late}]+", piece) if len(piece) > per else [piece])
    # A `key: value` whose value is long starts the value on its own line, so a path reads as one value under its key rather than as
    # a tail broken off the key; a value is long when it would not fit beside its key in half a line.
    forced = set()
    for i, piece in enumerate(pieces):
        if piece.endswith(": "):
            value = 0
            for later in pieces[i + 1 :]:
                value += len(later.rstrip())
                if later.endswith((",", " ")):
                    break
            if value > per // 2:
                forced.add(i)
    lines, current = [], ""
    for i, piece in enumerate(pieces):
        if current and len(current) + len(piece.rstrip()) > per:
            lines.append(current.rstrip())
            current = ""
        current += piece
        if i in forced and current.strip():
            lines.append(current.rstrip())
            current = ""
    if current.strip():
        lines.append(current.rstrip())
    return lines or [""]


def unwrap_lines(text):
    """The one line a drawing's wrapped text prints: a line ending in `/` or `.` continues without a space, any other with one."""
    out = ""
    for line in text.split("\n"):
        line = line.strip()
        out += line if not out or out.endswith(WRAP_GLUED + WRAP_LATE) else " " + line
    return out


def parse_call(line):
    """The call a drawing's line prints, back in the contract form."""
    try:
        raw = load_yaml(unwrap_lines(line))
    except yaml.YAMLError as error:
        raise DeclarationError(f"get cannot read `{line}` as a contract-form call: {error}") from None
    return {raw: None} if isinstance(raw, str) else raw


def cause_sizes():
    """The named sizes of the cause's half-disc, each its radius, from drawio.yml action-lens cause-sizes: `name radius, ...`."""
    return {name: int(radius) for name, radius in (pair.split() for pair in str(ACTION["cause-sizes"]).split(","))}


def cause_radius(cause):
    """The radius the cause draws with: its written size, else the largest when its label ends in `!`, else the configured default."""
    sizes = cause_sizes()
    size = cause.get("size") or (
        max(sizes, key=lambda name: sizes[name]) if str(cause["label"]).rstrip().endswith("!") else str(ACTION["cause-size"])
    )
    return sizes[size]


def action_content(content, out, ids, where, lens=ACTION_LENS):
    """The action lens's content: its cause (the actor or trigger, in plain words), its action (one contract-form call, or a call site
    of several, drawn one row each) and its effects, each a note in a zone with its where chip and the observation that proves it; the
    proof lens takes the action alone."""
    for key in ("action",) if lens == PROOF_LENS else ACTION_KEYS:
        if key not in content:
            raise DeclarationError(f"{where}: the {lens} lens needs content.{key}")
    action_raw = content["action"]
    if not isinstance(action_raw, dict) or set(action_raw) not in ({"call"}, {"calls"}):
        raise DeclarationError(f"{where}: content.action is `call: <one command>` or `calls: [<commands>]`, never both or neither")
    if "call" in action_raw:
        action = {"call": contract_call(action_raw["call"], where, "action.call")}
    else:
        calls = action_raw["calls"]
        if not isinstance(calls, list) or len(calls) < 2:
            raise DeclarationError(f"{where}: content.action.calls is a call site of two or more commands; one command is `call:`")
        action = {"calls": [contract_call(c, where, f"action.calls[{n}]") for n, c in enumerate(calls)]}
    ids["action"] = "action"
    if lens == PROOF_LENS:
        out["action"] = action
        return
    # Whether the action diagram draws its Proof box; the default is declared once, and the key is kept only when it differs.
    proof = str(content.get("proof", "shown" if PROOF_SHOWN else "hidden"))
    if proof not in ("shown", "hidden"):
        choices(f"{where}: content.proof", proof, ("shown", "hidden"))
    if (proof == "shown") != PROOF_SHOWN:
        out["proof"] = proof
    # The cause's half-disc has a named size from the closed list in drawio.yml, the default when none is given; a label ending in `!`
    # takes the largest. The size is kept only when written, so the yml stays minimal and get gives it back the same way.
    cause = entry(content["cause"], ("label",), where, "cause", optional={"size": ""})
    sizes = cause_sizes()
    if cause["size"] and cause["size"] not in sizes:
        choices(f"{where}: cause size", cause["size"], tuple(sizes))
    if not cause["size"]:
        cause.pop("size")
    effects_raw = content["effects"]
    if not isinstance(effects_raw, list) or not effects_raw:
        raise DeclarationError(f"{where}: content.effects is a list of the action's effects, one or more")
    # The diagram's where: every effect's unless it says otherwise; kept only when it differs from the default declared once.
    diagram_where = str(content.get("where", DEFAULT_WHERE))
    if diagram_where not in WHERES:
        choices(f"{where}: content.where", diagram_where, WHERES)
    if diagram_where != DEFAULT_WHERE:
        out["where"] = diagram_where
    for cid in ("frame", "cause", "action"):
        ids[cid] = cid
    # An effect sits in a zone, the causal hop: zone 1 is what the action changes directly, zone 2 what those changes cause, and so on;
    # the effects of one zone ran in parallel. An effect follows the action, or, with after:, an effect declared before it in its own
    # zone or an inner one: an effect only goes forward. The declared order is the story's order, numbered on the drawing.
    effects = []
    for raw in effects_raw:
        # An effect is a state change (says, and the observation that proves it) or an execution (call, a further contracted command
        # the story triggers, with optional words); the edge into it says which: effects for a state change, affects for an execution.
        execution = isinstance(raw, dict) and "call" in raw
        keys = ("id", "zone", "call") if execution else ("id", "zone", "says", "proves")
        if where == "the drawing":  # a note shows only what its show: says; get cannot read the rest, and save keeps the source's
            keys = ("id", "zone")
        optional = {"where": "", "show": "", "after": "", **({k: "" for k in ("says", "proves", "call") if k not in keys})}
        effect = entry(raw, keys, where, "effect", optional=optional)
        if effect["id"] in ids:
            raise DeclarationError(f"{where}: id '{effect['id']}' is used twice")
        if not str(effect["zone"]).isdigit() or int(effect["zone"]) < 1:
            raise DeclarationError(f"{where}: effect '{effect['id']}' zone is the causal hop, 1 or more; it is {effect['zone']}")
        effect["zone"] = int(effect["zone"])
        # An effect's where is the diagram's unless it says otherwise, and the key is kept only where it differs, as its chip is drawn.
        if effect["where"] and effect["where"] not in WHERES:
            choices(f"{where}: effect '{effect['id']}' where", effect["where"], WHERES)
        if not effect["where"] or effect["where"] == diagram_where:
            effect.pop("where")
        # What the note prints; the default is declared once, and the key is kept only where it differs.
        if effect["show"] and effect["show"] not in SHOWS:
            choices(f"{where}: effect '{effect['id']}' show", effect["show"], SHOWS)
        if not effect["show"] or effect["show"] == DEFAULT_SHOW:
            effect.pop("show")
        if effect.get("show") == "words" and not str(effect.get("says", "")).strip():
            raise DeclarationError(f"{where}: effect '{effect['id']}' shows words alone but says nothing")
        if where == "the drawing":  # whatever the note printed; the source keeps what its show: hid
            for key in ("call", "proves"):
                if raw.get(key) is not None:
                    effect[key] = contract_call(raw[key], where, f"effect '{effect['id']}' {key}")
                else:
                    effect.pop(key, None)
            if not str(effect.get("says", "")).strip():
                effect.pop("says", None)
        elif execution:
            effect["call"] = contract_call(raw.get("call"), where, f"effect '{effect['id']}' call")
            if not effect["says"].strip():
                effect.pop("says")
        else:
            if not effect["says"].strip():
                raise DeclarationError(f"{where}: effect '{effect['id']}' says nothing; says is the state it changes, in plain words")
            effect["proves"] = contract_call(raw.get("proves"), where, f"effect '{effect['id']}' proves")
        effect = {k: effect[k] for k in EFFECT_KEYS if k in effect and effect[k] != ""}  # an optional key left empty is absent
        after = effect.pop("after", "")
        if after:
            earlier = next((e for e in effects if e["id"] == after), None)
            if earlier is None:
                choices(f"{where}: effect '{effect['id']}' after (an effect declared before it)", after, [e["id"] for e in effects])
            if earlier["zone"] > effect["zone"]:
                raise DeclarationError(
                    f"{where}: effect '{effect['id']}' in zone {effect['zone']} comes after '{after}' in zone {earlier['zone']}; "
                    "an effect only goes forward, to its own zone or an outer one"
                )
            effect["after"] = after
        ids[effect["id"]] = "effect"
        effects.append(effect)
    zones = sorted({e["zone"] for e in effects})
    if zones != list(range(1, len(zones) + 1)):
        raise DeclarationError(f"{where}: the zones are the causal hops 1, 2, …, each with an effect; the effects name {zones}")
    # The canonical order is by zone, then as declared: the story's order, which the drawing numbers.
    out["cause"], out["action"], out["effects"] = cause, action, sorted(effects, key=lambda e: e["zone"])
