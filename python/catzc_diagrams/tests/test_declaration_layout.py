# cspell:ignore minimaps widgetese getpixel miny
"""The declaration of a diagram, tested: vocabularies, themes, notes, rows, lanes and ladders.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/catzc_diagrams/tests/test_declaration_layout.py
"""

import sys
from pathlib import Path

import pytest

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration
from conftest import ROWS, WIDGET_MINIMAPS, WIDGETS, claimed, committed_pair, lane_widgets, widgets


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


@pytest.mark.parametrize("asset", ["glyphs.xml", "template-slide.xml"])
def test_a_kit_asset_breaks_a_long_tag_between_attributes_only(asset):
    import re
    import xml.etree.ElementTree as ET

    text = (declaration.KIT / "assets" / asset).read_text(encoding="utf-8")
    joined = re.sub(r'\n[ \t]+(?=[\w:.-]+=")', " ", text)
    assert ET.tostring(ET.fromstring(joined)) == ET.tostring(ET.fromstring(text)), "joining the attribute lines back changes no value"
    wide = [line for line in text.splitlines() if len(line) > 140]
    assert [line for line in wide if not re.search(r'="[^"]*"$', line)] == [], "a line over the width ends inside one attribute value"


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
    raw["content"]["glyphs"].append(
        {"id": "rung-bvt", "kind": "commit", "label": "BVT", "in": "band-gadgets", "shape": "box", "state": "bvt"}
    )
    raw["content"]["glyphs"].append(
        {"id": "rung-gone", "kind": "commit", "label": "discarded", "in": "band-gadgets", "shape": "box", "state": "discarded"}
    )
    first = declaration.normalise(raw)
    model = declaration.put(first)
    assert "commitShape=box" in model and "fillColor=#8E2424" in model
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
