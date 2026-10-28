"""The action lens's shared samples: the declarations in `action-lens/`, loaded raw or normalised, for every action-lens test file."""

from pathlib import Path

import yaml
from catzc.diagrams import declaration

FIXTURES = Path(__file__).resolve().parent / "action-lens"


def sample(name="action-sample"):
    return yaml.safe_load((FIXTURES / f"{name}.drawio.yml").read_text(encoding="utf-8"))


def normalised(raw):
    return declaration.normalise(raw)
