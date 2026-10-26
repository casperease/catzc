"""A C3 or C4 slide's query rows, tested: the file's shape, the cells written out in the first band, and a source that never holds them.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_query_rows.py
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
    assert {"query-get-widget", "query-widget-config"} <= declared["content"]["generated"]


def test_at_or_under_the_cap_every_edge_runs_in_a_lane_of_its_own_and_crosses_no_cell(rows):
    rows()
    declared = declaration.normalise(raw_at())
    drawn = [e for e in declared["content"]["edges"] if e["from"].startswith("query-")]
    assert [(e["from"], e["to"]) for e in drawn] == [("query-get-widget", "query-widget-config")]
    assert not [c for c in declared["content"]["chips"] if c["at"].startswith("query-")]
    box = declared["layout"]["query-get-widget"]
    assert all(p[0] > box["x"] + box["w"] for p in drawn[0]["via"])  # the lane stands right of the column
    cells = [c for c in declaration.place(declared, check_routes=True)[0] if not c["edge"]]
    assert cells  # placing with the route check raises E_KEEPOUT on any edge through a cell
    text = declaration.dump(declared)
    assert "query-" not in text and "band-widgets: {" not in text


def test_over_the_cap_the_cells_carry_count_chips_and_no_edge_is_drawn(rows, monkeypatch):
    rows()
    monkeypatch.setitem(query_rows.DEFAULTS["renderer"], "query-edges-max-nodes", "1")
    declared = declaration.normalise(raw_at())
    assert not [e for e in declared["content"]["edges"] if e["from"].startswith("query-") or e["to"].startswith("query-")]
    chips = {c["at"]: c["text"] for c in declared["content"]["chips"] if c["kind"] == "count"}
    assert chips["query-get-widget"] == "0 in 1 out"
    assert chips["query-widget-config"] == "1 in 0 out"


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
    assert not [c for c in back["content"]["chips"] if c["at"].startswith("query-")]
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


SCHEMA = Path(__file__).resolve().parents[3] / "contracts/catzc/0.1.0/pwsh.base.maps/query-rows.schema.json"


@pytest.mark.parametrize("payload", ["sample", "fixture"])
def test_the_published_schema_holds_the_sample_and_the_rows_the_kit_reads(payload):
    jsonschema = pytest.importorskip("jsonschema")
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    data = json.loads(SCHEMA.with_name("query-rows.sample.json").read_text(encoding="utf-8")) if payload == "sample" else ROWS
    jsonschema.validate(data, schema)
    if payload == "sample":
        query_rows._loaded.clear()
        assert {key[1] for key in query_rows.read(SCHEMA.with_name("query-rows.sample.json"))} == {"C3", "C4"}


def test_the_published_schema_refuses_a_level_no_query_answers():
    jsonschema = pytest.importorskip("jsonschema")
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate({"rows": [{"point": "widgets", "level": "C2", "nodes": [], "edges": []}]}, schema)


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
