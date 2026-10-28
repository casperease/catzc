# cspell:ignore minimaps
"""The kit's tests run on fixture diagrams outside the repository, where no minimap data has been computed: each diagram gets its
declared minimaps (or three fixed ones) as empty contract data, so put draws the sidebar without Catzc.Base.Maps. A test names its
diagram by its tmp_path as the stem, so the pair is `<tmp_path>.drawio.yml` and `<tmp_path>.drawio.png`."""


import pytest
from catzc.diagrams import declaration, declaration_settings, declaration_sync

FIXTURE_MINIMAPS = ["grid", "axis", "layer-stack"]


def empty_minimaps(folder):
    has_source = declaration.declared(folder)
    views = (declaration.shown_minimaps(declaration.load(folder)["content"]["minimaps"]) if has_source else None) or FIXTURE_MINIMAPS
    return {view: {"id": view, "axes": [], "cells": [], "lit": []} for view in views}


@pytest.fixture(autouse=True)
def fixture_minimap_data(monkeypatch):
    monkeypatch.setattr(declaration_sync, "minimap_data", empty_minimaps)


@pytest.fixture(autouse=True)
def keep_out_is_off_unless_a_test_asks(monkeypatch):
    """The fixtures place cells by the grid with no regard for an edge's path; only the keep-out tests turn the check on."""
    monkeypatch.setattr(declaration_settings, "FINDINGS_FAIL", False)


WIDGETS = """
about:
  lens: architecture
content:
  title: Widgets flow into gadgets
  flow: left-to-right
  relation: feeds
  states: true
  bands:
    - { id: band-widgets, label: Widgets }
    - { id: band-gadgets, label: Gadgets }
  spans:
    - { id: span-build, label: CI, over: [band-widgets, band-gadgets] }
  groups:
    - { id: group-kit, label: Catzc.Widget.Kit, in: band-widgets }
    - { id: group-inner, label: Catzc.Widget.Kit.Inner, in: group-kit }
  glyphs:
    - { id: widget-a, kind: code, label: Widget A, in: group-kit }
    - { id: widget-b, kind: type, label: Widget B, in: group-inner }
    - { id: gadget-store, kind: store, label: Gadget store, in: band-gadgets }
    - { id: gadget-gate, kind: gate, label: Gadget gate, in: band-gadgets }
  edges:
    - { from: widget-a, to: gadget-store, kind: flow, label: writes }
    - { from: gadget-store, to: gadget-gate, kind: fail }
    - { from: gadget-store, to: group-kit, kind: adr }
  markers:
    - { at: widget-a, number: 1 }
    - { at: gadget-gate, number: 2 }
  chips:
    - { at: gadget-gate, kind: count, text: "87" }
"""


def widgets():
    return declaration.normalise(__import__("yaml").safe_load(WIDGETS))


ROWS = {
    "templates": {"widget-shape": {"states": {"PR": "landed", "BVT": "bvt", "ship": "prod"}, "drop": "discarded"}},
    "rows": [
        {
            "id": "row-full",
            "template": "widget-shape",
            "label": "PR + ship",
            "in": "band-gadgets",
            "start": "topic",
            "steps": ["PR", "BVT", "ship"],
        },
        {"id": "row-short", "template": "widget-shape", "label": "ship", "in": "band-gadgets", "start": "bvt", "steps": ["ship"]},
    ],
}


LANE = {
    "flow": "top-to-bottom",
    "bands": [{"id": "band-widgets", "label": "Widgets"}, {"id": "band-gadgets", "label": "Gadgets"}, {"id": "band-git", "label": "GIT"}],
    "lanes": [
        {
            "band": "band-git",
            "steps": 6,
            "trunk": "main",
            "commits": [
                {"id": "g1", "step": 1, "label": "1", "state": "landed"},
                {"id": "g2", "step": 2, "row": 1, "label": "2", "state": "topic", "from": "g1"},
                {"id": "g3", "step": 4, "label": "3", "from": "g2"},
            ],
            "marks": [{"at": "g3", "text": "dirty head"}],
        }
    ],
    "rules": [{"after": 2, "kind": "manual"}, {"after": 4, "kind": "automated"}],
}


def lane_widgets():
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["content"].update(__import__("copy").deepcopy(LANE))  # a copy, so no test's added commit reaches the next
    raw["content"]["spans"] = []
    return raw


WIDGET_MINIMAPS = ["grid", {"axis": {"exclude": ["AUTO/*"]}}, "layer-stack"]


def claimed():
    """The widget declaration about real places of this repository's registries, with three computed minimaps."""
    raw = __import__("yaml").safe_load(WIDGETS)
    raw["about"] = {
        "lens": "architecture",
        "rules": [next(iter(declaration.minimaps.records()))],
        "tracks": ["python"],
        "languages": ["python"],
        "modules": ["Catzc.Base.Repository"],
        "files": ["python/diagrams/minimaps.py"],
    }
    raw["content"]["minimaps"] = ["code-locations", "module-neighbourhood", "axis"]
    return raw


def committed_pair(folder, source):
    """Write a pair the way a commit holds it: the yml, and the png put from it; the pair's text and model are the base."""
    text = __import__("yaml").safe_dump(source, sort_keys=False)
    declaration.source_of(folder).write_text(text, encoding="utf-8")
    declaration.put_png(folder, declaration.load(folder))
    return text, declaration.model_of(folder)
