"""The arrow rule's rank table and kind-pair defaults, read once from the kit's drawio.yml (DDR-VISUAL-ARROWSPOINTATDEPENDENCY).

`edge-rank` lists, lowest first, each rank and the glyph kinds standing at it: the lower rank acts on the higher, so an edge between
two cells of different rank runs from the lower to the higher. `edge-defaults` names the label such a pair carries when it declares
none, by kind or by rank name (`<tail>><head>`, the most specific of kind or rank on either end wins). `edge-rules` holds the kinds
whose edges keep their declared direction (`trusted-kinds`). declaration.py
reads this module to orient and label an edge, and edge_audit.py reads it to judge one: there is no second copy.
"""

from .drawio_png import DEFAULTS


class RuleError(ValueError):
    """A key of the edge rules outside its vocabulary, naming the key."""


RANKS = tuple(DEFAULTS["edge-rank"])  # the rank names, lowest first
KIND_RANK = {kind: name for name, kinds in DEFAULTS["edge-rank"].items() for kind in kinds.replace(",", " ").split()}
DEFAULT_LABELS = {tuple(pair.split(">")): label for pair, label in DEFAULTS["edge-defaults"].items()}
TRUSTED_KINDS = tuple(DEFAULTS["edge-rules"]["trusted-kinds"].replace(",", " ").split())
EDGE_KIND_LABEL = {"read": "reads", "fail": "failed", "junction": "junction"}  # an edge kind that already says its meaning
NOT_ARROWS = ("record", "bypass")  # a DRS link and a ladder bypass join no actor, code or file


def validate(glyph_kinds, edge_labels):
    """Every key of the rules against the kit's vocabularies, or a RuleError naming the key."""
    seen = {}
    for name, kinds in DEFAULTS["edge-rank"].items():
        for kind in kinds.replace(",", " ").split():
            if kind not in glyph_kinds:
                raise RuleError(f"drawio.yml edge-rank {name}: '{kind}' is not a glyph kind; one of: {', '.join(glyph_kinds)}")
            if kind in seen:
                raise RuleError(f"drawio.yml edge-rank {name}: '{kind}' already stands at rank '{seen[kind]}'")
            seen[kind] = name
    for pair, label in DEFAULTS["edge-defaults"].items():
        ends = pair.split(">")
        if len(ends) != 2 or any(end not in glyph_kinds and end not in RANKS for end in ends):
            raise RuleError(f"drawio.yml edge-defaults '{pair}': write `<tail>><head>`, each a glyph kind or a rank name ({', '.join(RANKS)})")
        if label not in edge_labels:
            raise RuleError(f"drawio.yml edge-defaults '{pair}': '{label}' is not an edge label; one of: {', '.join(edge_labels)}")
    for kind in TRUSTED_KINDS:
        if kind not in glyph_kinds:
            raise RuleError(f"drawio.yml edge-rules trusted-kinds: '{kind}' is not a glyph kind; one of: {', '.join(glyph_kinds)}")


def rank_of(kind):
    """The index of a glyph kind's rank, lowest acting, or None for a kind that stands at no rank."""
    name = KIND_RANK.get(kind)
    return RANKS.index(name) if name else None


def default_label(tail_kind, head_kind):
    """The label a pair of kinds carries when its edge declares none: by kind or by rank on either end, kind before rank."""
    tails = (tail_kind, KIND_RANK.get(tail_kind))
    heads = (head_kind, KIND_RANK.get(head_kind))
    for tail in tails:
        for head in heads:
            if tail and head and (tail, head) in DEFAULT_LABELS:
                return DEFAULT_LABELS[(tail, head)]
    return ""


def judge(tail_kind, head_kind, label, edge_kind, edge_labels):
    """One edge's verdict, by the rule: a label declared in `edge-labels` fixes the direction (ok, never judged against rank); any other
    edge is oriented by rank: `reverse` when the tail ranks above the head, `ambiguous` when both stand at one rank, `declared` when an
    end is a trusted kind (the declared direction stands), `not-judged` when an end stands at no rank, else ok."""
    if edge_kind in NOT_ARROWS:
        return "not-judged"
    if (label or EDGE_KIND_LABEL.get(edge_kind, "")) in set(edge_labels) | set(EDGE_KIND_LABEL.values()):
        return "ok"
    if tail_kind in TRUSTED_KINDS or head_kind in TRUSTED_KINDS:
        return "declared"
    tail, head = rank_of(tail_kind), rank_of(head_kind)
    if tail is None or head is None:
        return "not-judged"
    return "reverse" if tail > head else "ambiguous" if tail == head else "ok"


