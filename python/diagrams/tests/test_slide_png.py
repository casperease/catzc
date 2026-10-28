"""The path a slide's `## Image` section links to, the refusal of any other form, the slide a written png names, and one stamp per call.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/diagrams/tests/test_slide_png.py
"""

import pytest
from catzc.diagrams import slide_png, stamp
from PIL import Image, ImageColor


@pytest.fixture
def stamps(tmp_path, monkeypatch):
    """The head runs a call starts, each the argument list it hands the entry script; the repository is the test's folder."""
    calls = []

    def run(arguments, **_):
        calls.append(arguments)
        return type("Run", (), {"returncode": 0, "stdout": "", "stderr": ""})()

    monkeypatch.setattr(stamp, "REPO", tmp_path)
    monkeypatch.setattr(stamp.subprocess, "run", run)
    return calls


def fact(tmp_path, name, image=None):
    """A fact slide named name; with an image, its head reduces the deck's source png into it."""
    head = "---\ncatzc:\n  config:\n    pattern: fact\n    picture: { mode: reduce, source: source.png, scale: 1 }\n---\n\n" if image else ""
    shown = f"## Image\n\n[{name}]({image})\n\n" if image else ""
    path = tmp_path / f"{name}.slide.md"
    path.write_text(f"{head}# The {name} spins\n\n## Lead\n\nA {name} spins when wound.\n\n{shown}", encoding="utf-8", newline="\n")
    return path


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


def test_a_render_of_two_slides_stamps_both_in_one_head_run(tmp_path, stamps):
    paths = [fact(tmp_path, "widget"), fact(tmp_path, "gadget")]
    written = slide_png.write("render", [str(path) for path in paths])
    assert written == [tmp_path / ".assets" / "widget.slide.png", tmp_path / ".assets" / "gadget.slide.png"]
    assert all(png.exists() for png in written)
    assert len(stamps) == 1
    assert stamps[0][4:] == [
        "@('.assets/widget.slide.png', '.assets/gadget.slide.png') | ForEach-Object { Set-GeneratedFileHead -Path $_ -Writer 'slide_png render' }",
    ]


def test_a_picture_of_two_slides_stamps_both_in_one_head_run(tmp_path, stamps):
    Image.new("RGB", (4, 2), "white").save(tmp_path / "source.png")
    fact(tmp_path, "widget", ".assets/widget.png")
    fact(tmp_path, "gadget", ".assets/gadget.png")
    written = slide_png.write("picture", [str(tmp_path / ".assets" / "widget.png"), str(tmp_path / ".assets" / "gadget.png")])
    assert written == [tmp_path / ".assets" / "widget.png", tmp_path / ".assets" / "gadget.png"]
    with Image.open(written[0]) as img:
        assert img.size == (4, 2)
    assert len(stamps) == 1
    assert stamps[0][4:] == [
        "@('.assets/widget.png', '.assets/gadget.png') | ForEach-Object { Set-GeneratedFileHead -Path $_ -Writer 'slide_png picture' }",
    ]
