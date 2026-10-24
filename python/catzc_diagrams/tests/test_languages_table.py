"""The language tags of a code glyph: derived from the shape of its label by one table, the override validated, a command listing every form."""

import re
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration
import languages_table

WIDGET_ROWS = {
    "widgetshell": {"tag": "wsh", "extensions": [".wsh"], "shapes": ["^Widget-[A-Z]\\w+$"], "glyph_kinds": ["code"]},
    "gadgetlang": {"tag": "gdg", "extensions": [".gdg"], "shapes": ["^[A-Z]\\w+\\.[A-Z]\\w+$"], "glyph_kinds": ["type"]},
    "accosted": {"tag": "contract", "extensions": [".accosted.yml"], "shapes": ["^[a-z]+(_[a-z]+)+$"]},
}


@pytest.fixture
def widget_table(monkeypatch):
    monkeypatch.setitem(languages_table._cache, "rows", WIDGET_ROWS)
    monkeypatch.setitem(languages_table._cache, "engines", ["wsh", "bash"])
    monkeypatch.setitem(languages_table._cache, "commands", {"widget_start"})


def test_a_label_is_named_by_the_first_shape_that_matches_then_by_extension_then_by_its_kind(widget_table):
    assert languages_table.detect("Widget-Start", "code") == ("widgetshell", False)
    assert languages_table.detect("Gizmo.Run", "code") == ("gadgetlang", False)  # a shape of another language wins over the glyph kind
    assert languages_table.detect("cog.gdg", "code") == ("gadgetlang", False)  # name.ext: by the extension of a row
    assert languages_table.detect("something else", "code") == ("widgetshell", True)  # nothing matches: the kind's default, flagged
    assert languages_table.detect("something else", "type") == ("gadgetlang", True)
    assert languages_table.detect("something else", "file") == (None, True)


def test_lang_is_the_one_override_and_must_name_a_row_with_a_tag(widget_table):
    assert languages_table.detect("Widget-Start", "code", "gadgetlang") == ("gadgetlang", False)
    with pytest.raises(ValueError, match="lang 'nothing' is not one of: widgetshell, gadgetlang, accosted"):
        languages_table.detect("Widget-Start", "code", "nothing")


def test_a_command_with_a_contract_lists_every_form_it_has_and_one_without_lists_its_language(widget_table):
    assert languages_table.tags("Widget-Start", "code") == (["wsh", "bash", "contract"], False)  # engines in the registry's order, then the contract
    assert languages_table.tags("widget_start", "code") == (["wsh", "bash", "contract"], False)  # Verb-Noun and snake_case are one command
    assert languages_table.tags("Widget-Stop", "code") == (["wsh"], False)
    assert languages_table.tags("something else", "type") == (["gdg"], True)


def test_the_shipped_table_names_a_command_a_c_sharp_member_and_a_contract_call():
    assert languages_table.tags("Get-FileLanguage", "code")[0] == ["pwsh", "bash", "zsh", "contract"]
    assert languages_table.tags("BashSafeguard.Decide", "code") == (["C#"], False)
    assert languages_table.tags("GlobsConfig", "type") == (["C#"], False)
    assert languages_table.tags("get_file_language", "code")[0][-1] == "contract"
    assert languages_table.tags("a plain phrase", "code") == (["pwsh"], True)


def test_a_code_glyph_prints_its_tags_right_aligned_on_its_top_edge_and_get_reads_back_its_kind_and_override(widget_table):
    raw = yaml_of(
        """
about:
  lens: architecture
content:
  title: Widgets
  flow: left-to-right
  bands:
    - { id: band-a, label: Widgets }
  glyphs:
    - { id: widget-a, kind: code, label: Widget-Start, in: band-a }
    - { id: widget-b, kind: type, label: Gizmo.Run, in: band-a, lang: widgetshell }
  edges: []
"""
    )
    model = declaration.put(declaration.normalise(raw))
    first = re.findall(r'<mxCell id="(widget-a-tag[^"]*)" value="([^"]*)"', model)
    assert first == [("widget-a-tag", "wsh"), ("widget-a-tag-2", "bash"), ("widget-a-tag-3", "contract")]
    assert "catzcKind=code;" in model and "catzcLang=widgetshell;" in model
    back = declaration.get(model, kind="explanation")
    assert {g["id"]: (g["kind"], g.get("lang")) for g in back["content"]["glyphs"]} == {"widget-a": ("code", None), "widget-b": ("type", "widgetshell")}
    assert "tag" not in declaration.dump(back).replace("catzc", "")  # the tag words are never written back


def test_a_lang_outside_the_table_is_refused_with_the_rows_to_choose_from(widget_table):
    raw = yaml_of(
        """
about:
  lens: architecture
content:
  title: Widgets
  flow: left-to-right
  bands:
    - { id: band-a, label: Widgets }
  glyphs:
    - { id: widget-a, kind: code, label: Widget-Start, in: band-a, lang: cobol }
  edges: []
"""
    )
    with pytest.raises(declaration.DeclarationError, match="glyph 'widget-a' lang 'cobol' is not one of: widgetshell, gadgetlang, accosted"):
        declaration.normalise(raw)


def yaml_of(text):
    import yaml

    return yaml.safe_load(text)


def test_only_the_first_line_of_a_label_is_the_snippet_and_its_remark_line_is_ignored(widget_table):
    remark = "Widget-Start" + chr(10) + "with a remark, in process"
    assert languages_table.detect(remark, "code") == ("widgetshell", False)
    assert languages_table.tags(remark, "code") == (["wsh", "bash", "contract"], False)
