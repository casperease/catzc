"""The path a slide's `## Image` section links to, and the refusal of any other form.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/diagrams/tests/test_slide_png.py
"""

import pytest
from catzc.diagrams import slide_png


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


def test_an_image_embed_is_refused(tmp_path):
    path = slide(tmp_path, "![widget](.assets/widget.png)")
    _, fields = slide_png.head_and_fields(path)
    with pytest.raises(SystemExit, match="found '!\\[widget\\]"):
        slide_png.image_of(path, fields)
