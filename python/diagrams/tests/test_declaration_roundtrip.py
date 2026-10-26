# cspell:ignore minimaps widgetese getpixel miny
"""The declaration of a diagram, tested: put and get round-trips, the vocabulary errors, the declared minimaps and the source file.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_declaration_roundtrip.py
"""

import re

import pytest
from catzc.diagrams import declaration, declaration_settings, declaration_sync
from conftest import WIDGET_MINIMAPS, WIDGETS, claimed, widgets
from PIL import Image


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
    monkeypatch.setattr(declaration_settings, "EDGE_LABEL", "word")  # the word presentation: the word stands beside its line
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"]["edges"][1]["label"] = "fails"  # a word on a line inside one band: it stays beside the line
    raw["layout"] = {"gadget-store": {"x": 800, "y": 150, "w": 220, "h": 72}, "gadget-gate": {"x": 800, "y": 320, "w": 220, "h": 72}}
    model = declaration.put(declaration.normalise(raw))  # the two ends stand one above the other, so the edge falls steeply
    steep = re.search(
        r'<mxCell id="e-gadget-store-gadget-gate" value="[^"]*" style="([^"]*)" [^\n]*\n\s*<mxGeometry x="(-?\d+)" y="(-?\d+)"', model
    )
    assert steep is not None and "align=left;" in steep.group(1) and (steep.group(2), steep.group(3)) == ("0", "-3")
    raw.pop("layout")
    model = declaration.put(declaration.normalise(raw))  # side by side on the grid, the edge runs flat
    flat = re.search(r'<mxCell id="e-gadget-store-gadget-gate" value="[^"]*" style="([^"]*)" [^\n]*\n\s*<mxGeometry relative="1"', model)
    assert flat is not None and "align=left;" not in flat.group(1)
    assert declaration.dump(declaration.get(model, kind="explanation")) == declaration.dump(declaration.normalise(raw))


def test_a_word_on_a_line_into_another_band_becomes_a_transition_bubble_on_that_border_in_the_word_presentation(monkeypatch):
    monkeypatch.setattr(declaration_settings, "EDGE_LABEL", "word")
    first = widgets()
    model = declaration.put(first)
    bubble = re.search(
        r'<mxCell id="e-widget-a-gadget-store-word" value="&lt;b&gt;writes&lt;/b&gt;" style="rounded=1;arcSize=50;[^"]*" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"',
        model,
    )
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
def test_each_minimap_is_an_id_or_its_excluded_cells_and_stored_cells_fail():
    raw = __import__("yaml").safe_load(WIDGETS)
    with_minimaps = lambda minimaps: {**raw, "content": {**raw["content"], "minimaps": minimaps}}
    assert declaration.normalise(with_minimaps(WIDGET_MINIMAPS))["content"]["minimaps"] == WIDGET_MINIMAPS
    # An entry with nothing excluded is its bare id.
    assert declaration.normalise(with_minimaps(["grid", {"axis": {"exclude": []}}, {"layer-stack": None}]))["content"]["minimaps"] == [
        "grid",
        "axis",
        "layer-stack",
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
    assert list(back["content"]["minimaps"]) == list(declaration_sync.minimap_data(tmp_path))
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
