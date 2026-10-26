# cspell:ignore minimaps
"""The action lens: one action, its cause on the left rim and its effects in zones between rings, in accosted words. Its fixtures live in
`action-lens/`: two sample declarations and the accosted file their proofs name; the kit checks the shape alone, and Test-Diagrams
proves the calls against the contracts and the proof file.

usage (repo root, background): timeout 120 uv run --project python python -m pytest python/diagrams/tests/test_action_lens.py
"""

import copy
import itertools
import math
import re
from pathlib import Path

import pytest
import yaml
from catzc.diagrams import declaration, declaration_settings
from catzc.diagrams.module_paths import REPO

FIXTURES = Path(__file__).resolve().parent / "action-lens"
OUT = REPO / "out" / "drawio"


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
    assert 'id="cats"' in model and 'id="e-action-effect-catalogue"' in model
    assert 'id="effect-count-tag"' not in model and 'id="effect-catalogue-tag"' in model and 'value="remote"' in model
    assert "publish_gadget: { name: widget-a,&lt;br&gt;dry_run: false }" in model  # wrapped at its break inside the action width
    assert 'id="mark-1"' in model and 'id="mark-5"' in model and 'id="mark-6"' not in model  # cause, action, three effects


def test_an_effect_after_another_draws_its_edge_from_it_and_comes_back():
    first = normalised(sample("action-site-sample"))
    model = declaration.put(first)
    assert 'id="e-effect-index-effect-recount"' in model and 'id="e-action-effect-recount"' not in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["effects"][1]["after"] == "effect-index"


def test_the_operators_label_every_edge_and_an_execution_comes_back():
    model = declaration.put(normalised(sample("action-site-sample")))
    cats = re.search(r'id="cats" value="([^"]*)"', model)  # the word at the hand that does the statement
    executes = re.search(r'id="e-action-effect-index" value="([^"]*)"', model)
    affects = re.search(r'id="e-effect-index-effect-recount-word" value="([^"]*)"', model)  # across a ring: in its transition bubble
    effects = re.search(r'id="e-effect-recount-effect-catalogue-word" value="([^"]*)"', model)  # inside one zone: in its pill at the line's middle
    assert cats is not None and executes is not None and affects is not None and effects is not None
    assert [m.group(1) for m in (cats, executes, affects, effects)] == [f"&lt;b&gt;{w}&lt;/b&gt;" for w in ("cats", "executes", "affects", "effects")]
    for word, meaning in declaration.OPERATORS.items():
        assert f'value="{word}: {meaning}"' in model
    assert 'value="execution: a triggered command"' in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["effects"][1] == {
        "id": "effect-recount", "zone": 2, "where": "remote", "says": "The catalogue service recounts", "call": {"count_gadgets": {}}, "after": "effect-index"
    }
    assert declaration.put(back) == model


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
    for phrase in ("cause", "action", "ring", "effect", "cats: an actor runs it", "effects: changes state"):
        assert f'value="{phrase}"' in model
    assert 'id="lg-marker"' in model  # the story's numbers


def test_a_long_argument_wraps_at_its_breaks_and_comes_back_whole():
    import html

    raw = sample()
    path = "pwsh/Base.Contracts/accosted/contracts.accosted.yml"
    raw["content"]["action"] = {"call": {"get_widget": {"path": path}}}
    raw["content"]["effects"][0]["proves"] = {"get_widget": {"path": path}}
    raw["content"]["effects"][0]["says"] = "The widget's file is read from the repository and nothing else is touched"
    model = declaration.put(normalised(raw))
    action = re.search(r'<mxCell id="action" value="([^"]*)" style="[^"]*" vertex="1" parent="1">\s*<mxGeometry x="\d+" y="\d+" width="(\d+)"', model)
    assert action is not None
    value, width = html.unescape(action.group(1)), int(action.group(2))
    styled = re.search(r'<mxCell id="action" value="[^"]*" style="([^"]*)"', model)
    assert styled is not None
    tail = int(float(declaration.style_map(styled.group(1)).get("size", 0)))
    width -= tail  # the bubble's cell holds its tail too; the words live in the body
    assert "<br>" in value and all(len(line) <= (width - 28) // 7 for line in value.split("<br>"))
    assert width <= declaration.ACTION_WIDTH
    note = re.search(r'<mxCell id="effect-index" value="([^"]*)" style="[^"]*" vertex="1" parent="1">\s*<mxGeometry x="\d+" y="\d+" width="(\d+)"', model)
    assert note is not None
    proof_lines = html.unescape(note.group(1)).split("<br>")[1:]
    assert len(proof_lines) > 1 and all(len(line) <= (int(note.group(2)) - 24) // 7 for line in proof_lines)
    back = declaration.get(model, kind="explanation")
    assert back["content"]["action"] == {"call": {"get_widget": {"path": path}}}
    assert back["content"]["effects"][0]["proves"] == {"get_widget": {"path": path}}


def test_an_edge_that_skips_a_zone_runs_through_the_margin_clear_of_every_note():
    raw = sample()
    raw["content"]["action"] = {"call": {"count_gadgets": None}}  # a short action, so three zones fit the page
    raw["content"]["effects"].append(
        {"id": "effect-far", "zone": 3, "where": "remote", "says": "A far effect", "proves": {"count_gadgets": None}, "after": "effect-index"}
    )
    raw["content"]["effects"][2]["after"] = "effect-count"  # zone 2 keeps a direct edge; the new zone-3 effect skips zone 2
    model = declaration.put(normalised(raw))
    boxes = {
        m.group(1): tuple(int(v) for v in m.groups()[1:])
        for m in re.finditer(r'<mxCell id="(effect-[a-z]+)" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    }
    edge = re.search(r'<mxCell id="e-effect-index-effect-far" [^\n]*\n\s*<mxGeometry[^\n]*\n\s*<Array as="points">\s*((?:<mxPoint [^\n]*\n\s*)+)</Array>', model)
    assert edge is not None
    points = [(int(p.group(1)), int(p.group(2))) for p in re.finditer(r'<mxPoint x="(-?\d+)" y="(-?\d+)"', edge.group(1))]
    assert len(points) == 2 and points[0][1] == points[1][1]  # one run across the margin
    frame = re.search(r'<mxCell id="frame" [^\n]*\n\s*<mxGeometry x="\d+" y="(\d+)" width="\d+" height="(\d+)"', model)
    assert frame is not None
    top, height = int(frame.group(1)), int(frame.group(2))
    inner_top, inner_bottom = top + declaration.LABEL_ROW, top + height - declaration.PAD
    assert inner_top < points[0][1] < inner_top + declaration.ACTION_MARGIN or inner_bottom - declaration.ACTION_MARGIN < points[0][1] < inner_bottom
    a, b = boxes["effect-index"], boxes["effect-far"]
    path = [(a[0] + a[2], a[1] + a[3] // 2), *points, (b[0], b[1] + b[3] // 2)]
    for cid, (x, y, w, h) in boxes.items():
        if cid in ("effect-index", "effect-far"):
            continue
        for (x0, y0), (x1, y1) in itertools.pairwise(path):  # every leg is axis-parallel or a short join; none enters another note
            if max(x0, x1) >= x and min(x0, x1) <= x + w and max(y0, y1) >= y and min(y0, y1) <= y + h:
                raise AssertionError(f"the routed edge crosses {cid}")
    back = declaration.get(model, kind="explanation")
    assert back["content"]["effects"][3]["after"] == "effect-index" and back["layout"] == {}


def test_the_proof_box_stands_under_the_frame_and_speaks_every_engine():
    first = normalised(sample())
    model = declaration.put(first)
    frame = re.search(r'<mxCell id="frame" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    proof = re.search(r'<mxCell id="proof" value="Proof" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    assert frame is not None and proof is not None
    assert int(proof.group(1)) == int(frame.group(1)) and int(proof.group(3)) == int(frame.group(3))  # as wide as the frame
    assert int(proof.group(2)) >= int(frame.group(2)) + int(frame.group(4))  # under it
    assert "publish_gadget: { name: widget-a, dry_run: false }" in html_unescaped(model, "proof-1-cats")
    assert html_unescaped(model, "proof-1-pwsh").endswith("Publish-Gadget -Name 'widget-a' -DryRun:$false")
    assert html_unescaped(model, "proof-1-bash").endswith("publish-gadget --name 'widget-a' --dry-run false")
    import html

    assert 'id="proof-1-zsh"' in model and "proof: the statement in each engine's words" in html.unescape(model)
    back = declaration.get(model, kind="explanation")
    assert "proof" not in back["content"]
    assert declaration.put(back) == model


def html_unescaped(model, cid):
    import html

    found = re.search(rf'<mxCell id="{cid}" value="([^"]*)"', model)
    assert found is not None
    return declaration.plain(html.unescape(found.group(1)))


def test_a_hidden_proof_leaves_no_box_and_comes_back():
    raw = sample()
    raw["content"]["proof"] = "hidden"
    first = normalised(raw)
    model = declaration.put(first)
    assert 'id="proof"' not in model and "proof-1-pwsh" not in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["proof"] == "hidden" and "proof: hidden" in declaration.dump(back)
    assert declaration.dump(back) == declaration.dump({**first, "about": {k: v for k, v in first["about"].items() if k != "proves"}, "description": ""})


def test_the_proof_lens_draws_the_box_alone_and_comes_back():
    first = normalised(sample("proof-sample"))
    model = declaration.put(first)
    assert 'id="proof"' in model and 'id="frame"' not in model and 'id="cause"' not in model
    assert 'value="PROOF"' in model
    back = declaration.get(model, kind="explanation")
    assert back["content"]["action"] == first["content"]["action"]
    assert declaration.dump(back) == declaration.dump({**first, "description": ""})
    assert declaration.put(back) == model


def test_the_proof_lens_refuses_a_cause():
    raw = sample("proof-sample")
    raw["content"]["cause"] = {"label": "An author"}
    with pytest.raises(declaration.DeclarationError, match="content.cause belongs to the action lens; the proof lens draws"):
        declaration.normalise(raw)


def test_a_where_chip_is_drawn_only_where_an_effect_differs_from_the_diagram():
    first = normalised(sample())  # two local effects, one remote; the diagram's where is the default, local
    assert "where" not in first["content"] and [e.get("where") for e in first["content"]["effects"]] == [None, None, "remote"]
    model = declaration.put(first)
    assert 'id="effect-index-tag"' not in model and 'id="effect-catalogue-tag"' in model
    back = declaration.get(model, kind="explanation")
    assert declaration.dump(back) == declaration.dump({**first, "about": {k: v for k, v in first["about"].items() if k != "proves"}, "description": ""})
    raw = sample()
    raw["content"]["where"] = "remote"  # now the remote effect is the diagram's own, and the two local ones carry chips
    remote = normalised(raw)
    assert remote["content"]["where"] == "remote" and [e.get("where") for e in remote["content"]["effects"]] == ["local", "local", None]
    model = declaration.put(remote)
    assert 'id="effect-index-tag"' in model and 'id="effect-catalogue-tag"' not in model


def test_show_prints_words_or_the_call_alone_and_comes_back():
    raw = sample()
    raw["content"]["effects"][0]["show"] = "words"
    raw["content"]["effects"][1]["show"] = "call"
    first = normalised(raw)
    model = declaration.put(first)
    assert html_unescaped(model, "effect-index") == "The gadget index gains the entry"
    assert html_unescaped(model, "effect-count") == "count_gadgets"
    back = declaration.get(model, kind="explanation")
    assert [e.get("show") for e in back["content"]["effects"]] == ["words", "call", None]
    assert declaration.put(back) == model


def test_show_words_needs_words():
    failing(lambda r: r["content"]["effects"][1].update(show="words", says=""), "needs says")
    raw = sample("action-site-sample")
    raw["content"]["effects"][1].update(show="words", says="")  # an execution may go without words, but not when words are all it shows
    with pytest.raises(declaration.DeclarationError, match="shows words alone but says nothing"):
        declaration.normalise(raw)


def test_legend_used_lists_only_the_operators_the_drawing_draws():
    raw = sample()
    raw["content"]["legend"] = "used"
    model = declaration.put(normalised(raw))  # every edge comes from the action: cats and executes only
    assert 'value="cats: an actor runs it"' in model and 'value="executes: to the state machine"' in model
    assert "affects:" not in model and "effects:" not in model
    raw = sample("action-site-sample")
    raw["content"]["legend"] = "used"
    model = declaration.put(normalised(raw))  # an execution after an effect, and a state after it: all four
    assert "affects: triggers an execution" in model and "effects: changes state" in model


def test_the_head_thinks_it_and_the_hand_does_it_with_nothing_drawn_between():
    model = declaration.put(normalised(sample()))
    cause = re.search(r'<mxCell id="cause" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    action = re.search(r'<mxCell id="action" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    hand = re.search(r'<mxCell id="actor-hand-r" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)"', model)
    assert cause is not None and action is not None and hand is not None
    assert int(cause.group(2)) + int(cause.group(4)) <= int(action.group(2)) + int(action.group(4)) // 2  # the head stands above
    assert abs(int(hand.group(2)) - (int(action.group(2)) + int(action.group(4)) // 2)) <= 1  # the hand on the statement's centre line
    assert int(hand.group(1)) < int(action.group(1)) <= int(hand.group(1)) + 12  # the statement just right of the hand
    assert 'id="e-cause-action"' not in model and "shape=callout" not in model  # nothing drawn from head to hand
    assert 'id="cats"' in model  # the word at the hand


def test_the_stick_man_is_drawn_last_over_the_drawing_and_read_by_nobody(monkeypatch):
    first = normalised(sample())
    model = declaration.put(first)
    lines = re.findall(r'<mxCell id="(actor-[a-z-]+-[a-z-]+)" value="" style="endArrow=none;[^"]*" edge="1"', model)
    assert sorted(lines) == ["actor-hand-l-hand-r", "actor-hip-foot-l", "actor-hip-foot-r", "actor-neck-hip"]
    assert model.index('id="actor-neck-hip"') > model.index('id="effect-catalogue"')  # painted after the drawing
    assert 'id="cause" value="&lt;b&gt;An author&lt;/b&gt;"' in model  # the fragment keeps the words: it is his head
    back = declaration.get(model, kind="explanation")
    assert back["content"]["cause"] == {"label": "An author"} and declaration.put(back) == model
    monkeypatch.setattr(declaration_settings, "ACTOR", False)
    assert "actor-" not in declaration.put(first)


def test_a_word_on_a_line_between_zones_becomes_a_transition_bubble_on_the_ring_in_the_word_presentation(monkeypatch):
    monkeypatch.setattr(declaration_settings, "EDGE_LABEL", "word")
    first = normalised(sample("action-site-sample"))
    model = declaration.put(first)
    bubble = re.search(r'<mxCell id="e-effect-index-effect-recount-word" value="&lt;b&gt;affects&lt;/b&gt;" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    ring = re.search(r'<mxCell id="ring-1" [^\n]*\n\s*<mxGeometry x="(-?\d+)" y="(-?\d+)" width="(\d+)" height="(\d+)"', model)
    cause = re.search(r'<mxCell id="cause" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="\d+" height="(\d+)"', model)
    assert bubble is not None and ring is not None and cause is not None
    bx, by = int(bubble.group(1)) + int(bubble.group(3)) / 2, int(bubble.group(2)) + int(bubble.group(4)) / 2
    cx, cy, r = int(cause.group(1)), int(cause.group(2)) + int(cause.group(3)) / 2, int(ring.group(3)) / 2
    assert abs(math.hypot(bx - cx, by - cy) - r) <= 1.5  # centred on the first ring the line crosses
    assert re.search(r'<mxCell id="e-action-effect-index" value="&lt;b&gt;executes&lt;/b&gt;"', model)  # into zone 1 the word stays beside the line
    back = declaration.get(model, kind="explanation")
    assert declaration.put(back) == model


def test_a_long_value_starts_on_its_own_line_under_its_key():
    line = "get_widget: { path: pwsh/Base.Contracts/accosted/contracts.accosted.yml }"
    lines = declaration.wrap_line(line, 38)
    assert lines[0] == "get_widget: { path:" and lines[1].startswith("pwsh/Base.Contracts/")
    assert declaration.unwrap_lines("\n".join(lines)) == line
    assert declaration.wrap_line("get_widget: { path: a.yml }", 38) == ["get_widget: { path: a.yml }"]  # a short value stays beside its key


def test_wrap_and_unwrap_are_inverse():
    line = "get_widget: { path: pwsh/Base.Contracts/accosted/contracts.accosted.yml, name: a b c }"
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


def test_a_pill_stands_at_the_middle_of_its_line_when_the_ring_crossing_would_cover_the_head():
    model = declaration.put(normalised(sample("action-site-sample")))
    bubble = re.search(r'<mxCell id="e-effect-index-effect-recount-word" [^\n]*\n\s*<mxGeometry x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)"', model)
    assert bubble is not None
    centre = (int(bubble.group(1)) + int(bubble.group(3)) / 2, int(bubble.group(2)) + int(bubble.group(4)) / 2)
    assert abs(centre[0] - 638.5) <= 1.5 and abs(centre[1] - 359.5) <= 1.5  # halfway between the two boxes' facing sides
