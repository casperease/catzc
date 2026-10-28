# cspell:ignore minimaps
"""A minimap drawn from its contract data: every shape of data draws, and what is lit is what shows.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_minimap_drawing.py
"""

import copy
import itertools
import json

import pytest
from catzc.diagrams import minimap_contract, minimaps
from catzc.diagrams.module_paths import module_path

SAMPLE = minimap_contract.SCHEMA.with_name("minimap.sample.json")


def sample():
    return json.loads(SAMPLE.read_text(encoding="utf-8"))


def strip():
    """One axis: the gadget layers, one of them lit."""
    return {
        "id": "layer-stack",
        "axes": [{"name": "layer", "values": ["widget", "gadget"]}],
        "cells": [{"at": ["widget"], "count": 1}, {"at": ["gadget"], "count": 2}],
        "lit": [{"at": ["gadget"], "count": 2, "reasons": [{"subject": "ADR-GADGET", "basis": "layer", "requested": None, "note": None}]}],
    }


def places():
    """Three axes: track, module and folder, one place lit."""
    return {
        "id": "code-locations",
        "axes": [{"name": "track", "values": ["pwsh"]}, {"name": "module", "values": ["Catzc.Widget"]}, {"name": "folder", "values": ["tests"]}],
        "cells": [{"at": ["pwsh", "Catzc.Widget", "tests"], "count": 3}],
        "lit": [{"at": ["pwsh", "Catzc.Widget", "tests"], "count": 3, "reasons": [{"subject": "pwsh/Catzc.Widget/tests/a.ps1", "basis": "citation", "requested": "ADR-WIDGET", "note": None}]}],
        "place_rows": {"rows": ["pwsh.widget.tests"], "counters": "1 place"},
    }


@pytest.mark.parametrize("data", [sample(), strip(), places()], ids=["two axes", "one axis", "three axes"])
def test_every_shape_of_contract_data_draws_and_what_is_lit_shows(data):
    minimap_contract.validate_minimap(data)
    drawn = minimaps.picture_from(data, 300, 160)
    unlit = copy.deepcopy(data)
    unlit["lit"] = []
    unlit.pop("place_rows", None)  # an unlit place list has no rows
    assert drawn.startswith("data:image/png,")
    assert drawn != minimaps.picture_from(unlit, 300, 160)


def crowded(columns):
    """Thirty widget rows, the last five lit: one axis when columns is 0, else a second axis of that many gadget columns."""
    rows = [f"widget-{n:02}" for n in range(30)]
    cols = [f"gadget-{n}" for n in range(columns)]
    at = lambda row: [row, cols[0]] if cols else [row]
    axes = [{"name": "widget", "values": rows}] + ([{"name": "gadget", "values": cols}] if cols else [])
    return {
        "id": "grid" if cols else "layer-stack",
        "axes": axes,
        "cells": [{"at": at(row), "count": 1} for row in rows],
        "lit": [{"at": at(row), "count": 1, "reasons": [{"subject": "ADR-WIDGET", "basis": "layer", "requested": None, "note": None}]} for row in rows[25:]],
    }


@pytest.mark.parametrize("columns", [0, 3, 12], ids=["strip", "matrix", "rows of names"])
def test_a_crowded_minimap_never_prints_a_label_over_another_and_counts_what_it_leaves_out(monkeypatch, columns):
    data = crowded(columns)
    minimap_contract.validate_minimap(data)
    written = []
    real = minimaps.text
    monkeypatch.setattr(minimaps, "text", lambda d, at, s, size, *rest, **kw: (written.append((at[1], s, size)), real(d, at, s, size, *rest, **kw)))
    minimaps.picture_from(data, 300, 160)
    lines = sorted((y, s) for y, s, size in written if size == 9)  # the row labels and the count, not the 11 px caption or 8 px names
    assert all(b[0] - a[0] >= minimaps.MIN_PITCH - 0.5 for a, b in itertools.pairwise(lines))
    shown = [s for _, s in lines if s.startswith("widget-")]
    more = [s for _, s in lines if s.startswith("+")]
    assert more and int(more[0].split()[0].lstrip("+")) + len(shown) == 30
    assert {f"widget-{n}" for n in range(25, 30)} <= set(shown)  # the lit rows are never the ones left out


def test_a_row_lit_as_a_whole_in_rows_of_names_is_outlined_with_its_label_lit_and_never_prints_a_star(monkeypatch):
    data = crowded(12)  # twelve columns: too many for cells, so the rows are drawn as lines of names
    data["cells"].append({"at": ["widget-03", "*"], "count": 0})
    data["lit"].append({"at": ["widget-03", "*"], "count": 0, "reasons": [{"subject": "ADR-WIDGET", "basis": "concern", "requested": None, "note": "outside the axis"}]})
    minimap_contract.validate_minimap(data)
    written, outlined = [], []
    real_text, real_box = minimaps.text, minimaps.box
    monkeypatch.setattr(minimaps, "text", lambda d, at, s, size, *rest, **kw: (written.append((s, kw.get("bold"))), real_text(d, at, s, size, *rest, **kw)))
    monkeypatch.setattr(minimaps, "box", lambda d, xy, fill, rim=None, radius=3: (outlined.append((xy, fill, rim)), real_box(d, xy, fill, rim, radius)))
    minimaps.picture_from(data, 300, 160)
    assert not [s for s, _ in written if s.strip() == "*"]
    assert ("widget-03", True) in written  # the row's label is lit
    assert [xy for xy, fill, rim in outlined if fill is None and rim == minimaps.LIT]  # and the row outlined


def test_a_minimap_draws_in_every_theme():
    assert minimaps.picture_from(sample(), 300, 160, "dark") != minimaps.picture_from(sample(), 300, 160, "light")


def test_a_row_lit_as_a_whole_is_outlined_and_a_place_drops_its_placeholders():
    data = sample()
    data["cells"].append({"at": ["pwsh", "*"], "count": 0})
    whole = copy.deepcopy(data)
    whole["lit"] = [{"at": ["pwsh", "*"], "count": 0, "reasons": [{"subject": "ADR-WIDGET", "basis": "concern", "requested": None, "note": "concern automation, outside the axis"}]}]
    unlit = copy.deepcopy(data)
    unlit["lit"] = []
    assert minimaps.picture_from(whole, 300, 160) != minimaps.picture_from(unlit, 300, 160)


def written_by(monkeypatch):
    """The texts a drawing prints, as (value, size), in order."""
    written = []
    real = minimaps.text
    monkeypatch.setattr(minimaps, "text", lambda d, at, s, size, *rest, **kw: (written.append((s, size)), real(d, at, s, size, *rest, **kw)))
    return written


def test_a_place_list_draws_the_rows_it_is_given_and_nothing_else(monkeypatch):
    data = places()
    rows = ["docs", "pwsh.widget", "pwsh.widget_cog.configs|types", "pwsh.gadget.(root)|configs|..."]
    data["place_rows"] = {"rows": rows, "counters": "+4 more · 7 places"}
    written = written_by(monkeypatch)
    minimaps.picture_from(data, 300, 160)
    printed = [s for s, size in written if size != 11]
    assert printed == [*rows, "+4 more · 7 places"]  # in the given order: nothing sorted, cut or added


def test_a_place_list_without_its_rows_is_refused_rather_than_computed_here():
    data = places()
    del data["place_rows"]
    with pytest.raises(ValueError, match="carries no place_rows"):
        minimaps.picture_from(data, 300, 160)


def test_a_row_wider_than_the_sidebar_is_drawn_a_point_smaller_never_cut(monkeypatch):
    data = places()
    long_row = "pwsh.widget...assembly_gadgetry.tests|types"  # the 40 characters of the budget
    data["place_rows"] = {"rows": [long_row], "counters": "1 place"}
    written = written_by(monkeypatch)
    minimaps.picture_from(data, 160, 160)  # a narrow sidebar
    sizes = [size for s, size in written if s == long_row]
    assert sizes and sizes[0] < 9  # it shrank
    assert not [s for s, _ in written if "…" in s]  # and was never cut with an ellipsis


def test_a_short_row_keeps_the_full_size(monkeypatch):
    data = places()
    written = written_by(monkeypatch)
    minimaps.picture_from(data, 300, 160)
    assert [size for s, size in written if s == "pwsh.widget.tests"] == [9]


def test_the_rules_are_read_under_every_record_kind_the_registry_declares(tmp_path, monkeypatch):
    # A widget registry with two kinds: a rule heading under either is a rule, one under an undeclared kind is not.
    registry = tmp_path / module_path("Catzc.Base.Drs", "configs", "drs.yml")
    registry.parent.mkdir(parents=True)
    registry.write_text("kinds:\n  ADR: {}\n  GDR: {}\n", encoding="utf-8")
    (tmp_path / "docs/drs/widget").mkdir(parents=True)
    (tmp_path / "docs/drs/widget/gadget.md").write_text(
        "### Rule ADR-WIDGET-TURN\n\n### Rule GDR-GADGET-SPIN\n\n### Rule XDR-GIZMO-STOP\n", encoding="utf-8"
    )
    monkeypatch.setattr(minimaps, "REPO", tmp_path)
    minimaps.kinds.cache_clear()
    minimaps.records_root.cache_clear()
    minimaps.rules.cache_clear()
    try:
        assert minimaps.rules() == {"ADR-WIDGET-TURN", "GDR-GADGET-SPIN"}
    finally:
        minimaps.kinds.cache_clear()
        minimaps.records_root.cache_clear()
        minimaps.rules.cache_clear()


def luminance(colour):
    r, g, b = [int(colour.lstrip("#")[i : i + 2], 16) / 255 for i in (0, 2, 4)]
    f = lambda c: c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def contrast(a, b):
    high, low = sorted((luminance(a), luminance(b)), reverse=True)
    return (high + 0.05) / (low + 0.05)


def test_every_dark_minimap_text_pair_holds_its_contrast_and_a_lit_cell_is_a_step_above_an_idle_one():
    t = minimaps.tokens("dark")
    assert contrast(t["map-caption"], t["map-page"]) >= 7 and contrast(t["map-caption"], t["map-panel"]) >= 7
    assert contrast(t["map-lit-ink"], t["map-lit"]) >= 7
    for ground in ("map-page", "map-panel"):
        assert contrast(t["map-dim"], t[ground]) >= 4.5 and contrast(t["map-mention"], t[ground]) >= 4.5
    assert contrast("#FFFFFF", t["sidebar"]) >= 7
    assert contrast(t["map-lit"], t["map-panel"]) >= 1.5  # lit reads as a different state than idle


def test_the_gold_panel_border_is_a_token_that_holds_three_to_one_on_the_minimap_grounds_in_both_themes():
    dark = minimaps.tokens("dark")
    assert contrast(dark["map-border-lit"], dark["map-panel"]) >= 3 and contrast(dark["map-border-lit"], dark["map-page"]) >= 3
    light = minimaps.tokens("light")
    assert contrast(light["map-border-lit"], light["band"]) >= 3 and contrast(light["map-border-lit"], light["map-panel"]) >= 3



def test_the_column_headers_of_a_matrix_never_run_together_lit_or_dim():
    _, d = minimaps.canvas(240, 160)
    cols = ["Base.Widgets", "Base.Gadgets", "Base.WidgetStore", "Base.GadgetShelf"]
    lit = {("subject", "Base.Widgets"), ("subject", "Base.Gadgets")}  # the lit headers are bold, so wider than the dim ones
    headers = minimaps.column_headers(d, cols, lit, 70, (240 - 70 - 8) / len(cols))
    assert [on for _, _, on in headers] == [True, True, False, False]
    for (x, value, on), (next_x, _, _) in itertools.pairwise(headers):
        end = x + d.textlength(value, font=minimaps.font(8 * minimaps.SCALE, on)) / minimaps.SCALE
        assert end <= next_x - minimaps.HEADER_GAP, f"{value!r} runs into the next header"
