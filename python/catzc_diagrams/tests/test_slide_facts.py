# ---
# catzc:
#   immutable:
#     with_body_sha: "6d12e32c8ada"
# ---

"""The subtitle a slide says it supports (`<codes> · <lens>`) and the article's Supports line held against it.

usage (repo root, background): timeout 120 uv run -q --with pillow==12.3.0 --with pytest==9.1.1 python -m pytest python/catzc_diagrams/tests
"""

import sys
from pathlib import Path

import pytest

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import drawio_forward
from drawio_png import DEFAULTS


def model(subtitle):
    """A model whose subtitle cell says the given line."""
    return f'<mxGraphModel><root><mxCell id="0"/><mxCell id="subtitle" value="{subtitle}"/></root></mxGraphModel>'


@pytest.fixture
def repo(tmp_path, monkeypatch):
    """A repository whose ADR index knows ADR-WIDGET and ADR-GADGET, standing in for the real one."""
    index = tmp_path / "docs" / "adr" / "index.md"
    index.parent.mkdir(parents=True)
    index.write_text("| `ADR-WIDGET` | widget |\n| `ADR-GADGET` | gadget |\n", encoding="utf-8")
    monkeypatch.setattr(drawio_forward, "REPO", tmp_path)
    return tmp_path


def test_each_rule_code_names_its_adr(repo):
    assert drawio_forward.slide_facts(model("ADR-WIDGET-TURN · ADR-WIDGET-SPIN · ADR-GADGET-FOLD · architecture")) == (
        ["ADR-GADGET", "ADR-WIDGET"],
        "architecture",
        [],
    )


def test_a_rule_name_with_digits_names_its_adr(repo):
    assert drawio_forward.slide_facts(model("ADR-WIDGET-RE01 · meta"))[0] == ["ADR-WIDGET"]


def test_a_numbered_citation_is_reported_and_its_adr_still_read(repo):
    adrs, lens, problems = drawio_forward.slide_facts(model("ADR-WIDGET#3 · meta"))
    assert (adrs, lens) == (["ADR-WIDGET"], "meta")
    assert len(problems) == 1
    assert "cites a rule by number" in problems[0]


def test_a_numbered_group_is_reported(repo):
    problems = drawio_forward.slide_facts(model("ADR-WIDGET#{1,3} · meta"))[2]
    assert len(problems) == 1


def test_a_code_the_index_does_not_know_is_dropped(repo):
    assert drawio_forward.slide_facts(model("ADR-SPROCKET-TURN · ADR-WIDGET-SPIN · meta"))[0] == ["ADR-WIDGET"]


@pytest.mark.parametrize("lens", sorted(DEFAULTS["lenses"]))
def test_every_lens_of_the_closed_set_is_accepted_with_or_without_the_word_lens(repo, lens):
    for subtitle in (f"ADR-WIDGET-TURN · {lens}", f"ADR-WIDGET-TURN · {lens} lens"):
        assert drawio_forward.slide_facts(model(subtitle))[1:] == (lens, [])


def test_a_lens_outside_the_closed_set_is_reported_and_read_as_none(repo):
    adrs, lens, problems = drawio_forward.slide_facts(model("ADR-WIDGET-TURN · sprocket"))
    assert (adrs, lens) == (["ADR-WIDGET"], None)
    assert len(problems) == 1
    assert "'sprocket', not a lens of drawio.yml" in problems[0]


def test_a_model_without_a_subtitle_cell_is_reported(repo):
    assert drawio_forward.slide_facts('<mxGraphModel><root><mxCell id="0"/></root></mxGraphModel>') == (
        [],
        None,
        ["the model has no subtitle cell"],
    )


@pytest.fixture
def article(repo):
    """An article folder whose one page embeds the slide of its diagram folder `.assets/gadget/`."""
    folder = repo / "docs" / "explanation" / "widget" / ".assets" / "gadget"
    folder.mkdir(parents=True)
    (folder / drawio_forward.SLIDE).write_bytes(b"")
    page = folder.parent.parent / "widget-page.md"

    def write(supports):
        lines = ["# Widget", "", "![Gadget](.assets/gadget/diagram.drawio.png)", ""]
        page.write_text("\n".join(lines + ([supports] if supports else [])) + "\n", encoding="utf-8")
        return folder

    return write


def test_no_drift_when_the_supports_line_agrees_with_the_subtitle(article):
    folder = article("Supports ADR-WIDGET (meta lens).")
    assert drawio_forward.supports_drift(folder, ["ADR-WIDGET"], "meta") is None


def test_a_supports_line_naming_another_lens_is_drift(article):
    folder = article("Supports ADR-WIDGET (meta lens).")
    warning = drawio_forward.supports_drift(folder, ["ADR-WIDGET"], "architecture")
    assert warning == (
        "docs/explanation/widget/widget-page.md says Supports ['ADR-WIDGET'] (meta lens), "
        "the subtitle ['ADR-WIDGET'] (architecture lens)"
    )


def test_a_supports_line_naming_other_codes_is_drift(article):
    folder = article("Supports ADR-WIDGET and ADR-GADGET (meta lens)")
    warning = drawio_forward.supports_drift(folder, ["ADR-WIDGET"], "meta")
    assert warning is not None
    assert "says Supports ['ADR-GADGET', 'ADR-WIDGET'] (meta lens)" in warning


def test_a_supports_line_citing_rules_agrees_at_the_adr_level(article):
    folder = article("Supports ADR-WIDGET-TURN and ADR-WIDGET-SPIN (meta lens).")
    assert drawio_forward.supports_drift(folder, ["ADR-WIDGET"], "meta") is None


def test_no_drift_without_a_supports_line(article):
    assert drawio_forward.supports_drift(article(None), ["ADR-WIDGET"], "meta") is None


def test_a_page_that_does_not_embed_the_slide_is_not_its_article(article, repo):
    folder = article(None)
    other = folder.parent.parent / "gizmo-page.md"
    other.write_text("# Gizmo\n\nSupports ADR-GADGET (governance lens).\n", encoding="utf-8")
    assert drawio_forward.supports_drift(folder, ["ADR-WIDGET"], "meta") is None


@pytest.fixture
def roles(repo, monkeypatch):
    """drawio.yml's roles: in the fixture repository, naming one widget folder a legend; every other folder takes renderer.role."""
    legend = repo / "docs" / "explanation" / ".assets" / "widget-legend"
    slide = repo / "docs" / "explanation" / ".assets" / "gadget-slide"
    legend.mkdir(parents=True)
    slide.mkdir(parents=True)
    monkeypatch.setitem(DEFAULTS, "roles", {"docs/explanation/.assets/widget-legend": "legend"})
    return legend, slide


def test_a_legend_without_a_subtitle_has_no_warning(roles):
    legend, _ = roles
    no_subtitle = '<mxGraphModel><root><mxCell id="0"/></root></mxGraphModel>'
    assert drawio_forward.folder_role(legend) == "legend"
    assert drawio_forward.subtitle_facts(legend, no_subtitle) == ([], None, [])


def test_a_slide_without_a_subtitle_is_warned(roles):
    _, slide = roles
    no_subtitle = '<mxGraphModel><root><mxCell id="0"/></root></mxGraphModel>'
    assert drawio_forward.folder_role(slide) == DEFAULTS["renderer"]["role"] == "slide"
    assert drawio_forward.subtitle_facts(slide, no_subtitle) == (
        [],
        None,
        ["W_SUBTITLE docs/explanation/.assets/gadget-slide: the model has no subtitle cell"],
    )


def test_a_legend_png_is_stale_only_when_the_glyph_library_moved_from_it(roles, monkeypatch):
    legend, _ = roles
    drawio_forward.put_legend(legend)
    assert drawio_forward.legend_stale(legend) is False
    monkeypatch.setattr(drawio_forward, "legend_model", lambda: '<mxGraphModel><root><mxCell id="widget"/></root></mxGraphModel>')
    assert drawio_forward.legend_stale(legend) is True


def test_a_legend_without_a_declaration_is_not_warned(roles):
    legend, _ = roles
    assert drawio_forward.undeclared_warnings(legend, "diagram.drawio.yml") == []


def test_a_slide_without_a_declaration_is_warned(roles):
    _, slide = roles
    assert drawio_forward.undeclared_warnings(slide, "diagram.drawio.yml") == [
        "W_UNDECLARED docs/explanation/.assets/gadget-slide: no diagram.drawio.yml, so its minimaps are not rebuilt; declare it to put it"
    ]


def test_a_role_outside_the_closed_set_is_refused(roles, monkeypatch):
    legend, _ = roles
    monkeypatch.setitem(DEFAULTS, "roles", {"docs/explanation/.assets/widget-legend": "poster"})
    with pytest.raises(ValueError, match="not one of slide, legend"):
        drawio_forward.folder_role(legend)
