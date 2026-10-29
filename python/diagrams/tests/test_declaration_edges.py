# cspell:ignore minimaps widgetese getpixel miny
"""The declaration of a diagram, tested: edge semantics, labels and pills, ranks, counts, routes and the uniform word.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_declaration_edges.py
"""

import re

import pytest
from catzc.diagrams import declaration, declaration_routes, declaration_settings
from conftest import WIDGETS


def test_every_edge_with_both_ends_carries_the_deadzone_on_each_end():
    model = declaration.put(declaration.normalise(__import__("yaml").safe_load(WIDGETS)))
    edges = [line for line in model.splitlines() if 'edge="1"' in line]
    assert edges and all(
        f"sourcePerimeterSpacing={declaration.EDGE_DEADZONE};" in line and f"targetPerimeterSpacing={declaration.EDGE_DEADZONE};" in line
        for line in edges
        if 'source="None"' not in line and 'target="None"' not in line
    )
    assert declaration.EDGE_DEADZONE == 8


def _edge_declaration(glyphs, edges, **content):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"] = glyphs
    raw["content"]["edges"] = edges
    raw["content"].pop("spans", None)
    raw["content"].pop("groups", None)
    raw["content"].pop("markers", None)
    raw["content"].pop("chips", None)
    raw["content"].pop("relation", None)
    raw["content"].pop("states", None)
    raw["content"].update(content)
    for g in glyphs:
        g["in"] = "band-widgets"
    return raw


CODE_GLYPHS = [
    {"id": "widget-a", "kind": "code", "label": "Widget A"},
    {"id": "widget-b", "kind": "code", "label": "Widget B"},
    {"id": "gadget-store", "kind": "store", "label": "Gadget store"},
    {"id": "author", "kind": "actor", "label": "author"},
]


def test_a_plain_arrow_ending_on_a_code_block_needs_an_actor_or_a_call_label():
    bare = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": ""}])
    with pytest.raises(declaration.DeclarationError, match="edge widget-a -> widget-b ends on a code block"):
        declaration.normalise(bare)
    called = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": "calls"}])
    assert declaration.normalise(called)["content"]["edges"]
    fed = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": "feeds"}])
    assert declaration.normalise(fed)["content"]["edges"]  # feeds is the second label that may end on code: its tail initiates
    written = _edge_declaration(CODE_GLYPHS, [{"from": "author", "to": "widget-b", "kind": "flow", "label": ""}])
    assert declaration.normalise(written)["content"]["edges"], "an actor starts a flow into code"


def test_an_arrow_onto_a_file_or_a_store_needs_neither():
    reads = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "gadget-store", "kind": "flow", "label": ""}])
    assert declaration.normalise(reads)["content"]["edges"]


def test_a_relation_without_states_is_refused_naming_the_rule():
    plain = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": "calls"}], relation="feeds")
    with pytest.raises(
        declaration.DeclarationError, match=r"content.relation 'feeds' is only for a state diagram.*DDR-VISUAL-ARROWSPOINTATDEPENDENCY"
    ):
        declaration.normalise(plain)


def test_states_without_a_relation_is_refused_naming_the_rule():
    bare = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": "calls"}], states=True)
    with pytest.raises(declaration.DeclarationError, match=r"content.states is true but names no relation.*DDR-VISUAL-ARROWSPOINTATDEPENDENCY"):
        declaration.normalise(bare)


def test_a_state_diagram_keeps_its_relation_and_states_round_trips_while_false_is_never_written():
    steps = _edge_declaration(
        CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": ""}], relation="advances one rung", states=True
    )
    normalised = declaration.normalise(steps)
    assert normalised["content"]["states"] is True and normalised["content"]["relation"] == "advances one rung"
    assert "states: true" in declaration.dump(normalised)
    labelled = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": "calls"}])
    assert "states:" not in declaration.dump(declaration.normalise(labelled))
    with pytest.raises(declaration.DeclarationError, match="content.states is true or false"):
        declaration.normalise(_edge_declaration(CODE_GLYPHS, [], relation="moves on", states="yes"))


def test_a_diagram_with_its_own_relation_is_not_judged_by_the_default_meaning():
    own = _edge_declaration(
        CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": ""}], relation="feeds the next", states=True
    )
    assert declaration.normalise(own)["content"]["edges"]


def test_the_default_meaning_and_the_labels_are_declared_once_and_the_legend_reads_them():
    assert declaration.DEFAULTS["edge-semantics"]["legend"] == "initiator to receiver"
    assert declaration.LIB["edges"]["flow"]["phrase"] == "flow: initiator to receiver"
    assert set(declaration.EDGE_SEMANTICS["code-head-labels"]) <= set(declaration.EDGE_LABELS)
    assert set(declaration.EDGE_LABELS.values()) <= {"tail", "head"}
    glyph_library = (declaration.KIT / "assets" / "glyphs.xml").read_text(encoding="utf-8")
    assert 'value="flow: initiator to receiver"' in glyph_library, "the glyph library's words agree with the declaration"


def pill(model, edge):
    return re.search(
        rf'<mxCell\s+id="{edge}-word"\s+value="&lt;b&gt;([^&]*)&lt;/b&gt;"\s+style="rounded=1;arcSize=50;[^"]*"[^>]*>\s*<mxGeometry\s+x="(-?\d+)"\s+y="(-?\d+)"\s+width="(\d+)"\s+height="(\d+)"',
        model,
    )


def test_every_labelled_edge_draws_its_word_in_a_pill_by_default_and_the_line_keeps_none():
    assert declaration_settings.EDGE_LABEL == "pill"
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][1]["label"] = "fails"  # a line inside one band
    raw["layout"] = {"gadget-gate": {"x": 950, "y": 183, "w": 127, "h": 93}}  # far enough from the store to hold a pill and a head
    first = declaration.normalise(raw)
    model = declaration.put(first)
    for edge, word in (("e-widget-a-gadget-store", "writes"), ("e-gadget-store-gadget-gate", "fails")):
        found = pill(model, edge)
        assert found is not None and found.group(1) == word
        assert re.search(rf'<mxCell id="{edge}" value="" ', model)
    assert "label: the word on a line" in model and "transition: into a new state" not in model
    assert declaration.dump(declaration.get(model, kind="explanation")) == declaration.dump(first)


def test_a_line_too_short_for_a_pill_gets_the_same_pill_beside_it_and_never_bare_text():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][1]["label"] = "fails"
    raw["layout"] = {"gadget-store": {"x": 800, "y": 150, "w": 220, "h": 72}, "gadget-gate": {"x": 800, "y": 262, "w": 220, "h": 72}}
    model = declaration.put(declaration.normalise(raw))  # the two ends stand 40 px apart: no room for a pill and a head on the line
    found = pill(model, "e-gadget-store-gadget-gate")
    assert found is not None and found.group(1) == "fails"
    assert re.search(r'<mxCell id="e-gadget-store-gadget-gate" value="" ', model)  # the line keeps no word of its own
    x, y, w, h = (int(found.group(i)) for i in (2, 3, 4, 5))
    assert x >= 800 + 220 or x + w <= 800 or y + h <= 150 or y >= 150 + 72  # the pill overlaps neither box
    assert abs(x + w / 2 - 910) >= w / 2  # the line runs down x = 910: the pill stands off it, not on it
    with pytest.MonkeyPatch.context() as patch:
        patch.setattr(declaration_settings, "EDGE_LABEL", "word")
        assert (
            pill(declaration.put(declaration.normalise(raw)), "e-gadget-store-gadget-gate") is None
        )  # the word presentation keeps it bare


def test_a_pill_beside_a_short_line_between_two_tall_boxes_steps_out_past_them_and_never_stands_on_either():
    widget, gadget = (0, 28, 100, 44), (120, 28, 100, 44)  # 20 px apart, the line between them level at y = 50
    run, word = [(100, 50), (120, 50)], "writes"
    width, height = 6.2 * len(word) + 2 * declaration_routes.WORD_MARGIN, 12 + 2 * declaration_routes.WORD_MARGIN
    spot = declaration_routes.label_spot(run, word, 0, None, [widget, gadget])
    assert spot is not None
    x, y = spot
    rect = (x - width / 2, y - height / 2, width, height)
    assert not declaration_routes.overlaps(rect, widget) and not declaration_routes.overlaps(rect, gadget)
    assert y < 50 and 50 - y <= height / 2 + declaration_routes.WORD_GAP + declaration_routes.WORD_STEP_OUT  # above the line, within the step-out
    with pytest.MonkeyPatch.context() as patch:
        patch.setattr(declaration_routes, "WORD_STEP_OUT", 0)
        assert declaration_routes.label_spot(run, word, 0, None, [widget, gadget]) is None  # no step-out: no free place beside, bare


def test_a_bare_word_on_a_cell_is_a_finding_that_names_the_edge_and_the_cells(monkeypatch):
    monkeypatch.setattr(declaration_settings, "FINDINGS_FAIL", True)  # the conftest turns findings off for every other test
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][1]["label"] = "fails"
    raw["layout"] = {"gadget-store": {"x": 600, "y": 150, "w": 220, "h": 200}, "gadget-gate": {"x": 840, "y": 150, "w": 220, "h": 200}}
    declared = declaration.normalise(raw)  # 20 px apart and 200 px tall: no pill fits beside the line within the step-out
    with pytest.raises(declaration.DeclarationError, match=r"the word of gadget-store -> gadget-gate has no free place .* widen the gap"):
        declaration.put(declared)
    monkeypatch.setattr(declaration_settings, "FINDINGS_FAIL", False)
    assert declaration.put(declared)  # with findings off the drawing still renders, its word bare


def test_the_label_presentation_is_one_of_the_two_the_renderer_names():
    assert declaration.LABEL_PRESENTATIONS == ("pill", "word")
    with pytest.raises(declaration.DeclarationError, match="edge-label 'badge' is not one of: pill, word"):
        declaration.choices("drawio.yml renderer edge-label", "badge", declaration.LABEL_PRESENTATIONS)


def ranked(*edges):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].pop("relation")  # a diagram without its own relation: the arrow rule's ranks apply
    raw["content"].pop("states")
    raw["content"]["edges"] += list(edges)
    return raw


def test_an_edge_from_the_lower_rank_to_the_higher_takes_its_kind_pair_default_label():
    first = declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store"}))
    edge = next(e for e in first["content"]["edges"] if e["from"] == "widget-b")
    assert edge["label"] == "writes"  # code acts on a store
    model = declaration.put(first)
    assert declaration.dump(declaration.get(model, kind="explanation")) == declaration.dump(first)


def test_an_edge_between_two_cells_is_oriented_by_their_ranks():
    first = declaration.normalise(ranked({"between": ["gadget-store", "widget-b"]}))
    edge = next(e for e in first["content"]["edges"] if e["to"] == "gadget-store" and e["from"] == "widget-b")
    assert edge["label"] == "writes" and "between" not in edge
    with pytest.raises(declaration.DeclarationError, match="between widget-a and widget-b has no direction by rank"):
        declaration.normalise(ranked({"between": ["widget-a", "widget-b"]}))  # one rank: declared with from and to


def test_an_edge_declared_against_its_rank_without_a_label_is_refused_naming_it():
    with pytest.raises(declaration.DeclarationError, match="edge gadget-store -> widget-b runs against its rank"):
        declaration.normalise(ranked({"from": "gadget-store", "to": "widget-b"}))
    declaration.normalise(ranked({"from": "gadget-store", "to": "widget-b", "label": "calls"}))  # a label of the vocabulary fixes it


def test_a_diagram_with_its_own_relation_keeps_its_plain_arrows_and_a_gate_keeps_its_declared_direction():
    raw = __import__("yaml").safe_load(WIDGETS)  # relation: feeds
    raw["content"]["edges"].append({"from": "gadget-store", "to": "widget-b"})
    assert (
        next(e for e in declaration.normalise(raw)["content"]["edges"] if e["from"] == "gadget-store" and e["to"] == "widget-b")["label"]
        == ""
    )
    first = declaration.normalise(ranked({"from": "gadget-gate", "to": "widget-b"}, {"from": "widget-b", "to": "gadget-gate"}))
    assert [e["label"] for e in first["content"]["edges"] if "gadget-gate" in (e["from"], e["to"]) and e["kind"] == "flow"] == ["", ""]


def test_the_rank_table_names_its_key_when_a_kind_is_outside_the_vocabulary(monkeypatch):
    monkeypatch.setitem(declaration.DEFAULTS["edge-rank"], "code", "code, gadgetkind")
    with pytest.raises(declaration.edge_rules.RuleError, match="edge-rank code: 'gadgetkind' is not a glyph kind"):
        declaration.edge_rules.validate(declaration.GLYPH_KINDS, tuple(declaration.EDGE_LABELS))


def test_the_source_keeps_a_minimal_edge_minimal_and_the_round_trip_is_stable():
    first = declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store"}))
    assert next(e for e in first["content"]["edges"] if e["from"] == "widget-b")["label"] == "writes"  # derived for the drawing
    text = declaration.dump(first)
    assert "from: widget-b, to: gadget-store" in text or "{ from: widget-b, to: gadget-store" in text
    assert "label: writes" not in text.split("widget-b, to: gadget-store")[1].split("}")[0]  # the source never carries the derived word
    again = declaration.normalise(__import__("yaml").safe_load(text))
    assert declaration.dump(again) == text and declaration.put(again) == declaration.put(
        first
    )  # source to drawing to source: nothing moves
    model = declaration.put(first)
    assert declaration.put(declaration.get(model, kind="explanation")) == model  # get then put changes nothing
    assert declaration.dump(declaration.get(model, kind="explanation")) == text  # and get writes the minimal form back


def test_an_authored_default_label_is_the_same_edge_as_the_derived_one_and_a_different_label_is_kept():
    written = declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store", "label": "writes"}))
    minimal = declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store"}))
    assert declaration.dump(written) == declaration.dump(minimal)  # one form for one meaning
    other = declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store", "label": "calls"}))
    assert "label: calls" in declaration.dump(other)
    relation = __import__("yaml").safe_load(WIDGETS)  # relation: feeds, its edge labelled writes by the author: kept as written
    assert "label: writes" in declaration.dump(declaration.normalise(relation))


def test_get_keeps_the_direction_an_author_wrote_and_never_rewrites_it_into_between():
    first = declaration.normalise(ranked({"between": ["gadget-store", "widget-b"]}))
    text = declaration.dump(first)
    assert "between" not in text and "widget-b" in text


def test_an_edge_count_shows_in_its_pill_after_its_label_and_comes_back_as_a_count(monkeypatch):
    monkeypatch.setattr(
        declaration_settings, "UNIFORM_LABEL", "pills"
    )  # both flow edges say writes: the pills setting keeps the word in each
    raw = ranked({"from": "widget-b", "to": "gadget-store", "label": "writes", "count": "13/28"})
    raw["layout"] = {"gadget-gate": {"x": 950, "y": 183, "w": 127, "h": 93}}
    first = declaration.normalise(raw)
    edge = next(e for e in first["content"]["edges"] if e["from"] == "widget-b")
    assert edge["label"] == "writes" and edge["count"] == "13/28"
    model = declaration.put(first)
    assert "&lt;b&gt;writes 13/28&lt;/b&gt;" in model  # the label, then the count, in one pill
    back = declaration.get(model, kind="explanation")
    assert next(e for e in back["content"]["edges"] if e["from"] == "widget-b")["count"] == "13/28"
    assert declaration.put(back) == model
    assert "count: " not in declaration.dump(declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store"})))  # no count, no key


def test_a_count_is_n_of_m_with_n_at_most_m_and_decides_no_direction():
    for bad in ("29/28", "13", "13/", "a/b"):
        with pytest.raises(declaration.DeclarationError, match="count .* is n/m with n at most m"):
            declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store", "count": bad}))
    with pytest.raises(declaration.DeclarationError, match="runs against its rank"):
        declaration.normalise(ranked({"from": "gadget-store", "to": "widget-b", "count": "1/2"}))  # a count is no label
    only = declaration.normalise(ranked({"from": "widget-b", "to": "gadget-store", "label": "5/5"}))  # a label that is a count is one
    assert next(e for e in only["content"]["edges"] if e["from"] == "widget-b")["count"] == "5/5"


ROUTED = """
about:
  lens: architecture
content:
  title: Widgets
  flow: left-to-right
  bands:
    - { id: band-a, label: Widgets }
  glyphs:
    - { id: widget-a, kind: code, label: Widget A, in: band-a }
    - { id: widget-b, kind: code, label: Widget B, in: band-a }
    - { id: gadget-store, kind: store, label: Gadget store, in: band-a }
    - { id: gadget-gate, kind: code, label: Gadget code, in: band-a }
"""

ROW = {
    "band-a": {"x": 20, "y": 84, "w": 1000, "h": 420},
    "widget-b": {"x": 40, "y": 300, "w": 120, "h": 44},
    "widget-a": {"x": 300, "y": 300, "w": 120, "h": 44},
    "gadget-store": {"x": 580, "y": 300, "w": 120, "h": 60},
    "gadget-gate": {"x": 300, "y": 120, "w": 120, "h": 60},
}


def routed(layout, edges):
    raw = __import__("yaml").safe_load(ROUTED)
    raw["content"]["edges"] = list(edges)
    raw["layout"] = layout
    return declaration.normalise(raw)


def edge_style(model, source, target):
    found = re.search(rf'<mxCell id="e-{source}-{target}[^"]*" [^\n]*style="([^"]*)"', model)
    assert found is not None
    return dict(part.split("=", 1) for part in found.group(1).split(";") if "=" in part)


def test_edges_between_aligned_cells_run_straight_from_side_middle_to_side_middle():
    model = declaration.put(routed(ROW, [{"from": "widget-b", "to": "widget-a", "label": "calls"}]))
    style = edge_style(model, "widget-b", "widget-a")
    assert (style["exitX"], style["exitY"], style["entryX"], style["entryY"]) == ("1.0", "0.5", "0.0", "0.5")


def test_edges_that_share_a_side_are_spaced_evenly_along_it_in_the_order_of_their_other_ends():
    layout = {**ROW, "widget-b": {"x": 40, "y": 120, "w": 120, "h": 44}, "gadget-gate": {"x": 40, "y": 420, "w": 120, "h": 44}}
    edges = [{"from": "widget-a", "to": "widget-b", "label": "calls"}, {"from": "widget-a", "to": "gadget-gate", "label": "calls"}]
    model = declaration.put(routed(layout, edges))
    upper, lower = edge_style(model, "widget-a", "widget-b"), edge_style(model, "widget-a", "gadget-gate")
    assert (upper["exitX"], lower["exitX"]) == ("0.0", "0.0") and (upper["exitY"], lower["exitY"]) == ("0.3333", "0.6667")


def test_an_edge_through_a_cell_that_is_neither_end_is_a_keep_out_error_and_a_free_path_is_not(monkeypatch):
    monkeypatch.setattr(declaration_settings, "FINDINGS_FAIL", True)
    layout = {**ROW, "gadget-store": {"x": 700, "y": 300, "w": 120, "h": 44}}
    edges = [{"from": "widget-b", "to": "gadget-store", "label": "writes"}]
    with pytest.raises(
        declaration.DeclarationError, match="E_KEEPOUT edge widget-b -> gadget-store runs through the keep-out zone of widget-a"
    ):
        declaration.put(routed(layout, edges))
    layout["widget-a"] = {"x": 300, "y": 120, "w": 120, "h": 44}  # moved out of the line
    declaration.put(routed(layout, edges))


def test_the_keep_out_zone_is_the_cell_grown_by_the_deadzone_and_a_container_is_no_obstacle(monkeypatch):
    monkeypatch.setattr(declaration_settings, "FINDINGS_FAIL", True)
    edges = [{"from": "widget-b", "to": "gadget-store", "label": "writes"}]
    layout = {**ROW, "gadget-store": {"x": 700, "y": 300, "w": 120, "h": 44}, "widget-a": {"x": 300, "y": 326, "w": 120, "h": 44}}
    with pytest.raises(
        declaration.DeclarationError, match="keep-out zone of widget-a"
    ):  # its top is 4 px under the line: inside the 8 px zone
        declaration.put(routed(layout, edges))
    layout["widget-a"] = {"x": 300, "y": 340, "w": 120, "h": 44}  # 18 px under the line: clear of the zone
    declaration.put(routed(layout, edges))  # and the band that holds both ends and the cell never counts
    assert declaration.segment_hits_rect((0, 10), (100, 10), (40, 0, 20, 20)) and not declaration.segment_hits_rect(
        (0, 30), (100, 30), (40, 0, 20, 20)
    )


def uniform(edges):
    return routed({**ROW, "gadget-gate": {"x": 300, "y": 120, "w": 120, "h": 44}}, edges)


CALLS = [
    {"from": "widget-b", "to": "widget-a", "label": "calls"},
    {"from": "widget-a", "to": "gadget-gate", "label": "calls"},
]


def test_when_every_flow_edge_says_one_word_the_legend_says_it_once_and_no_pill_is_drawn():
    model = declaration.put(uniform(CALLS))
    assert "-word" not in model and 'value="flow: calls"' in model and "label: the word on a line" not in model


def test_a_count_keeps_its_pill_and_a_second_word_or_a_failure_edge_decides_the_rule():
    counted = declaration.put(uniform([{**CALLS[0], "count": "3/4"}, CALLS[1]]))
    assert "&lt;b&gt;3/4&lt;/b&gt;" in counted and 'value="flow: calls"' in counted  # the count alone, in its pill
    mixed = declaration.put(uniform([*CALLS, {"from": "widget-a", "to": "gadget-store", "label": "writes"}]))
    assert mixed.count("-word") >= 3 and 'value="flow: calls"' not in mixed  # two words: every edge keeps its pill
    failing = declaration.put(uniform([*CALLS, {"from": "widget-a", "to": "gadget-store", "kind": "fail"}]))
    assert "-word" not in failing and 'value="flow: calls"' in failing  # a failure edge does not count toward the words


def test_the_uniform_word_is_derived_and_get_never_writes_it_back_as_a_relation():
    first = uniform(CALLS)
    model = declaration.put(first)
    back = declaration.get(model, kind="explanation")
    assert back["content"]["relation"] == "" and [e["label"] for e in back["content"]["edges"]] == ["calls", "calls"]
    edge_cells = lambda xml: sorted(re.findall(r'<mxCell id="e-[^>]*>', xml))
    assert edge_cells(declaration.put(back)) == edge_cells(model)  # get then put draws the same edges and the same legend word
    assert 'value="flow: calls"' in declaration.put(back)
    with pytest.MonkeyPatch.context() as patch:
        patch.setattr(declaration_settings, "UNIFORM_LABEL", "pills")
        assert declaration.put(first).count("-word") == 2 and 'value="flow: calls"' not in declaration.put(first)


DIAGONAL = {**ROW, "gadget-gate": {"x": 700, "y": 120, "w": 120, "h": 44}, "widget-b": {"x": 40, "y": 320, "w": 120, "h": 44}}


def test_an_edge_whose_ends_share_no_x_or_y_overlap_is_routed_as_one_elbow_the_pill_on_its_longer_leg(monkeypatch):
    monkeypatch.setattr(declaration_settings, "FINDINGS_FAIL", True)
    layout = {**DIAGONAL, "widget-a": {"x": 400, "y": 460, "w": 120, "h": 44}, "gadget-store": {"x": 600, "y": 440, "w": 120, "h": 44}}
    model = declaration.put(routed(layout, [{"from": "widget-b", "to": "gadget-gate", "label": "calls"}]))
    style = edge_style(model, "widget-b", "gadget-gate")
    assert (style["exitX"], style["exitY"], style["entryX"], style["entryY"]) == ("1.0", "0.5", "0.5", "1.0") and style["catzcElbow"] == "1"
    route = declaration.LAST_ROUTES[0]["points"]
    assert (
        len(route) == 3 and route[0][1] == route[1][1] and route[1][0] == route[2][0]
    )  # one bend: along the exit row, then up the entry column
    pill = declaration.LAST_ROUTES[0]["pill"]
    legs = [abs(route[1][0] - route[0][0]), abs(route[2][1] - route[1][1])]
    centre = (pill[0] + pill[2] / 2, pill[1] + pill[3] / 2)
    assert abs(centre[1] - route[0][1]) < 1 if legs[0] >= legs[1] else abs(centre[0] - route[1][0]) < 1  # on the longer leg


def test_the_elbow_is_derived_so_get_never_reads_it_back_as_a_waypoint_and_ends_that_overlap_stay_straight():
    first = routed(
        DIAGONAL, [{"from": "widget-b", "to": "gadget-gate", "label": "calls"}, {"from": "widget-b", "to": "widget-a", "label": "calls"}]
    )
    model = declaration.put(first)
    assert "catzcElbow=1" in edge_style_text(model, "widget-b", "gadget-gate") and "catzcElbow" not in edge_style_text(
        model, "widget-b", "widget-a"
    )
    back = declaration.get(model, kind="explanation")
    assert all("via" not in e for e in back["content"]["edges"])
    edge_cells = lambda xml: sorted(re.findall(r'<mxCell id="e-[^>]*>', xml))
    assert edge_cells(declaration.put(back)) == edge_cells(model)  # the same edges, the same elbow


def test_the_straight_setting_keeps_the_diagonal(monkeypatch):
    monkeypatch.setattr(declaration_settings, "EDGE_ROUTE", "straight")
    model = declaration.put(routed(DIAGONAL, [{"from": "widget-b", "to": "gadget-gate", "label": "calls"}]))
    assert "catzcElbow" not in edge_style_text(model, "widget-b", "gadget-gate")


def edge_style_text(model, source, target):
    found = re.search(rf'<mxCell id="e-{source}-{target}[^"]*" [^' + chr(10) + r']*style="([^"]*)"', model)
    assert found is not None
    return found.group(1)
