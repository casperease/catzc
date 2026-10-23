# cspell:ignore minimaps
"""The action lens: one action, its cause on the left rim and its effects on rings, in accosted words. Its fixtures live in
`action-lens/`: two sample declarations, the widget command contracts they are checked against, and the accosted file their proofs
must occur in; the kit's repository root is pointed at that folder for every test here.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/catzc_diagrams/tests/test_action_lens.py
"""

import copy
import re
import sys
from pathlib import Path

import pytest
import yaml

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import declaration

FIXTURES = Path(__file__).resolve().parent / "action-lens"
OUT = Path(__file__).resolve().parents[3] / "out" / "drawio"


@pytest.fixture(autouse=True)
def fixture_root(monkeypatch):
    monkeypatch.setattr(declaration, "ROOT", FIXTURES)


def sample(name="action-sample"):
    return yaml.safe_load((FIXTURES / f"{name}.drawio.yml").read_text(encoding="utf-8"))


def normalised(raw):
    return declaration.normalise(raw)


# ---- the two directions ------------------------------------------------------------------------------------------------


@pytest.mark.parametrize("name", ["action-sample", "action-site-sample"])
def test_put_then_get_returns_the_same_yml_but_for_the_proof_file_the_drawing_cannot_carry(name):
    first = normalised(sample(name))
    second = declaration.get(declaration.put(first), kind="explanation")
    expected = copy.deepcopy(first)
    expected["about"].pop("proves")
    expected["description"] = ""
    assert declaration.dump(second) == declaration.dump(expected)


@pytest.mark.parametrize("name", ["action-sample", "action-site-sample"])
def test_get_then_put_is_byte_stable(name):
    model = declaration.put(normalised(sample(name)))
    assert declaration.put(declaration.get(model, kind="explanation")) == model


def test_the_drawing_holds_the_lens_grammar():
    model = declaration.put(normalised(sample()))
    assert 'id="frame"' in model and 'id="cause"' in model and 'id="action"' in model
    assert 'id="ring-1"' in model and 'id="ring-2"' in model and 'id="ring-3"' not in model
    assert 'id="e-cause-action"' in model and 'id="e-action-effect-catalogue"' in model
    assert 'id="effect-count-tag"' in model and 'value="remote"' in model
    assert "publish_gadget: { name: widget-a, dry_run: false }" in model


def test_a_call_site_draws_one_row_per_command():
    model = declaration.put(normalised(sample("action-site-sample")))
    assert 'id="action-1"' in model and 'id="action-2"' in model and 'id="action-3"' not in model
    assert 'value="count_gadgets"' in model


def test_a_moved_effect_folds_back_to_its_ring_and_order_never_to_coordinates():
    model = declaration.put(normalised(sample()))
    pattern = re.compile(r'(<mxCell id="effect-count" [^\n]*\n\s*<mxGeometry x="\d+" y=")(\d+)')
    moved = pattern.sub(lambda m: m.group(1) + str(int(m.group(2)) + 40), model, count=1)  # the note slides 40 px down its ring
    assert moved != model
    back = declaration.get(moved, kind="explanation")
    assert back["layout"] == {}
    assert [e["id"] for e in back["content"]["effects"]] == ["effect-index", "effect-count", "effect-catalogue"]
    assert declaration.put(back) == model


def test_the_legend_names_the_lens_kinds_and_the_flow():
    model = declaration.put(normalised(sample()))
    for phrase in ("cause", "action", "ring", "effect", "flow: changes"):
        assert f'value="{phrase}"' in model


def test_the_golden_samples_render_to_out():
    for name in ("action-sample", "action-site-sample"):
        folder = OUT / name
        folder.parent.mkdir(parents=True, exist_ok=True)
        dst = declaration.put_png(folder, normalised(sample(name)))
        assert dst.is_file() and dst.stat().st_size > 0


# ---- validation: one error each, with its text --------------------------------------------------------------------------


def failing(mutate, match):
    raw = sample()
    mutate(raw)
    with pytest.raises(declaration.DeclarationError, match=match):
        declaration.normalise(raw)


def test_the_band_grammar_is_refused_in_the_action_lens():
    failing(lambda r: r["content"].update(bands=[{"id": "b", "label": "B"}]), "content.bands is the band grammar")


def test_the_action_keys_are_refused_in_another_lens():
    failing(lambda r: r["about"].update(lens="meta"), "content.cause belongs to the action lens; this diagram's lens is meta")


def test_the_proof_file_is_refused_in_another_lens():
    raw = sample()
    raw["about"]["lens"] = "meta"
    for key in ("cause", "action", "effects"):
        raw["content"].pop(key)
    with pytest.raises(declaration.DeclarationError, match="about.proves names an action diagram's proof file"):
        declaration.normalise(raw)


def test_an_action_is_call_or_calls_never_both():
    failing(lambda r: r["content"]["action"].update(calls=[{"count_gadgets": None}, {"count_gadgets": None}]), "never both or neither")


def test_a_call_site_has_two_or_more_commands():
    failing(lambda r: r["content"].update(action={"calls": [{"count_gadgets": None}]}), "two or more commands")


def test_a_command_outside_the_contracts_fails_with_the_contracts_folder():
    failing(lambda r: r["content"].update(action={"call": {"frobnicate": None}}), "'frobnicate', which is not a contracted command")


def test_a_parameter_outside_the_contract_fails_with_the_parameters():
    failing(
        lambda r: r["content"].update(action={"call": {"publish_gadget": {"colour": "red"}}}),
        "parameter 'colour' is not one of: name, dry_run",
    )


def test_an_argument_is_one_literal():
    failing(lambda r: r["content"].update(action={"call": {"publish_gadget": {"name": ["a", "b"]}}}), "name is one literal, never a list")


def test_a_where_outside_the_vocabulary_fails_with_the_wheres():
    failing(lambda r: r["content"]["effects"][0].update(where="nearby"), "where 'nearby' is not one of: local, remote")


def test_the_rings_are_the_hops_without_a_gap():
    failing(lambda r: r["content"]["effects"][2].update(ring=3), r"the effects name \[1, 3\]")


def test_a_proof_outside_the_accosted_file_fails_with_the_call():
    failing(
        lambda r: r["content"]["effects"][0].update(proves={"get_widget": {"path": "nowhere.yml"}}),
        r"proves `get_widget: \{ path: nowhere.yml \}`, which no run of widgets.accosted.yml holds",
    )


def test_a_missing_proof_file_fails():
    failing(lambda r: r["about"].update(proves="gone.accosted.yml"), "names gone.accosted.yml, which is not a file")


def test_only_the_frame_takes_a_layout_entry():
    failing(
        lambda r: r.update(layout={"effect-index": {"x": 1, "y": 2, "w": 3, "h": 4}}), "layout cell .* 'effect-index' is not one of: frame"
    )


def test_a_ring_gap_too_small_for_a_note_is_the_kits_error_not_the_authors(monkeypatch):
    monkeypatch.setitem(declaration.ACTION, "ring-gap", 100)
    with pytest.raises(declaration.DeclarationError, match="ring-gap 100 leaves no room for a note of note-width"):
        declaration.put(normalised(sample()))


def test_a_cause_without_a_label_fails():
    failing(lambda r: r["content"].update(cause={}), "cause")


# ---- the other lenses are untouched -----------------------------------------------------------------------------------


def test_another_lens_dumps_no_action_key_and_its_legend_is_unchanged():
    raw = sample()
    raw["about"] = {"lens": "meta"}
    raw["content"] = {
        "title": "Widgets",
        "bands": [{"id": "b", "label": "B"}],
        "glyphs": [{"id": "w", "kind": "code", "label": "W", "in": "b"}],
    }
    text = declaration.dump(declaration.normalise(raw))
    assert "cause" not in text and "effects" not in text and "proves" not in text
    model = declaration.put(declaration.normalise(raw))
    assert 'id="frame"' not in model and 'id="ring-1"' not in model
