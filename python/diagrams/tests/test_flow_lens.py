"""The flow lens's declaration and rows: a flow declaration stores its inputs alone, its point in about, and a flow row rides the query
rows file filed under the lens beside the levels."""

import json

import pytest
from catzc.diagrams import declaration, query_rows


def flow_declaration(**content):
    return {
        "about": {"lens": "flow", "point": ".ado/pipelines/ci-widget.yml"},
        "content": {"title": "A widget commit's route", **content},
    }


def test_a_flow_declaration_holds_its_point_and_its_lens():
    declared = declaration.normalise(flow_declaration())
    assert declared["content"]["lens"] == "flow"
    assert declared["content"]["point"] == ".ado/pipelines/ci-widget.yml"


def test_a_flow_declaration_with_a_content_key_beyond_title_and_kind_is_refused_naming_it():
    with pytest.raises(declaration.DeclarationError, match="holds only title and kind; it also holds bands"):
        declaration.normalise(flow_declaration(bands=[]))


def test_a_flow_row_is_filed_under_the_lens_beside_a_level_row(tmp_path):
    path = tmp_path / "rows.json"
    path.write_text(
        json.dumps(
            {
                "rows": [
                    {"point": "pwsh/Base.Widget", "level": "C4", "nodes": [{"id": "a", "label": "a", "kind": "file"}], "edges": []},
                    {"point": ".ado/pipelines/ci-widget.yml", "lens": "flow", "lanes": [{"id": "ci-widget"}], "edges": []},
                ]
            }
        ),
        encoding="utf-8",
    )
    found = query_rows.read(path)
    assert set(found) == {("pwsh/Base.Widget", "C4"), (".ado/pipelines/ci-widget.yml", "flow")}
    assert found[(".ado/pipelines/ci-widget.yml", "flow")]["lanes"] == [{"id": "ci-widget"}]


def test_a_flow_row_of_the_wrong_shape_is_refused_naming_it(tmp_path):
    path = tmp_path / "rows.json"
    path.write_text(json.dumps({"rows": [{"point": "x.yml", "lens": "flow", "lanes": [{"label": "no id"}]}]}), encoding="utf-8")
    with pytest.raises(declaration.DeclarationError, match="lanes is a list of maps, each with its id"):
        query_rows.read(path)
