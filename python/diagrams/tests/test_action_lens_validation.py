"""The action lens's validation: one error each, with its text, for a declaration the lens refuses; the drawing itself is
`test_action_lens.py`'s.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_action_lens_validation.py
"""

import re

import pytest
from action_lens_sample import normalised, sample
from catzc.diagrams import declaration


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


def test_a_command_name_is_in_the_normal_form():
    failing(
        lambda r: r["content"].update(action={"call": {"Publish-Gadget": None}}),
        "names 'Publish-Gadget'; a command's name is in the repository normal form",
    )


def test_an_argument_is_one_literal():
    failing(lambda r: r["content"].update(action={"call": {"publish_gadget": {"name": ["a", "b"]}}}), "name is one literal, never a list")


def test_a_where_outside_the_vocabulary_fails_with_the_wheres():
    failing(lambda r: r["content"]["effects"][0].update(where="nearby"), "where 'nearby' is not one of: local, remote")


def test_the_zones_are_the_hops_without_a_gap():
    failing(lambda r: r["content"]["effects"][2].update(zone=3), r"the effects name \[1, 3\]")


def test_only_the_frame_takes_a_layout_entry():
    failing(
        lambda r: r.update(layout={"effect-index": {"x": 1, "y": 2, "w": 3, "h": 4}}), "layout cell .* 'effect-index' is not one of: frame"
    )


def test_a_ring_gap_too_small_for_a_note_is_the_kits_error_not_the_authors(monkeypatch):
    monkeypatch.setitem(declaration.ACTION, "ring-gap", 100)
    with pytest.raises(declaration.DeclarationError, match="ring-gap 100 leaves no room for a note of note-width"):
        declaration.put(normalised(sample()))


def test_the_cause_takes_a_named_size_and_is_bold():
    sizes = declaration.cause_sizes()
    default = sizes[declaration.ACTION["cause-size"]]
    model = declaration.put(normalised(sample()))
    cause = re.search(r'<mxCell id="cause" value="([^"]*)" [^\n]*\n\s*<mxGeometry x="\d+" y="\d+" width="(\d+)" height="(\d+)"', model)
    assert cause is not None and cause.group(1).startswith("&lt;b&gt;")
    assert (int(cause.group(2)), int(cause.group(3))) == (default, 2 * default)
    raw = sample()
    raw["content"]["cause"]["size"] = "largest"
    model = declaration.put(normalised(raw))
    assert f'width="{sizes["largest"]}" height="{2 * sizes["largest"]}"' in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["cause"] == {"label": "An author", "size": "largest"}
    raw = sample()
    raw["content"]["cause"] = {"label": "The pipeline fires!"}
    model = declaration.put(normalised(raw))
    assert f'width="{sizes["largest"]}" height="{2 * sizes["largest"]}"' in model
    assert declaration.get(model, kind="explanation")["content"]["cause"] == {"label": "The pipeline fires!"}


def test_a_cause_size_outside_the_sizes_fails_with_them():
    failing(lambda r: r["content"]["cause"].update(size="vast"), "cause size 'vast' is not one of: smallest, small, medium, large, largest")


def test_a_cause_without_a_label_fails():
    failing(lambda r: r["content"].update(cause={}), "cause")
