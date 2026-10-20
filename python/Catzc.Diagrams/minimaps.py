# cspell:ignore minimaps textlength LANCZOS
"""The minimaps of a diagram, drawn for the sidebar from the data Catzc.Base.Maps computes.

A minimap's data is computed in PowerShell from the diagram's subject, the ADR codes of its `about.adrs` and the files that cite
them, and reaches this module as contract JSON (minimap_contract.py); what it lights, and why, is never computed or written here.
Every view is a question in its caption, readable at the sidebar's width: lit places are bright and named, context is dim.

Until the rework of every diagram's minimaps drops them, the other `about:` names (tracks, languages, modules, files) are still
checked against their registries (problems), and otherwise ignored. The registries are read here, never a file's head
(ADR-REPO-FILEMETA-NOREADBACK).
"""

import base64
import io
from functools import cache
from pathlib import Path

import yaml
from drawio_png import SCALE, font, tokens
from PIL import Image, ImageDraw

REPO = Path(__file__).resolve().parents[2]
QUESTION = {
    "code-locations": "Where does it live?",
    "module-neighbourhood": "What does it lean on?",
    "axis": "Which stage of delivery?",
    "grid": "Which tracks and languages?",
    "layer-stack": "Which layer?",
    "lifecycle-position": "Which rung of the lifecycle?",
    "track-placement": "Which tracks and vendors?",
    "engine-strip": "Which engines?",
}
ABOUT_KEYS = ("adrs",)


def use_theme(theme=None):
    """Set the minimap colours to a theme's map-* tokens (the default theme's when none is named); every picture starts here."""
    global PAGE, PANEL, RIM, LIT, LIT_INK, DIM_INK, CAPTION
    t = tokens(theme)
    PAGE, PANEL, RIM = t["map-page"], t["map-panel"], t["map-rim"]
    LIT, LIT_INK, DIM_INK, CAPTION = t["map-lit"], t["map-lit-ink"], t["map-dim"], t["map-caption"]


use_theme()


def registry(path):
    return yaml.safe_load((REPO / path).read_text(encoding="utf-8")) or {}


@cache
def tracks():
    """Every track and the folder it lives in (its first place), from variants.yml."""
    return {name: (entry.get("places") or [name])[0] for name, entry in registry("pwsh/Catzc.Base.Variants/configs/variants.yml")["tracks"].items()}


@cache
def adrs():
    """Every ADR code in the registry with the stack and the concerns it sits on: a ruleset's own concern, else its domain's."""
    found = {}

    def walk(node, stack=None, concern=None):
        if not isinstance(node, dict):
            return
        stack = node.get("stack", stack)
        concern = node.get("concern", concern)
        for value in (node.get("rulesets") or {}).values():
            if isinstance(value, dict) and value.get("external"):
                found[value["external"]] = (stack, value.get("concern") or concern or [])
        for key, value in node.items():
            if key != "rulesets":
                walk(value, stack, concern)

    walk(registry("pwsh/Catzc.Base.Docs/configs/adrs.yml"))
    return found


@cache
def rules():
    """Every rule code the ADRs define: the `### Rule <code>` headings under docs/adr."""
    found = set()
    for page in (REPO / "docs" / "adr").rglob("*.md"):
        for line in page.read_text(encoding="utf-8").splitlines():
            if line.startswith("### Rule ADR-"):
                found.add(line.removeprefix("### Rule ").split()[0])
    return found


def adr_of(code):
    """The ADR a rule code belongs to: the longest registered ADR code that is the code or its prefix."""
    hits = [adr for adr in adrs() if code == adr or code.startswith(adr + "-")]
    return max(hits, key=len) if hits else None


def problems(about):
    """Every name in `about:` that its registry does not know, each with what the registry does know."""
    out = []
    for code in about["adrs"]:
        adr = adr_of(code)
        if adr is None:
            out.append(f"about.adrs '{code}' is not a rule of an ADR in adrs.yml")
        elif code not in adrs() and code not in rules():
            siblings = sorted(r for r in rules() if r.startswith(adr + "-"))
            out.append(f"about.adrs '{code}' is not a rule of {adr}; its rules are: {', '.join(siblings)}")
    return out


def canvas(width, height):
    img = Image.new("RGB", (width * SCALE, height * SCALE), PAGE)
    return img, ImageDraw.Draw(img)


def text(d, xy, value, size, ink, bold=False):
    d.text((xy[0] * SCALE, xy[1] * SCALE), value, font=font(size * SCALE, bold), fill=ink)


def box(d, xy, fill, rim=None, radius=3):
    d.rounded_rectangle([v * SCALE for v in xy], radius=radius * SCALE, fill=fill, outline=rim, width=SCALE if rim else 0)


def fit(d, value, size, width, bold=False):
    """The value shortened with an ellipsis until it fits the width."""
    f = font(size * SCALE, bold)
    if d.textlength(value, font=f) <= width * SCALE:
        return value
    while value and d.textlength(value + "…", font=f) > width * SCALE:
        value = value[:-1]
    return value + "…"


# ---- a minimap drawn from its contract data (minimap_contract.py): Catzc.Base.Maps computes, this module only draws ----------

MIN_CELL = 36  # the narrowest matrix column whose header still reads at the sidebar's width; a wider axis is drawn as rows of names
MIN_PITCH = 12  # the tightest line of a list; the places that do not fit are counted, not crushed


def fitting_rows(rows, lit, height, top):
    """The rows a minimap has room for at MIN_PITCH, in axis order, and how many it leaves out: when not all fit, the rows holding a
    lit place come first, and the last line is kept for the count of the others, so no label is ever drawn over another."""
    room = max(1, int((height - top - 6) // MIN_PITCH))
    if len(rows) <= room:
        return list(rows), 0
    holds = lambda row: any(at[0] == row for at in lit)
    chosen = set(([r for r in rows if holds(r)] + [r for r in rows if not holds(r)])[: room - 1])
    return [r for r in rows if r in chosen], len(rows) - len(chosen)


def draw_data(d, width, height, data):
    """A minimap from its data: one axis is a strip of cells, two a matrix with the first axis down, more a list of the lit
    places. A lit cell is filled; a place the data names no cell for stays empty."""
    axes = data["axes"]
    present = {tuple(c["at"]) for c in data["cells"]}
    lit = {tuple(c["at"]) for c in data["lit"]}
    top = 40
    if len(axes) == 1:
        values, hidden = fitting_rows(axes[0]["values"], lit, height, top)
        pitch = min(16, (height - top - 6) / max(1, len(values) + bool(hidden)))
        for i, value in enumerate(values):
            y, on = top + i * pitch, (value,) in lit
            if (value,) in present:
                box(d, (8, y + 1, 26, y + pitch - 1), LIT if on else PANEL, None if on else RIM, 2)
            text(d, (32, y + pitch / 2 - 6), fit(d, value, 9, width - 40, bold=on), 9, CAPTION if on else DIM_INK, bold=on)
        if hidden:
            text(d, (32, top + len(values) * pitch), f"+{hidden} more", 9, DIM_INK)
        return
    if len(axes) == 2 and (width - 78) / max(1, len(axes[1]["values"])) < MIN_CELL:
        draw_rows(d, width, height, axes[0]["values"], present, lit)
        return
    if len(axes) == 2:
        (rows, hidden), cols = fitting_rows(axes[0]["values"], lit, height, top), axes[1]["values"]
        label_w = 70
        cell_w = (width - label_w - 8) / max(1, len(cols))
        cell_h = min(18, (height - top - 6) / max(1, len(rows) + bool(hidden)))
        for j, col in enumerate(cols):
            on = any(at[1] == col for at in lit)
            text(d, (label_w + j * cell_w + 2, top - 13), fit(d, col, 8, cell_w - 2), 8, CAPTION if on else DIM_INK, bold=on)
        for i, row in enumerate(rows):
            y = top + i * cell_h
            on = any(at[0] == row for at in lit)
            text(d, (6, y + cell_h / 2 - 6), fit(d, row, 9, label_w - 8, bold=on), 9, CAPTION if on else DIM_INK, bold=on)
            for j, col in enumerate(cols):
                if (row, col) in present:
                    here = (row, col) in lit
                    x = label_w + j * cell_w
                    box(d, (x + 1, y + 1, x + cell_w - 1, y + cell_h - 1), LIT if here else PANEL, None if here else RIM, 2)
            # A row lit as a whole ([row, '*']): the subject sits in it outside every column, so the row is outlined.
            if (row, "*") in lit:
                box(d, (label_w, y, width - 8, y + cell_h), None, LIT, 3)
        if hidden:
            text(d, (6, top + len(rows) * cell_h), f"+{hidden} more", 9, DIM_INK)
        return
    places = sorted(lit)
    room = max(1, int((height - top - 6) // MIN_PITCH))
    shown = places if len(places) <= room else places[: room - 1]
    pitch = min(15, (height - top - 6) / max(1, len(shown) + (len(shown) < len(places))))
    for i, at in enumerate(shown):
        y = top + i * pitch
        box(d, (8, y, width - 8, y + pitch - 2), LIT)
        # A place's '-' (no module) and '.' (the module's root) are placeholders of the data, never printed.
        label = " / ".join(part for part in at if part not in ("-", "."))
        text(d, (13, y), fit(d, label, 9, width - 26, bold=True), 9, LIT_INK, bold=True)
    if len(shown) < len(places):
        text(d, (13, top + len(shown) * pitch), f"+{len(places) - len(shown)} more", 9, DIM_INK)


def draw_rows(d, width, height, rows, present, lit):
    """A matrix too wide to draw as cells: one line per row, its label, then the second-axis values it holds, lit ones bright and
    first, the rest dim, as many as fit and the count of the others. When the rows are too many for a line of names under each
    label, the names follow the label on its own line."""
    top = 40
    rows, hidden = fitting_rows(rows, lit, height, top)
    pitch = min(36, (height - top - 6) / max(1, len(rows) + bool(hidden)))
    inline = pitch < 26
    # The bold width plus the 12 px the label is fitted inside of and a 2 px gap, so a lit label is never cut short.
    label_w = max((d.textlength(row, font=font(9 * SCALE, True)) / SCALE for row in rows), default=0) + 14 if inline else 0
    label_w = min(label_w, width * 0.4)
    for i, row in enumerate(rows):
        y = top + i * pitch
        # A row lit as a whole ([row, '*']): the subject sits in it outside every column, so the row is outlined and its label lit;
        # '*' is never a name of its own.
        whole = (row, "*") in lit
        names = [at[1] for at in sorted(present) if at[0] == row and at[1] != "*"]
        on = [n for n in names if (row, n) in lit]
        off = [n for n in names if (row, n) not in lit]
        bright_label = bool(on) or whole
        text(d, (6, y), fit(d, row, 9, (label_w or width) - 12, bold=bright_label), 9, CAPTION if bright_label else DIM_INK, bold=bright_label)
        x, line = (6.0 + label_w, y) if inline else (14.0, y + 13)
        if whole:
            box(d, (3, y - 1, width - 6, line + 13), None, LIT, 3)
        ordered = [(n, True) for n in on] + [(n, False) for n in off]
        for k, (name, bright) in enumerate(ordered):
            label = fit(d, name.removeprefix("Catzc."), 8, width - 28, bold=bright)
            w = d.textlength(label, font=font(8 * SCALE, bright)) / SCALE + 8
            if x + w > width - 30:
                text(d, (x, line), f"+{len(ordered) - k}", 8, DIM_INK)
                break
            if bright:
                box(d, (x, line, x + w - 2, line + 12), LIT)
            text(d, (x + 3, line), label, 8, LIT_INK if bright else DIM_INK, bold=bright)
            x += w
    if hidden:
        text(d, (6, top + len(rows) * pitch), f"+{hidden} more", 9, DIM_INK)


def picture_from(data, width, height, theme=None):
    """One minimap as a PNG data URI, from its contract data, in a theme: its question as the caption, then the data drawn."""
    use_theme(theme)
    img, d = canvas(width, height)
    text(d, (8, 6), QUESTION.get(data["id"], data["id"]), 11, CAPTION, bold=True)
    draw_data(d, width, height, data)
    small = img.resize((width * 2, height * 2), Image.Resampling.LANCZOS)
    buffer = io.BytesIO()
    small.save(buffer, "PNG")
    return "data:image/png," + base64.b64encode(buffer.getvalue()).decode()
