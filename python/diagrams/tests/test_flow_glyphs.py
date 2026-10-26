"""The flow glyphs: every word of drawio.yml's flow-glyphs renders exactly as its committed SVG, and a wrong word is refused naming it."""

import base64

import pytest
from catzc.diagrams import embed_images, flow_glyphs
from catzc.diagrams.declaration_vocabulary import GLYPH_KINDS, LIB, DeclarationError
from catzc.diagrams.drawio_png_base import tokens


@pytest.mark.parametrize("entry", flow_glyphs.glyphs(), ids=lambda entry: entry["id"])
def test_every_flow_glyph_renders_as_its_committed_svg(entry):
    committed = flow_glyphs.ASSETS / f"{entry['id']}.svg"
    assert committed.is_file(), f"no committed {committed.name}; run flow_glyphs.write_all()"
    assert flow_glyphs.render(entry["word"]) == committed.read_text(encoding="utf-8")


def test_a_word_is_three_symbols_long():
    with pytest.raises(DeclarationError, match="'O=' is not three symbols long"):
        flow_glyphs.render("O=")


def test_a_symbol_outside_the_alphabet_is_refused_naming_it():
    with pytest.raises(DeclarationError, match="holds 'x'"):
        flow_glyphs.render("Ox0")


def test_the_dotted_circle_is_the_empty_one_with_a_dot():
    empty = flow_glyphs.render("O..")
    dotted = flow_glyphs.render("0..")
    assert dotted.count("<circle") == empty.count("<circle") + 1


def test_lines_at_two_heights_join_with_a_riser_and_strokes_are_the_ink_token():
    text = flow_glyphs.render("O_-")
    assert text.count("<line") == 3  # the bottom line, the middle line and the riser between them
    assert "#" not in text.split("\n", 1)[1]  # no hex colour: every stroke is @ink


def test_the_flow_environment_is_a_rhombus_glyph_of_the_kit():
    assert "env-flow" in GLYPH_KINDS
    assert "shape=rhombus" in LIB["glyphs"]["env-flow"]["style"]


@pytest.mark.parametrize("theme", ["dark", "light"])
def test_a_glyph_embeds_with_the_themes_ink(theme):
    model = '<mxGraphModel><root><mxCell id="g" style="shape=image;html=1;" vertex="1"/></root></mxGraphModel>'
    embedded = embed_images.embed(model, "g", flow_glyphs.ASSETS / "pipeline.svg", theme)
    data = embedded.split("image=data:image/svg+xml,", 1)[1].split(";", 1)[0]
    svg = base64.b64decode(data).decode("utf-8")
    assert "@ink" not in svg
    assert tokens(theme)["ink"] in svg
