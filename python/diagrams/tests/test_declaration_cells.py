# cspell:ignore minimaps widgetese getpixel miny
"""The declaration of a diagram, tested: chips, commits, spans, markers, drift, and the conflict and sync of a committed pair.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_declaration_cells.py
"""


import pytest
from catzc.diagrams import declaration, declaration_sync
from conftest import WIDGETS, claimed, committed_pair


def test_rule_chips_number_their_rule_and_round_trip_with_the_key_in_the_legend():
    raw = claimed()
    rules = list(declaration.minimaps.records())[:2]
    raw["about"]["rules"] = rules
    raw["content"]["chips"] = [
        {"at": "gadget-gate", "kind": "rule", "rule": rules[1]},
        {"at": "gadget-gate", "kind": "rule", "rule": rules[0], "gated": False},
        {"at": "group-kit", "kind": "rule", "rule": rules[0]},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert 'value="#2"' in model and model.count("dashed=1;") >= 2  # the DRS-only chip and its legend swatch
    assert f"#1  {rules[0]}" in model and f"#2  {rules[1]}" in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["chips"] == first["content"]["chips"]


def test_a_rule_chip_names_a_rule_the_diagram_covers():
    raw = claimed()
    raw["content"]["chips"] = [{"at": "gadget-gate", "kind": "rule", "rule": "ADR-WIDGET-ELSEWHERE"}]
    with pytest.raises(declaration.DeclarationError, match="rule chip at 'gadget-gate' rule 'ADR-WIDGET-ELSEWHERE' is not one of"):
        declaration.normalise(raw)


def test_commits_draw_in_their_palette_state_and_ghosts_come_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"] += [
        {"id": "commit-one", "kind": "commit", "label": "1", "in": "band-widgets", "state": "topic"},
        {"id": "commit-two", "kind": "commit", "label": "2", "in": "band-widgets", "state": "landed", "ghost": True},
        {"id": "commit-three", "kind": "commit", "label": "3", "in": "band-gadgets"},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "fillColor=#4E6378" in model and "fillColor=#C9CCD1" in model and "opacity=60" in model
    # One legend entry per state, and one for a ghost of any state.
    assert 'value="commit: topic"' in model and 'value="commit: landed"' in model and 'value="commit: ghost"' in model
    back = declaration.get(model, kind="explanation")
    commits = lambda d: {g["id"]: g for g in d["content"]["glyphs"] if g["kind"] == "commit"}
    assert commits(back) == commits(first)
    again = declaration.get(declaration.put(back), kind="explanation")
    assert declaration.dump(again) == declaration.dump(back)


def test_only_a_commit_takes_a_state_and_only_a_palette_state():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"][0]["state"] = "topic"
    with pytest.raises(declaration.DeclarationError, match="only a commit takes a state"):
        declaration.normalise(raw)
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"].append({"id": "commit-one", "kind": "commit", "label": "1", "in": "band-widgets", "state": "purple"})
    with pytest.raises(declaration.DeclarationError, match="state 'purple' is not one of: bvt, topic, landed"):
        declaration.normalise(raw)


def test_a_span_sits_above_its_bands_and_a_wider_span_stacks_over_a_narrower_one():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"] = [
        {"id": "span-wide", "label": "CD", "over": ["band-widgets", "band-gadgets"]},
        {"id": "span-narrow", "label": "CI", "over": ["band-widgets"]},
    ]
    cells = {c["id"]: c for c in declaration.place(declaration.normalise(raw))[0]}
    top = cells["band-widgets"]["y"]
    assert cells["span-narrow"]["y"] == top - 24 and cells["span-wide"]["y"] == top - 24 - 32


def test_a_span_names_its_row_and_the_others_stack_around_it():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"] = [
        {"id": "span-wide", "label": "CD", "over": ["band-widgets", "band-gadgets"]},
        {"id": "span-high", "label": "CI", "over": ["band-widgets"], "row": 3},
    ]
    first = declaration.normalise(raw)
    cells = {c["id"]: c for c in declaration.place(first)[0]}
    top = cells["band-widgets"]["y"]
    assert cells["span-high"]["y"] == top - 24 - 3 * 32 and cells["span-wide"]["y"] == top - 24  # the wide one takes the free row 0
    back = declaration.undrawn(declaration.get(declaration.put(first), kind="explanation")["content"], first)
    assert back["spans"] == first["content"]["spans"]


def test_two_spans_over_the_same_stage_on_one_row_fail_naming_the_row():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"] = [
        {"id": "span-one", "label": "CD", "over": ["band-widgets"], "row": 1},
        {"id": "span-two", "label": "CI", "over": ["band-widgets", "band-gadgets"], "row": 1},
    ]
    with pytest.raises(declaration.DeclarationError, match="row 1"):
        declaration.place(declaration.normalise(raw))


def test_a_span_row_is_auto_or_a_whole_number():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"][0]["row"] = "high"
    with pytest.raises(declaration.DeclarationError, match="auto or a whole number"):
        declaration.normalise(raw)


def test_a_span_over_glyphs_of_one_band_covers_just_them_and_comes_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"] = [{"id": "span-gate", "label": "CI", "over": ["gadget-gate"]}]
    first = declaration.normalise(raw)
    cells = {c["id"]: c for c in declaration.place(first)[0]}
    assert cells["span-gate"]["x"] == cells["gadget-gate"]["x"] and cells["span-gate"]["w"] == cells["gadget-gate"]["w"]
    back = declaration.get(declaration.put(first), kind="explanation")
    assert back["content"]["spans"] == first["content"]["spans"]


def test_a_marker_on_an_edge_and_corners_for_markers_and_chips_round_trip():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["markers"] = [
        {"at": "widget-a", "number": 1, "corner": "bottom-left"},
        {"at": "widget-a->gadget-store", "number": 2},
        {"at": "gadget-store", "number": 3},
    ]
    raw["content"]["chips"] = [{"at": "gadget-gate", "kind": "count", "text": "87", "corner": "top-left"}]
    first = declaration.normalise(raw)
    cells = {c["id"]: c for c in declaration.place(first)[0]}
    a, s = cells["widget-a"], cells["gadget-store"]
    assert cells["mark-2"]["x"] == round((a["x"] + a["w"] / 2 + s["x"] + s["w"] / 2) / 2 - 11)
    back = declaration.get(declaration.put(first), kind="explanation")
    assert back["content"]["markers"] == first["content"]["markers"]
    assert back["content"]["chips"] == first["content"]["chips"]


def test_labels_keep_angle_brackets():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["title"] = "Widgets pass <RunCommand> to gadgets"
    first = declaration.normalise(raw)
    back = declaration.get(declaration.put(first), kind="explanation")
    assert back["content"]["title"] == "Widgets pass <RunCommand> to gadgets"


def test_a_commit_occupies_an_environment_and_comes_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"] += [
        {"id": "env-uat", "kind": "env", "label": "gadget UAT", "in": "band-gadgets"},
        {"id": "commit-six", "kind": "commit", "label": "6", "in": "env-uat", "state": "main-uat"},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert 'id="commit-six"' in model and 'parent="env-uat"' in model
    back = declaration.get(model, kind="explanation")
    occupant = next(g for g in back["content"]["glyphs"] if g["id"] == "commit-six")
    assert occupant["in"] == "env-uat" and occupant["state"] == "main-uat"


def test_an_edge_routes_through_its_waypoints_and_a_repeat_edge_keeps_its_own_path():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"] += [
        {"from": "widget-a", "to": "gadget-store", "kind": "record", "via": [[400, 520], [900, 520]]},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    box = {c["id"]: c for c in declaration.place(first)[0]}
    frame = box[box["e-widget-a-gadget-store~2"]["parent"]]  # the model holds a framed edge's waypoints relative to its frame
    assert f'<mxPoint x="{400 - frame["x"]}" y="{520 - frame["y"]}" />' in model and 'id="e-widget-a-gadget-store~2"' in model
    back = declaration.get(model, kind="explanation")
    assert [e.get("via") for e in back["content"]["edges"] if e["kind"] == "record" and e["from"] == "widget-a"] == [[[400, 520], [900, 520]]]


def test_a_marker_on_a_routed_edge_sits_halfway_along_its_waypoints_and_comes_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][1]["via"] = [[1200, 900]]
    raw["content"]["markers"] = [{"at": "gadget-store->gadget-gate", "number": 1}]
    first = declaration.normalise(raw)
    cells = {c["id"]: c for c in declaration.place(first)[0]}
    s, g = cells["gadget-store"], cells["gadget-gate"]
    straight = round((s["x"] + s["w"] / 2 + g["x"] + g["w"] / 2) / 2 - 11), round((s["y"] + s["h"] / 2 + g["y"] + g["h"] / 2) / 2 - 11)
    assert (cells["mark-1"]["x"], cells["mark-1"]["y"]) != straight
    back = declaration.get(declaration.put(first), kind="explanation")
    assert back["content"]["markers"] == first["content"]["markers"]


def test_a_span_may_name_a_track_of_the_registry_and_nothing_else():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"][0]["label"] = "vendor_ado.pipelines"
    assert declaration.normalise(raw)["content"]["spans"][0]["label"] == "vendor_ado.pipelines"
    raw["content"]["spans"][0]["label"] = "pipelines"
    with pytest.raises(declaration.DeclarationError, match=r"vendor_ado\.pipelines"):
        declaration.normalise(raw)


def test_drift_is_empty_after_put_and_names_the_cell_a_yml_edit_left_unwritten(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    assert declaration.drift(tmp_path) == ([], [])
    source["content"]["glyphs"][2]["label"] = "Gadget vault"
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    cells, stale = declaration.drift(tmp_path)
    assert "gadget-store" in cells and stale == []


def test_labels_keep_quotes_unescaped_in_the_drawing():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["title"] = "The caller's value wins"
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "&amp;#x27;" not in model
    assert declaration.get(model, kind="explanation")["content"]["title"] == "The caller's value wins"


def edited_both_sides(folder):
    """Move both sides of a committed pair: the yml relabels the gadget store, the drawing relabels widget A."""
    source = __import__("yaml").safe_load(WIDGETS)
    base = committed_pair(folder, source)
    drawn = __import__("yaml").safe_load(WIDGETS)
    drawn["content"]["glyphs"][0]["label"] = "Widget Z"
    declaration.put_png(folder, declaration.normalise(drawn))
    source["content"]["glyphs"][2]["label"] = "Gadget vault"
    declaration.source_of(folder).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    return base


def test_a_pair_edited_on_both_sides_is_a_conflict_naming_the_cells(tmp_path):
    base = edited_both_sides(tmp_path)
    cells = declaration.conflict(tmp_path, base)
    assert "gadget-store" in cells and "widget-a" in cells


def test_get_by_name_clears_a_conflict(tmp_path):
    base = edited_both_sides(tmp_path)
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    assert declaration.conflict(tmp_path, base) == []


def test_put_by_name_clears_a_conflict(tmp_path):
    base = edited_both_sides(tmp_path)
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    assert declaration.conflict(tmp_path, base) == []


def test_one_side_moved_is_no_conflict(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    base = committed_pair(tmp_path, source)
    drawn = __import__("yaml").safe_load(WIDGETS)
    drawn["content"]["glyphs"][0]["label"] = "Widget Z"
    declaration.put_png(tmp_path, declaration.normalise(drawn))
    assert declaration.conflict(tmp_path, base) == []
    assert "widget-a" in declaration.drift(tmp_path)[0]


def test_an_untracked_pair_is_never_a_conflict(tmp_path):
    edited_both_sides(tmp_path)
    assert declaration.conflict(tmp_path, None) == []
    assert declaration.committed(tmp_path) is None


def test_a_committed_pair_whose_png_was_removed_renders_from_its_yml_alone(tmp_path):
    base = committed_pair(tmp_path, __import__("yaml").safe_load(WIDGETS))
    declaration.slide_of(tmp_path).unlink()
    assert declaration.conflict(tmp_path, base) == []
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    assert declaration.model_of(tmp_path) == base[1]
    declaration.slide_of(tmp_path).unlink()
    assert declaration.sync(tmp_path, base) == ["put"]
    assert declaration.drift(tmp_path) == ([], [])


def test_sync_after_a_drawio_edit_gets_then_puts_and_leaves_no_drift(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    base = committed_pair(tmp_path, source)
    drawn = __import__("yaml").safe_load(WIDGETS)
    drawn["content"]["glyphs"][0]["label"] = "Widget Z"
    declaration.put_png(tmp_path, declaration.normalise(drawn))
    assert declaration.sync(tmp_path, base) == ["get", "put"]
    assert declaration.drift(tmp_path) == ([], [])
    assert declaration.load(tmp_path)["content"]["glyphs"][0]["label"] == "Widget Z"


def test_sync_after_a_yml_edit_only_puts(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    base = committed_pair(tmp_path, source)
    source["content"]["glyphs"][2]["label"] = "Gadget vault"
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    assert declaration.sync(tmp_path, base) == ["put"]
    assert declaration.drift(tmp_path) == ([], [])


def test_sync_stops_on_a_conflict_before_put_naming_the_cells(tmp_path):
    base = edited_both_sides(tmp_path)
    before = declaration.model_of(tmp_path)
    with pytest.raises(declaration.DeclarationError, match="widget-a"):
        declaration.sync(tmp_path, base)
    assert declaration.model_of(tmp_path) == before


def test_a_tree_change_a_minimap_reads_makes_it_stale_not_drifted(tmp_path, monkeypatch):
    committed_pair(tmp_path, __import__("yaml").safe_load(WIDGETS))
    assert declaration.drift(tmp_path) == ([], [])
    computed = declaration_sync.minimap_data

    # The tree the minimaps read changed under them: the same declaration now computes data that lights a cell.
    def changed(folder):
        reason = {"subject": "widgets/a.ps1", "basis": "citation", "requested": "ADR-WIDGET", "note": None}
        lit = {"axes": [{"name": "track", "values": ["widgets"]}], "cells": [{"at": ["widgets"], "count": 1}]}
        return {
            view: {**data, **lit, "lit": [{"at": ["widgets"], "count": 1, "reasons": [reason]}]} for view, data in computed(folder).items()
        }

    monkeypatch.setattr(declaration_sync, "minimap_data", changed)
    cells, stale = declaration.drift(tmp_path)
    assert cells == [] and stale and all(cell.startswith("minimap-") for cell in stale)


def git_in(repo, *args):
    __import__("subprocess").run(["git", "-C", str(repo), *args], check=True, capture_output=True)


def test_a_batch_reads_the_committed_pairs_once_at_its_start_and_the_next_batch_sees_a_new_commit(tmp_path):
    repo = tmp_path / "repo"
    stem = repo / "docs" / ".assets" / "widget"
    stem.parent.mkdir(parents=True)
    git_in(repo, "init", "-q")
    git_in(repo, "config", "user.email", "widget@example.invalid")
    git_in(repo, "config", "user.name", "widget")
    source = __import__("yaml").safe_load(WIDGETS)
    first = committed_pair(stem, source)
    git_in(repo, "add", ".")
    git_in(repo, "commit", "-q", "-m", "widget")
    before = declaration.committed_batch([stem])
    assert before[str(stem.resolve())] == declaration.committed(stem) == (first[0], first[1])
    source["content"]["glyphs"][0]["label"] = "Widget Z"
    second = committed_pair(stem, source)
    git_in(repo, "commit", "-q", "-am", "relabel")
    after = declaration.committed_batch([stem])
    assert after[str(stem.resolve())] == (second[0], second[1]) != before[str(stem.resolve())]
    assert declaration.committed(stem, before) == before[str(stem.resolve())]


def test_a_batch_outside_a_repository_has_no_base(tmp_path):
    committed_pair(tmp_path, __import__("yaml").safe_load(WIDGETS))
    assert declaration.committed_batch([tmp_path]) == {str(tmp_path.resolve()): None}
