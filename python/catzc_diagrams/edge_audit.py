# cspell:ignore drsonly callsite
"""Read-only audit of every declared edge against the arrow rule (DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON).

It reads each declaration of the repository (the diagrams under `docs/**/.assets/`), normalised where the declaration is valid and as
written otherwise, and judges every edge. It writes nothing but its two reports and changes no declaration and no rule.

The rank table, the kind-pair default labels and the folders left out (`edge-rank`, `edge-defaults` and `edge-rules` of drawio.yml) are
read from edge_rules, the one source declaration.py reads too. An edge whose label is declared in `edge-labels` is ok by definition: the
label's initiating end fixes its direction. Any other edge, unlabelled or with free text, is oriented by the rank of its two ends: the
tail must rank below the head; a tail above the head is `reverse`, two ends of one rank are `ambiguous` (between two code blocks it
needs `calls`, an actor or a decision), an end of a trusted kind (a gate) keeps its declared direction as `declared`, and an end at no
rank is `not-judged`. An edge of a state diagram (`states: true`, the rule's declared opt-out) is `excused`, needing no edit. An edge of
any other diagram with its own `relation` is audited like any other and also listed as `relation-opt-out`. The
labels are read as the author wrote them, so a label the kit derives from the kind pair is not counted as one.

usage (repo root):
  uv run --no-sync --project python python python/catzc_diagrams/edge_audit.py [--out out] [--stem <name-substring>] [--crossings]
prints the table and writes <out>/edge-audit.md and <out>/edge-audit.csv.
"""

import csv
import math
import sys
from collections import Counter
from pathlib import Path

import declaration
import edge_rules
import yaml

REPO = Path(__file__).resolve().parents[2]


def stems(root=REPO, needle=""):
    return sorted(
        png.with_name(png.name[: -len(".drawio.png")])
        for png in (root / "docs").rglob("*.drawio.png")
        if needle in png.name and ".assets" in png.parts
    )


def raw_of(stem):
    """The diagram's declaration: normalised when valid, else as written; with whether it had to fall back."""
    text, where = declaration.read_source(stem)
    raw = yaml.safe_load(text) or {}
    try:
        return declaration.normalise(raw, where=str(where)), False
    except declaration.DeclarationError:
        return raw, True


def kind_of(content, ident):
    for key, kind in (("glyphs", None), ("groups", "group"), ("bands", "band")):
        for item in content.get(key) or []:
            if item.get("id") == ident:
                return kind or item.get("kind", "?")
    return "?"


HEAD_REACH = 12  # px from a line's end that an arrowhead covers


def hidden_crossings(routes):
    """The pairs of routes that cross where the crossing hides an arrowhead (within HEAD_REACH of either line's end) or a pill (inside the
    other's pill rectangle): informational, a crossing elsewhere hides nothing and is not counted."""
    found = []
    for i, first in enumerate(routes):
        for second in routes[i + 1 :]:
            for p, q in zip(first["points"], first["points"][1:]):
                for a, b in zip(second["points"], second["points"][1:]):
                    point = declaration.cross_segment(p, q, a, b)
                    if point is None:
                        continue
                    near_head = any(
                        math.hypot(point[0] - end[0], point[1] - end[1]) <= HEAD_REACH
                        for end in (first["points"][-1], second["points"][-1])
                    )
                    in_pill = any(
                        r["pill"]
                        and r["pill"][0] <= point[0] <= r["pill"][0] + r["pill"][2]
                        and r["pill"][1] <= point[1] <= r["pill"][1] + r["pill"][3]
                        for r in (first, second)
                    )
                    if near_head or in_pill:
                        found.append((first["from"], first["to"], second["from"], second["to"]))
    return found


def written_edges(stem):
    """The edges as the author wrote them, before the kit derives any label or orientation."""
    text, _ = declaration.read_source(stem)
    return [e for e in ((yaml.safe_load(text) or {}).get("content") or {}).get("edges") or [] if isinstance(e, dict)]


def audit(root=REPO, needle=""):
    labels = declaration.EDGE_LABELS
    rows, fallbacks, undeclared = [], 0, 0
    for stem in stems(root, needle):
        if not declaration.declared(stem):
            undeclared += 1
            continue
        try:
            decl, fell = raw_of(stem)
        except (declaration.DeclarationError, OSError, yaml.YAMLError):
            undeclared += 1
            continue
        fallbacks += fell
        content = decl.get("content") or {}
        name = stem.relative_to(root / "docs").as_posix() if stem.is_relative_to(root / "docs") else stem.as_posix()
        relation = str(content.get("relation", "") or "").strip()
        written = {}
        for e in written_edges(stem):  # in declared order, so two edges between one pair keep their own labels
            written.setdefault((e.get("from"), e.get("to"), e.get("kind", "flow")), []).append(e.get("label", "") or "")
        for edge in content.get("edges") or []:
            held = written.get((edge["from"], edge["to"], edge.get("kind", "flow")), [])
            edge = {**edge, "label": held.pop(0) if held else ""}
            tail_kind, head_kind = kind_of(content, edge["from"]), kind_of(content, edge["to"])
            word = edge_rules.judge(tail_kind, head_kind, edge["label"], edge.get("kind", "flow"), labels)
            if content.get("states") is True:  # a state diagram's arrows are its own transitions, the rule's declared opt-out
                word = "excused"
            default = ""
            if word == "ok" and not edge["label"] and edge.get("kind", "flow") == "flow":
                default = edge_rules.default_label(tail_kind, head_kind)
            rows.append(
                {
                    "stem": name,
                    "from": edge["from"],
                    "tail_kind": tail_kind,
                    "to": edge["to"],
                    "head_kind": head_kind,
                    "edge_kind": edge.get("kind", "flow"),
                    "label": edge.get("label", "") or "",
                    "relation": relation,
                    "verdict": word,
                    "default_label": default,
                    "relation_opt_out": bool(relation and not edge.get("label")),
                }
            )
    return rows, {"fallbacks": fallbacks, "undeclared": undeclared}


def summary(rows, extra):
    by_verdict = Counter(r["verdict"] for r in rows)
    needing = Counter(r["stem"] for r in rows if r["verdict"] in ("reverse", "ambiguous"))
    diagrams = len({r["stem"] for r in rows})
    unlabelled_ok = [r for r in rows if r["verdict"] == "ok" and not r["label"] and r["edge_kind"] not in edge_rules.EDGE_KIND_LABEL]
    derived = [r for r in unlabelled_ok if r["default_label"]]
    lines = [
        "# Edge audit",
        "",
        f"{len(rows)} edges in {diagrams} diagrams with edges ({extra['fallbacks']} read as written because they do not validate, "
        f"{extra['undeclared']} without a declaration). Read-only: no declaration and no rule is changed."
        + (
            f" Crossings that hide an arrowhead or a pill (informational): {extra['hidden_crossings']}."
            if "hidden_crossings" in extra
            else ""
        ),
        "",
        "## Verdicts",
        "",
        *[f"- {name}: {count}" for name, count in sorted(by_verdict.items(), key=lambda kv: -kv[1])],
        (
            f"- relation-opt-out (an unlabelled edge of a diagram with its own `relation`, also counted above): "
            f"{sum(r['relation_opt_out'] for r in rows)}"
        ),
        "",
        "## Diagrams with the most edges needing work (reverse, ambiguous)",
        "",
        "| diagram | edges needing work |",
        "| --- | --- |",
        *[f"| {stem} | {count} |" for stem, count in needing.most_common(20)],
        "",
        "## Rank table and defaults the audit judged by",
        "",
        "Rank of an end, the lower acting on the higher (drawio.yml `edge-rank`): "
        + ", then ".join(f"{name} ({', '.join(k for k, r in edge_rules.KIND_RANK.items() if r == name)})" for name in edge_rules.RANKS)
        + f". Trusted kinds keep their declared direction: {', '.join(edge_rules.TRUSTED_KINDS)}.",
        "",
        "| tail to head (drawio.yml `edge-defaults`) | default label |",
        "| --- | --- |",
        *[f"| {tail} to {head} | {label} |" for (tail, head), label in edge_rules.DEFAULT_LABELS.items()],
        "",
        (
            f"Edges needing no edit: {len([r for r in rows if r['verdict'] == 'ok'])} of {len(rows)} are ok today "
            f"({len(derived)} unlabelled ones would also show a derived default label, {len(unlabelled_ok) - len(derived)} stay plain); "
            f"{sum(by_verdict[v] for v in ('reverse', 'ambiguous'))} need an edit."
        ),
    ]
    return lines


FIELDS = ["stem", "from", "tail_kind", "to", "head_kind", "edge_kind", "label", "relation", "verdict", "default_label", "relation_opt_out"]


def table_line(r):
    opt = " relation-opt-out" if r["relation_opt_out"] else ""
    return (
        f"{r['stem']} | {r['from']} ({r['tail_kind']}) -> {r['to']} ({r['head_kind']}) | label={r['label'] or '-'} "
        f"| relation={r['relation'] or '-'} | {r['verdict']}{opt}"
    )


def write_reports(rows, extra, out):
    out.mkdir(parents=True, exist_ok=True)
    lines = summary(rows, extra)
    (out / "edge-audit.md").write_text(
        "\n".join(
            lines
            + ["", "## Edges", "", "| stem | edge | label | relation | verdict |", "| --- | --- | --- | --- | --- |"]
            + [f"| {table_line(r)} |" for r in rows]
        )
        + "\n",
        encoding="utf-8",
    )
    with (out / "edge-audit.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, FIELDS)
        writer.writeheader()
        writer.writerows(rows)
    return lines


def main(argv=None):
    args = list(sys.argv[1:] if argv is None else argv)
    out = Path(args[args.index("--out") + 1]) if "--out" in args else REPO / "out"
    needle = args[args.index("--stem") + 1] if "--stem" in args else ""
    rows, extra = audit(REPO, needle)
    if "--crossings" in args:  # informational: crossings that hide an arrowhead or a pill, put in memory, nothing written under docs/
        hidden = 0
        for stem in stems(REPO, needle):
            if declaration.declared(stem):
                try:
                    declaration.put(declaration.with_data(stem, declaration.load(stem)))
                except (declaration.DeclarationError, OSError, ValueError):
                    continue
                hidden += len(hidden_crossings(declaration.LAST_ROUTES))
        extra["hidden_crossings"] = hidden
    lines = write_reports(rows, extra, out)
    for r in rows:
        print(table_line(r))
    print()
    print("\n".join(lines))


if __name__ == "__main__":
    main()
