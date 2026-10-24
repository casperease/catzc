"""The repository normal form of a name, read from the one place that configures it.

`naming.normal_form` of the languages config (pwsh/Catzc.Base.Languages/configs/languages.yml) names the case every contract, lookup and
cross-language name is written in (ADR-AUTO-IDIOM-NORMALFORM). This module reads that key and judges a name against the configured case,
so a declaration's command name follows the repository's setting and no second copy of the case lives here. The default of the setting is
programmed once, on LanguagesConfig, and shown in the shipped file; a file without the key is an error here, never a silent default.
"""

import re
from functools import cache
from pathlib import Path

import yaml

REPO = Path(__file__).resolve().parents[2]
LANGUAGES = REPO / "pwsh" / "Catzc.Base.Languages" / "configs" / "languages.yml"

# The closed set of naming cases (ADR-AUTO-IDIOM-CLOSEDCASES), each as the names it accepts. `snake` is the one the repository configures.
CASES = {
    "snake": r"[a-z][a-z0-9_]*",
    "kebab": r"[a-z][a-z0-9-]*",
    "flat": r"[a-z][a-z0-9]*",
    "camel": r"[a-z][a-zA-Z0-9]*",
    "pascal": r"[A-Z][a-zA-Z0-9]*",
    "pascal-dotted": r"[A-Z][a-zA-Z0-9]*(\.[A-Z][a-zA-Z0-9]*)*",
    "verb-noun": r"[A-Z][a-z0-9]*-[A-Z][a-zA-Z0-9]*",
}


@cache
def configured_case():
    """The case the languages config names as the normal form."""
    naming = (yaml.safe_load(LANGUAGES.read_text(encoding="utf-8")) or {}).get("naming") or {}
    case = naming.get("normal_form")
    if case is None:
        raise ValueError(f"{LANGUAGES.name} states no naming.normal_form; the normal form is configured, never assumed")
    if case not in CASES:
        raise ValueError(f"naming.normal_form '{case}' is not one of: {', '.join(CASES)}")
    return case


def accepts(name, case=None):
    """Whether the name is written in the case (the configured normal form when none is given)."""
    return re.fullmatch(CASES[case or configured_case()], str(name)) is not None
