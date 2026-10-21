# ---
# catzc:
#   immutable:
#     with_body_sha: bf2fd227d84b
# ---

"""The minimap contract: the kit accepts the contract's sample and rejects a minimap JSON that breaks the schema.

usage (repo root, background): timeout 120 uv run -q --project python/catzc_diagrams python -m pytest python/catzc_diagrams/tests/test_minimap_contract.py
"""

import json
import sys
from pathlib import Path

import jsonschema
import pytest

KIT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(KIT))

import minimap_contract

SAMPLE = minimap_contract.SCHEMA.with_name("minimap.sample.json")


def sample() -> dict:
    return json.loads(SAMPLE.read_text(encoding="utf-8"))


def test_the_contract_sample_conforms():
    minimap_contract.validate_minimap(sample())


def test_load_reads_and_checks_a_file(tmp_path):
    path = tmp_path / "widget.json"
    path.write_text(json.dumps(sample()), encoding="utf-8")
    assert minimap_contract.load_minimap(path)["id"] == "grid"


@pytest.mark.parametrize(
    ("breakage", "names"),
    [
        (lambda data: data["lit"][0].pop("reasons"), "reasons"),
        (lambda data: data.__setitem__("id", "widget"), "widget"),
        (lambda data: data["cells"][0].__setitem__("count", "two"), "two"),
        (lambda data: data.__setitem__("gadget", 1), "gadget"),
    ],
)
def test_a_minimap_that_breaks_the_schema_is_rejected(breakage, names):
    data = sample()
    breakage(data)
    with pytest.raises(jsonschema.ValidationError, match=names):
        minimap_contract.validate_minimap(data)
