# cspell:ignore minimaps
"""Markers and chips take room no tag, pill or other mark holds: a marker leaves the corner a tag stands on, chips on one corner step
inward past the tags and each other, and get reads each back as declared.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/diagrams/tests/test_mark_room.py
"""

import xml.etree.ElementTree as ET

import yaml
from catzc.diagrams import declaration
from catzc.diagrams.declaration_cells import TAG_ID

CROWD = """
about:
  lens: architecture
content:
  title: A widget crowded with marks
  flow: left-to-right
  relation: feeds
  states: true
  bands:
    - { id: band-widgets, label: Widgets }
  glyphs:
    - { id: widget-caller, kind: code, label: Invoke-Widget, in: band-widgets }
    - { id: widget-callee, kind: code, label: Get-WidgetGadgetState, in: band-widgets }
  edges:
    - { from: widget-caller, to: widget-callee, kind: flow, label: calls }
  markers:
    - { at: widget-caller, number: 1 }
    - { at: widget-callee, number: 2 }
  chips:
    - { at: widget-callee, kind: count, text: "12", corner: top-right }
    - { at: widget-callee, kind: count, text: "345", corner: top-right }
"""


def rectangles(model):
    found = {}
    for c in ET.fromstring(model).iter("mxCell"):
        g = c.find("mxGeometry")
        if c.get("vertex") == "1" and g is not None:
            found[c.get("id")] = tuple(float(g.get(k, 0)) for k in ("x", "y", "width", "height"))
    return found


def meet(a, b):
    return a[0] < b[0] + b[2] and b[0] < a[0] + a[2] and a[1] < b[1] + b[3] and b[1] < a[1] + a[3]


def test_no_marker_or_chip_stands_on_a_tag_a_pill_or_another_mark():
    model = declaration.put(declaration.normalise(yaml.safe_load(CROWD)))
    cells = rectangles(model)
    marks = [i for i in cells if i.startswith(("mark-", "chip-"))]
    room = [i for i in cells if TAG_ID.search(i) or i.endswith("-word")]
    assert any(TAG_ID.search(i) for i in cells), "the fixture's code glyphs carry tags"
    for n, mark in enumerate(marks):
        for other in room + marks[n + 1 :]:
            assert not meet(cells[mark], cells[other]), f"{mark} stands on {other}"


def test_get_reads_back_the_markers_and_chips_as_declared():
    source = declaration.normalise(yaml.safe_load(CROWD))
    back = declaration.get(declaration.put(source), "explanation")
    assert back["content"]["markers"] == source["content"]["markers"]
    assert back["content"]["chips"] == source["content"]["chips"]
