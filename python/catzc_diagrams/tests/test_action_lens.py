# cspell:ignore minimaps
"""The action lens: one action, its cause on the left rim and its effects on rings, in accosted words. Its fixtures live in
`action-lens/`: two sample declarations, the widget command contracts they are checked against, and the accosted file their proofs
must occur in; the kit's repository root is pointed at that folder for every test here.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/catzc_diagrams/tests/test_action_lens.py
"""

import copy
import math
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
    assert "publish_gadget: { name: widget-a,&lt;br&gt;dry_run: false }" in model  # wrapped at its break inside the action width
    assert 'id="mark-1"' in model and 'id="mark-5"' in model and 'id="mark-6"' not in model  # cause, action, three effects


def test_an_effect_after_another_draws_its_edge_from_it_and_comes_back():
    first = normalised(sample("action-site-sample"))
    model = declaration.put(first)
    assert 'id="e-effect-index-effect-catalogue"' in model and 'id="e-action-effect-catalogue"' not in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["effects"][1]["after"] == "effect-index"


def test_an_effect_never_goes_back_to_an_inner_zone():
    failing(
        lambda r: r["content"]["effects"][0].update(after="effect-catalogue") or r["content"]["effects"].reverse(),
        "comes after 'effect-catalogue' in zone 2; an effect only goes forward",
    )


def test_an_effect_follows_one_declared_before_it():
    failing(lambda r: r["content"]["effects"][0].update(after="effect-catalogue"), "after .* 'effect-catalogue' is not one of")


def test_a_call_site_draws_one_row_per_command():
    model = declaration.put(normalised(sample("action-site-sample")))
    assert 'id="action-1"' in model and 'id="action-2"' in model and 'id="action-3"' not in model
    assert 'value="count_gadgets"' in model


def test_a_moved_effect_folds_back_to_its_zone_and_order_never_to_coordinates():
    model = declaration.put(normalised(sample()))
    pattern = re.compile(r'(<mxCell id="effect-count" [^\n]*\n\s*<mxGeometry x="\d+" y=")(\d+)')
    moved = pattern.sub(lambda m: m.group(1) + str(int(m.group(2)) + 20), model, count=1)  # the note slides 20 px down its zone
    assert moved != model
    back = declaration.get(moved, kind="explanation")
    assert back["layout"] == {}
    assert [e["id"] for e in back["content"]["effects"]] == ["effect-index", "effect-count", "effect-catalogue"]
    assert declaration.put(back) == model


def test_the_legend_names_the_lens_kinds_and_the_flow():
    model = declaration.put(normalised(sample()))
    for phrase in ("cause", "action", "ring", "effect", "flow: changes"):
        assert f'value="{phrase}"' in model
    assert 'id="lg-marker"' in model  # the story's numbers


def test_a_long_argument_wraps_at_its_breaks_and_comes_back_whole():
    import html

    raw = sample()
    path = "pwsh/Catzc.Base.Contracts/accosted/contracts.accosted.yml"
    raw["content"]["action"] = {"call": {"get_widget": {"path": path}}}
    raw["content"]["effects"][0]["proves"] = {"get_widget": {"path": path}}
    raw["content"]["effects"][0]["says"] = "The widget's file is read from the repository and nothing else is touched"
    (FIXTURES / "widgets.accosted.yml").write_text(
        (FIXTURES / "widgets.accosted.yml").read_text(encoding="utf-8") + f"  - - get_widget: {{ path: {path} }}\n", encoding="utf-8"
    )
    try:
        model = declaration.put(normalised(raw))
    finally:
        text = (FIXTURES / "widgets.accosted.yml").read_text(encoding="utf-8")
        (FIXTURES / "widgets.accosted.yml").write_text(text.replace(f"  - - get_widget: {{ path: {path} }}\n", ""), encoding="utf-8")
    action = re.search(r'<mxCell id="action" value="([^"]*)" style="[^"]*" vertex="1" parent="1">\s*<mxGeometry x="\d+" y="\d+" width="(\d+)"', model)
    assert action is not None
    value, width = html.unescape(action.group(1)), int(action.group(2))
    assert "<br>" in value and all(len(line) <= (width - 28) // 7 for line in value.split("<br>"))
    assert width <= declaration.ACTION_WIDTH
    note = re.search(r'<mxCell id="effect-index" value="([^"]*)" style="[^"]*" vertex="1" parent="1">\s*<mxGeometry x="\d+" y="\d+" width="(\d+)"', model)
    assert note is not None
    proof_lines = html.unescape(note.group(1)).split("<br>")[1:]
    assert len(proof_lines) > 1 and all(len(line) <= (int(note.group(2)) - 24) // 7 for line in proof_lines)
    back = declaration.get(model, kind="explanation")
    assert back["content"]["action"] == {"call": {"get_widget": {"path": path}}}
    assert back["content"]["effects"][0]["proves"] == {"get_widget": {"path": path}}


def test_wrap_and_unwrap_are_inverse():
    line = "get_widget: { path: pwsh/Catzc.Base.Contracts/accosted/contracts.accosted.yml, name: a b c }"
    lines = declaration.wrap_line(line, 30)
    assert len(lines) > 1 and all(len(piece) <= 30 for piece in lines)
    assert declaration.unwrap_lines("\n".join(lines)) == line


def test_the_rings_fit_the_frame_and_the_notes_sit_in_the_lane():
    model = declaration.put(normalised(sample()))
    frame = re.search(r'<mxCell id="frame" [^\n]*\n\s*<mxGeometry x="\d+" y="(\d+)" width="\d+" height="(\d+)"', model)
    ring = re.search(r'<mxCell id="ring-2" [^\n]*startAngle=([\d.]+);endAngle=([\d.]+);[^\n]*\n\s*<mxGeometry x="-?\d+" y="-?\d+" width="(\d+)" height="(\d+)"', model)
    assert frame is not None and ring is not None
    top, height = int(frame.group(1)), int(frame.group(2))
    radius, turn = int(ring.group(3)) / 2, float(ring.group(2))
    assert int(ring.group(3)) == int(ring.group(4))  # a perfect circle
    assert abs(float(ring.group(1)) + turn - 1) < 0.001  # mirrored on the centre line
    inner = height - declaration.LABEL_ROW - declaration.PAD
    assert abs(radius * math.sin(2 * math.pi * turn) - inner // 2) < 1  # drawn from the inner top boundary to the inner bottom one
    for cid in ("effect-index", "effect-count", "effect-catalogue"):
        note = re.search(rf'<mxCell id="{cid}" [^\n]*\n\s*<mxGeometry x="\d+" y="(\d+)" width="\d+" height="(\d+)"', model)
        assert note is not None
        assert int(note.group(1)) >= top + declaration.LABEL_ROW + declaration.ACTION_MARGIN
        assert int(note.group(1)) + int(note.group(2)) <= top + height - declaration.PAD - declaration.ACTION_MARGIN


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
    failing(lambda r: r["content"].update(action={"call": {"paint_widget": None}}), "'paint_widget', which is not a contracted command")


def test_a_parameter_outside_the_contract_fails_with_the_parameters():
    failing(
        lambda r: r["content"].update(action={"call": {"publish_gadget": {"colour": "red"}}}),
        "parameter 'colour' is not one of: name, dry_run",
    )


def test_an_argument_is_one_literal():
    failing(lambda r: r["content"].update(action={"call": {"publish_gadget": {"name": ["a", "b"]}}}), "name is one literal, never a list")


def test_a_where_outside_the_vocabulary_fails_with_the_wheres():
    failing(lambda r: r["content"]["effects"][0].update(where="nearby"), "where 'nearby' is not one of: local, remote")


def test_the_zones_are_the_hops_without_a_gap():
    failing(lambda r: r["content"]["effects"][2].update(zone=3), r"the effects name \[1, 3\]")


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


def test_the_cause_takes_a_named_size_and_is_bold():
    sizes = declaration.cause_sizes()
    default = sizes[declaration.ACTION["cause-size"]]
    model = declaration.put(normalised(sample()))
    cause = re.search(r'<mxCell id="cause" value="([^"]*)" [^\n]*\n\s*<mxGeometry x="\d+" y="\d+" width="(\d+)" height="(\d+)"', model)
    assert cause is not None and cause.group(1).startswith("&lt;b&gt;") and (int(cause.group(2)), int(cause.group(3))) == (default, 2 * default)
    raw = sample()
    raw["content"]["cause"]["size"] = "largest"
    model = declaration.put(normalised(raw))
    assert f'width="{sizes["largest"]}" height="{2 * sizes["largest"]}"' in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["cause"] == {"label": "An author runs cats", "size": "largest"}
    raw = sample()
    raw["content"]["cause"] = {"label": "The pipeline fires!"}
    model = declaration.put(normalised(raw))
    assert f'width="{sizes["largest"]}" height="{2 * sizes["largest"]}"' in model
    assert declaration.get(model, kind="explanation")["content"]["cause"] == {"label": "The pipeline fires!"}


def test_a_cause_size_outside_the_sizes_fails_with_them():
    failing(lambda r: r["content"]["cause"].update(size="vast"), "cause size 'vast' is not one of: smallest, small, medium, large, largest")


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
