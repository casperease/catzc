# ---
# catzc:
#   immutable:
#     with_body_sha: c7891b438da4
# ---

# cspell:ignore minimaps
"""The kit's tests run on fixture folders outside the repository, where no minimap data has been computed: each folder gets its
declared minimaps (or three fixed ones) as empty contract data, so put draws the sidebar without Catzc.Base.Maps."""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration

FIXTURE_MINIMAPS = ["grid", "axis", "layer-stack"]


def empty_minimaps(folder):
    has_source = (Path(folder) / declaration.SOURCE).is_file()
    views = (declaration.load(folder)["content"]["minimaps"] if has_source else None) or FIXTURE_MINIMAPS
    return {view: {"id": view, "axes": [], "cells": [], "lit": []} for view in views}


@pytest.fixture(autouse=True)
def fixture_minimap_data(monkeypatch):
    monkeypatch.setattr(declaration, "minimap_data", empty_minimaps)
