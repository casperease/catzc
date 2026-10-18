"""Re-rendering a .drawio.png from the model it carries, with and without a page override.

usage (repo root, background): timeout 120 uv run -q --with pillow==12.3.0 --with pytest==9.1.1 python -m pytest .claude/drawio/tests
"""

import sys
from pathlib import Path

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import drawio_png
from PIL import Image

MODEL = (
    '<mxGraphModel background="#ffffff"><root><mxCell id="0"/><mxCell id="1" parent="0"/>'
    '<mxCell id="widget" value="widget" style="rounded=1;html=1;" vertex="1" parent="1">'
    '<mxGeometry x="20" y="20" width="120" height="40" as="geometry"/></mxCell></root></mxGraphModel>'
)


def run(monkeypatch, *args):
    """Run the script's main with the given arguments."""
    monkeypatch.setattr(sys, "argv", ["drawio_png.py", *map(str, args)])
    drawio_png.main()


def built(tmp_path, monkeypatch):
    """A .drawio.png built from the widget model, carrying the default page name."""
    source = tmp_path / "widget.xml"
    source.write_text(MODEL, encoding="utf-8")
    png = tmp_path / "widget.drawio.png"
    run(monkeypatch, source, png)
    return png


def test_rerenders_a_png_in_place_keeping_its_model_and_page_name(tmp_path, monkeypatch):
    png = built(tmp_path, monkeypatch)
    run(monkeypatch, png, png)
    chunk = drawio_png.mxfile_chunk(Image.open(png))
    assert drawio_png.decode(chunk).strip() == MODEL
    assert 'name="Page-1"' in drawio_png.unquote(chunk)


def test_rerenders_a_png_in_place_on_the_page_it_is_given(tmp_path, monkeypatch):
    png = built(tmp_path, monkeypatch)
    run(monkeypatch, png, png, "--page", "model")
    assert Image.open(png).convert("RGB").getpixel((2, 2)) == (255, 255, 255)


RED, GREEN, BLUE = (255, 0, 0), (0, 255, 0), (0, 0, 255)


def rendered(cells):
    """The raster of a white page holding a 300 x 200 frame at (0, 0) and the given cells; pixel (x + 20, y + 20) is model point (x, y)."""
    model = (
        '<mxGraphModel background="#ffffff"><root><mxCell id="0"/><mxCell id="1" parent="0"/>'
        '<mxCell id="frame" value="" style="rounded=0;fillColor=none;strokeColor=none;" vertex="1" parent="1">'
        '<mxGeometry x="0" y="0" width="300" height="200" as="geometry"/></mxCell>' + cells + "</root></mxGraphModel>"
    )
    return drawio_png.render(drawio_png.ET.fromstring(model), "model").convert("RGB")


def at(img, x, y):
    """The colour at model point (x, y)."""
    return img.getpixel((int(x) + 20, int(y) + 20))


def test_draws_an_edge_given_by_points_inside_a_group_with_its_start_arrow():
    img = rendered(
        '<mxCell id="group" value="" style="group;strokeColor=none;" vertex="1" parent="1">'
        '<mxGeometry x="50" y="50" width="200" height="100" as="geometry"/></mxCell>'
        '<mxCell id="span" value="" style="endArrow=none;startArrow=classic;strokeColor=#FF0000;strokeWidth=3;" edge="1" parent="group">'
        '<mxGeometry relative="1" as="geometry"><mxPoint x="10" y="50" as="sourcePoint"/><mxPoint x="190" y="50" as="targetPoint"/>'
        "</mxGeometry></mxCell>"
    )
    assert at(img, 150, 100) == RED  # the middle of the span, the group's offset added
    assert at(img, 69, 103) == RED  # the start arrow's head widens past the 4 px line
    assert at(img, 231, 103) != RED  # no end arrow


def test_routes_an_edge_through_its_waypoints_rounding_the_corners_when_rounded():
    def corner(rounded):
        return rendered(
            f'<mxCell id="bend" value="" style="endArrow=none;rounded={rounded};strokeColor=#FF0000;strokeWidth=3;" edge="1" parent="1">'
            '<mxGeometry relative="1" as="geometry"><mxPoint x="20" y="20" as="sourcePoint"/><mxPoint x="200" y="180" as="targetPoint"/>'
            '<Array as="points"><mxPoint x="200" y="20"/></Array></mxGeometry></mxCell>'
        )

    square, round_ = corner(0), corner(1)
    assert at(square, 110, 20) == RED and at(square, 200, 100) == RED  # both legs follow the waypoint, not the diagonal
    assert at(square, 110, 100) != RED
    assert at(square, 200, 20) == RED and at(round_, 200, 20) != RED  # the rounded corner cuts the waypoint
    assert at(round_, 110, 20) == RED and at(round_, 200, 100) == RED


def test_draws_a_flex_arrow_as_a_filled_block_with_a_head():
    img = rendered(
        '<mxCell id="push" value="" style="shape=flexArrow;endArrow=classic;fillColor=#00FF00;strokeColor=#0000FF;width=10;endWidth=20;endSize=7;" '
        'edge="1" parent="1"><mxGeometry relative="1" as="geometry"><mxPoint x="20" y="100" as="sourcePoint"/>'
        '<mxPoint x="280" y="100" as="targetPoint"/></mxGeometry></mxCell>'
    )
    assert at(img, 120, 100) == GREEN and at(img, 120, 103) == GREEN  # the body is a filled band, not a line
    assert at(img, 120, 112) != GREEN  # the body is width 10
    assert at(img, 268, 108) == GREEN  # the head is wider than the body
    assert BLUE in (at(img, 120, 95), at(img, 120, 94), at(img, 120, 96))  # its outline
