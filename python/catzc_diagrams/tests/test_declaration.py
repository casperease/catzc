# cspell:ignore minimaps widgetese getpixel miny
"""The declaration of a diagram and its two directions: put (yml to model to raster) and get (model to yml).

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/catzc_diagrams/tests/test_declaration.py
"""

import re
import sys
import xml.etree.ElementTree as ET
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


def test_read_and_junction_edges_draw_their_own_line_and_legend_and_come_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"] += [
        {"from": "gadget-gate", "to": "widget-a", "kind": "read"},
        {"from": "widget-b", "to": "gadget-gate", "kind": "junction"},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "dashPattern=1 3" in model and "endArrow=open" in model and "startArrow=oval" in model
    assert 'value="reads"' in model and 'value="junction"' in model
    assert declaration.dump(declaration.get(model, kind="explanation")) == declaration.dump(first)


def test_the_thick_phrase_names_the_thick_legend_and_comes_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["thick"] = "to a truth store"
    raw["content"]["edges"].append({"from": "widget-b", "to": "gadget-store", "kind": "thick"})
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert 'value="to a truth store"' in model and 'value="to a named set"' not in model
    assert declaration.get(model, kind="explanation")["content"]["thick"] == "to a truth store"
    assert declaration.dump(declaration.get(model, kind="explanation")) == declaration.dump(first)


def test_a_thick_edge_without_a_phrase_keeps_the_library_phrase():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"].append({"from": "widget-b", "to": "gadget-store", "kind": "thick"})
    model = declaration.put(declaration.normalise(raw))
    assert 'value="to a named set"' in model
    assert declaration.get(model, kind="explanation")["content"]["thick"] == ""


def test_a_span_label_outside_the_vocabularies_fails_with_the_allowed_words():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"][0]["label"] = "sideways"
    with pytest.raises(declaration.DeclarationError, match="span 'span-build' label 'sideways' is not one of: CI, CD, DEPLOY"):
        declaration.normalise(raw)


def test_a_steep_edge_glues_its_word_right_of_the_line_and_a_flat_one_keeps_it_centred(monkeypatch):
    monkeypatch.setattr(declaration, "EDGE_LABEL", "word")  # the word presentation: the word stands beside its line
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][1]["label"] = "fails"  # a word on a line inside one band: it stays beside the line
    raw["layout"] = {"gadget-store": {"x": 800, "y": 150, "w": 220, "h": 72}, "gadget-gate": {"x": 800, "y": 320, "w": 220, "h": 72}}
    model = declaration.put(declaration.normalise(raw))  # the two ends stand one above the other, so the edge falls steeply
    steep = re.search(r'<mxCell id="e-gadget-store-gadget-gate" value="[^"]*" style="([^"]*)" [^\n]*\n\s*<mxGeometry x="(-?\d+)" y="(-?\d+)"', model)
    assert steep is not None and "align=left;" in steep.group(1) and (steep.group(2), steep.group(3)) == ("0", "-3")
    raw.pop("layout")
    model = declaration.put(declaration.normalise(raw))  # side by side on the grid, the edge runs flat
    flat = re.search(r'<mxCell id="e-gadget-store-gadget-gate" value="[^"]*" style="([^"]*)" [^\n]*\n\s*<mxGeometry relative="1"', model)
    assert flat is not None and "align=left;" not in flat.group(1)
    assert declaration.dump(declaration.get(model, kind="explanation")) == declaration.dump(declaration.normalise(raw))


def test_a_word_on_a_line_into_another_band_becomes_a_transition_bubble_on_that_border_in_the_word_presentation(monkeypatch):
    monkeypatch.setattr(declaration, "EDGE_LABEL", "word")
    first = widgets()
    model = declaration.put(first)
    bubble = re.search(r'<mxCell id="e-widget-a-gadget-store-word" value="&lt;b&gt;writes&lt;/b&gt;" style="rounded=1;arcSize=50;[^"]*" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    band = re.search(r'<mxCell id="band-gadgets" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    assert bubble is not None and band is not None
    cx = int(bubble.group(1)) + int(bubble.group(3)) / 2
    assert abs(cx - int(band.group(1))) <= 1  # centred on the border of the band being entered
    assert re.search(r'<mxCell id="e-widget-a-gadget-store" value="" ', model)  # the line keeps no word of its own
    assert "transition: into a new state" in model
    back = declaration.get(model, kind="explanation")
    assert declaration.dump(back) == declaration.dump(first)  # the word reads back from its bubble


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


def test_an_untitled_group_keeps_its_blank_label_through_get():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["groups"][1]["label"] = " "
    first = declaration.normalise(raw)
    back = declaration.get(declaration.put(first), kind="explanation")
    assert {g["id"]: g["label"] for g in back["content"]["groups"]}["group-inner"] == " "
    assert declaration.dump(back) == declaration.dump(first)


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


def test_declared_minimaps_must_be_three_known_views_and_none_declared_leaves_the_defaults_to_the_data():
    raw = __import__("yaml").safe_load(WIDGETS)
    views = lambda r: declaration.normalise(r)["content"]["minimaps"]
    assert views(raw) == []
    raw["content"]["minimaps"] = ["grid", "code-locations", "track-placement"]
    assert views(raw) == ["grid", "code-locations", "track-placement"]
    raw["content"]["minimaps"] = ["grid", "axis", "moon"]
    with pytest.raises(declaration.DeclarationError, match="minimap view 'moon' is not one of: grid, code-locations"):
        declaration.normalise(raw)
    raw["content"]["minimaps"] = ["grid"]
    with pytest.raises(declaration.DeclarationError, match="exactly three"):
        declaration.normalise(raw)
    raw["content"]["minimaps"] = ["grid", "axis", "grid"]
    with pytest.raises(declaration.DeclarationError, match="names 'grid' twice"):
        declaration.normalise(raw)


# The inputs only: the shown ids, one with the lit cell its author rejects; never a computed cell.
WIDGET_MINIMAPS = ["grid", {"axis": {"exclude": ["AUTO/*"]}}, "layer-stack"]


def test_each_minimap_is_an_id_or_its_excluded_cells_and_stored_cells_fail():
    raw = __import__("yaml").safe_load(WIDGETS)
    with_minimaps = lambda minimaps: {**raw, "content": {**raw["content"], "minimaps": minimaps}}
    assert declaration.normalise(with_minimaps(WIDGET_MINIMAPS))["content"]["minimaps"] == WIDGET_MINIMAPS
    # An entry with nothing excluded is its bare id.
    assert declaration.normalise(with_minimaps(["grid", {"axis": {"exclude": []}}, {"layer-stack": None}]))["content"]["minimaps"] == [
        "grid", "axis", "layer-stack"
    ]
    stored = {"grid": [{"cell": "widgets/widget-script", "by": ["ADR-WIDGET-SPIN"]}], "axis": [], "layer-stack": []}
    with pytest.raises(declaration.DeclarationError, match="minimaps is a list of the shown minimaps.*never the cells they light"):
        declaration.normalise(with_minimaps(stored))
    with pytest.raises(declaration.DeclarationError, match="minimaps.axis takes only exclude:"):
        declaration.normalise(with_minimaps(["grid", {"axis": {"cell": "AUTO/*"}}, "layer-stack"]))
    with pytest.raises(declaration.DeclarationError, match="minimaps.axis excludes a cell twice"):
        declaration.normalise(with_minimaps(["grid", {"axis": {"exclude": ["AUTO/*", "AUTO/*"]}}, "layer-stack"]))


def test_the_excluded_cells_survive_a_put_then_a_get_through_save(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["minimaps"] = WIDGET_MINIMAPS
    declaration.source_of(tmp_path).write_text(declaration.dump(declaration.normalise(raw)), encoding="utf-8")
    first = declaration.load(tmp_path)
    declaration.put_png(tmp_path, first)
    back = declaration.get(declaration.model_of(tmp_path), kind="explanation")
    assert back["content"]["minimaps"] == ["grid", "axis", "layer-stack"]  # the drawing carries the views, not what is excluded
    declaration.save(tmp_path, back)
    assert declaration.load(tmp_path)["content"]["minimaps"] == WIDGET_MINIMAPS


def test_declare_minimaps_prints_the_inputs_and_keeps_the_head_and_every_other_line_as_written(tmp_path):
    # A generated head and a block list of the shown ids: the rewrite prints them as save does and changes only those lines.
    head = '# ---\n# catzc:\n#   immutable:\n#     with_body_sha: "0123456789ab"\n# ---\n\n'
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["minimaps"] = ["grid", "axis", "layer-stack"]
    text = head + declaration.dump(declaration.normalise(raw))
    line = "  minimaps: [grid, axis, layer-stack]\n"
    assert line in text
    block = "  minimaps:\n    - grid\n    - axis\n    - layer-stack\n"
    declaration.source_of(tmp_path).write_text(text.replace(line, block, 1), encoding="utf-8")
    declaration.declare_minimaps(tmp_path)
    assert declaration.source_of(tmp_path).read_text(encoding="utf-8") == text
    # Run again on the inputs it wrote, it changes nothing, and an exclude: the author gave is kept.
    declaration.declare_minimaps(tmp_path)
    assert declaration.source_of(tmp_path).read_text(encoding="utf-8") == text
    excluding = text.replace(line, "  minimaps:\n    - grid\n    - axis:\n        exclude: [AUTO/*]\n    - layer-stack\n", 1)
    declaration.source_of(tmp_path).write_text(excluding, encoding="utf-8")
    declaration.declare_minimaps(tmp_path)
    assert declaration.load(tmp_path)["content"]["minimaps"] == WIDGET_MINIMAPS


def claimed():
    """The widget declaration about real places of this repository's registries, with three computed minimaps."""
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["about"] = {
        "lens": "architecture",
        "adrs": [next(iter(declaration.minimaps.adrs()))],
        "tracks": ["python"],
        "languages": ["python"],
        "modules": ["Catzc.Base.Repository"],
        "files": ["python/catzc_diagrams/minimaps.py"],
    }
    raw["content"]["minimaps"] = ["code-locations", "module-neighbourhood", "axis"]
    return raw


def test_the_subject_is_its_adr_codes_checked_against_the_registry():
    raw = claimed()
    raw["about"]["adrs"] = ["ADR-WIDGET-NOWHERE"]
    with pytest.raises(declaration.DeclarationError, match="is not a rule of an ADR in drs.yml"):
        declaration.normalise(raw)


def test_the_retired_subject_lists_are_read_ignored_and_never_written_back():
    about = declaration.normalise(claimed())["about"]
    assert set(about) == {"lens", "adrs"}
    assert all(key not in declaration.dump(declaration.normalise(claimed())) for key in ("tracks:", "languages:", "modules:", "files:"))
    raw = claimed()
    raw["about"]["gadgets"] = ["widget"]
    with pytest.raises(declaration.DeclarationError, match="about key 'gadgets' is not one of: adrs, lens"):
        declaration.normalise(raw)


def test_put_embeds_each_minimap_as_a_picture_and_get_keeps_the_subject_through_save(tmp_path):
    raw = claimed()
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    first = declaration.load(tmp_path)
    model = declaration.put(first)
    assert model.count("image=data:image/png,") == 3
    declaration.put_png(tmp_path, first)
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    assert declaration.dump(declaration.load(tmp_path)) == declaration.dump(first)


def test_put_png_embeds_the_model_and_get_reads_it_back(tmp_path):
    first = widgets()
    dst = declaration.put_png(tmp_path, first)
    assert dst == tmp_path.with_name(tmp_path.name + ".drawio.png")
    with Image.open(dst) as img:
        assert img.size[0] > 1500
    back = declaration.get(declaration.model_of(tmp_path), kind="explanation")
    # A declaration that names no minimaps takes the folder's data's three, and get writes them out.
    assert list(back["content"]["minimaps"]) == list(declaration.minimap_data(tmp_path))
    assert declaration.dump(back) == declaration.dump({**first, "content": {**first["content"], "minimaps": back["content"]["minimaps"]}})


def test_the_source_file_round_trips_through_load_and_save(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    source["description"] = "Widgets pass a gate on their way to the gadget store."
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    loaded = declaration.load(tmp_path)
    assert loaded["description"] == "Widgets pass a gate on their way to the gadget store."
    declaration.save(tmp_path, loaded)
    assert declaration.dump(declaration.load(tmp_path)) == declaration.dump(loaded)


def test_get_into_the_folder_keeps_the_description_the_drawing_cannot_carry(tmp_path):
    source = __import__("yaml").safe_load(WIDGETS)
    source["description"] = "Widgets pass a gate on their way to the gadget store."
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(source, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    back = declaration.get(declaration.model_of(tmp_path), kind="explanation")
    assert back["description"] == ""
    declaration.save(tmp_path, back)
    assert declaration.load(tmp_path)["description"] == "Widgets pass a gate on their way to the gadget store."


def test_a_diagram_without_its_source_fails_naming_the_file(tmp_path):
    with pytest.raises(declaration.DeclarationError, match="needs exactly one `yml drawio` block above its image, found 0"):
        declaration.load(tmp_path)  # neither a yml nor a block: the shipped default carrier, the article, is the one that is missing


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
    assert "fillColor=#C4915C" in model and "fillColor=#C9CCD1" in model and "opacity=60" in model
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
        {"from": "widget-a", "to": "gadget-store", "kind": "adr", "via": [[400, 520], [900, 520]]},
    ]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    box = {c["id"]: c for c in declaration.place(first)[0]}
    frame = box[box["e-widget-a-gadget-store~2"]["parent"]]  # the model holds a framed edge's waypoints relative to its frame
    assert f'<mxPoint x="{400 - frame["x"]}" y="{520 - frame["y"]}" />' in model and 'id="e-widget-a-gadget-store~2"' in model
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


def committed_pair(folder, source):
    """Write a pair the way a commit holds it: the yml, and the png put from it; the pair's text and model are the base."""
    text = __import__("yaml").safe_dump(source, sort_keys=False)
    declaration.source_of(folder).write_text(text, encoding="utf-8")
    declaration.put_png(folder, declaration.load(folder))
    return text, declaration.model_of(folder)


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
    computed = declaration.minimap_data

    # The tree the minimaps read changed under them: the same declaration now computes data that lights a cell.
    def changed(folder):
        reason = {"subject": "widgets/a.ps1", "basis": "citation", "requested": "ADR-WIDGET", "note": None}
        lit = {"axes": [{"name": "track", "values": ["widgets"]}], "cells": [{"at": ["widgets"], "count": 1}]}
        return {view: {**data, **lit, "lit": [{"at": ["widgets"], "count": 1, "reasons": [reason]}]} for view, data in computed(folder).items()}

    monkeypatch.setattr(declaration, "minimap_data", changed)
    cells, stale = declaration.drift(tmp_path)
    assert cells == [] and stale and all(cell.startswith("minimap-") for cell in stale)


def test_a_base_citing_a_code_the_registry_no_longer_has_is_read_as_data(tmp_path):
    text, model = committed_pair(tmp_path, __import__("yaml").safe_load(WIDGETS))
    retired = __import__("yaml").safe_load(text)
    retired.setdefault("about", {})["adrs"] = ["ADR-WIDGET-RETIRED-GONE"]
    base = (__import__("yaml").safe_dump(retired, sort_keys=False), model)
    assert declaration.conflict(tmp_path, base) == []


def vocabulary_cases():
    """Each closed vocabulary: how to put a value outside it into the widget declaration, and every value it allows."""
    pools = declaration.DEFAULTS["minimaps"]

    def span(raw):
        raw["content"]["spans"][0]["label"] = "sideways"

    def glyph(raw):
        raw["content"]["glyphs"][0]["kind"] = "blob"

    def edge(raw):
        raw["content"]["edges"][0]["kind"] = "wobble"

    def minimap(raw):
        raw["content"]["minimaps"] = ["grid", "axis", "moon"]

    def flow(raw):
        raw["content"]["flow"] = "inside-out"

    def theme(raw):
        raw["content"]["theme"] = "sepia"

    return [
        ("span label", span, tuple(declaration.span_vocabulary())),
        ("glyph kind", glyph, declaration.GLYPH_KINDS),
        ("edge kind", edge, declaration.EDGE_KINDS),
        ("minimap view", minimap, tuple(str(pools["ids"]).replace(",", " ").split())),
        ("flow", flow, declaration.FLOWS),
        ("theme", theme, tuple(declaration.DEFAULTS["themes"])),
    ]


@pytest.mark.parametrize("name,spoil,allowed", vocabulary_cases(), ids=[case[0] for case in vocabulary_cases()])
def test_a_value_outside_a_vocabulary_fails_naming_every_value_it_allows(name, spoil, allowed):
    raw = __import__("yaml").safe_load(WIDGETS)
    spoil(raw)
    with pytest.raises(declaration.DeclarationError) as error:
        declaration.normalise(raw)
    assert "is not one of: " in str(error.value)
    listed = str(error.value).split("is not one of: ", 1)[1].split(", ")
    assert set(allowed) <= set(listed), f"{name}: the error leaves out {sorted(set(allowed) - set(listed))}"


def test_one_declaration_renders_in_every_theme_from_its_token_sets():
    dark, light = (declaration.put(widgets(), theme) for theme in ("dark", "light"))
    assert 'background="#1E2430"' in dark and 'background="#FFFFFF"' in light
    assert "@" not in "".join(__import__("re").findall(r'style="([^"]*)"', dark + light))


def test_a_theme_other_than_the_default_renders_to_out_and_leaves_the_committed_png(tmp_path):
    committed_pair(tmp_path, __import__("yaml").safe_load(WIDGETS))
    before = declaration.slide_of(tmp_path).read_bytes()
    dst = declaration.put_png(tmp_path, declaration.load(tmp_path), "light")
    assert dst.parts[-4:-1] == ("drawio", "themes", "light") and dst.name == declaration.slide_of(tmp_path).name and dst.is_file()
    assert declaration.slide_of(tmp_path).read_bytes() == before


def test_a_style_token_no_theme_defines_fails_naming_the_tokens():
    with pytest.raises(KeyError, match="'@nowhere' is not one of: page, band"):
        declaration.paint("fillColor=@nowhere;")


def test_the_glyph_library_names_colours_only_as_tokens():
    library = (declaration.KIT / "assets" / "glyphs.xml").read_text(encoding="utf-8")
    assert __import__("re").findall(r"#[0-9A-Fa-f]{6}", library) == []


def test_tidy_re_saves_a_source_without_its_retired_keys_and_changes_nothing_else(tmp_path):
    raw = claimed()
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    before = declaration.load(tmp_path)
    declaration.save(tmp_path, declaration.load(tmp_path))
    text = declaration.source_of(tmp_path).read_text(encoding="utf-8")
    assert all(key not in text for key in ("tracks:", "languages:", "modules:", "files:"))
    assert declaration.dump(declaration.load(tmp_path)) == declaration.dump(before)


def test_a_commit_drawn_as_a_box_keeps_its_palette_state_and_comes_back():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"].append({"id": "rung-bvt", "kind": "commit", "label": "BVT", "in": "band-gadgets", "shape": "box", "state": "bvt"})
    raw["content"]["glyphs"].append({"id": "rung-gone", "kind": "commit", "label": "discarded", "in": "band-gadgets", "shape": "box", "state": "discarded"})
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert 'commitShape=box' in model and "fillColor=#8E2424" in model
    back = declaration.get(model, kind="explanation")
    assert declaration.dump(back) == declaration.dump(first)
    boxes = {g["id"]: g for g in back["content"]["glyphs"] if g.get("shape") == "box"}
    assert boxes["rung-gone"]["state"] == "discarded" and boxes["rung-gone"]["kind"] == "commit"


def test_a_commit_shape_outside_the_vocabulary_fails_with_the_shapes():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["glyphs"].append({"id": "c-x", "kind": "commit", "label": "x", "in": "band-gadgets", "shape": "star"})
    with pytest.raises(declaration.DeclarationError, match="shape 'star' is not one of: dot, box"):
        declaration.normalise(raw)


def test_a_note_is_a_free_text_block_in_its_band_and_comes_back_line_for_line():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["notes"] = [{"id": "note-key", "in": "band-gadgets", "text": "PR: Pull Request\nCI: Continuous Integration <basic>"}]
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "noteBlock=1" in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["notes"] == first["content"]["notes"]
    assert declaration.dump(back) == declaration.dump(first)


def test_a_note_sits_in_a_band_or_a_group_and_nowhere_else():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["notes"] = [{"id": "note-key", "in": "widget-a", "text": "x"}]
    with pytest.raises(declaration.DeclarationError, match="note 'note-key' in 'widget-a' is not one of: band-widgets"):
        declaration.normalise(raw)


ROWS = {
    "templates": {"widget-shape": {"states": {"PR": "landed", "BVT": "bvt", "ship": "prod"}, "drop": "discarded"}},
    "rows": [
        {"id": "row-full", "template": "widget-shape", "label": "PR + ship", "in": "band-gadgets", "start": "topic", "steps": ["PR", "BVT", "ship"]},
        {"id": "row-short", "template": "widget-shape", "label": "ship", "in": "band-gadgets", "start": "bvt", "steps": ["ship"]},
    ],
}


def test_a_row_of_a_template_writes_out_its_dots_drops_and_labelled_edges():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(ROWS)
    content = declaration.normalise(raw)["content"]
    dots = {g["id"]: g.get("state", "bvt") for g in content["glyphs"] if g["id"].startswith("row-full-") and not g["id"].endswith("-drop")}
    assert dots == {"row-full-0": "topic", "row-full-1": "landed", "row-full-2": "bvt", "row-full-3": "prod"}
    labels = [e.get("label") for e in content["edges"] if e["from"].startswith("row-full-") and e["kind"] == "flow"]
    assert labels == ["PR", "BVT", "ship"]
    assert sum(1 for e in content["edges"] if e["kind"] == "fail" and e["from"].startswith("row-")) == 6


def test_declare_minimaps_keeps_the_rows_and_an_edge_between_their_cells(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(ROWS)
    raw["content"]["edges"].append({"from": "row-full-0", "to": "row-short-0", "kind": "adr"})  # both ends are cells the rows write out
    raw["content"]["minimaps"] = WIDGET_MINIMAPS
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    declaration.declare_minimaps(tmp_path)
    written = __import__("yaml").safe_load(declaration.source_of(tmp_path).read_text(encoding="utf-8"))
    assert written["content"]["rows"] == ROWS["rows"]
    assert {"from": "row-full-0", "to": "row-short-0", "kind": "adr"} in written["content"]["edges"]
    assert {k: v for k, v in written["content"].items() if k != "minimaps"} == {k: v for k, v in raw["content"].items() if k != "minimaps"}


def test_a_row_is_written_back_as_a_row_and_a_get_of_its_drawing_keeps_it(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(ROWS)
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    first = declaration.load(tmp_path)
    text = declaration.dump(first)
    assert "rows:" in text and "row-full-0" not in text
    declaration.put_png(tmp_path, first)
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    again = declaration.source_of(tmp_path).read_text(encoding="utf-8")
    assert "rows:" in again and "row-full-0:" not in again.split("layout:")[0]


def test_a_row_step_outside_its_template_fails_with_the_steps():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(ROWS))
    raw["content"]["rows"][1]["steps"] = ["sideways"]
    with pytest.raises(declaration.DeclarationError, match="row 'row-short' step 'sideways' is not one of: PR, BVT, ship"):
        declaration.normalise(raw)


def test_a_skipped_step_draws_a_bypass_under_the_dot_it_skips_and_the_row_keeps_its_skip(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(ROWS))
    raw["content"]["rows"][0]["skip"] = ["BVT"]
    first = declaration.normalise(raw)
    assert {"from": "row-full-1", "to": "row-full-3", "kind": "bypass", "label": ""} in first["content"]["edges"]
    box = {c["id"]: c for c in declaration.place(first)[0]}
    low = {y for _, y in box["e-row-full-1-row-full-3"]["via"]}
    assert low == {box["row-full-1"]["y"] + box["row-full-1"]["h"] + declaration.BYPASS_DIP}
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    again = declaration.source_of(tmp_path).read_text(encoding="utf-8")
    assert "skip: [BVT]" in again and "row-full-0:" not in again.split("layout:")[0]


def test_a_skip_of_a_row_last_step_fails_with_the_steps_it_can_skip():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(ROWS))
    raw["content"]["rows"][0]["skip"] = ["ship"]
    with pytest.raises(declaration.DeclarationError, match="row 'row-full' skip 'ship' is not one of: PR, BVT"):
        declaration.normalise(raw)


LANE = {
    "flow": "top-to-bottom",
    "bands": [{"id": "band-widgets", "label": "Widgets"}, {"id": "band-gadgets", "label": "Gadgets"}, {"id": "band-git", "label": "GIT"}],
    "lanes": [
        {
            "band": "band-git",
            "steps": 6,
            "trunk": "main",
            "commits": [
                {"id": "g1", "step": 1, "label": "1", "state": "landed"},
                {"id": "g2", "step": 2, "row": 1, "label": "2", "state": "topic", "from": "g1"},
                {"id": "g3", "step": 4, "label": "3", "from": "g2"},
            ],
            "marks": [{"at": "g3", "text": "dirty head"}],
        }
    ],
    "rules": [{"after": 2, "kind": "manual"}, {"after": 4, "kind": "automated"}],
}


def lane_widgets():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(LANE))  # a copy, so no test's added commit reaches the next
    raw["content"]["spans"] = []
    return raw


def test_a_lane_places_its_commits_by_step_and_row_and_draws_its_trunk_marks_and_rules():
    first = declaration.normalise(lane_widgets())
    cells, _ = declaration.place(first)
    box = {c["id"]: c for c in cells}
    assert box["g1"]["y"] == box["g3"]["y"] and box["g2"]["y"] < box["g1"]["y"]  # on the trunk, and the branch above it
    assert box["g1"]["x"] < box["g2"]["x"] < box["g3"]["x"]
    assert {"lane-band-git-trunk", "lane-band-git-mark-0", "lane-rule-0", "lane-rule-1"} <= set(box)
    assert box["lane-rule-0-a"]["x"] < box["lane-rule-1-a"]["x"]


def test_a_left_and_a_right_slot_stand_side_by_side_on_their_step_and_a_centre_slot_stays_on_it():
    raw = lane_widgets()
    raw["content"]["lanes"][0]["commits"] += [
        {"id": "s-one", "step": 5, "row": -1, "slot": "left", "label": "1"},
        {"id": "s-two", "step": 5, "row": -1, "slot": "right", "label": "2"},
        {"id": "s-top", "step": 5, "row": 1, "label": "3"},
    ]
    box = {c["id"]: c for c in declaration.place(declaration.normalise(raw))[0]}
    assert box["s-one"]["y"] == box["s-two"]["y"] and box["s-one"]["x"] + box["s-one"]["w"] < box["s-two"]["x"]
    assert box["s-one"]["x"] + box["s-two"]["x"] == 2 * box["s-top"]["x"]  # the pair is centred on the step its centre commit stands on
    assert box["s-top"]["y"] < box["s-one"]["y"]


def ladder_widgets():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"] = []
    raw["content"]["glyphs"] += [{"id": "gadget-top", "kind": "env", "label": "Top gadget", "in": "band-gadgets"}]
    raw["content"]["edges"] += [{"from": "gadget-gate", "to": "gadget-top", "kind": "adr"}]
    raw["content"]["ladders"] = [{"band": "band-gadgets", "rise": 30, "w": 150, "h": 80}]
    return raw


def test_a_ladder_climbs_its_band_left_to_right_along_the_forward_edges_and_the_source_keeps_the_hint(tmp_path):
    first = declaration.normalise(ladder_widgets())
    box = {c["id"]: c for c in declaration.place(first)[0]}
    # store -> gate -> top: each rung 150 by 80, right of and 30 px above the one before, the first on the band's floor and the last
    # against the band's right padding
    assert all((box[r]["w"], box[r]["h"]) == (150, 80) for r in ("gadget-store", "gadget-gate", "gadget-top"))
    assert box["gadget-store"]["x"] == box["band-gadgets"]["x"] + declaration.PAD
    assert box["gadget-store"]["x"] < box["gadget-gate"]["x"] < box["gadget-top"]["x"]
    assert box["gadget-top"]["x"] + 150 == box["band-gadgets"]["x"] + box["band-gadgets"]["w"] - declaration.PAD
    assert box["gadget-store"]["y"] + box["gadget-store"]["h"] == box["band-gadgets"]["y"] + box["band-gadgets"]["h"] - declaration.PAD
    assert box["gadget-store"]["y"] + box["gadget-store"]["h"] - 30 == box["gadget-gate"]["y"] + box["gadget-gate"]["h"]
    assert box["gadget-gate"]["y"] + box["gadget-gate"]["h"] - 30 == box["gadget-top"]["y"] + box["gadget-top"]["h"]
    # a climb leaves the rung's top centre, runs up, then right into the next rung's left centre: one waypoint routes it
    cells = declaration.place(first)[0]
    climb = next(c for c in cells if c["id"] == "e-gadget-gate-gadget-top")
    assert climb["via"] == [
        [round(box["gadget-gate"]["x"] + box["gadget-gate"]["w"] / 2), round(box["gadget-top"]["y"] + box["gadget-top"]["h"] / 2)]
    ]
    assert "ladders:" in declaration.dump(first) and "via:" not in declaration.dump(first)
    declaration.source_of(tmp_path).write_text(declaration.dump(first), encoding="utf-8")
    declaration.put_png(tmp_path, first)
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    again = declaration.source_of(tmp_path).read_text(encoding="utf-8")
    assert "ladders:" in again and "via:" not in again  # the ladder's own route never comes back as a hand waypoint


def test_a_ladder_names_a_band_and_a_rise_from_1():
    raw = ladder_widgets()
    raw["content"]["ladders"] = [{"band": "group-kit", "rise": 30}]
    with pytest.raises(declaration.DeclarationError, match="ladder band 'group-kit' is not one of: band-widgets, band-gadgets"):
        declaration.normalise(raw)
    raw["content"]["ladders"] = [{"band": "band-gadgets", "rise": 0}]
    with pytest.raises(declaration.DeclarationError, match="rise is a whole number of px from 1"):
        declaration.normalise(raw)
    raw["content"]["ladders"] = [{"band": "band-gadgets", "rise": 30, "w": 150}]
    with pytest.raises(declaration.DeclarationError, match="w and h are a rung's size in px, both or neither"):
        declaration.normalise(raw)


def test_a_lane_slot_outside_left_centre_right_fails_with_the_slots():
    raw = lane_widgets()
    raw["content"]["lanes"][0]["commits"][0]["slot"] = "middle"
    with pytest.raises(declaration.DeclarationError, match="left, centre, right"):
        declaration.normalise(raw)


def test_a_lane_is_written_back_as_a_lane_and_a_get_of_its_drawing_keeps_it(tmp_path):
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(lane_widgets(), sort_keys=False), encoding="utf-8")
    first = declaration.load(tmp_path)
    assert "lanes:" in declaration.dump(first) and "id: g1\n    kind" not in declaration.dump(first)
    declaration.put_png(tmp_path, first)
    declaration.save(tmp_path, declaration.get(declaration.model_of(tmp_path), kind="explanation"))
    again = declaration.source_of(tmp_path).read_text(encoding="utf-8")
    assert "lanes:" in again and "rules:" in again


def test_a_lane_names_its_gate_rules_in_the_legend_and_a_span_over_its_glyphs_lies_above_its_band():
    raw = lane_widgets()
    raw["content"]["spans"] = [{"id": "span-ci", "label": "CI", "over": ["g1", "g3"]}]
    first = declaration.normalise(raw)
    box = {c["id"]: c for c in declaration.place(first)[0]}
    assert {box["lg-rule-manual-t"]["value"], box["lg-rule-automated-t"]["value"]} == {"manual gate", "automated gate"}
    assert "rotation=90" not in box["span-ci"]["style"] and box["span-ci"]["y"] < box["band-git"]["y"]
    assert box["span-ci"]["x"] == box["g1"]["x"]


def pixel(declared, x, y):
    """The colour the raster paints at a page point, and the model it was painted from."""
    cells = declaration.place(declared)[0]
    minx = min(c["x"] for c in cells if not c["edge"]) - 20
    miny = min(c["y"] for c in cells if not c["edge"]) - 20
    model = declaration.put(declared)
    image = declaration.render(ET.fromstring(model), page="model").convert("RGB")
    return image.getpixel((round(x - minx), round(y - miny))), model


def near(rgb, hex_colour, slack=24):
    want = tuple(int(hex_colour.lstrip("#")[i : i + 2], 16) for i in (0, 2, 4))
    return all(abs(a - b) <= slack for a, b in zip(rgb, want))


def test_a_line_crossing_a_commit_passes_beneath_it_in_the_model_and_the_raster():
    raw = lane_widgets()
    raw["content"]["lanes"][0]["commits"] += [
        {"id": "c-top", "step": 5, "row": 1, "label": "1", "state": "landed"},
        {"id": "c-mid", "step": 5, "label": "2", "state": "l3"},
        {"id": "c-low", "step": 5, "row": -1, "label": "3", "state": "landed"},
    ]
    raw["content"]["edges"] = [{"from": "c-top", "to": "c-low", "kind": "fail"}]
    first = declaration.normalise(raw)
    mid = {c["id"]: c for c in declaration.place(first)[0]}["c-mid"]
    colour, model = pixel(first, mid["x"] + mid["w"] / 2, mid["y"] + 4)
    assert model.index('id="e-c-top-c-low"') < model.index('id="c-mid"')
    assert near(colour, declaration.COMMITS["l3"][0])


def test_an_edge_crossing_a_band_title_passes_beneath_the_title_in_the_model_and_the_raster():
    raw = __import__("yaml").safe_load(WIDGETS)
    content = raw["content"]
    content.update({"flow": "top-to-bottom", "spans": [], "groups": [], "markers": [], "chips": []})
    content["glyphs"] = [
        {"id": "top-gate", "kind": "gate", "label": "Top", "in": "band-widgets"},
        {"id": "low-gate", "kind": "gate", "label": "Low", "in": "band-gadgets"},
    ]
    content["edges"] = [{"from": "top-gate", "to": "low-gate", "kind": "fail"}]
    title = {c["id"]: c for c in declaration.place(declaration.normalise(raw))[0]}["band-gadgets-title"]
    column = title["x"] + title["w"] - 5  # the edge runs down the margin the box keeps right of its word
    raw["layout"] = {
        "top-gate": {"x": column - 20, "y": title["y"] - 120, "w": 40, "h": 30},
        "low-gate": {"x": column - 20, "y": title["y"] + 80, "w": 40, "h": 30},
    }
    first = declaration.normalise(raw)
    colour, model = pixel(first, column, title["y"] + title["h"] / 2)
    assert model.index('id="e-top-gate-low-gate"') < model.index('id="band-gadgets-title"')
    assert near(colour, declaration.paint("@band"))  # the title box hides the line where it crosses
    below, _ = pixel(first, column, title["y"] + title["h"] + 8)
    assert near(below, declaration.paint("@red-rim"), slack=40)  # and the line shows again under the box


def test_a_bypass_passes_beneath_the_discard_arrow_it_crosses():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(ROWS))
    raw["content"]["rows"][0]["skip"] = ["BVT"]
    first = declaration.normalise(raw)
    box = {c["id"]: c for c in declaration.place(first)[0]}
    assert box["e-row-full-1-row-full-3"]["parent"] == box["e-row-full-2-row-full-2-drop"]["parent"] == "row-full"
    skipped = box["row-full-2"]
    colour, model = pixel(first, skipped["x"] + skipped["w"] / 2, box["e-row-full-1-row-full-3"]["via"][0][1])
    assert model.index('id="e-row-full-1-row-full-3"') < model.index('id="e-row-full-2-row-full-2-drop"') < model.index('id="row-full-2"')
    assert near(colour, declaration.paint("@red-rim"))


def test_an_edge_leaving_a_frame_passes_beneath_a_glyph_inside_another_frame():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["layout"] = {
        "widget-a": {"x": 60, "y": 300, "w": 120, "h": 40},
        "widget-b": {"x": 260, "y": 300, "w": 120, "h": 40},
        "gadget-store": {"x": 700, "y": 300, "w": 120, "h": 40},
    }
    first = declaration.normalise(raw)
    box = {c["id"]: c for c in declaration.place(first)[0]}
    assert box["e-widget-a-gadget-store"]["parent"] == "group-inner"  # the one frame that holds no frame
    inner = box["widget-b"]
    colour, model = pixel(first, inner["x"] + 6, inner["y"] + inner["h"] / 2)
    assert model.index('id="e-widget-a-gadget-store"') < model.index('id="widget-b"')
    fill = declaration.style_map(declaration.paint(declaration.LIB["glyphs"]["type"]["style"]))["fillColor"]
    assert near(colour, fill)


def test_a_pair_whose_sides_both_moved_but_draw_the_same_is_no_conflict_whatever_the_drawing_cannot_carry(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update({"kind": "reference", "relation": "feeds (data moves)"})
    raw["layout"] = {"band-widgets": {"x": 20, "y": 108, "w": 1260, "h": 200}, "band-gadgets": {"x": 20, "y": 330, "w": 1260, "h": 200}}
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    base = ("content: {}\n", "<mxGraphModel />")  # both sides moved from it
    # kind is never drawn, the stacked bands read as top-to-bottom, and the legend drops the relation's parenthesis
    assert declaration.get(declaration.model_of(tmp_path))["content"]["flow"] == "top-to-bottom"
    assert declaration.conflict(tmp_path, base) == []


def test_a_conflict_names_the_drawn_cells_and_never_a_derived_one(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    raw["content"]["glyphs"][2]["kind"] = "file"  # the yml moves on: a new kind for gadget-store, and with it a new legend row
    declaration.source_of(tmp_path).write_text(__import__("yaml").safe_dump(raw, sort_keys=False), encoding="utf-8")
    cells = declaration.conflict(tmp_path, ("content: {}\n", "<mxGraphModel />"))
    assert "gadget-store" in cells and not [c for c in cells if c.startswith(declaration.DERIVED_PREFIXES) or c in declaration.DERIVED]


def test_get_reads_spans_chips_and_laid_out_bands_back_in_their_declared_order():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["spans"] = [
        {"id": "span-wide", "label": "CD", "over": ["band-widgets", "band-gadgets"]},
        {"id": "span-narrow", "label": "CI", "over": ["band-widgets"]},
    ]
    raw["content"]["chips"] = [{"at": "gadget-store", "kind": "count", "text": str(n)} for n in (7, 8, 9)]
    raw["layout"] = {"band-widgets": {"x": 20, "y": 140, "w": 300, "h": 400}, "band-gadgets": {"x": 340, "y": 120, "w": 940, "h": 420}}
    first = declaration.normalise(raw)
    read = declaration.get(declaration.put(first), kind="explanation")["content"]
    assert [s["id"] for s in read["spans"]] == ["span-wide", "span-narrow"]
    assert read["chips"] == first["content"]["chips"]  # the third chip, far along its row, still names its row's corner
    assert [b["id"] for b in read["bands"]] == ["band-gadgets", "band-widgets"]  # read top first: the layout drew no order
    back = declaration.undrawn(read, first)
    assert [b["id"] for b in back["bands"]] == ["band-widgets", "band-gadgets"]


def test_a_laid_out_item_keeps_its_declared_band_when_it_sits_between_bands():
    raw = __import__("yaml").safe_load(WIDGETS)
    first = declaration.normalise(raw)
    box = {c["id"]: c for c in declaration.place(first)[0]}
    gap_y = (box["band-widgets"]["y"] + box["band-widgets"]["h"] + box["band-gadgets"]["y"]) // 2 if box["band-gadgets"]["y"] > box["band-widgets"]["y"] else 20
    raw["layout"] = {"gadget-gate": {"x": 1290, "y": gap_y, "w": 60, "h": 40}}  # right of every band: in no band
    first = declaration.normalise(raw)
    back = declaration.undrawn(declaration.get(declaration.put(first), kind="explanation")["content"], first)
    assert {g["id"]: g["in"] for g in back["glyphs"]}["gadget-gate"] == "band-gadgets"


def test_a_layout_that_moves_an_item_out_of_its_band_fails_naming_the_band_it_sits_in():
    raw = __import__("yaml").safe_load(WIDGETS)
    first = declaration.normalise(raw)
    gadgets = {c["id"]: c for c in declaration.place(first)[0]}["band-gadgets"]
    raw["layout"] = {"group-kit": {"x": gadgets["x"] + 40, "y": gadgets["y"] + 40, "w": 200, "h": 120}}
    with pytest.raises(declaration.DeclarationError, match="layout places 'group-kit' in band-gadgets, but its in: is band-widgets"):
        declaration.place(declaration.normalise(raw))


def test_span_room_moves_the_drawing_but_a_put_then_a_get_returns_the_declared_geometry_byte_equal(tmp_path):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][0]["via"] = [[400, 300], [900, 300]]
    raw["content"]["minimaps"] = ["grid", "axis", "layer-stack"]  # the three the fixture data draws, so get reads back what is declared
    raw["layout"] = {"band-widgets": {"x": 20, "y": 60, "w": 620, "h": 300}, "band-gadgets": {"x": 660, "y": 60, "w": 620, "h": 300}}
    text = declaration.dump(declaration.normalise(raw))
    declaration.source_of(tmp_path).write_text(text, encoding="utf-8")
    declaration.put_png(tmp_path, declaration.load(tmp_path))
    model = declaration.model_of(tmp_path)
    title = ET.fromstring(model).find(".//mxCell[@id='title']")
    assert title is not None
    shift = declaration.shift_of(title.get("style"))
    assert shift > 0  # the span over the high bands reached into the title, so the drawing area moved down
    declaration.save(tmp_path, declaration.get(model, kind="explanation"))
    assert declaration.source_of(tmp_path).read_text(encoding="utf-8") == text


def test_a_rule_and_a_lane_commit_outside_their_vocabularies_fail_with_the_allowed_values():
    raw = lane_widgets()
    raw["content"]["rules"] = [{"after": 2, "kind": "sometimes"}]
    with pytest.raises(declaration.DeclarationError, match="rule kind 'sometimes' is not one of: manual, automated"):
        declaration.normalise(raw)
    raw = lane_widgets()
    raw["content"]["lanes"][0]["commits"][0]["row"] = 2
    with pytest.raises(declaration.DeclarationError, match="row '2' is not one of: -1, 0, 1"):
        declaration.normalise(raw)


def test_a_leaf_mapping_that_fits_is_one_flow_line_and_one_over_the_width_stays_block():
    data = {"glyphs": [{"id": "widget", "kind": "set", "label": "1 widget"}, {"id": "gadget", "label": "g" * 60}]}
    text = declaration.flow_yaml(data, 60)
    assert "  - { id: widget, kind: set, label: 1 widget }\n" in text
    assert "  - id: gadget\n    label:" in text
    assert __import__("yaml").safe_load(text) == data


def test_a_nested_mapping_stays_block_and_its_leaves_flow():
    data = {"widget": {"gadget": {"a": 1, "b": "two"}, "sprockets": ["cog", "gear"]}}
    text = declaration.flow_yaml(data, 140)
    assert text == "widget:\n  gadget: { a: 1, b: two }\n  sprockets: [cog, gear]\n"
    assert __import__("yaml").safe_load(text) == data


def test_an_empty_string_and_a_scalar_that_needs_quotes_round_trip_in_flow():
    data = {"widgets": [{"id": "widget", "label": ""}, {"id": "gadget", "label": "EXAMPLES: widget, gadget"}], "flag": ["yes", "1"]}
    text = declaration.flow_yaml(data, 140)
    assert '- { id: widget, label: "" }' in text
    assert 'label: "EXAMPLES: widget, gadget" }' in text
    assert __import__("yaml").safe_load(text) == data


def test_a_long_plain_text_is_filled_under_its_key_and_beside_its_dash_within_the_width():
    words = " ".join(f"widget{n}" for n in range(30))
    data = {"description": words, "notes": [words]}
    text = declaration.flow_yaml(data, 60)
    lines = text.splitlines()
    assert lines[0] == "description:" and lines[1].startswith("  widget0 ")
    assert any(line.startswith("  - widget0 ") for line in lines)
    assert all(len(line) <= 60 for line in lines)
    assert __import__("yaml").safe_load(text) == data


def test_a_long_or_multi_line_quoted_text_prints_as_prettier_does():
    # The expected text is Prettier 3.9.4's output for the same data at printWidth 140, proseWrap always.
    long = "Widgets: a long widget text that is long enough to pass the width of one hundred and forty characters when its key sits beside"
    data = {"widgets": {
        "description": long + " it on the line, so it moves under the key.",
        "legend": "W: Widget\nG: Gadget\n\nS: Sprocket (hands on)",
        "short": "W: widget",
        "notes": [long + " it on the dash line", "W: widget\nG: gadget"],
    }}
    assert declaration.flow_yaml(data, 140) == (
        "widgets:\n"
        "  description:\n"
        "    \"Widgets: a long widget text that is long enough to pass the width of one hundred and forty characters when its key sits beside it on\n"
        "    the line, so it moves under the key.\"\n"
        "  legend: \"W: Widget\n"
        "\n"
        "    G: Gadget\n"
        "\n"
        "\n"
        "    S: Sprocket (hands on)\"\n"
        "  short: \"W: widget\"\n"
        "  notes:\n"
        "    - \"Widgets: a long widget text that is long enough to pass the width of one hundred and forty characters when its key sits beside it on\n"
        "      the dash line\"\n"
        "    - \"W: widget\n"
        "\n"
        "      G: gadget\"\n"
    )
    assert __import__("yaml").safe_load(declaration.flow_yaml(data, 140)) == data


def test_the_minimaps_block_is_the_printed_form_of_the_shown_ids_and_their_excludes():
    assert declaration.minimaps_block(["grid", "axis", "layer-stack"], 140) == ["  minimaps: [grid, axis, layer-stack]"]
    assert declaration.minimaps_block([], 140) == []
    placed = ["grid", {"axis": {"exclude": ["widgets/widget", "widgets/gadget"]}}, "layer-stack"]
    for width in (140, 30):
        text = "\n".join(declaration.minimaps_block(placed, width)) + "\n"
        assert all(len(line) <= width for line in text.splitlines())
        assert __import__("yaml").safe_load("content:\n" + text) == {"content": {"minimaps": placed}}
        assert text == "".join("  " + line + "\n" for line in declaration.flow_yaml({"minimaps": placed}, width - 2).splitlines())


def test_print_width_reads_the_markdown_max_line_length_and_fails_without_it(tmp_path):
    config = tmp_path / ".editorconfig"
    config.write_text("root = true\n\n[*]\nmax_line_length = 80\n\n[*.md]\nmax_line_length = 99\n", encoding="utf-8")
    assert declaration.print_width(tmp_path) == 99
    config.write_text("[*]\nmax_line_length = 80\n", encoding="utf-8")
    with pytest.raises(declaration.DeclarationError, match=r"\[\*\.md\] has no max_line_length"):
        declaration.print_width(tmp_path)
    config.unlink()
    with pytest.raises(declaration.DeclarationError, match="not found"):
        declaration.print_width(tmp_path)


def test_reflow_keeps_the_head_and_the_rows_and_refuses_a_text_that_loads_differently(tmp_path, monkeypatch):
    head = '# ---\n# catzc:\n#   immutable:\n#     with_body_sha: "0123456789ab"\n# ---\n\n'
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(ROWS))
    text = head + __import__("yaml").safe_dump(raw, sort_keys=False)
    declaration.source_of(tmp_path).write_text(text, encoding="utf-8")
    declaration.reflow(tmp_path)
    again = declaration.source_of(tmp_path).read_text(encoding="utf-8")
    assert again.startswith(head)
    assert __import__("yaml").safe_load(again) == raw  # the rows are kept as written, never expanded
    assert "row-full-0" not in again
    assert len(again.splitlines()) < len(text.splitlines())
    printed = declaration.flow_yaml
    monkeypatch.setattr(declaration, "flow_yaml", lambda data, width: printed(data, width).replace(raw["content"]["title"], "Gadgets"))
    with pytest.raises(declaration.DeclarationError, match="loads a different declaration"):
        declaration.reflow(tmp_path)
    assert declaration.source_of(tmp_path).read_text(encoding="utf-8") == again


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
    written = _edge_declaration(CODE_GLYPHS, [{"from": "author", "to": "widget-b", "kind": "flow", "label": ""}])
    assert declaration.normalise(written)["content"]["edges"], "an actor starts a flow into code"


def test_an_arrow_onto_a_file_or_a_store_needs_neither():
    reads = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "gadget-store", "kind": "flow", "label": ""}])
    assert declaration.normalise(reads)["content"]["edges"]


def test_a_diagram_with_its_own_relation_is_not_judged_by_the_default_meaning():
    own = _edge_declaration(CODE_GLYPHS, [{"from": "widget-a", "to": "widget-b", "kind": "flow", "label": ""}], relation="feeds the next")
    assert declaration.normalise(own)["content"]["edges"]


def test_the_default_meaning_and_the_labels_are_declared_once_and_the_legend_reads_them():
    assert declaration.DEFAULTS["edge-semantics"]["legend"] == "initiator to receiver"
    assert declaration.LIB["edges"]["flow"]["phrase"] == "flow: initiator to receiver"
    assert set(declaration.EDGE_SEMANTICS["call-labels"]) <= set(declaration.EDGE_LABELS)
    assert set(declaration.EDGE_LABELS.values()) <= {"tail", "head"}
    glyph_library = (declaration.KIT / "assets" / "glyphs.xml").read_text(encoding="utf-8")
    assert 'value="flow: initiator to receiver"' in glyph_library, "the glyph library's words agree with the declaration"


def pill(model, edge):
    return re.search(rf'<mxCell id="{edge}-word" value="&lt;b&gt;([^&]*)&lt;/b&gt;" style="rounded=1;arcSize=50;[^"]*" [^\n]*\n\s*<mxGeometry x="(-?\d+)" y="(-?\d+)" width="(\d+)" height="(\d+)"', model)


def test_every_labelled_edge_draws_its_word_in_a_pill_by_default_and_the_line_keeps_none():
    assert declaration.EDGE_LABEL == "pill"
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
        patch.setattr(declaration, "EDGE_LABEL", "word")
        assert pill(declaration.put(declaration.normalise(raw)), "e-gadget-store-gadget-gate") is None  # the word presentation keeps it bare


def test_the_label_presentation_is_one_of_the_two_the_renderer_names():
    assert declaration.LABEL_PRESENTATIONS == ("pill", "word")
    with pytest.raises(declaration.DeclarationError, match="edge-label 'badge' is not one of: pill, word"):
        declaration.choices("drawio.yml renderer edge-label", "badge", declaration.LABEL_PRESENTATIONS)
