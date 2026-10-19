# cspell:ignore minimaps textlength LANCZOS
"""The minimaps of a diagram, computed from what its yml says the diagram is about, and drawn for the sidebar.

A diagram's `about:` names its subject: the ADR rules it covers (`adrs`), the tracks it describes (`tracks`), the languages it
models (`languages`, empty for a high-level diagram), the modules it draws (`modules`) and, optionally, the exact files it stands
for (`files`). Every name is checked against its registry: the ADR registry (adrs.yml), the tracks (variants.yml), the languages
(languages.yml), the module dependencies (dependencies.yml) and the disk; a name a registry does not know fails with what it does.

A minimap is a view; what it lights, and why, is computed from `about:` and the registries, never written by hand:

  code-locations        where the subject lives: each described track, the drawn modules in it, and the named files
  module-neighbourhood  the drawn modules, with the modules they use to the right and the modules that use them to the left
  axis                  the ADR registry's stacks down and the delivery concerns across: the stack and concern of each covered rule
  grid                  the described tracks down and the modelled languages across

The other views the plan names render as a labelled frame until they are built. Every view is a question in its caption, readable at
the sidebar's width: lit places are bright and named, context is dim. The registries are read here, never a file's head
(ADR-REPO-FILEMETA-NOREADBACK).
"""

import base64
import io
from functools import cache
from pathlib import Path

import yaml
from drawio_png import SCALE, font
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
ABOUT_KEYS = ("adrs", "tracks", "languages", "modules", "files")
PAGE, PANEL, RIM = "#1C2A24", "#243229", "#3B4D43"
LIT, LIT_INK, DIM_INK, CAPTION = "#E6EAF0", "#1E2430", "#7D8C86", "#CDD3DC"


def registry(path):
    return yaml.safe_load((REPO / path).read_text(encoding="utf-8")) or {}


@cache
def tracks():
    """Every track and the folder it lives in (its first place), from variants.yml."""
    return {name: (entry.get("places") or [name])[0] for name, entry in registry("pwsh/Catzc.Base.Variants/configs/variants.yml")["tracks"].items()}


@cache
def languages():
    raw = registry("pwsh/Catzc.Base.Languages/configs/languages.yml")["languages"]
    return [entry if isinstance(entry, str) else entry.get("name") for entry in raw] if isinstance(raw, list) else list(raw)


@cache
def dependencies():
    """Every module and the modules it uses, from the module system's dependency registry."""
    uses = {}

    def walk(node):
        for key, value in (node or {}).items():
            if isinstance(value, list) and key.startswith("Catzc."):
                uses.setdefault(key, [])
                uses[key] += [v for v in value if isinstance(v, str) and v.startswith("Catzc.") and v not in uses[key]]
            elif isinstance(value, dict):
                walk(value)

    # Only the `groups:` section names module-to-module edges; `modules:` maps a module to the groups it may use.
    walk(registry("pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml")["groups"])
    return {module: [m for m in used if m in uses] for module, used in uses.items()}


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
def axis():
    stacks = []
    for stack, _ in adrs().values():
        if stack and stack not in stacks:
            stacks.append(stack)
    return stacks, ["build", "quality-control", "release", "deploy", "access"]


def adr_of(code):
    """The ADR a rule code belongs to: the longest registered ADR code that is the code or its prefix."""
    hits = [adr for adr in adrs() if code == adr or code.startswith(adr + "-")]
    return max(hits, key=len) if hits else None


def problems(about):
    """Every name in `about:` that its registry does not know, each with what the registry does know."""
    out = []
    for code in about["adrs"]:
        if adr_of(code) is None:
            out.append(f"about.adrs '{code}' is not a rule of an ADR in adrs.yml")
    for name, known, registry_name in (("tracks", tracks(), "variants.yml"), ("languages", languages(), "languages.yml"), ("modules", dependencies(), "dependencies.yml")):
        for value in about[name]:
            if value not in known:
                out.append(f"about.{name} '{value}' is not one of {registry_name}: {', '.join(list(known)[:24])}")
    for path in about["files"]:
        if not (REPO / path).is_file():
            out.append(f"about.files '{path}' is not a file in the repository")
    return out


def home(path):
    """The track a repository path sits in, and the module folder under it when the path is inside one of the drawn modules."""
    for track, place in sorted(tracks().items(), key=lambda kv: -len(kv[1])):
        if path == place or path.startswith(place + "/"):
            rest = path[len(place) + 1 :].split("/")
            return track, rest[0] if rest[0] in dependencies() else None
    return None, None


def lights(view, about):
    """What a view lights for the subject, each place with the reason a registry or `about:` gives."""
    if view == "code-locations":
        out = []
        for track in about["tracks"]:
            out.append((track, f"about.tracks; lives in {tracks()[track]}"))
        for module in about["modules"]:
            for track, place in tracks().items():
                if (REPO / place / module).is_dir():
                    out.append((f"{track}/{module}", f"about.modules; {place}/{module}"))
        for path in about["files"]:
            out.append((path, "about.files"))
        return out
    if view == "module-neighbourhood":
        return [(module, "about.modules") for module in about["modules"]]
    if view == "axis":
        out = []
        for code in about["adrs"]:
            adr = adr_of(code)
            stack, concerns = adrs()[adr]
            for concern in concerns:
                if (f"{stack}/{concern}", None) not in [(p, None) for p, _ in out]:
                    out.append((f"{stack}/{concern}", f"{adr}: stack {stack}, concern {concern} in adrs.yml"))
        return out
    if view == "grid":
        return [(f"{t}/{lang}", "about.tracks and about.languages") for t in about["tracks"] for lang in about["languages"]]
    return []


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


def draw_code_locations(d, width, height, about):
    """Each described track, the drawn modules in it with the count of their other files, and the named files under their home."""
    rows = []
    for track in about["tracks"]:
        place = tracks()[track]
        files = [f for f in about["files"] if home(f)[0] == track]
        modules = [m for m in about["modules"] if (REPO / place / m).is_dir()]
        rows.append(("track", place, None))
        for module in modules:
            mine = [f for f in files if home(f)[1] == module]
            total = sum(1 for p in (REPO / place / module).rglob("*") if p.is_file() and "tests" not in p.parts)
            rows.append(("module", module.removeprefix("Catzc."), f"{len(mine)} of {total}" if mine else f"{total} files"))
            rows += [("file", "/".join(Path(f).parts[len(Path(place).parts) + 1 :]), None) for f in mine]
        rows += [("file", f[len(place) + 1 :], None) for f in files if home(f)[1] not in modules]
    pitch = min(15, (height - 26) / max(1, len(rows)))
    size = 10 if pitch >= 13 else 9
    y = 24
    for kind, label, note in rows:
        if kind == "track":
            text(d, (8, y), fit(d, label, size, width - 16, bold=True), size, CAPTION, bold=True)
        elif kind == "module":
            text(d, (16, y), fit(d, label, size, width - 80, bold=True), size, CAPTION, bold=True)
            text(d, (width - 60, y), note, size - 1, DIM_INK)
        else:
            box(d, (22, y, width - 8, y + pitch - 2), LIT)
            text(d, (27, y), fit(d, label, size - 1, width - 40, bold=True), size - 1, LIT_INK, bold=True)
        y += pitch


def draw_module_neighbourhood(d, width, height, about):
    """The drawn modules against the right edge, a `uses` arrow down between two that depend on each other; to the left the
    modules that use each one, with an arrow into it; under a box, dimmed, the modules it uses that the diagram does not draw."""
    uses = dependencies()
    lit = about["modules"]
    short = lambda m: m.removeprefix("Catzc.")
    box_x, box_w = width * 0.48, width * 0.52 - 6
    pitch = min(60, (height - 30) / max(1, len(lit)))
    text(d, (4, 22), "used by", 8, DIM_INK)
    for i, module in enumerate(lit):
        y = 34 + i * pitch
        box(d, (box_x, y, box_x + box_w, y + 16), LIT)
        text(d, (box_x + 4, y + 2), fit(d, short(module), 9, box_w - 8, bold=True), 9, LIT_INK, bold=True)
        users = [m for m, deps in uses.items() if module in deps and m not in lit]
        shown = users[:3] + ([f"+{len(users) - 3} more"] if len(users) > 3 else [])
        for j, name in enumerate(shown):
            text(d, (4, y + 1 + j * 11), fit(d, short(name), 8, box_x - 22), 8, DIM_INK)
        if users:
            arrow(d, (box_x - 14, y + 8), (box_x - 1, y + 8), DIM_INK)
        outside = [m for m in uses.get(module, []) if m not in lit]
        if outside:
            line = "uses " + ", ".join(short(m) for m in outside)
            text(d, (box_x + 4, y + 18), fit(d, line, 8, box_w - 8), 8, DIM_INK)
        if i + 1 < len(lit) and lit[i + 1] in uses.get(module, []):
            mid = box_x + box_w / 2
            arrow(d, (mid, y + 16), (mid, y + pitch - 1), LIT)
            text(d, (mid + 5, y + pitch / 2 + 2), "uses", 8, CAPTION)


def arrow(d, a, b, ink):
    """A one-pixel line from a to b with a small head at b."""
    d.line([(a[0] * SCALE, a[1] * SCALE), (b[0] * SCALE, b[1] * SCALE)], fill=ink, width=SCALE)
    if a[0] == b[0]:
        head = [(b[0] - 3, b[1] - 4), (b[0] + 3, b[1] - 4), b]
    else:
        head = [(b[0] - 4, b[1] - 3), (b[0] - 4, b[1] + 3), b]
    d.polygon([(x * SCALE, y * SCALE) for x, y in head], fill=ink)


def draw_axis(d, width, height, about):
    """The ADR registry's stacks down and the delivery concerns across, the cells of the covered rules lit."""
    stacks, concerns = axis()
    lit = {place for place, _ in lights("axis", about)}
    label_w, top = 44, 40
    cell_w = (width - label_w - 8) / len(concerns)
    cell_h = min(20, (height - top - 6) / max(1, len(stacks)))
    for j, concern in enumerate(concerns):
        short = "QC" if concern == "quality-control" else concern.upper()
        on = any(place.endswith("/" + concern) for place in lit)
        text(d, (label_w + j * cell_w + 2, top - 13), fit(d, short, 8, cell_w - 2), 8, CAPTION if on else DIM_INK, bold=on)
    for i, stack in enumerate(stacks):
        y = top + i * cell_h
        on = any(place.startswith(stack + "/") for place in lit)
        text(d, (6, y + cell_h / 2 - 6), stack, 9, CAPTION if on else DIM_INK, bold=on)
        for j, concern in enumerate(concerns):
            x = label_w + j * cell_w
            here = f"{stack}/{concern}" in lit
            box(d, (x + 1, y + 1, x + cell_w - 1, y + cell_h - 1), LIT if here else PANEL, None if here else RIM, 2)


def draw_grid(d, width, height, about):
    """The described tracks down and the modelled languages across; a high-level diagram models none and says so."""
    if not about["languages"]:
        text(d, (8, 40), "high level: no language modelled", 10, DIM_INK)
        return
    rows, cols = about["tracks"], about["languages"]
    label_w, top = 70, 40
    cell_w = (width - label_w - 8) / len(cols)
    for j, lang in enumerate(cols):
        text(d, (label_w + j * cell_w + 2, top - 13), fit(d, lang, 8, cell_w - 2), 8, CAPTION)
    for i, track in enumerate(rows):
        y = top + i * 18
        text(d, (6, y + 3), fit(d, track, 9, label_w - 8), 9, CAPTION)
        for j, lang in enumerate(cols):
            on = lang in (registry("pwsh/Catzc.Base.Variants/configs/variants.yml")["tracks"][track].get("languages") or [])
            box(d, (label_w + j * cell_w + 1, y + 1, label_w + (j + 1) * cell_w - 1, y + 17), LIT if on else PANEL, None if on else RIM, 2)


DRAW = {"code-locations": draw_code_locations, "module-neighbourhood": draw_module_neighbourhood, "axis": draw_axis, "grid": draw_grid}


def picture(view, about, width, height):
    """One minimap as a PNG data URI: its question as the caption, then the view computed from `about:`."""
    img, d = canvas(width, height)
    text(d, (8, 6), QUESTION.get(view, view), 11, CAPTION, bold=True)
    if view in DRAW:
        DRAW[view](d, width, height, about)
    else:
        text(d, (8, height / 2 - 6), f"{view}: not drawn yet", 10, DIM_INK)
    small = img.resize((width * 2, height * 2), Image.Resampling.LANCZOS)
    buffer = io.BytesIO()
    small.save(buffer, "PNG")
    return "data:image/png," + base64.b64encode(buffer.getvalue()).decode()
