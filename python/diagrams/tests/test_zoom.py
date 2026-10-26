"""A diagram's zoom, tested: the optional about.zoom, its closed list beside the lenses, and the source that keeps it.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_zoom.py
"""

import sys
from pathlib import Path

import pytest

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration
from conftest import WIDGETS


def raw_widgets():
    return __import__("yaml").safe_load(WIDGETS)


def test_a_diagram_without_a_zoom_has_none_and_dumps_none():
    declared = declaration.normalise(raw_widgets())
    assert declared["content"]["zoom"] is None
    assert "zoom" not in declared["about"]
    assert "zoom" not in declaration.dump(declared)


@pytest.mark.parametrize("level", ["C0", "C1", "C2", "C3", "C4"])
def test_every_level_of_the_ladder_is_accepted_and_dumped(level):
    raw = raw_widgets()
    raw["about"]["zoom"] = level
    declared = declaration.normalise(raw)
    assert declared["content"]["zoom"] == level
    assert declared["about"]["zoom"] == level
    assert f"zoom: {level}" in declaration.dump(declared)


def test_the_zoom_badge_stands_beside_the_lens_badge_and_comes_back():
    raw = raw_widgets()
    raw["about"]["zoom"] = "C3"
    first = declaration.normalise(raw)
    cells = {c["id"]: c for c in declaration.place(first)[0]}
    lens, zoom, title = cells["lens-badge"], cells["zoom-badge"], cells["title"]
    assert zoom["value"] == "C3"
    assert lens["x"] + lens["w"] <= zoom["x"] < zoom["x"] + zoom["w"] <= title["x"]
    back = declaration.get(declaration.put(first), kind="explanation")
    assert back["about"]["zoom"] == "C3"
    assert declaration.dump(back) == declaration.dump(first)


def test_a_diagram_without_a_zoom_draws_no_zoom_badge():
    cells = {c["id"] for c in declaration.place(declaration.normalise(raw_widgets()))[0]}
    assert "zoom-badge" not in cells and "lens-badge" in cells


def test_a_level_outside_the_ladder_is_refused_naming_it():
    raw = raw_widgets()
    raw["about"]["zoom"] = "C5"
    with pytest.raises(declaration.DeclarationError, match="about.zoom"):
        declaration.normalise(raw)
