"""The language tags of a code glyph, derived at render time from the shape of its label and never stored in a declaration.

One table, pwsh/Catzc.Base.Languages/configs/languages.yml: a language row with a `tag` is one a diagram prints, its `shapes` are the
ordered regular expressions that name a whole label as one of its snippets (the first match over the rows in file order wins), a label of
the form `name.ext` is named by the extension of a row, and `glyph_kinds` names the rows a glyph kind falls back to when nothing
matches. A command (a label that is a Verb-Noun or a snake_case name whose command contract exists under contracts/) lists every form it
has: one tag per execution engine, then the contract's. `lang:` on a glyph is the only override and must name a row with a tag.
"""

import re
from pathlib import Path

import yaml

REPO = Path(__file__).resolve().parents[2]
TABLE = REPO / "pwsh" / "Catzc.Base.Languages" / "configs" / "languages.yml"
ENGINES = REPO / "pwsh" / "Catzc.Base.Engines" / "types" / "ExecutionEngines.cs"
CONTRACTS = REPO / "contracts" / "catzc"
CONTRACT_LANGUAGE = "accosted"  # the language row whose tag names the contract form of a command
EXTENSION = re.compile(r"^[\w-]+(\.[A-Za-z0-9]+)$")
VERB_NOUN = re.compile(r"^([A-Z][a-z]+(?:-[A-Z][A-Za-z0-9]*)+)(?:\(\))?$")

_cache = {}


def rows():
    """The language rows that carry a tag, in file order: name -> the row."""
    if "rows" not in _cache:
        table = yaml.safe_load(TABLE.read_text(encoding="utf-8"))["languages"]
        _cache["rows"] = {name: row for name, row in table.items() if row.get("tag")}
    return _cache["rows"]


def engine_names():
    """The execution engines, in the registry's order, read from the ExecutionEngines model that declares them once."""
    if "engines" not in _cache:
        _cache["engines"] = re.findall(r'name: "([a-z]+)"', ENGINES.read_text(encoding="utf-8"))
    return _cache["engines"]


def commands():
    """The snake_case names of every command that has a contract under contracts/."""
    if "commands" not in _cache:
        _cache["commands"] = {p.name.removesuffix(".command.yml") for p in CONTRACTS.rglob("*.command.yml")}
    return _cache["commands"]


def snake(name):
    """A Verb-Noun command name in the repository normal form: get_file_language."""
    return "_".join(re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "_", part).lower() for part in name.split("-"))


def first_line(label):
    """The snippet of a label: its first line, a box's second line being its remark."""
    lines = str(label or "").strip().splitlines()
    return lines[0].strip() if lines else ""


def detect(label, kind, lang=""):
    """The language row a glyph's label names and whether it was a fallback by kind: (name, fell_back), or (None, True) when no row
    matches and none is the default for the kind. `lang` names the row outright and fails when it names none with a tag."""
    table = rows()
    if lang:
        if lang not in table:
            raise ValueError(f"lang '{lang}' is not one of: {', '.join(table)}")
        return lang, False
    text = first_line(label)
    for name, row in table.items():
        if any(re.fullmatch(pattern, text) for pattern in row.get("shapes") or []):
            return name, False
    found = EXTENSION.match(text)
    if found:
        for name, row in table.items():
            if found.group(1) in (row.get("extensions") or []):
                return name, False
    for name, row in table.items():
        if kind in (row.get("glyph_kinds") or []):
            return name, True
    return None, True


def tag_of(name):
    return rows()[name]["tag"]


def tags(label, kind, lang=""):
    """The tags a glyph prints, in order, with whether the language was a fallback: ([tag, ...], fell_back). A command with a contract
    lists every form it has, one per engine and then its contract's."""
    name, fell_back = detect(label, kind, lang)
    if name is None:
        return [], True
    text = first_line(label)
    command = VERB_NOUN.match(text)
    candidate = snake(command.group(1)) if command else (text if name == CONTRACT_LANGUAGE and re.fullmatch(r"[a-z][a-z0-9_]*", text) else "")
    if candidate and candidate in commands():
        table = rows()
        by_engine = [table[e]["tag"] if e in table else e for e in engine_names()]
        return [*by_engine, tag_of(CONTRACT_LANGUAGE)], fell_back
    return [tag_of(name)], fell_back
