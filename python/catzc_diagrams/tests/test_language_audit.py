"""The language audit lists every code glyph with its language, tags and fallback flag, on widget and gadget fixtures, and writes one report."""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import language_audit
import languages_table

ROWS = {
    "widgetshell": {"tag": "wsh", "extensions": [".wsh"], "shapes": ["^Widget-[A-Z]\w+$"], "glyph_kinds": ["code"]},
    "gadgetlang": {"tag": "gdg", "extensions": [".gdg"], "shapes": ["^[A-Z]\w+\.[A-Z]\w+$"], "glyph_kinds": ["type"]},
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


def test_every_code_glyph_gets_its_language_its_tags_and_whether_its_kind_chose_it(fixture_repo):
    rows = {r["id"]: r for r in language_audit.audit(fixture_repo)}
    assert set(rows) == {"widget-a", "widget-b", "gadget-a", "widget-c"}  # a file is no code glyph
    assert (rows["widget-a"]["language"], rows["widget-a"]["tags"], rows["widget-a"]["fell_back"]) == ("widgetshell", "wsh", False)
    assert (rows["widget-b"]["language"], rows["widget-b"]["fell_back"]) == ("widgetshell", True)  # no shape matched: the kind chose
    assert (rows["gadget-a"]["language"], rows["gadget-a"]["fell_back"]) == ("gadgetlang", False)
    assert (rows["widget-c"]["language"], rows["widget-c"]["fell_back"]) == ("gadgetlang", False)  # lang: names it outright


def test_the_report_counts_the_glyphs_per_language_and_lists_the_fallbacks(fixture_repo):
    rows = language_audit.audit(fixture_repo)
    lines = language_audit.report(rows)
    text = "\n".join(lines)
    assert "4 code glyphs in 1 diagrams" in text and "| widgetshell | wsh | 2 | 1 |" in text and "| gadgetlang | gdg | 2 | 0 |" in text
    assert "## Fallbacks (1)" in text and "| widgets/.assets/widget-flow | widget-b | code | a plain phrase | widgetshell |" in text
