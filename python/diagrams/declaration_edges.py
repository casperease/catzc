# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The edges of a declaration read as words: the ends an edge kind joins, the word an edge carries, and the edges oriented and judged
against the rules of edge-semantics."""

import re

import edge_rules
from declaration_vocabulary import EDGE_LABELS, EDGE_SEMANTICS, DeclarationError


def end_kinds(out):
    """The glyph kind of every glyph an edge may end at, and `group` for a group."""
    return {**{g["id"]: "group" for g in out.get("groups", [])}, **{g["id"]: g["kind"] for g in out.get("glyphs", [])}}


EDGE_COUNT = re.compile(r"(\d+)/(\d+)")


def edge_word(edge):
    """The word an edge's pill carries: its label, then its count (`calls 13/28`)."""
    return " ".join(part for part in (edge.get("label", ""), edge.get("count", "")) if part)


def between_edge(e, out, where):
    """An edge declared minimally as `between: [a, b]`: oriented by the rank of its two ends, the lower acting on the higher, so it
    becomes `from` the lower and `to` the higher; ends of one rank, or of a trusted or unranked kind, are declared with from and to."""
    ends = e["between"]
    if not isinstance(ends, list) or len(ends) != 2:
        raise DeclarationError(f"{where}: edge between is a list of two cells, `between: [a, b]`")
    kinds = end_kinds(out)
    ranks = [edge_rules.rank_of(kinds.get(end)) for end in ends]
    if None in ranks or ranks[0] == ranks[1] or any(kinds.get(end) in edge_rules.TRUSTED_KINDS for end in ends):
        raise DeclarationError(
            f"{where}: edge between {ends[0]} and {ends[1]} has no direction by rank (equal, unranked or trusted kinds); "
            f"declare it with from and to (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON)"
        )
    first_rank, second_rank = ranks
    assert first_rank is not None and second_rank is not None  # an unranked end raised above
    low, high = (ends[0], ends[1]) if first_rank < second_rank else (ends[1], ends[0])
    return {**{k: v for k, v in e.items() if k != "between"}, "from": low, "to": high}


def relation_pairing(out, where):
    """A diagram's own `relation` and `states: true` come together (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON): only a state diagram, whose
    arrows are steps of one thing between states, gives its plain arrows another single meaning, and a state diagram names it."""
    relation, states = out.get("relation", ""), out.get("states", False)
    if relation and not states:
        raise DeclarationError(
            f"{where}: content.relation '{relation}' is only for a state diagram; declare states: true if the arrows are steps of one thing "
            f"between states, or drop the relation and label the arrows (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON)"
        )
    if states and not relation:
        raise DeclarationError(
            f"{where}: content.states is true but names no relation; a state diagram says what its arrows mean in its relation "
            f"(DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON)"
        )


def orient_edges(out, content, where):
    """The rank of an edge's ends against its direction (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON): a flow edge that carries no label of
    the arrow vocabulary runs from the lower rank to the higher, so one declared against its rank is refused naming the edge, and one
    declared with it and no label takes its kind pair's default label. A diagram with its own `relation` is left as it is."""
    if str(content.get("relation", "") or "").strip():
        return
    kinds = end_kinds(out)
    for e in out.get("edges", []):
        if e["kind"] not in ("flow", "thick") or e["label"] in EDGE_LABELS:
            continue
        verdict = edge_rules.judge(kinds.get(e["from"]), kinds.get(e["to"]), e["label"], e["kind"], tuple(EDGE_LABELS))
        if verdict == "reverse":
            raise DeclarationError(
                f"{where}: edge {e['from']} -> {e['to']} runs against its rank ({kinds[e['from']]} ranks above {kinds[e['to']]}, and the "
                f"lower rank acts on the higher); swap its ends, or label it one of {', '.join(EDGE_LABELS)} (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON)"
            )
        if verdict == "ok" and not e["label"] and e["kind"] == "flow" and kinds.get(e["from"]) not in edge_rules.TRUSTED_KINDS:
            e["label"] = edge_rules.default_label(kinds.get(e["from"]), kinds.get(e["to"]))


def edge_semantics_findings(out, content, where):
    """The default meaning of an edge (drawio.yml edge-semantics, DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON): the tail initiates and the
    head receives, so a plain arrow ends on a code block only from an actor, which is an author or a trigger, or labelled as a call. A
    diagram that declares its own `relation` gives its plain arrows another single meaning and is not judged here."""
    if str(content.get("relation", "") or "").strip():
        return
    kinds = {g["id"]: g["kind"] for g in out.get("glyphs", [])}
    for e in out.get("edges", []):
        if e["kind"] != "flow" or kinds.get(e["to"]) not in EDGE_SEMANTICS["code-kinds"]:
            continue
        if kinds.get(e["from"]) == "actor" or e["label"] in EDGE_SEMANTICS["code-head-labels"]:
            continue
        raise DeclarationError(
            f"{where}: edge {e['from']} -> {e['to']} ends on a code block ({e['to']}), which only an actor writes or a call reaches; start it at an "
            f"actor or label it one of {', '.join(EDGE_SEMANTICS['code-head-labels'])} (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON)"
        )
