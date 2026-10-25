"""A C3 or C4 slide's query rows, tested: the file's shape, the cells written out in the first band, and a source that never holds them.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/catzc_diagrams/tests/test_query_rows.py
"""

import json
import sys
from pathlib import Path

import pytest

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration
import query_rows
from conftest import WIDGETS

POINT = "widgets/Widget.Kit"
ROWS = {
    "rows": [
        {
            "point": POINT,
            "level": "C4",
            "nodes": [
                {"id": "get-widget", "label": "Get-Widget", "kind": "code"},
                {"id": "widget-config", "label": "widget.yml", "kind": "file"},
            ],
            "edges": [{"from": "get-widget", "to": "widget-config", "label": "reads"}],
        }
    ]
}


@pytest.fixture
def rows(tmp_path, monkeypatch):
    def write(data=ROWS):
        path = tmp_path / "rows.json"
        path.write_text(json.dumps(data), encoding="utf-8")
        query_rows._loaded.clear()
        monkeypatch.setenv(query_rows.ROWS_VARIABLE, str(path))
        return path

    yield write
    query_rows._loaded.clear()


def raw_at(level="C4", point=POINT):
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["about"].update(zoom=level, point=point)
    return raw


def test_the_rows_are_written_out_in_the_first_band_with_query_ids(rows):
    rows()
    declared = declaration.normalise(raw_at())
    glyphs = {g["id"]: g for g in declared["content"]["glyphs"]}
    assert glyphs["query-get-widget"]["in"] == "band-widgets" and glyphs["query-get-widget"]["kind"] == "code"
    assert glyphs["query-widget-config"]["label"] == "widget.yml"
    assert any(e["from"] == "query-get-widget" and e["to"] == "query-widget-config" for e in declared["content"]["edges"])
    assert {"query-get-widget", "query-widget-config"} <= declared["content"]["generated"]


def test_the_source_holds_the_point_and_never_the_cells(rows):
    rows()
    declared = declaration.normalise(raw_at())
    text = declaration.dump(declared)
    assert f"point: {POINT}" in text and "zoom: C4" in text
    assert "query-" not in text


def test_a_drawing_read_back_leaves_the_query_cells_out(rows):
    rows()
    model = declaration.put(declaration.normalise(raw_at()))
    back = declaration.get(model, kind="explanation")
    ids = [g["id"] for g in back["content"]["glyphs"]]
    assert not [i for i in ids if i.startswith("query-")]
    assert back["about"]["zoom"] == "C4"


def test_without_an_address_nothing_is_expanded(monkeypatch):
    monkeypatch.delenv(query_rows.ROWS_VARIABLE, raising=False)
    declared = declaration.normalise(raw_at())
    assert not [g for g in declared["content"]["glyphs"] if g["id"].startswith("query-")]
    assert declared["about"]["point"] == POINT


def test_a_point_needs_a_query_level():
    with pytest.raises(declaration.DeclarationError, match="about.point belongs to a slide at C3 or C4"):
        declaration.normalise(raw_at(level="C2"))


def test_rows_holding_nothing_for_the_point_are_refused(rows):
    rows()
    with pytest.raises(declaration.DeclarationError, match="hold nothing for widgets/Other at C4"):
        declaration.normalise(raw_at(point="widgets/Other"))


@pytest.mark.parametrize(
    "data, message",
    [
        ({"rows": {}}, "a map with one key, rows, a list"),
        ({"rows": [{"point": POINT, "level": "C2", "nodes": []}]}, "level 'C2' is not one of C3, C4"),
        ({"rows": [{"point": POINT, "level": "C4", "nodes": [{"id": "a"}]}]}, r"nodes is a list of \{ id, label, kind \}"),
        (
            {"rows": [{"point": POINT, "level": "C4", "nodes": [], "edges": [{"from": "a", "to": "b"}]}]},
            "an edge names 'a', which no node is",
        ),
    ],
)
def test_a_rows_file_of_the_wrong_shape_is_refused_naming_it(rows, data, message):
    rows(data)
    with pytest.raises(declaration.DeclarationError, match=message):
        declaration.normalise(raw_at())
