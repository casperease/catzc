"""The minimap data contract: one minimap's JSON is checked against the schema in contracts/ before anything draws it.

Catzc.Base.Maps writes the data through its MinimapData type; this kit only reads it, and never loads that type
(contracts/catzc/0.0.0/Catzc.Base.Maps/minimap.schema.json, ADR-REPO-CONTRACT-CONTRACTASSET).
"""

import json
from functools import cache
from pathlib import Path
from typing import Any

import jsonschema

REPO = Path(__file__).resolve().parents[2]
SCHEMA = REPO / "contracts" / "catzc" / "0.0.0" / "Catzc.Base.Maps" / "minimap.schema.json"


@cache
def schema() -> dict[str, Any]:
    return json.loads(SCHEMA.read_text(encoding="utf-8"))


def validate_minimap(data: Any) -> None:
    """Raise jsonschema.ValidationError, naming the failing path, when the data breaks the minimap contract."""
    jsonschema.validate(data, schema())


def load_minimap(path: Path) -> dict[str, Any]:
    """Read one minimap's JSON and check it against the contract before it is drawn."""
    data = json.loads(path.read_text(encoding="utf-8"))
    validate_minimap(data)
    return data
