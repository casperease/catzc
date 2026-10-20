# cspell:ignore minimaps widgetese
"""The declaration of a diagram and its two directions: put (yml to model to raster) and get (model to yml).

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/Catzc.Diagrams/tests/test_declaration.py
"""

import sys
from pathlib import Path

import pytest

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration
from PIL import Image

WIDGETS = """
about:
  lens: architecture
content:
  title: Widgets flow into gadgets
  flow: left-to-right
  relation: feeds
  bands:
    - { id: band-widgets, label: Widgets }
    - { id: band-gadgets, label: Gadgets }
  spans:
    - { id: span-build, label: CI, over: [band-widgets, band-gadgets] }
  groups:
    - { id: group-kit, label: Catzc.Widget.Kit, in: band-widgets }
    - { id: group-inner, label: Catzc.Widget.Kit.Inner, in: group-kit }
  glyphs:
    - { id: widget-a, kind: code, label: Widget A, in: group-kit }
    - { id: widget-b, kind: type, label: Widget B, in: group-inner }
    - { id: gadget-store, kind: store, label: Gadget store, in: band-gadgets }
    - { id: gadget-gate, kind: gate, label: Gadget gate, in: band-gadgets }
  edges:
    - { from: widget-a, to: gadget-store, kind: flow, label: writes }
    - { from: gadget-store, to: gadget-gate, kind: fail }
    - { from: gadget-store, to: group-kit, kind: adr }
  markers:
    - { at: widget-a, number: 1 }
    - { at: gadget-gate, number: 2 }
  chips:
    - { at: gadget-gate, kind: count, text: "87" }
"""


def widgets():
    return declaration.normalise(__import__("yaml").safe_load(WIDGETS))


def test_put_then_get_returns_the_same_yml():
    first = widgets()
    model = declaration.put(first)
    second = declaration.get(model, kind="explanation")
    assert declaration.dump(second) == declaration.dump(first)


def test_get_then_put_returns_the_same_xml():
    model = declaration.put(widgets())
    again = declaration.put(declaration.get(model, kind="explanation"))
    assert again == model


def test_the_relation_names_the_flow_legend_and_comes_back():
    model = declaration.put(widgets())
    assert 'value="flow: feeds"' in model
    assert declaration.get(model, kind="explanation")["content"]["relation"] == "feeds"


def test_a_span_label_outside_the_vocabularies_fails_with_the_allowed_words():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"][0]["label"] = "sideways"
    with pytest.raises(declaration.DeclarationError, match="span 'span-build' label 'sideways' is not one of: CI, CD, DEPLOY"):
        declaration.normalise(raw)


def test_a_glyph_kind_outside_the_library_fails_with_the_kinds():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"][0]["kind"] = "blob"
    with pytest.raises(declaration.DeclarationError, match="kind 'blob' is not one of: code, set, file"):
        declaration.normalise(raw)


def test_a_nested_group_round_trips_with_its_holder():
    back = declaration.get(declaration.put(widgets()), kind="explanation")
    groups = {g["id"]: g["in"] for g in back["content"]["groups"]}
    glyphs = {g["id"]: g["in"] for g in back["content"]["glyphs"]}
    assert groups == {"group-kit": "band-widgets", "group-inner": "group-kit"}
    assert glyphs["widget-b"] == "group-inner" and glyphs["widget-a"] == "group-kit"


def test_a_cell_without_layout_is_placed_by_the_grid_and_a_moved_one_keeps_its_place():
    first = widgets()
    assert first["layout"] == {}
    moved = declaration.put({"content": first["content"], "layout": {"gadget-gate": {"x": 900, "y": 300, "w": 120, "h": 60}}})
    back = declaration.get(moved, kind="explanation")
    assert back["layout"] == {"gadget-gate": {"x": 900, "y": 300, "w": 120, "h": 60}}
    assert "gadget-store" not in back["layout"]


def test_top_to_bottom_stacks_the_bands_and_stands_the_span_beside_them():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["flow"] = "top-to-bottom"
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "rotation=90" in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["flow"] == "top-to-bottom"
    assert declaration.dump(back) == declaration.dump(first)


def test_minimaps_default_by_kind_and_must_be_three_known_views():
    raw = __import__("yaml").safe_load(WIDGETS)
    views = lambda r: declaration.normalise(r)["content"]["minimaps"]
    assert views(raw) == ["grid", "axis", "layer-stack"]
    raw["content"]["kind"] = "reference"
    assert views(raw) == ["grid", "code-locations", "track-placement"]
    raw["content"]["minimaps"] = ["grid", "axis", "moon"]
    with pytest.raises(declaration.DeclarationError, match="minimap view 'moon' is not one of: grid, code-locations"):
        declaration.normalise(raw)
    raw["content"]["minimaps"] = ["grid"]
    with pytest.raises(declaration.DeclarationError, match="exactly three"):
        declaration.normalise(raw)


def claimed():
    """The widget declaration about real places of this repository's registries, with three computed minimaps."""
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["about"] = {
        "lens": "architecture",
        "adrs": [next(iter(declaration.minimaps.adrs()))],
        "tracks": ["python"],
        "languages": ["python"],
        "modules": ["Catzc.Base.Repository"],
        "files": ["python/Catzc.Diagrams/minimaps.py"],
    }
    raw["content"]["minimaps"] = ["code-locations", "module-neighbourhood", "axis"]
    return raw


def test_every_about_name_is_checked_against_its_registry():
    assert declaration.normalise(claimed())["about"]["tracks"] == ["python"]
    for key, wrong, message in (
        ("files", "python/Catzc.Diagrams/gone.py", "is not a file in the repository"),
        ("modules", "Catzc.Widget.Nowhere", "is not one of dependencies.yml"),
        ("tracks", "widgets", "is not one of variants.yml"),
        ("languages", "widgetese", "is not one of languages.yml"),
        ("adrs", "ADR-WIDGET-NOWHERE", "is not a rule of an ADR in adrs.yml"),
    ):
        raw = claimed()
        raw["about"][key] = [wrong]
        with pytest.raises(declaration.DeclarationError, match=message):
            declaration.normalise(raw)


def test_the_minimaps_light_what_about_names_with_a_reason():
    about = declaration.normalise(claimed())["about"]
    code = dict(declaration.minimaps.lights("code-locations", about))
    assert code["python/Catzc.Diagrams/minimaps.py"] == "about.files" and "python" in code
    assert declaration.minimaps.lights("module-neighbourhood", about) == [("Catzc.Base.Repository", "about.modules")]
    assert all("adrs.yml" in why for _, why in declaration.minimaps.lights("axis", about))


def test_put_embeds_each_minimap_as_a_picture_and_get_keeps_the_subject_through_save(tmp_path):
    raw = claimed()
    (tmp_path / declaration.SOURCE).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    first = declaration.load(tmp_path)
    model = declaration.put(first)
    assert model.count("image=data:image/png,") == 3
    declaration.put_png(tmp_path, first)
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    assert declaration.dump(declaration.load(tmp_path)) == declaration.dump(first)


def test_put_png_embeds_the_model_and_get_reads_it_back(tmp_path):
    first = widgets()
    dst = declaration.put_png(tmp_path, first)
    assert dst.name == "diagram.drawio.png"
    with Image.open(dst) as img:
        assert img.size[0] > 1500
    back = declaration.get(declaration.model_of(tmp_path), kind="explanation")
    assert declaration.dump(back) == declaration.dump(first)


def test_the_source_file_round_trips_through_load_and_save(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    source["description"] = "Widgets pass a gate on their way to the gadget store."
    (tmp_path / declaration.SOURCE).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    loaded = declaration.load(tmp_path)
    assert loaded["description"] == "Widgets pass a gate on their way to the gadget store."
    declaration.save(tmp_path, loaded)
    assert declaration.dump(declaration.load(tmp_path)) == declaration.dump(loaded)


def test_get_into_the_folder_keeps_the_description_the_drawing_cannot_carry(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    source["description"] = "Widgets pass a gate on their way to the gadget store."
    (tmp_path / declaration.SOURCE).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    back = declaration.get(declaration.model_of(tmp_path), kind="explanation")
    assert back["description"] == ""
    declaration.save(tmp_path, back)
    assert declaration.load(tmp_path)["description"] == "Widgets pass a gate on their way to the gadget store."


def test_a_folder_without_its_source_fails_naming_the_file(tmp_path):
    with pytest.raises(declaration.DeclarationError, match="no diagram.drawio.yml"):
        declaration.load(tmp_path)


def test_rule_chips_number_their_rule_and_round_trip_with_the_key_in_the_legend():
    raw = claimed()
    rules = list(declaration.minimaps.adrs())[:2]
    raw["about"]["adrs"] = rules
    raw["content"]["chips"] = [
        {"at": "gadget-gate", "kind": "rule", "rule": rules[1]},
        {"at": "gadget-gate", "kind": "rule", "rule": rules[0], "gated": False},
        {"at": "group-kit", "kind": "rule", "rule": rules[0]},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert 'value="#2"' in model and model.count("dashed=1;") >= 2  # the ADR-only chip and its legend swatch
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
    assert "fillColor=#C4915C" in model and "fillColor=#C9CCD1" in model and "opacity=60" in model
    assert 'value="commit: topic"' in model and 'value="commit: landed (ghost)"' in model
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
        {"from": "widget-a", "to": "gadget-store", "kind": "adr", "via": [[400, 520], [900, 520]]},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert '<mxPoint x="400" y="520" />' in model and 'id="e-widget-a-gadget-store~2"' in model
    back = declaration.get(model, kind="explanation")
    assert [e.get("via") for e in back["content"]["edges"] if e["kind"] == "adr" and e["from"] == "widget-a"] == [[[400, 520], [900, 520]]]


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
    raw["content"]["spans"][0]["label"] = "ado-pipelines"
    assert declaration.normalise(raw)["content"]["spans"][0]["label"] == "ado-pipelines"
    raw["content"]["spans"][0]["label"] = "pipelines"
    with pytest.raises(declaration.DeclarationError, match="ado-pipelines"):
        declaration.normalise(raw)


def test_drift_is_empty_after_put_and_names_the_cell_a_yml_edit_left_unwritten(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    (tmp_path / declaration.SOURCE).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    assert declaration.drift(tmp_path) == ([], [])
    source["content"]["glyphs"][2]["label"] = "Gadget vault"
    (tmp_path / declaration.SOURCE).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    cells, stale = declaration.drift(tmp_path)
    assert "gadget-store" in cells and stale == []


def test_labels_keep_quotes_unescaped_in_the_drawing():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["title"] = "The caller's value wins"
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "&amp;#x27;" not in model
    assert declaration.get(model, kind="explanation")["content"]["title"] == "The caller's value wins"
