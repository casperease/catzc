# cspell:ignore minimaps
"""A minimap drawn from its contract data: every shape of data draws, and what is lit is what shows.

usage (repo root, background): timeout 120 uv run --project python/Catzc.Diagrams python -m pytest python/Catzc.Diagrams/tests/test_minimap_drawing.py
"""

import copy
import json
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import minimap_contract
import minimaps

SAMPLE = minimap_contract.SCHEMA.with_name("minimap.sample.json")


def sample():
    return json.loads(SAMPLE.read_text(encoding="utf-8"))


def strip():
    """One axis: the gadget layers, one of them lit."""
    return {
        "id": "layer-stack",
        "axes": [{"name": "layer", "values": ["widget", "gadget"]}],
        "cells": [{"at": ["widget"], "count": 1}, {"at": ["gadget"], "count": 2}],
        "lit": [{"at": ["gadget"], "count": 2, "reasons": [{"subject": "ADR-GADGET", "basis": "layer", "requested": None, "note": None}]}],
    }


def places():
    """Three axes: track, module and folder, one place lit."""
    return {
        "id": "code-locations",
        "axes": [{"name": "track", "values": ["pwsh"]}, {"name": "module", "values": ["Catzc.Widget"]}, {"name": "folder", "values": ["tests"]}],
        "cells": [{"at": ["pwsh", "Catzc.Widget", "tests"], "count": 3}],
        "lit": [{"at": ["pwsh", "Catzc.Widget", "tests"], "count": 3, "reasons": [{"subject": "pwsh/Catzc.Widget/tests/a.ps1", "basis": "citation", "requested": "ADR-WIDGET", "note": None}]}],
    }


@pytest.mark.parametrize("data", [sample(), strip(), places()], ids=["two axes", "one axis", "three axes"])
def test_every_shape_of_contract_data_draws_and_what_is_lit_shows(data):
    minimap_contract.validate_minimap(data)
    drawn = minimaps.picture_from(data, 300, 160)
    unlit = copy.deepcopy(data)
    unlit["lit"] = []
    assert drawn.startswith("data:image/png,")
    assert drawn != minimaps.picture_from(unlit, 300, 160)


def test_a_minimap_draws_in_every_theme():
    assert minimaps.picture_from(sample(), 300, 160, "dark") != minimaps.picture_from(sample(), 300, 160, "light")
