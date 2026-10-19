# cspell:ignore minimaps
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
content:
  title: Widgets flow into gadgets
  adrs: [ADR-X-Y]
  lens: architecture
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
    - { at: gadget-gate, kind: rule, text: "#2" }
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


def test_minimaps_default_by_kind_and_must_be_three_known_ids():
    raw = __import__("yaml").safe_load(WIDGETS)
    assert declaration.normalise(raw)["content"]["minimaps"] == ["grid", "axis", "layer-stack"]
    raw["content"]["kind"] = "reference"
    assert declaration.normalise(raw)["content"]["minimaps"] == ["grid", "code-locations", "track-placement"]
    raw["content"]["minimaps"] = ["grid", "axis", "moon"]
    with pytest.raises(declaration.DeclarationError, match="minimap 'moon' is not one of: grid, code-locations"):
        declaration.normalise(raw)
    raw["content"]["minimaps"] = ["grid"]
    with pytest.raises(declaration.DeclarationError, match="exactly three"):
        declaration.normalise(raw)


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
