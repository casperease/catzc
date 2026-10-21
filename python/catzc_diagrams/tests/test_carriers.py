# ---
# catzc:
#   immutable:
#     with_body_sha: e84b3f55c940
# ---

"""The carrier of a diagram's declaration: the kit's drawio.yml declares the default once, and names a diagram's other carrier by its stem.

usage (repo root, background): timeout 120 uv run -q --project python/catzc_diagrams python -m pytest python/catzc_diagrams/tests
"""

import sys
from pathlib import Path

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from drawio_png import DEFAULTS

CARRIERS = ("file", "article")


def test_the_default_carrier_is_the_file_beside_the_png():
    assert DEFAULTS["renderer"]["carrier"] == "file"


def test_every_named_carrier_is_one_of_the_closed_set_and_names_a_stem():
    for stem, carrier in DEFAULTS["carriers"].items():
        assert carrier in CARRIERS, f"{stem}: carrier '{carrier}' is not one of {', '.join(CARRIERS)}"
        assert "/.assets/" in stem and not stem.endswith((".drawio.yml", ".drawio.png")), f"{stem}: a carrier is keyed by the diagram's stem"
