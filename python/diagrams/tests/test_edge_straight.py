# cspell:ignore minimaps
"""Every routed edge runs level or plumb: an edge whose two boxes share a span on one axis is one straight line inside that span, a
fan-out's targets each take their line at their own middle, and an end held at its middle (a diamond) that the span misses steps once
across the gap; no leg is a slant.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/diagrams/tests/test_edge_straight.py
"""

from itertools import pairwise

import pytest
import yaml
from catzc.diagrams import declaration

FAN = """
about:
  lens: architecture
content:
  title: A widget fans out to two gadgets
  flow: top-to-bottom
  relation: feeds
  states: true
  bands:
    - { id: band-widgets, label: Widgets }
  glyphs:
    - { id: widget-source, kind: code, label: Widget source, in: band-widgets }
    - { id: gadget-left, kind: code, label: Gadget left, in: band-widgets }
    - { id: gadget-right, kind: code, label: Gadget right, in: band-widgets }
    - { id: widget-gate, kind: gate, label: Widget gate, in: band-widgets }
    - { id: gadget-off, kind: code, label: Gadget off, in: band-widgets }
    - { id: gadget-level, kind: code, label: Gadget level, in: band-widgets }
  edges:
    - { from: widget-source, to: gadget-left, kind: flow, label: calls }
    - { from: widget-source, to: gadget-right, kind: flow, label: calls }
    - { from: widget-gate, to: gadget-off, kind: flow, label: then }
    - { from: gadget-right, to: gadget-level, kind: flow, label: calls }
layout:
  band-widgets: { x: 40, y: 140, w: 1100, h: 420 }
  widget-source: { x: 100, y: 200, w: 440, h: 44 }
  gadget-left: { x: 70, y: 340, w: 220, h: 44 }
  gadget-right: { x: 320, y: 340, w: 220, h: 44 }
  widget-gate: { x: 640, y: 190, w: 120, h: 80 }
  gadget-off: { x: 720, y: 400, w: 200, h: 44 }
  gadget-level: { x: 800, y: 330, w: 200, h: 44 }
"""


def routes():
    declaration.put(declaration.normalise(yaml.safe_load(FAN)))
    return {(r["from"], r["to"]): r["points"] for r in declaration.LAST_ROUTES}


def slanted(points):
    return [(p, q) for p, q in pairwise(points) if abs(p[0] - q[0]) > 1 and abs(p[1] - q[1]) > 1]


def shares_a_span(a, b):
    return min(a["x"] + a["w"], b["x"] + b["w"]) > max(a["x"], b["x"]) or min(a["y"] + a["h"], b["y"] + b["h"]) > max(a["y"], b["y"])


def test_no_feed_or_call_edge_between_boxes_that_could_align_is_drawn_diagonal():
    layout = yaml.safe_load(FAN)["layout"]
    drawn = routes()
    for (tail, head), points in drawn.items():
        if shares_a_span(layout[tail], layout[head]):
            assert not slanted(points), f"{tail} -> {head} is diagonal: {points}"


@pytest.mark.parametrize("head", ["gadget-left", "gadget-right"])
def test_a_fan_out_target_takes_its_line_at_its_own_middle_as_one_plumb_line(head):
    layout = yaml.safe_load(FAN)["layout"]
    points = routes()["widget-source", head]
    middle = layout[head]["x"] + layout[head]["w"] / 2
    assert len(points) == 2
    assert all(abs(x - middle) < 1 for x, _ in points)


def test_a_diamond_whose_middle_the_shared_span_misses_steps_once_across_the_gap():
    points = routes()["widget-gate", "gadget-off"]
    assert len(points) == 4 and not slanted(points)
    assert abs(points[0][0] - 700) < 1  # out of the diamond's bottom tip, at its middle


def test_a_level_edge_runs_at_one_y_inside_the_span_its_boxes_share():
    points = routes()["gadget-right", "gadget-level"]
    assert len(points) == 2 and abs(points[0][1] - points[1][1]) < 1
    assert 340 <= points[0][1] <= 374
