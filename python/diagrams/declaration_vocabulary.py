# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The closed vocabulary of the kit: the error a declaration outside it raises, the glyph library read from assets/glyphs.xml, the
glyph and edge kinds, and the span words."""

import xml.etree.ElementTree as ET
from typing import NoReturn

from . import edge_rules, minimaps
from .declaration_constants import KIT
from .drawio_png import DEFAULTS, plain


class DeclarationError(ValueError):
    """A declaration outside the kit's vocabulary, naming what the author may choose from."""


def choices(what, value, allowed) -> NoReturn:
    raise DeclarationError(f"{what} '{value}' is not one of: {', '.join(allowed)}")


# ---- the glyph library: every kind, its style and its default size, read from assets/glyphs.xml --------------------


def library():
    """The kit's closed vocabulary from the glyph library: glyph kinds, edge kinds, the marker and the chips, each with its verbatim
    style, its legend phrase and its default size."""
    root = ET.parse(KIT / "assets" / "glyphs.xml").getroot()
    cells = {str(c.get("id")): c for c in root.iter("mxCell") if c.get("id")}

    def geometry(c):
        g = c.find("mxGeometry")
        return tuple(int(float(g.get(k, 0))) for k in ("width", "height")) if g is not None else (0, 0)

    glyphs, edges, marks = {}, {}, {}
    for cid, c in cells.items():
        if cid.startswith("g-") and not cid.endswith(("-text", "-tag", "-member", "-holder", "-sample")) and "-tag-" not in cid:
            kind = cid[2:]
            glyphs[kind] = {"style": c.get("style"), "phrase": plain(c.get("value")), "size": geometry(c)}
        elif cid.startswith("e-") and c.get("edge") == "1":
            kind = cid[2:]
            edges[kind] = {"style": c.get("style"), "phrase": plain(cells[f"{cid}-text"].get("value"))}
        elif cid in ("m-marker", "m-rule", "m-count"):
            kind = cid[2:]
            marks[kind] = {"style": c.get("style"), "phrase": plain(cells[f"{cid}-text"].get("value")), "size": geometry(c)}
    glyphs["commit"]["phrase"] = "commit"
    glyphs.pop("commit-red", None)
    tag = cells["g-type-tag"]
    glyphs["type"]["tag"] = {"style": tag.get("style"), "size": geometry(tag)}
    # The action lens: an effect's where chip, and a call site's member row (one per command).
    tag = cells["g-effect-tag"]
    glyphs["effect"]["tag"] = {"style": tag.get("style"), "size": geometry(tag)}
    member = cells["g-callsite-a-member"]
    glyphs["callsite"]["member"] = {"style": member.get("style"), "size": geometry(member)}
    return {"glyphs": glyphs, "edges": edges, "marks": marks, "module": cells["g-module"].get("style")}


LIB = library()
LIB["edges"]["flow"]["phrase"] = (
    f"flow: {DEFAULTS['edge-semantics']['legend']}"  # the legend words of a plain arrow come from the one declaration
)
EDGE_SEMANTICS = {k: tuple(v.replace(",", " ").split()) for k, v in DEFAULTS["edge-semantics"].items() if k != "legend"}
EDGE_LABELS = {word: end for word, end in DEFAULTS["edge-labels"].items()}  # label -> the end that initiates under it
GLYPH_KINDS = tuple(LIB["glyphs"])
EDGE_KINDS = tuple(LIB["edges"])
try:  # the rank table and the kind-pair defaults of the arrow rule, one source for this module and the edge audit
    edge_rules.validate(GLYPH_KINDS, tuple(EDGE_LABELS))
except edge_rules.RuleError as error:
    raise ValueError(str(error)) from error


def span_vocabulary():
    """Every span label the kit allows, flattened from the vocabularies block of drawio.yml and the tracks of variants.yml, with the list
    each came from."""
    words = {}
    for name, entries in DEFAULTS["vocabularies"].items():
        for word in str(entries).split(","):
            word = word.strip()
            if word:
                words.setdefault(word, name)
    for track in minimaps.tracks():
        words.setdefault(track, "tracks")
    return words
