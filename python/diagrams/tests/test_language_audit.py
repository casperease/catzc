"""The language audit lists every code glyph with its language, tags and fallback flag, on widget and gadget fixtures, and writes one report."""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import language_audit
import languages_table

ROWS = {
    "widgetshell": {"tag": "wsh", "extensions": [".wsh"], "shapes": [r"^Widget-[A-Z]\w+$"]},
    "gadgetlang": {"tag": "gdg", "extensions": [".gdg"], "shapes": [r"^[A-Z]\w+\.[A-Z]\w+$"]},
}

DECLARATION = """
about:
  lens: architecture
content:
  title: Widgets
  flow: left-to-right
  bands:
    - {{ id: band-a, label: Widgets }}
  glyphs:
    - {{ id: widget-a, kind: code, label: Widget-Start, in: band-a }}
    - {{ id: widget-b, kind: code, label: a plain phrase, in: band-a }}
    - {{ id: gadget-a, kind: type, label: Gizmo.Run, in: band-a }}
    - {{ id: gadget-file, kind: file, label: gadget.yml, in: band-a }}
    - {{ id: widget-c, kind: code, label: another phrase, in: band-a, lang: gadgetlang }}
  edges: []
"""


@pytest.fixture
def fixture_repo(tmp_path, monkeypatch):
    monkeypatch.setitem(languages_table._cache, "rows", ROWS)
    monkeypatch.setitem(languages_table._cache, "commands", set())
    folder = tmp_path / "docs" / "widgets" / ".assets"
    folder.mkdir(parents=True)
    (folder / "widget-flow.drawio.png").write_bytes(b"")
    (folder / "widget-flow.drawio.yml").write_text(DECLARATION.replace("{{", "{").replace("}}", "}"), encoding="utf-8")
    return tmp_path


def test_every_code_glyph_gets_its_language_its_tags_and_whether_it_prints_none(fixture_repo):
    rows = {r["id"]: r for r in language_audit.audit(fixture_repo)}
    assert set(rows) == {"widget-a", "widget-b", "gadget-a", "widget-c"}  # a file is no code glyph
    assert (rows["widget-a"]["language"], rows["widget-a"]["tags"], rows["widget-a"]["untagged"]) == ("widgetshell", "wsh", False)
    assert (rows["widget-b"]["language"], rows["widget-b"]["tags"], rows["widget-b"]["untagged"]) == ("none", "", True)  # no shape matched
    assert (rows["gadget-a"]["language"], rows["gadget-a"]["untagged"]) == ("gadgetlang", False)
    assert (rows["widget-c"]["language"], rows["widget-c"]["untagged"]) == ("gadgetlang", False)  # lang: names it outright


def test_the_report_counts_the_glyphs_per_language_and_lists_the_untagged(fixture_repo):
    text = chr(10).join(language_audit.report(language_audit.audit(fixture_repo)))
    assert "4 code glyphs in 1 diagrams, 1 of them untagged" in text and "| widgetshell | wsh | 1 |" in text and "| gadgetlang | gdg | 2 |" in text
    assert "## Untagged (1)" in text and "| widgets/.assets/widget-flow | widget-b | code | a plain phrase |" in text
