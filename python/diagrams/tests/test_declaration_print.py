# cspell:ignore minimaps widgetese getpixel miny
"""The declaration of a diagram, tested: layering under the drawing, conflicts by drawing, the printed form of the source, reflow and the deadzone.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_declaration_print.py
"""

import xml.etree.ElementTree as ET

import pytest
from catzc.diagrams import declaration, declaration_sync
from conftest import ROWS, WIDGETS, lane_widgets


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
    gap_y = (
        (box["band-widgets"]["y"] + box["band-widgets"]["h"] + box["band-gadgets"]["y"]) // 2
        if box["band-gadgets"]["y"] > box["band-widgets"]["y"]
        else 20
    )
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
    data = {
        "widgets": {
            "description": long + " it on the line, so it moves under the key.",
            "legend": "W: Widget\nG: Gadget\n\nS: Sprocket (hands on)",
            "short": "W: widget",
            "notes": [long + " it on the dash line", "W: widget\nG: gadget"],
        }
    }
    assert declaration.flow_yaml(data, 140) == (
        "widgets:\n"
        "  description:\n"
        '    "Widgets: a long widget text that is long enough to pass the width of one hundred and forty characters when its key sits beside it on\n'
        '    the line, so it moves under the key."\n'
        '  legend: "W: Widget\n'
        "\n"
        "    G: Gadget\n"
        "\n"
        "\n"
        '    S: Sprocket (hands on)"\n'
        '  short: "W: widget"\n'
        "  notes:\n"
        '    - "Widgets: a long widget text that is long enough to pass the width of one hundred and forty characters when its key sits beside it on\n'
        '      the dash line"\n'
        '    - "W: widget\n'
        "\n"
        '      G: gadget"\n'
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
    monkeypatch.setattr(declaration_sync, "flow_yaml", lambda data, width: printed(data, width).replace(raw["content"]["title"], "Gadgets"))
    with pytest.raises(declaration.DeclarationError, match="loads a different declaration"):
        declaration.reflow(tmp_path)
    assert declaration.source_of(tmp_path).read_text(encoding="utf-8") == again
