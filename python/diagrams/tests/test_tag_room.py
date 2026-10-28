"""Tags and group names take room no pill, marker or line end holds: a pill steps off a tag, a band title, a group name and a marker's
spot, a marker steps off a group name, an arrowhead and a bare word, a plumb line ends left of the tag row it meets, and a tag row wider
than its glyph stays inside the frame that holds it.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/diagrams/tests/test_tag_room.py
"""

import xml.etree.ElementTree as ET

import yaml
from catzc.diagrams import declaration
from catzc.diagrams.declaration_cells import TAG_ID
from catzc.diagrams.declaration_routes import LAST_ROUTES

HEAD = """
about:
  lens: architecture
content:
  title: A widget drawing
  flow: left-to-right
  relation: feeds
  states: true
"""


def put(body):
    return declaration.put(declaration.normalise(yaml.safe_load(HEAD + body)))


def cells_of(model):
    found = {}
    for c in ET.fromstring(model).iter("mxCell"):
        g = c.find("mxGeometry")
        if c.get("vertex") == "1" and g is not None:
            found[c.get("id")] = {
                "rect": tuple(float(g.get(k, 0)) for k in ("x", "y", "width", "height")),
                "parent": c.get("parent"),
                "value": c.get("value") or "",
                "style": c.get("style") or "",
            }
    return found


def meet(a, b):
    return a[0] < b[0] + b[2] and b[0] < a[0] + a[2] and a[1] < b[1] + b[3] and b[1] < a[1] + a[3]


def absolute(cells):
    """Each cell's rectangle on the page: a child's geometry is relative to its parent frame, so the frames' origins are added."""
    rects = {}
    for i, c in cells.items():
        x, y, w, h = c["rect"]
        parent = cells.get(c["parent"])
        while parent:
            x, y = x + parent["rect"][0], y + parent["rect"][1]
            parent = cells.get(parent["parent"])
        rects[i] = (x, y, w, h)
    return rects


GROUPED = """
  bands:
    - { id: band-widgets, label: WIDGETS }
  groups:
    - { id: grp-gadgets, label: Catzc.Widget.Gadgetry, in: band-widgets }
  glyphs:
    - { id: f-widget, kind: file, label: widget.yml, in: grp-gadgets }
    - { id: t-widget, kind: type, label: WidgetConfig, in: grp-gadgets }
  edges:
    - { from: t-widget, to: f-widget, kind: flow, label: reads }
  markers:
    - { at: f-widget, number: 1 }
    - { at: t-widget, number: 2 }
layout:
  band-widgets: { x: 20, y: 84, w: 310, h: 470 }
  grp-gadgets: { x: 40, y: 116, w: 270, h: 410 }
  f-widget: { x: 105, y: 140, w: 140, h: 52 }
  t-widget: { x: 100, y: 262, w: 150, h: 190 }
"""


def test_a_marker_steps_off_the_name_of_the_group_that_holds_its_glyph():
    cells = cells_of(put(GROUPED))
    rects = absolute(cells)
    x, y = rects["grp-gadgets"][:2]
    label = (x + 4, y, 6.5 * len("Catzc.Widget.Gadgetry") + 12, 18)  # the bold 11 px name under the frame's top-left corner
    for mark in (i for i in rects if i.startswith("mark-")):
        assert not meet(rects[mark], label), f"{mark} stands on the group name"


CROWDED = """
  bands:
    - { id: band-widgets, label: WIDGETS }
    - { id: band-gadgets, label: GADGETS }
  glyphs:
    - { id: w-first, kind: code, label: Invoke-Widget, in: band-widgets }
    - { id: w-second, kind: code, label: Invoke-WidgetAgain, in: band-widgets }
    - { id: w-run, kind: private, label: Invoke-WidgetRun, in: band-gadgets }
    - { id: w-next, kind: private, label: Get-GadgetState, in: band-gadgets }
  edges:
    - { from: w-first, to: w-run, kind: flow, label: calls }
    - { from: w-second, to: w-run, kind: flow, label: calls }
    - { from: w-run, to: w-next, kind: flow, label: calls }
  markers:
    - { at: w-run, number: 1 }
    - { at: w-next, number: 2 }
layout:
  band-widgets: { x: 20, y: 84, w: 200, h: 140 }
  band-gadgets: { x: 230, y: 84, w: 500, h: 140 }
  w-first: { x: 30, y: 114, w: 150, h: 40 }
  w-second: { x: 30, y: 166, w: 150, h: 40 }
  w-run: { x: 250, y: 136, w: 140, h: 36 }
  w-next: { x: 420, y: 136, w: 140, h: 36 }
"""


def test_a_marker_steps_off_every_arrowhead_and_bare_word_and_no_pill_stands_on_a_tag_a_title_or_a_marker():
    cells = cells_of(put(CROWDED))
    rects = absolute(cells)
    marks = [i for i in rects if i.startswith("mark-")]
    pills = [i for i in rects if i.endswith("-word")]
    tags = [i for i in rects if TAG_ID.search(i)]
    titles = [i for i in rects if i.endswith("-title") and i.startswith("band-")]
    assert tags and marks
    heads = [(r["points"][-1][0] - 6, r["points"][-1][1] - 6, 12, 12) for r in LAST_ROUTES]
    words = [r["word"] for r in LAST_ROUTES if r.get("word")]
    for mark in marks:
        for n, head in enumerate(heads + words):
            assert not meet(rects[mark], head), f"{mark} stands on the end or the word of line {n}"
    for pill in pills:
        for other in tags + titles + marks:
            assert not meet(rects[pill], rects[other]), f"{pill} stands on {other}"


def test_a_tag_row_wider_than_its_glyph_stays_inside_the_band_that_holds_it():
    cells = cells_of(put(CROWDED.replace("w-first: { x: 30, y: 114, w: 150, h: 40 }", "w-first: { x: 22, y: 114, w: 40, h: 40 }")))
    rects = absolute(cells)
    band = rects["band-widgets"]
    for tag in (i for i in rects if TAG_ID.search(i) and i.startswith("w-first")):
        x, _, w, _ = rects[tag]
        assert band[0] < x and x + w < band[0] + band[2], f"{tag} pokes out of its band"


PLUMB = """
  bands:
    - { id: band-widgets, label: WIDGETS }
    - { id: band-gadgets, label: GADGETS }
  glyphs:
    - { id: s-widget, kind: store, label: widget store, in: band-widgets }
    - { id: w-load, kind: code, label: Invoke-WidgetLoad, in: band-gadgets }
  edges:
    - { from: s-widget, to: w-load, kind: flow, label: feeds }
layout:
  band-widgets: { x: 20, y: 84, w: 900, h: 220 }
  band-gadgets: { x: 20, y: 330, w: 900, h: 120 }
  s-widget: { x: 600, y: 140, w: 280, h: 52 }
  w-load: { x: 380, y: 366, w: 300, h: 40 }
"""


def test_a_plumb_line_into_a_tagged_top_side_ends_left_of_the_tags():
    cells = cells_of(put(PLUMB))
    rects = absolute(cells)
    tag = rects["w-load-tag"]
    route = next(r for r in LAST_ROUTES if r["to"] == "w-load")
    tip_x = route["points"][-1][0]
    assert tip_x < tag[0] - 4, f"the line ends at x={tip_x} on or beside the tag {tag}"  # TAG_CLEAR, less the fractions' rounding
    assert rects["w-load"][0] < tip_x, "the line still ends on its target"
