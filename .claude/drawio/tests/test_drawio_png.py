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
