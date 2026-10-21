# ---
# catzc:
#   immutable:
#     with_body_sha: acbd47148fa1
# ---

# cspell:ignore minimaps
"""The kit's tests run on fixture diagrams outside the repository, where no minimap data has been computed: each diagram gets its
declared minimaps (or three fixed ones) as empty contract data, so put draws the sidebar without Catzc.Base.Maps. A test names its
diagram by its tmp_path as the stem, so the pair is `<tmp_path>.drawio.yml` and `<tmp_path>.drawio.png`."""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration

FIXTURE_MINIMAPS = ["grid", "axis", "layer-stack"]


def empty_minimaps(folder, computed=False):
    has_source = declaration.source_of(folder).is_file()
    views = (declaration.load(folder)["content"]["minimaps"] if has_source else None) or FIXTURE_MINIMAPS
    return {view: {"id": view, "axes": [], "cells": [], "lit": []} for view in views}


@pytest.fixture(autouse=True)
def fixture_minimap_data(monkeypatch):
    monkeypatch.setattr(declaration, "minimap_data", empty_minimaps)
