"""The repository normal form of a name is read from the languages config, never copied; wrap breaks are read from drawio.yml.

usage (repo root, background): timeout 120 uv run --no-sync --project python python -m pytest python/catzc_diagrams/tests/test_normal_form.py
"""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration
import normal_form


def test_the_configured_case_is_read_from_the_languages_config():
    assert normal_form.configured_case() == "snake"  # naming.normal_form of languages.yml, the one place that states it
    assert normal_form.accepts("get_widget") and not normal_form.accepts("Get-Widget")


def test_a_different_configured_case_changes_what_the_check_accepts(monkeypatch):
    monkeypatch.setattr(normal_form, "configured_case", lambda: "kebab")
    assert normal_form.accepts("get-widget") and not normal_form.accepts("get_widget")
    with pytest.raises(declaration.DeclarationError, match="repository normal form, kebab"):
        declaration.contract_call({"get_widget": None}, "widgets.yml", "the call")
    assert declaration.contract_call({"get-widget": None}, "widgets.yml", "the call") == {"get-widget": {}}


def test_a_name_in_every_case_of_the_closed_set_is_judged_by_its_own_case():
    samples = {
        "snake": "get_widget",
        "kebab": "get-widget",
        "flat": "getwidget",
        "camel": "getWidget",
        "pascal": "GetWidget",
        "pascal-dotted": "Catzc.Widget",
        "verb-noun": "Get-Widget",
    }
    assert set(samples) == set(normal_form.CASES)
    for case, name in samples.items():
        assert normal_form.accepts(name, case)
    assert not normal_form.accepts("get_widget", "kebab") and not normal_form.accepts("Get-Widget", "snake")
    assert not normal_form.accepts("GetWidget", "camel") and not normal_form.accepts("getWidget", "pascal")


def test_a_languages_config_without_the_key_is_an_error_not_a_default(monkeypatch, tmp_path):
    (tmp_path / "languages.yml").write_text("naming:\n  exempt_folders: [assets]\n", encoding="utf-8")
    monkeypatch.setattr(normal_form, "LANGUAGES", tmp_path / "languages.yml")
    normal_form.configured_case.cache_clear()
    try:
        with pytest.raises(ValueError, match="states no naming.normal_form"):
            normal_form.configured_case()
    finally:
        normal_form.configured_case.cache_clear()


def test_the_wrap_breaks_come_from_drawio_yml_and_wrap_and_unwrap_stay_exact_inverses(monkeypatch):
    assert declaration.WRAP_GLUED == ("/",) and set(declaration.WRAP_SPACED) == {",", " "} and declaration.WRAP_LATE == (".",)
    line = "get_widget: { path: pwsh/Catzc.Widget/accosted/widgets.accosted.yml, mode: fast }"
    assert declaration.unwrap_lines("\n".join(declaration.wrap_line(line, 30))) == line
    # A different configuration breaks elsewhere, and the two functions still agree.
    monkeypatch.setattr(declaration, "WRAP_GLUED", ("/", "-"))
    monkeypatch.setattr(declaration, "WRAP_LATE", (".", "_"))
    other = "get_widget: { path: pwsh/Catzc.Widget-parts/accosted/widgets_by.accosted.yml, mode: fast }"
    assert declaration.unwrap_lines("\n".join(declaration.wrap_line(other, 30))) == other
