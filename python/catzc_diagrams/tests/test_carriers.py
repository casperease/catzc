# ---
# catzc:
#   immutable:
#     with_body_sha: e84b3f55c940
# ---

"""The carrier of a diagram's declaration: the kit's drawio.yml declares the default once, and names a diagram's other carrier by its stem.

usage (repo root, background): timeout 120 uv run -q --project python/catzc_diagrams python -m pytest python/catzc_diagrams/tests
"""

import sys
from pathlib import Path

import pytest
import yaml

# The kit folder joins the path first, so its scripts import by bare name as they do beside each other; the tests folder joins too,
# so the shared widget fixture imports by name under any import mode.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import declaration
from drawio_png import DEFAULTS
from test_declaration import WIDGETS

CARRIERS = ("file", "article")
HEAD = "# ---\n# catzc:\n#   immutable:\n#     with_body_sha: 0123456789ab\n# ---\n\n"
BODY = "description: Widgets flow into gadgets through a gate.\n" + WIDGETS.lstrip("\n")
PAGE = "# Widgets flow into gadgets\n\nA paragraph before the diagram.\n\n![Widgets flow into gadgets](.assets/widget-flow.drawio.png)\n\nAfter it.\n"


@pytest.fixture
def pair(tmp_path, monkeypatch):
    """A page folder whose widget diagram is file-carried, its article embedding the png, and drawio.yml copied so carry edits the copy."""
    (tmp_path / ".assets").mkdir()
    (tmp_path / ".assets" / "widget-flow.drawio.yml").write_text(HEAD + BODY, encoding="utf-8")
    page = tmp_path / "widget-flow.md"
    page.write_text(PAGE, encoding="utf-8")
    config = tmp_path / "drawio.yml"
    config.write_text(declaration.CONFIG.read_text(encoding="utf-8"), encoding="utf-8")
    monkeypatch.setattr(declaration, "CONFIG", config)
    monkeypatch.setitem(DEFAULTS, "carriers", {})
    return tmp_path / ".assets" / "widget-flow", page, config


def test_the_shipped_default_carrier_is_the_article_block():
    shipped = yaml.safe_load(declaration.CONFIG.read_text(encoding="utf-8"))
    assert shipped["renderer"]["carrier"] == "article"


def test_every_named_carrier_is_one_of_the_closed_set_and_names_a_stem():
    for stem, carrier in DEFAULTS["carriers"].items():
        assert carrier in CARRIERS, f"{stem}: carrier '{carrier}' is not one of {', '.join(CARRIERS)}"
        assert "/.assets/" in stem and not stem.endswith((".drawio.yml", ".drawio.png")), f"{stem}: a carrier is keyed by the diagram's stem"


def test_carry_to_the_article_writes_the_block_above_the_image_removes_the_yml_and_records_the_carrier(pair):
    stem, page, config = pair
    before = declaration.load(stem)
    declaration.carry(stem, "article")
    assert not declaration.source_of(stem).exists(), "the yml beside the png is gone"
    text = page.read_text(encoding="utf-8")
    assert f"```yml drawio\n{BODY}```\n\n![Widgets flow into gadgets](.assets/widget-flow.drawio.png)" in text, "the block sits above the image, the head left out"
    assert text.startswith("# Widgets flow into gadgets\n\nA paragraph before the diagram.\n\n") and text.endswith("\n\nAfter it.\n")
    assert yaml.safe_load(config.read_text(encoding="utf-8"))["carriers"]["widget-flow"] == "article"
    assert declaration.carrier_of(stem) == "article" and declaration.load(stem) == before


def test_carry_back_to_the_file_restores_the_page_and_the_config_byte_for_byte(pair):
    stem, page, config = pair
    before, original = declaration.load(stem), config.read_text(encoding="utf-8")
    declaration.carry(stem, "article")
    declaration.carry(stem, "file")
    assert declaration.source_of(stem).read_text(encoding="utf-8") == BODY, "the yml holds the block's body"
    assert page.read_text(encoding="utf-8") == PAGE, "the block and its blank line are gone, the image stays"
    assert config.read_text(encoding="utf-8") == original, "carriers: is as it was, every comment kept"
    assert declaration.carrier_of(stem) == "file" and declaration.load(stem) == before


def test_a_slide_is_never_a_carrier(pair):
    stem, page, _ = pair
    page.unlink()
    slide = page.with_name("widget-flow.slide.md")
    slide.write_text(f"```yml drawio\n{BODY}```\n\n![Widgets flow into gadgets](.assets/widget-flow.drawio.png)\n", encoding="utf-8")
    assert declaration.articles(stem) == [], "a slide is no article"
    assert declaration.carrier_findings(stem) == [], "a block in a slide declares nothing"
    with pytest.raises(declaration.DeclarationError, match="found 0"):
        declaration.carry(stem, "article")
    assert declaration.source_of(stem).read_text(encoding="utf-8") == HEAD + BODY


def test_carry_refuses_on_a_parity_loss_and_restores_every_file(pair, monkeypatch):
    stem, page, config = pair
    original = config.read_text(encoding="utf-8")
    real, calls = declaration.normalise, []

    def drifting(raw, where="the declaration"):
        calls.append(where)
        held = real(raw, where=where)
        return held if len(calls) == 1 else {**held, "description": "something else"}

    monkeypatch.setattr(declaration, "normalise", drifting)
    with pytest.raises(declaration.DeclarationError, match="differs, so nothing was moved"):
        declaration.carry(stem, "article")
    assert declaration.source_of(stem).read_text(encoding="utf-8") == HEAD + BODY
    assert page.read_text(encoding="utf-8") == PAGE
    assert config.read_text(encoding="utf-8") == original
    assert declaration.carrier_of(stem) == "file"


def test_carry_refuses_a_diagram_already_in_the_carrier_or_declared_twice(pair):
    stem, page, _ = pair
    with pytest.raises(declaration.DeclarationError, match="already in the file carrier"):
        declaration.carry(stem, "file")
    page.write_text(PAGE.replace("![Widgets", f"```yml drawio\n{BODY}```\n\n![Widgets"), encoding="utf-8")
    with pytest.raises(declaration.DeclarationError, match="declared in both carriers"):
        declaration.carry(stem, "article")


def test_a_yml_cspell_ignore_moves_to_the_page_comment_under_the_title_and_back(pair):
    stem, page, _ = pair
    declaration.source_of(stem).write_text(HEAD + "# cspell:ignore gizmox\n\n" + BODY.replace("through a gate", "through a gizmox gate"), encoding="utf-8")
    declaration.carry(stem, "article")
    text = page.read_text(encoding="utf-8")
    assert text.startswith("# Widgets flow into gadgets\n\n<!-- cspell:ignore gizmox -->\n\nA paragraph before the diagram.\n\n")
    assert "cspell" not in text[text.index("```yml drawio") :], "the block holds no cspell comment"
    declaration.carry(stem, "file")
    assert declaration.source_of(stem).read_text(encoding="utf-8").startswith("# cspell:ignore gizmox\n\n"), "the word is ignored in the yml again"
    assert page.read_text(encoding="utf-8") == PAGE, "the comment the carry made is gone with its word"


def test_a_cspell_ignore_merges_into_the_page_own_comment_and_a_word_the_page_still_uses_stays(pair):
    stem, page, _ = pair
    declaration.source_of(stem).write_text("# cspell:ignore gizmox\n" + BODY.replace("through a gate", "through a gizmox gate"), encoding="utf-8")
    own = PAGE.replace("# Widgets flow into gadgets\n\n", "# Widgets flow into gadgets\n\n<!-- cspell:ignore sprocketz -->\n\n").replace("After it.", "After it, sprocketz.")
    page.write_text(own, encoding="utf-8")
    declaration.carry(stem, "article")
    assert "<!-- cspell:ignore sprocketz gizmox -->" in page.read_text(encoding="utf-8")
    declaration.carry(stem, "file")
    assert page.read_text(encoding="utf-8") == own, "the page keeps its own word and loses only the diagram's"


def test_a_page_with_two_diagrams_takes_one_block_above_each_image(pair, monkeypatch):
    stem, page, config = pair
    gadget = stem.with_name("gadget-flow")
    gadget_body = BODY.replace("Widgets flow into gadgets through a gate.", "Gadgets flow back.")
    page.write_text(PAGE + f"\n```yml drawio\n{gadget_body}```\n\n![Gadgets](.assets/gadget-flow.drawio.png)\n", encoding="utf-8")
    config.write_text(declaration.recorded_carriers(config.read_text(encoding="utf-8"), "gadget-flow", "article"), encoding="utf-8")
    monkeypatch.setitem(DEFAULTS, "carriers", {"gadget-flow": "article"})
    declaration.carry(stem, "article")
    text = page.read_text(encoding="utf-8")
    assert f"```yml drawio\n{BODY}```\n\n![Widgets flow into gadgets](.assets/widget-flow.drawio.png)" in text
    assert f"```yml drawio\n{gadget_body}```\n\n![Gadgets](.assets/gadget-flow.drawio.png)" in text
    assert declaration.load(gadget)["description"] == "Gadgets flow back." and declaration.carrier_findings(stem) == []


def test_carry_to_the_article_names_the_png_as_the_build_target(pair):
    stem, page, _ = pair
    where, png = declaration.carry(stem, "article")
    assert where == page and png == stem.with_name("widget-flow.drawio.png")


def test_rekey_moves_a_stems_carrier_and_role_entries_and_keeps_every_other_line():
    text = (
        "renderer:\n  carrier: article # the default\n"
        "roles: # by stem\n  docs/widgets/.assets/gadget: legend # the gadget legend\n  docs/widgets/.assets/gadget-two: slide\n"
        "carriers: # by stem\n  docs/widgets/.assets/gadget: file\n  docs/sprockets/.assets/sprocket: file\n"
        "lenses:\n  docs/widgets/.assets/gadget: not a stem entry\n"
    )
    moved = declaration.rekeyed(text, "docs/widgets/.assets/gadget", "docs/gadgets/.assets/gadget")
    assert moved == text.replace("  docs/widgets/.assets/gadget: legend", "  docs/gadgets/.assets/gadget: legend").replace(
        "carriers: # by stem\n  docs/widgets/.assets/gadget: file", "carriers: # by stem\n  docs/gadgets/.assets/gadget: file"
    ), "only the exact stem in carriers: and roles: moves; gadget-two, other sections and comments stay"


def test_rekey_of_a_folder_moves_every_stem_under_it():
    text = "carriers:\n  docs/widgets/.assets/gadget: file\n  docs/widgets/.assets/sprocket: file\n  docs/widgetsmore/.assets/cog: file\n"
    moved = declaration.rekeyed(text, "docs/widgets", "docs/gadgets")
    assert moved == "carriers:\n  docs/gadgets/.assets/gadget: file\n  docs/gadgets/.assets/sprocket: file\n  docs/widgetsmore/.assets/cog: file\n"
