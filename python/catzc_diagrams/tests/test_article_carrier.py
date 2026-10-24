"""The article carrier: a diagram declared in a `yml drawio` block directly above the image in its article, the way a mermaid block is.

usage (repo root, background): timeout 120 uv run -q --project python/catzc_diagrams python -m pytest python/catzc_diagrams/tests
"""

import sys
from pathlib import Path

import pytest
import yaml

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other; the tests folder joins too,
# so the shared widget fixture imports by name under any import mode.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import declaration
import drawio_forward
from test_declaration import WIDGETS

BODY = "description: Widgets flow into gadgets through a gate.\n" + WIDGETS.lstrip("\n")


def page_text(body, between="\n"):
    """An article: a title, a paragraph, the block, then the image that embeds the diagram's png, and a closing paragraph."""
    return (
        "# Widgets flow into gadgets\n\nA paragraph before the diagram.\n\n"
        f"```yml drawio\n{body}```\n{between}![Widgets flow into gadgets](.assets/widget-flow.drawio.png)\n\nA paragraph after it.\n"
    )


@pytest.fixture
def article(tmp_path, monkeypatch):
    """A page folder whose article carries the widget diagram's declaration, and no yml beside the png: the article carrier."""
    (tmp_path / ".assets").mkdir()
    page = tmp_path / "widget-flow.md"
    page.write_text(page_text(BODY), encoding="utf-8")
    return tmp_path / ".assets" / "widget-flow", page


def test_a_block_above_the_image_makes_the_article_the_carrier_and_a_diagram_with_neither_takes_the_default(article):
    stem, _ = article
    assert declaration.carrier_of(stem) == "article"
    assert declaration.carrier_of(stem.with_name("gadget-flow")) == declaration.DEFAULTS["renderer"]["carrier"]


def test_load_reads_the_block_above_the_image_and_put_writes_the_png_into_assets(article):
    stem, _ = article
    loaded = declaration.load(stem)
    assert loaded["description"] == "Widgets flow into gadgets through a gate."
    dst = declaration.put_png(stem, loaded)
    assert dst == stem.with_name("widget-flow.drawio.png") and dst.is_file()
    assert not declaration.source_of(stem).exists(), "the article carrier writes no yml beside the png"


def test_get_writes_back_into_the_block_and_leaves_the_rest_of_the_page_as_it_was(article):
    stem, page = article
    declaration.put_png(stem, declaration.load(stem))
    declaration.save(stem, declaration.get(declaration.model_of(stem), kind="explanation"))
    text = page.read_text(encoding="utf-8")
    assert text.startswith("# Widgets flow into gadgets\n\nA paragraph before the diagram.\n\n```yml drawio\n")
    assert text.endswith("```\n\n![Widgets flow into gadgets](.assets/widget-flow.drawio.png)\n\nA paragraph after it.\n")
    # Get writes the minimap views the drawing shows; everything else reads back as the block declared it.
    back = declaration.load(stem)
    first = declaration.normalise(yaml.safe_load(BODY))
    assert back["description"] == first["description"]
    assert {k: v for k, v in back["content"].items() if k != "minimaps"} == {k: v for k, v in first["content"].items() if k != "minimaps"}


def test_declare_minimaps_writes_the_inputs_into_the_block_in_place(article):
    stem, page = article
    # A block that lists the shown ids as a block list: the rewrite prints them as save does, in the block, in place.
    listed = "content:\n  minimaps:\n    - grid\n    - axis\n    - layer-stack\n"
    page.write_text(page.read_text(encoding="utf-8").replace("content:\n", listed, 1), encoding="utf-8", newline="\n")
    declaration.declare_minimaps(stem)
    text = page.read_text(encoding="utf-8")
    assert "content:\n  minimaps: [grid, axis, layer-stack]\n" in text
    assert text.endswith("```\n\n![Widgets flow into gadgets](.assets/widget-flow.drawio.png)\n\nA paragraph after it.\n")


def test_a_block_with_anything_but_blank_lines_before_its_image_declares_nothing(article):
    stem, page = article
    page.write_text(page_text(BODY, between="\nA sentence between.\n\n"), encoding="utf-8")
    assert not declaration.declared(stem)
    with pytest.raises(declaration.DeclarationError, match="exactly one `yml drawio` block above its image, found 0"):
        declaration.load(stem)


def test_two_blocks_for_one_diagram_fail_naming_the_pages(article):
    stem, page = article
    (page.parent / "second.md").write_text(page_text(BODY), encoding="utf-8")
    with pytest.raises(declaration.DeclarationError, match=r"found 2 \(second\.md, widget-flow\.md\)"):
        declaration.load(stem)


def test_a_diagram_declared_in_both_carriers_is_a_finding(article):
    stem, _ = article
    declaration.source_of(stem).write_text(BODY, encoding="utf-8")
    assert declaration.carrier_findings(stem) == ["declared in both carriers: widget-flow.drawio.yml and a `yml drawio` block in widget-flow.md"]


def test_the_renderer_finds_an_article_diagram_before_its_first_put_from_its_block(article, monkeypatch):
    stem, _ = article
    monkeypatch.setattr(drawio_forward, "REPO", stem.parent.parent)
    assert drawio_forward.diagrams(stem) == [stem.resolve()]
    assert drawio_forward.diagrams(stem.parent.parent) == [stem.resolve()]


def test_a_stem_with_no_block_no_yml_and_no_png_is_not_found(article):
    stem, page = article
    page.write_text("# Widgets flow into gadgets\n\nNo block here.\n", encoding="utf-8")
    assert drawio_forward.diagrams(stem.parent.parent) == [], "a diagram that does not exist yet is simply not found"


def test_a_block_in_a_slide_names_no_diagram(article):
    stem, page = article
    slide = page.with_name("widget-flow.slide.md")
    slide.write_text(page.read_text(encoding="utf-8"), encoding="utf-8")
    page.unlink()
    assert declaration.article_stems(stem.parent.parent) == set(), "a slide is never a carrier"
