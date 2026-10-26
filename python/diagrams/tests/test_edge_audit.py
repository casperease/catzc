"""The edge audit judges every declared edge by the arrow rule and writes only its two reports, on neutral widget and gadget fixtures."""

import csv

from catzc.diagrams import edge_audit

HEAD = """
about:
  lens: architecture
content:
  title: Widgets
  flow: left-to-right
  {relation}
  bands:
    - {{ id: band-a, label: Widgets }}
  glyphs:
    - {{ id: widget-actor, kind: actor, label: Author, in: band-a }}
    - {{ id: widget-a, kind: code, label: Widget A, in: band-a }}
    - {{ id: widget-b, kind: code, label: Widget B, in: band-a }}
    - {{ id: widget-gate, kind: gate, label: Gate, in: band-a }}
    - {{ id: gadget-file, kind: file, label: gadget.yml, in: band-a }}
    - {{ id: gadget-store, kind: store, label: Gadget store, in: band-a }}
    - {{ id: gadget-result, kind: result, label: Result, in: band-a }}
    - {{ id: gadget-failure, kind: failure, label: Failure, in: band-a }}
  edges:
{edges}
"""


def make(root, name, edges, relation=""):
    folder = root / "docs" / "widgets" / ".assets"
    folder.mkdir(parents=True, exist_ok=True)
    (folder / f"{name}.drawio.png").write_bytes(b"")
    body = "\n".join(f"    - {{ from: {a}, to: {b}, kind: flow, label: {label} }}" for a, b, label in edges)
    (folder / f"{name}.drawio.yml").write_text(HEAD.format(relation=relation, edges=body), encoding="utf-8")


def verdicts(rows):
    return {(r["from"], r["to"], r["label"]): r["verdict"] for r in rows}


def test_each_edge_gets_its_verdict_by_label_and_by_the_rank_of_its_ends(tmp_path):
    make(
        tmp_path,
        "widget-flow",
        [
            ("widget-actor", "widget-a", '""'),  # an actor acts on code
            ("widget-a", "gadget-file", '""'),  # code acts on a file
            ("gadget-file", "widget-a", '""'),  # a file never acts on code
            ("widget-a", "widget-b", '""'),  # two code blocks
            ("widget-a", "widget-b", "calls"),
            ("widget-a", "gadget-store", "writes"),
            ("widget-a", "gadget-result", "sorts"),
        ],
    )
    rows, extra = edge_audit.audit(tmp_path)
    got = verdicts(rows)
    assert got[("widget-actor", "widget-a", "")] == "ok"
    assert got[("widget-a", "gadget-file", "")] == "ok"
    assert got[("gadget-file", "widget-a", "")] == "reverse"
    assert got[("widget-a", "widget-b", "")] == "ambiguous"
    assert got[("widget-a", "widget-b", "calls")] == "ok"
    assert got[("widget-a", "gadget-store", "writes")] == "ok"
    assert got[("widget-a", "gadget-result", "sorts")] == "ok"  # free text is not an arrow meaning: oriented by rank, and code acts on a result
    assert extra["fallbacks"] == 1  # the declaration breaks the rule, so it is read as written


def test_the_default_label_of_a_kind_pair_is_proposed_for_an_unlabelled_ok_edge(tmp_path):
    make(tmp_path, "widget-defaults", [("widget-a", "gadget-file", '""'), ("widget-a", "gadget-store", '""'), ("widget-a", "gadget-failure", '""')])
    rows, _ = edge_audit.audit(tmp_path)
    assert {r["to"]: r["default_label"] for r in rows} == {"gadget-file": "reads", "gadget-store": "writes", "gadget-failure": "failed"}


def test_an_edge_of_a_diagram_with_its_own_relation_is_judged_and_listed_as_an_opt_out(tmp_path):
    make(tmp_path, "widget-relation", [("gadget-file", "widget-a", '""'), ("widget-a", "gadget-file", "reads")], relation="relation: feeds")
    rows, _ = edge_audit.audit(tmp_path)
    plain = next(r for r in rows if not r["label"])
    assert plain["verdict"] == "reverse" and plain["relation_opt_out"] and plain["relation"] == "feeds"
    assert not next(r for r in rows if r["label"]).get("relation_opt_out")


def test_every_edge_of_a_state_diagram_is_excused_whatever_its_ranks(tmp_path):
    make(tmp_path, "widget-states", [("gadget-result", "gadget-file", '""'), ("widget-a", "widget-b", '""')], relation="relation: moves on\n  states: true")
    rows, _ = edge_audit.audit(tmp_path)
    assert [r["verdict"] for r in rows] == ["excused", "excused"]


def test_the_audit_writes_its_two_reports_and_nothing_else(tmp_path):
    make(tmp_path, "widget-flow", [("widget-actor", "widget-a", '""'), ("gadget-file", "widget-a", '""')])
    before = {p: p.read_bytes() for p in (tmp_path / "docs").rglob("*") if p.is_file()}
    rows, extra = edge_audit.audit(tmp_path)
    out = tmp_path / "out"
    lines = edge_audit.write_reports(rows, extra, out)
    assert {p.name for p in out.iterdir()} == {"edge-audit.md", "edge-audit.csv"}
    assert before == {p: p.read_bytes() for p in (tmp_path / "docs").rglob("*") if p.is_file()}  # no declaration changed
    with (out / "edge-audit.csv").open(encoding="utf-8", newline="") as handle:
        assert [r["verdict"] for r in csv.DictReader(handle)] == ["ok", "reverse"]
    text = (out / "edge-audit.md").read_text(encoding="utf-8")
    assert "- reverse: 1" in text and "widgets/.assets/widget-flow" in text and "edge-defaults" in "\n".join(lines)


def test_a_trusted_kind_keeps_its_declared_direction_and_free_text_is_judged_by_rank(tmp_path):
    make(tmp_path, "widget-gates", [("widget-a", "widget-gate", '""'), ("gadget-file", "widget-a", "sorts")])
    rows, _ = edge_audit.audit(tmp_path)
    got = {r["to"]: r["verdict"] for r in rows}
    assert got["widget-gate"] == "declared" and got["widget-a"] == "reverse"



def test_the_audit_and_the_engine_read_one_rank_table():
    assert edge_audit.edge_rules is edge_audit.declaration.edge_rules


def test_a_crossing_counts_only_where_it_hides_an_arrowhead_or_a_pill():
    route = lambda a, b, points, pill=None: {"from": a, "to": b, "points": points, "pill": pill}
    plain = [route("widget-a", "widget-b", [(0, 0), (100, 100)]), route("gadget-a", "gadget-b", [(0, 100), (100, 0)])]
    assert edge_audit.hidden_crossings(plain) == []  # they cross at (50, 50), far from both heads and from any pill
    at_head = [route("widget-a", "widget-b", [(0, 0), (100, 100)]), route("gadget-a", "gadget-b", [(0, 100), (54, 46)])]
    assert edge_audit.hidden_crossings(at_head) == [("widget-a", "widget-b", "gadget-a", "gadget-b")]  # the second head is under the first line
    on_pill = [route("widget-a", "widget-b", [(0, 0), (100, 100)], (40, 40, 20, 20)), plain[1]]
    assert len(edge_audit.hidden_crossings(on_pill)) == 1
