# ---
# catzc:
#   immutable:
#     with_body_sha: "197567869f04"
# ---

# cspell:ignore mxfile getpixel
"""Re-rendering a .drawio.png from the model it carries, with and without a page override.

usage (repo root, background): timeout 120 uv run -q --with pillow==12.3.0 --with pytest==9.1.1 python -m pytest python/catzc_diagrams/tests
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


def near(pixel, colour, tolerance=24):
    """True when the pixel is the colour, up to the blend the supersampled page leaves on a shape's edge."""
    return all(abs(a - b) <= tolerance for a, b in zip(pixel, colour))


def dark(pixel):
    """True when the pixel is ink on the white page: a glyph stem, even one the downsample softened."""
    return sum(pixel) < 300


def test_draws_an_edge_given_by_points_inside_a_group_with_its_start_arrow():
    img = rendered(
        '<mxCell id="group" value="" style="group;strokeColor=none;" vertex="1" parent="1">'
        '<mxGeometry x="50" y="50" width="200" height="100" as="geometry"/></mxCell>'
        '<mxCell id="span" value="" style="endArrow=none;startArrow=classic;strokeColor=#FF0000;strokeWidth=3;" edge="1" parent="group">'
        '<mxGeometry relative="1" as="geometry"><mxPoint x="10" y="50" as="sourcePoint"/><mxPoint x="190" y="50" as="targetPoint"/>'
        "</mxGeometry></mxCell>"
    )
    assert near(at(img, 150, 100), RED)  # the middle of the span, the group's offset added
    assert near(at(img, 67, 102), RED)  # the start arrow's head widens past the 4 px line
    assert not near(at(img, 231, 103), RED)  # no end arrow


def test_routes_an_edge_through_its_waypoints_rounding_the_corners_when_rounded():
    def corner(rounded):
        return rendered(
            f'<mxCell id="bend" value="" style="endArrow=none;rounded={rounded};strokeColor=#FF0000;strokeWidth=3;" edge="1" parent="1">'
            '<mxGeometry relative="1" as="geometry"><mxPoint x="20" y="20" as="sourcePoint"/><mxPoint x="200" y="180" as="targetPoint"/>'
            '<Array as="points"><mxPoint x="200" y="20"/></Array></mxGeometry></mxCell>'
        )

    square, round_ = corner(0), corner(1)
    assert near(at(square, 110, 20), RED) and near(at(square, 200, 100), RED)  # both legs follow the waypoint, not the diagonal
    assert not near(at(square, 110, 100), RED)
    assert near(at(square, 200, 20), RED) and not near(at(round_, 200, 20), RED)  # the rounded corner cuts the waypoint
    assert near(at(round_, 110, 20), RED) and near(at(round_, 200, 100), RED)


def test_draws_no_arrowhead_for_an_edge_whose_ends_meet():
    img = rendered(
        '<mxCell id="label" value="" style="text;strokeColor=none;fillColor=none;" vertex="1" parent="1">'
        '<mxGeometry x="100" y="100" width="90" height="16" as="geometry"/></mxCell>'
        '<mxCell id="loop" value="" style="edgeStyle=orthogonalEdgeStyle;strokeColor=#FF0000;" edge="1" parent="1" source="label" target="label">'
        '<mxGeometry relative="1" as="geometry"/></mxCell>'
    )
    assert all(img.getpixel((x, y)) == (255, 255, 255) for x in range(20 + 90, 20 + 200) for y in range(20 + 95, 20 + 125))


def test_places_an_edge_label_at_the_middle_of_its_routed_length():
    img = rendered(
        '<mxCell id="bend" value="widget" style="endArrow=none;strokeColor=#FF0000;fontColor=#000000;fontSize=11;" edge="1" parent="1">'
        '<mxGeometry relative="1" as="geometry"><mxPoint x="120" y="20" as="sourcePoint"/><mxPoint x="20" y="180" as="targetPoint"/>'
        '<Array as="points"><mxPoint x="20" y="20"/></Array></mxGeometry></mxCell>'
    )
    ink = lambda x0, x1, y0, y1: any(dark(at(img, x, y)) for x in range(x0, x1) for y in range(y0, y1))
    assert ink(20, 80, 30, 60)  # beside the vertical leg: the 260 px path's middle is 30 px down it, at (20, 50)
    assert not ink(50, 110, 0, 15)  # not above the first leg's middle, at (70, 20)


def test_draws_nothing_for_a_group_cell():
    img = rendered(
        '<mxCell id="group" value="" style="group;" vertex="1" parent="1"><mxGeometry x="50" y="50" width="200" height="100" as="geometry"/></mxCell>'
    )
    assert at(img, 50, 100) == (255, 255, 255) and at(img, 150, 50) == (255, 255, 255)  # no border on either edge


def test_wraps_a_wrapping_label_inside_its_cell_width():
    img = rendered(
        '<mxCell id="note" value="widgets gadgets sprockets widgets gadgets sprockets" '
        'style="text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=12;fontColor=#000000;strokeColor=none;" vertex="1" parent="1">'
        '<mxGeometry x="20" y="20" width="80" height="150" as="geometry"/></mxCell>'
    )
    beyond = [img.getpixel((x, y)) for x in range(20 + 110, 20 + 290) for y in range(20 + 20, 20 + 170)]
    assert all(p == (255, 255, 255) for p in beyond)  # nothing past the cell's 80 px
    assert any(img.getpixel((x, 20 + 60)) != (255, 255, 255) for x in range(20 + 24, 20 + 100))  # the words went onto later lines


def test_reads_an_opening_div_as_a_new_line():
    assert drawio_png.plain("<font>widget</font><div><font>gadget</font></div>") == "widget\ngadget"
    assert drawio_png.plain("<div>widget</div><div>gadget</div>") == "widget\ngadget"


def test_reads_an_html_font_colour_given_as_rgb():
    assert drawio_png.html_color('<font style="color: rgb(255, 0, 0);">widget</font>') == "#ff0000"
    assert drawio_png.html_color('<font color="#00ff00">widget</font>') == "#00ff00"


def test_draws_a_flex_arrow_as_a_filled_block_with_a_head():
    img = rendered(
        '<mxCell id="push" value="" style="shape=flexArrow;endArrow=classic;fillColor=#00FF00;strokeColor=#0000FF;width=10;endWidth=20;endSize=7;" '
        'edge="1" parent="1"><mxGeometry relative="1" as="geometry"><mxPoint x="20" y="100" as="sourcePoint"/>'
        '<mxPoint x="280" y="100" as="targetPoint"/></mxGeometry></mxCell>'
    )
    assert near(at(img, 120, 100), GREEN) and near(at(img, 120, 103), GREEN)  # the body is a filled band, not a line
    assert not near(at(img, 120, 112), GREEN)  # the body is width 10
    assert near(at(img, 267, 106), GREEN)  # the head is wider than the body
    assert any(near(at(img, 120, y), BLUE, 90) for y in (94, 95, 96))  # its outline, a hairline the downsample blends


def test_an_unpainted_token_fails_naming_the_cell_and_the_key():
    import pytest
    with pytest.raises(SystemExit, match=r"widget fillColor=@slate"):
        rendered(
            '<mxCell id="widget" value="widget" style="rounded=1;fillColor=@slate;strokeColor=#FF0000;" vertex="1" parent="1">'
            '<mxGeometry x="20" y="20" width="120" height="40" as="geometry"/></mxCell>'
        )


def test_the_draw_io_colour_keywords_still_render():
    img = rendered(
        '<mxCell id="gadget" value="" style="rounded=1;fillColor=none;strokeColor=#FF0000;fontColor=default;" vertex="1" parent="1">'
        '<mxGeometry x="20" y="20" width="120" height="40" as="geometry"/></mxCell>'
    )
    assert img is not None


def test_a_legend_folder_renders_the_glyph_library_painted_in_the_default_theme(tmp_path):
    import drawio_forward
    target = drawio_forward.put_legend(tmp_path)
    model = drawio_png.decode(drawio_png.mxfile_chunk(Image.open(target)))
    assert "@" not in model and 'id="e-read"' in model and 'id="g-set"' in model
    assert drawio_png.tokens()["mauve"] in model  # the named set's fill, painted
