"""The path a slide's `## Image` section links to, the refusal of any other form, and the slide a written png names.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/diagrams/tests/test_slide_png.py
"""

import pytest
from catzc.diagrams import slide_png
from PIL import Image, ImageColor


def slide(tmp_path, image):
    """A slide file whose `## Image` section holds the given line."""
    path = tmp_path / "widget.slide.md"
    path.write_text(f"# Widget\n\n## Image\n\n{image}\n\n## Caption\n\nA widget.\n", encoding="utf-8", newline="\n")
    return path


def test_the_image_is_the_target_of_the_one_link(tmp_path):
    path = slide(tmp_path, "[widget](.assets/widget.png)")
    _, fields = slide_png.head_and_fields(path)
    assert slide_png.image_of(path, fields) == tmp_path / ".assets" / "widget.png"


def test_a_bare_path_is_refused_naming_the_file(tmp_path):
    path = slide(tmp_path, ".assets/widget.png")
    _, fields = slide_png.head_and_fields(path)
    with pytest.raises(SystemExit, match=r"widget\.slide\.md: the ## Image section holds one markdown link"):
        slide_png.image_of(path, fields)


def test_a_text_only_fact_slide_renders_at_the_deck_size(tmp_path):
    path = tmp_path / "widget.slide.md"
    path.write_text(
        "---\ncatzc:\n  config:\n    pattern: fact\n    order: 2\n---\n\n# The widget spins\n\n## Eyebrow\n\n2 / 3 · fact · ADR-WIDGET-SPIN\n\n"
        "## Lead\n\n" + "A widget spins when wound, and the lead takes the whole width of the slide. " * 3 + "\n",
        encoding="utf-8",
        newline="\n",
    )
    out = slide_png.render(path, tmp_path / "widget.slide.png")
    layout, fact = slide_png.SLIDES["layout"], slide_png.SLIDES["fact"]
    width, height, gutter = int(layout["width"]), int(layout["height"]), int(layout["gutter"])
    with Image.open(out) as img:
        assert img.size == (width, height)
        # With no picture the text runs into the column a picture would hold, so that column carries ink, not only the background.
        column = img.convert("RGB").crop((width - gutter - int(fact["picture_width"]), gutter, width - gutter, height // 2))
        background = ImageColor.getrgb(slide_png.SLIDES["token"]["bg_deep"])
        assert any(colour != background for _, colour in column.getcolors(maxcolors=column.width * column.height))


def test_a_png_names_the_slide_it_was_made_for(tmp_path):
    path = slide(tmp_path, "[widget](.assets/widget.png)")
    (tmp_path / "gadget.slide.md").write_text("# Gadget\n\n## Image\n\n[gadget](.assets/gadget.png)\n", encoding="utf-8", newline="\n")
    assert slide_png.slide_of(path, "picture") == path
    assert slide_png.slide_of(tmp_path / ".assets" / "widget.png", "picture") == path
    assert slide_png.slide_of(tmp_path / ".assets" / "widget.slide.png", "render") == path


def test_a_picture_no_slide_links_is_refused(tmp_path):
    slide(tmp_path, "[widget](.assets/widget.png)")
    with pytest.raises(SystemExit, match=r"0 slide\(s\) of its deck link it"):
        slide_png.slide_of(tmp_path / ".assets" / "sprocket.png", "picture")


def test_an_image_embed_is_refused(tmp_path):
    path = slide(tmp_path, "![widget](.assets/widget.png)")
    _, fields = slide_png.head_and_fields(path)
    with pytest.raises(SystemExit, match="found '!\\[widget\\]"):
        slide_png.image_of(path, fields)
