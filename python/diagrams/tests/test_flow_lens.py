"""The flow lens's declaration and rows: a flow declaration stores its inputs alone, its point in about, and a flow row rides the query
rows file filed under the lens beside the levels."""

import json
import re
from pathlib import Path

import pytest
import yaml
from catzc.diagrams import declaration, query_rows

FIXTURES = Path(__file__).resolve().parent / "flow-lens"


@pytest.fixture
def sample_model(monkeypatch):
    """The flow sample put with its readers' rows handed over by address, as Build-Diagrams hands them."""
    monkeypatch.setenv(query_rows.ROWS_VARIABLE, str(FIXTURES / "flow-sample.rows.json"))
    raw = yaml.safe_load((FIXTURES / "flow-sample.drawio.yml").read_text(encoding="utf-8"))
    return declaration.put(declaration.normalise(raw))


def ids(model):
    return set(re.findall(r'<mxCell id="([^"]+)"', model))


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


def test_each_lane_draws_its_triggers_its_pipeline_its_templates_and_its_environments(sample_model):
    drawn = ids(sample_model)
    assert {"ci-widget-pipeline", "cd-widget-pipeline", "deploy-widget-pipeline"} <= drawn
    assert {"ci-widget-trigger-1", "ci-widget-trigger-2", "ci-widget-template-1", "ci-widget-template-2"} <= drawn
    assert {"deploy-widget-env-1", "deploy-widget-env-2", "cd-widget-env-1"} <= drawn


def test_an_environment_is_a_rhombus_and_a_word_is_an_embedded_image(sample_model):
    env = re.search(r'<mxCell id="cd-widget-env-1"[^>]*style="([^"]*)"', sample_model).group(1)
    assert env.startswith("rhombus;")
    word = re.search(r'<mxCell id="ci-widget-pipeline"[^>]*style="([^"]*)"', sample_model).group(1)
    assert "shape=image" in word and "image=data:image/svg+xml," in word


def test_the_spanners_name_the_type_review_and_each_gated_environment(sample_model):
    drawn = ids(sample_model)
    assert {"ci-widget-type", "ci-widget-review", "deploy-widget-approve-1", "deploy-widget-approve-2"} <= drawn
    assert "cd-widget-approve-1" not in drawn  # an ungated rung takes no Approve
    assert "cd-widget-review" not in drawn


def test_the_deploy_lane_is_pinned_to_its_cd_lane_and_the_full_flow_runs_from_o_to_0(sample_model):
    edge = re.search(r'<mxCell id="e-deploy-widget-cd-widget"[^>]*>', sample_model).group(0)
    assert 'source="deploy-widget-pipeline"' in edge and 'target="cd-widget-pipeline"' in edge and "pins" in edge
    assert {"flow-start", "flow-end", "flow-line"} <= ids(sample_model)


def test_a_flow_slide_without_its_readers_rows_is_refused_naming_build_diagrams(monkeypatch):
    monkeypatch.delenv(query_rows.ROWS_VARIABLE, raising=False)
    raw = yaml.safe_load((FIXTURES / "flow-sample.drawio.yml").read_text(encoding="utf-8"))
    with pytest.raises(declaration.DeclarationError, match="Build-Diagrams hands them over by address"):
        declaration.put(declaration.normalise(raw))
