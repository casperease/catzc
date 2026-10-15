# cspell:ignore minimaps segoeui segoeuib seguisb textlength squarify Bruls rects cwid gfiles gmap gname maxw tname
"""Render the three minimaps of every slide, each with its sister .md, from the map processors' data.

Per slide, into the target folder (.claude/drawio/STYLE.md, "Fan-out"):
  <stem>.grid.png   the world map's grid: tracks x file languages, the lit cells filled
  <stem>.tree.png   the world map's tree: the files of the map as a treemap, the lit files filled
  <stem>.chain.png  the value-chain map: value-chain stack x value-chain concerns, the lit cells filled
and the sister <stem>.<view>.md of each (describe.py). The data comes from highlights.ps1 (the --data folder); this script
places nothing itself: every lit cell, lit file and reason is the highlight's.

usage (repo root, background):
  timeout 300 uv run -q --with pillow python .claude/drawio/minimaps/render.py --slides <slides.json>
      [--data out/minimaps] [--target docs/.assets/explanation] [--overview <world-map.tree.png>] [--facts <facts.json>]
"""

import argparse
import json
from functools import lru_cache
from pathlib import Path

import describe
from PIL import Image, ImageDraw, ImageFont

REPO = Path(__file__).resolve().parents[3]
# The minimap tokens (.claude/drawio/STYLE.md, "Colours (minimaps only)"): the minimap page, a dark green-grey nuance of
# its own so a minimap reads as a map inset and never as a band of the slide; idle cell, cell border, label, ink; HALO is
# the minimap page colour, used for the label halo, the lit ADR tile's rim and the lens badge's digits on the light badge.
BG, IDLE, BORDER, LABEL, INK, HALO, BADGE = "#1C2A24", "#243229", "#3B4D43", "#949FAE", "#CDD3DC", "#1C2A24", "#E6EAF0"
FONT_R = "C:/Windows/Fonts/segoeui.ttf"
FONT_B = "C:/Windows/Fonts/segoeuib.ttf"
FONT_SB = "C:/Windows/Fonts/seguisb.ttf"
LENS_BADGE = {"meta": "META", "architecture": "ARCH", "implementation": "IMPL", "operations": "OPS", "governance": "GOV"}
VIEWS = ("grid", "tree", "chain")

# Set by configure() from the data folder: the maps.yml palette and the bucket labels.
PALETTE = {}
BUCKETS = {}


def configure(data):
    """Load the palette and the printed labels the minimaps share with the world-map PDFs (maps.yml)."""
    PALETTE.update(json.loads((data / "palette.json").read_text(encoding="utf-8")))
    labels = json.loads((data / "labels.json").read_text(encoding="utf-8"))
    BUCKETS.update(labels["buckets"])
    return labels


def page():
    """The grey-bluish base layer of every rendered output, drawn first (palette.background)."""
    return PALETTE["background"]


def lit():
    """A lit cell and a lit file on all three minimaps: the ink the world-map PDFs outline a lit cell with (palette.highlight)."""
    return PALETTE["highlight"]


def printed(name):
    """A bucket key prints as its defined term (ADR-DSGN-TRACK#7, #8, #13); every other name as itself."""
    return BUCKETS.get(name, name)


@lru_cache(None)
def font(size, weight="r"):
    return ImageFont.truetype({"r": FONT_R, "b": FONT_B, "sb": FONT_SB}[weight], size)


def text_w(draw, s, f):
    return draw.textlength(s, font=f)


def fit(draw, s, f, width):
    if text_w(draw, s, f) <= width:
        return s
    while s and text_w(draw, s + "…", f) > width:
        s = s[:-1]
    return s + "…" if s else ""


def mix(hue, alpha, base):
    a, b = [tuple(int(h.lstrip("#")[i : i + 2], 16) for i in (0, 2, 4)) for h in (hue, base)]
    return tuple(round(b[i] + (a[i] - b[i]) * alpha) for i in range(3))


def mentions_only(highlight):
    """The lit files every reason of which is a passing mention (a comment after the file's header)."""
    reasons = {}
    for cell in highlight["cells"]:
        for reason in cell["reasons"]:
            if reason["path"]:
                reasons.setdefault(reason["path"], []).append(reason["mention"])
    return {path for path, flags in reasons.items() if all(flags)}


def lit_files(highlight):
    return {f for c in highlight["cells"] for f in c["files"]}


def spread(centres, pitch, low, high):
    """Label centres at least `pitch` apart, each as near its row as the others allow, inside [low, high]. A row is
    shorter than a label, so two lit rows side by side would print their names over each other; the tick on the
    axis keeps marking the exact row."""
    ys = []
    for c in centres:
        ys.append(max(c, ys[-1] + pitch) if ys else max(c, low + pitch / 2))
    for i in range(len(ys) - 1, -1, -1):
        ys[i] = min(ys[i], (ys[i + 1] - pitch) if i + 1 < len(ys) else high - pitch / 2)
    return ys


def touched():
    """A cell or file lit only by passing mentions: the lit colour, lighter (40 % over the idle grey)."""
    return mix(lit(), 0.4, IDLE)


def draw_cell(d, box, state):
    """One grid cell in the shared encoding: lit (ink), touched (light ink) or idle (a grey outlined box)."""
    if state == "lit":
        d.rectangle(box, fill=lit(), outline=lit(), width=1)
    elif state == "touched":
        d.rectangle(box, fill=touched(), outline=touched(), width=1)
    else:
        d.rectangle(box, fill=IDLE, outline=BORDER, width=1)


def draw_codes(d, items, f, top, low, high):
    """Short horizontal column labels: each centred over its column where the others allow, alternating between two lines
    so neighbours never touch; a tick under each lit column marks its exact place."""
    for line in (0, 1):
        row = [(x, text, fill) for i, (x, text, fill) in enumerate(items) if i % 2 == line]
        if not row:
            continue
        pitch = max(text_w(d, text, f) for _, text, _ in row) + 8
        for (_, text, fill), x in zip(row, spread([x for x, _, _ in row], pitch, low, high)):
            d.text((x, top + line * 22), text, font=f, fill=fill, anchor="mt")


def draw_badge(d, text, box, size):
    x0, y0, x1, y1 = box
    d.rounded_rectangle(box, radius=6, fill=BADGE)
    f = font(size, "b")
    tw = text_w(d, text, f)
    d.text(((x0 + x1) / 2 - tw / 2, (y0 + y1) / 2), text, font=f, fill=HALO, anchor="lm")


# ---------------------------------------------------------------- grid minimap (tracks x file languages)

GRID_W, GRID_H = 480, 300
GRID_LEFT, GRID_TOP, GRID_PAD = 124, 58, 3  # the top holds two lines of short column codes at 18 px


def render_grid(world, highlight, extensions, badge, path):
    """The world map's grid: one row per track, one column per file language, in the map's order, every cell a grey box.
    A lit cell is filled in ink, a cell lit only by passing mentions in lighter ink. Only the lit rows and columns are
    named: a row by its track, a column by a short code (the file language's first extension, 'other' for the unlisted
    files), horizontal, with a tick on its axis."""
    rows, cols = world["tracks"], world["file_languages"]
    cells = {(c["track"], c["file_language"]): c for c in highlight["cells"]}
    im = Image.new("RGB", (GRID_W, GRID_H), page())
    d = ImageDraw.Draw(im)
    cw = (GRID_W - GRID_LEFT - GRID_PAD) / len(cols)
    ch = (GRID_H - GRID_TOP - GRID_PAD) / len(rows)
    gap = 1.5
    for r, track in enumerate(rows):
        for c, language in enumerate(cols):
            x0, y0 = GRID_LEFT + c * cw, GRID_TOP + r * ch
            cell = cells.get((track, language))
            state = "idle" if not cell else "touched" if cell["touched"] else "lit"
            draw_cell(d, (x0 + gap, y0 + gap, x0 + cw - gap, y0 + ch - gap), state)
    f = font(18, "sb")
    lit_rows = {t for t, _ in cells}
    lit_cols = {lang for _, lang in cells}
    named = [(r, track) for r, track in enumerate(rows) if track in lit_rows]
    for (r, track), y in zip(named, spread([GRID_TOP + (r + 0.5) * ch for r, _ in named], 18, GRID_TOP, GRID_H)):
        name = fit(d, printed(track), f, GRID_LEFT - 14)
        d.text((GRID_LEFT - 8 - text_w(d, name, f), y), name, font=f, fill=INK, anchor="lm")
        yc = GRID_TOP + (r + 0.5) * ch
        d.rectangle((GRID_LEFT - 5, yc - ch / 2 + gap, GRID_LEFT - 2, yc + ch / 2 - gap), fill=lit())
    codes = []
    for c, language in enumerate(cols):
        if language not in lit_cols:
            continue
        x = GRID_LEFT + (c + 0.5) * cw
        code = "other" if language not in extensions else extensions[language][0]
        codes.append((x, code, INK))
        d.rectangle((x - cw / 2 + gap, GRID_TOP - 5, x + cw / 2 - gap, GRID_TOP - 2), fill=lit())
    draw_codes(d, codes, f, 4, GRID_LEFT + 4, GRID_W - 2)
    draw_badge(d, badge, (3, 4, 92, 38), 17)
    im.save(path, optimize=True)


# ---------------------------------------------------------------- value-chain minimap (stack x concern)

CHAIN_W, CHAIN_H = 480, 300
CHAIN_LEFT, CHAIN_TOP, CHAIN_PAD = 76, 58, 3  # the top holds two lines of capital column codes at 18 px


def render_chain(chain, highlight, path):
    """The value-chain map: one row per value-chain stack, one column per value-chain concern, both closed sets in their
    declared order, every cell a grey box and the lit cells filled in ink. Every row and column is named by a capital
    code (describe.concern_code), horizontal; the lit ones in ink with a tick, the others in the label grey. The map
    shows where the slide sits, not how many ADRs a cell holds."""
    rows, cols = chain["stacks"], chain["concerns"]
    cells = {(c["stack"], c["concern"]) for c in highlight["cells"]}
    im = Image.new("RGB", (CHAIN_W, CHAIN_H), page())
    d = ImageDraw.Draw(im)
    cw = (CHAIN_W - CHAIN_LEFT - CHAIN_PAD) / len(cols)
    ch = (CHAIN_H - CHAIN_TOP - CHAIN_PAD) / len(rows)
    gap = 3
    for r, stack in enumerate(rows):
        for c, concern in enumerate(cols):
            x0, y0 = CHAIN_LEFT + c * cw, CHAIN_TOP + r * ch
            draw_cell(d, (x0 + gap, y0 + gap, x0 + cw - gap, y0 + ch - gap), "lit" if (stack, concern) in cells else "idle")
    f = font(18, "sb")
    lit_rows = {s for s, _ in cells}
    lit_cols = {c for _, c in cells}
    for r, stack in enumerate(rows):
        y = CHAIN_TOP + (r + 0.5) * ch
        on = stack in lit_rows
        d.text((CHAIN_LEFT - 8 - text_w(d, stack, f), y), stack, font=f, fill=INK if on else LABEL, anchor="lm")
        if on:
            d.rectangle((CHAIN_LEFT - 5, y - ch / 2 + gap, CHAIN_LEFT - 2, y + ch / 2 - gap), fill=lit())
    codes = []
    for c, concern in enumerate(cols):
        x = CHAIN_LEFT + (c + 0.5) * cw
        on = concern in lit_cols
        codes.append((x, describe.concern_code(concern), INK if on else LABEL))
        if on:
            d.rectangle((x - cw / 2 + gap, CHAIN_TOP - 5, x + cw / 2 - gap, CHAIN_TOP - 2), fill=lit())
    draw_codes(d, codes, f, 4, CHAIN_LEFT + 4, CHAIN_W - 2)
    im.save(path, optimize=True)


# ---------------------------------------------------------------- tree minimap


def short_module(m):
    if m == "Catzc.Azure":
        return "Azure"
    for pre, rep in (("Catzc.Base.", ""), ("Catzc.Tooling.", "Tool."), ("Catzc.Azure.", "Az.")):
        if m.startswith(pre):
            return rep + m[len(pre) :]
    return m


def group_of(f, track):
    """The top folder and group of a file; a file in a bucket row of the map is its own top and group."""
    if track in BUCKETS:
        return (track, track)
    parts = f.split("/")
    if parts[0] == "automation":
        return ("automation", "automation/" + parts[1]) if len(parts) > 2 else ("automation", "automation")
    if parts[0] == "docs":
        if len(parts) > 2 and parts[1] == "adr":
            return ("docs", "docs/adr/" + parts[2]) if len(parts) > 3 else ("docs", "docs/adr")
        return ("docs", "docs/other")
    return (parts[0], parts[0])


def worst(row, w):
    s = sum(row)
    return max(max(w * w * r / (s * s), (s * s) / (w * w * r)) for r in row)


def squarify(values, x, y, w, h):
    """Squarified treemap (Bruls et al.). values sorted descending; returns rects in the same order."""
    rects = []
    vals = list(values)
    total = sum(vals)
    if total <= 0:
        return [(x, y, 0, 0)] * len(vals)
    scale = w * h / total
    areas = [v * scale for v in vals]
    i = 0
    while i < len(areas):
        short = min(w, h)
        row = [areas[i]]
        j = i + 1
        while j < len(areas) and worst(row + [areas[j]], short) <= worst(row, short):
            row.append(areas[j])
            j += 1
        s = sum(row)
        if w >= h:  # lay the row as a column on the left
            cwid = s / h
            yy = y
            for a in row:
                hh = a / cwid
                rects.append((x, yy, cwid, hh))
                yy += hh
            x += cwid
            w -= cwid
        else:
            rh = s / w
            xx = x
            for a in row:
                ww = a / rh
                rects.append((xx, y, ww, rh))
                xx += ww
            y += rh
            h -= rh
        i = j
    return rects


def inset(r, k):
    x, y, w, h = r
    k = min(k, w / 3, h / 3)
    return (x + k, y + k, w - 2 * k, h - 2 * k)


def build_tree(tracks, width=240.0, height=180.0):
    """Deterministic 3-level layout in 1x minimap units: top folder -> group -> file. `tracks` maps each file to its
    track on the world map."""
    tops = {}
    for f in sorted(tracks):
        t, g = group_of(f, tracks[f])
        tops.setdefault(t, {}).setdefault(g, []).append(f)
    top_items = sorted(tops.items(), key=lambda kv: (-sum(len(v) for v in kv[1].values()), kv[0]))
    top_rects = squarify([sum(len(v) for v in g.values()) for _, g in top_items], 0, 0, width, height)
    layout = {"tops": [], "groups": [], "files": {}}
    for (tname, groups), tr in zip(top_items, top_rects):
        layout["tops"].append((tname, tr))
        g_items = sorted(groups.items(), key=lambda kv: (-len(kv[1]), kv[0]))
        g_rects = squarify([len(v) for _, v in g_items], *inset(tr, 1.2))
        for (gname, gfiles), gr in zip(g_items, g_rects):
            layout["groups"].append((gname, gr, tname))
            for f, fr in zip(gfiles, squarify([1] * len(gfiles), *inset(gr, 0.6))):
                layout["files"][f] = (gname, fr)
    return layout


ADR_SHORT = {
    "automation": "auto",
    "configuration": "conf",
    "repository": "repo",
    "principles": "prin",
    "research": "res",
    "pipelines": "pipe",
    "process": "proc",
    "design": "dsgn",
    "flow": "flow",
    "azure": "azure",
    "github": "github",
}


def group_label(g):
    if g.startswith("automation/"):
        return short_module(g.split("/", 1)[1])
    if g.startswith("docs/adr/"):
        return "adr/" + g.split("/")[2]
    return {"docs/other": "docs", "docs/adr": "adr/*"}.get(g, printed(g))


def mini_label(g):
    if g.startswith("docs/adr/"):
        return "adr/" + ADR_SHORT.get(g.split("/")[2], g.split("/")[2])
    return group_label(g)


def group_folder(g):
    """The folder a tree group covers, as a reader finds it."""
    return {"docs/other": "docs/ outside docs/adr/", "docs/adr": "the files directly in docs/adr/"}.get(g, printed(g))


def sc(r, s):
    x, y, w, h = r
    return (x * s, y * s, (x + w) * s, (y + h) * s)


def draw_tree_base(d, layout, s):
    for _, tr in layout["tops"]:
        d.rectangle(sc(tr, s), fill=BG)
    for _, gr, _ in layout["groups"]:
        x0, y0, x1, y1 = sc(inset(gr, 0.3), s)
        if x1 - x0 >= 1 and y1 - y0 >= 1:
            d.rectangle((x0, y0, x1, y1), fill=IDLE, outline=BORDER, width=max(1, round(s / 2)))
    for _, tr in layout["tops"]:
        d.rectangle(sc(tr, s), outline=LABEL if s > 4 else BORDER, width=max(2, round(s * 0.6)))


def draw_label(d, text, x, y, f, maxw, fill=INK):
    t = fit(d, text, f, maxw)
    if t:
        d.text((x, y), t, font=f, fill=fill, anchor="lt", stroke_width=3, stroke_fill=HALO)


def lit_groups(layout, files):
    """The tree groups holding lit files, most lit first (the order the labels take): each as the label the minimap
    prints, the folder it covers, and its lit files in ordinal order."""
    by_group = {}
    for f in sorted(files):
        by_group.setdefault(layout["files"][f][0], []).append(f)
    ordered = sorted(by_group.items(), key=lambda kv: (-len(kv[1]), kv[0]))
    return [{"group": g, "label": mini_label(g), "folder": group_folder(g), "files": fs} for g, fs in ordered]


def render_tree(layout, files, mentions, adr_files, path):
    """The repository tree with the highlight's files lit in ink (lighter when lit only by passing mentions); a lit ADR
    file has a white rim. The tree sits inside a margin of the page background, so the background shows on every minimap."""
    s = 1.95
    canvas = Image.new("RGB", (480, 360), page())
    im = Image.new("RGB", (round(240 * s), round(180 * s)), BG)
    d = ImageDraw.Draw(im)
    draw_tree_base(d, layout, s)
    groups = lit_groups(layout, files)
    gmap = {g: r for g, r, _ in layout["groups"]}
    for group in groups:  # a lit group's edge, so the eye finds a lone small tile
        d.rectangle(sc(inset(gmap[group["group"]], 0.3), s), outline=lit(), width=3)
    for f in sorted(files):
        x0, y0, x1, y1 = sc(layout["files"][f][1], s)
        x0, y0, x1, y1 = x0 + 0.5, y0 + 0.5, max(x1 - 0.5, x0 + 3), max(y1 - 0.5, y0 + 3)
        d.rectangle((x0, y0, x1, y1), fill=touched() if f in mentions else lit())
        if f in adr_files:
            d.rectangle((x0, y0, x1, y1), outline=HALO, width=1)
    # Labels: the lit groups in full, most lit files first; a label that would cover one already printed is left out.
    f = font(19, "b")
    taken = []
    for group in groups:
        x, y, _, _ = gmap[group["group"]]
        label = group["label"]
        lw = text_w(d, label, f)
        lx = max(min(x * s + 4, im.width - 4 - lw), 2)
        rect = (lx - 2, y * s + 1, lx + lw + 2, y * s + 26)
        if any(rect[0] < t[2] and t[0] < rect[2] and rect[1] < t[3] and t[1] < rect[3] for t in taken):
            continue
        taken.append(rect)
        draw_label(d, label, lx, y * s + 3, f, im.width - 4)
    canvas.paste(im, ((canvas.width - im.width) // 2, (canvas.height - im.height) // 2))
    canvas.save(path, optimize=True)


def render_overview(layout, path):
    """The repository tree at full size, every group labelled with its file count: the tree world map of an out/ wave."""
    s = 8
    width, height = int(240 * s), int(180 * s)
    head = 120
    im = Image.new("RGB", (width, height + head), page())
    canvas = Image.new("RGB", (width, height), BG)
    d = ImageDraw.Draw(canvas)
    draw_tree_base(d, layout, s)
    counts = {}
    for g, _ in layout["files"].values():
        counts[g] = counts.get(g, 0) + 1
    for gname, gr, _ in layout["groups"]:
        x, y, w, h = gr
        if w * s >= 80 and h * s >= 34:
            lab = group_label(gname)
            ff = next((font(z, "b") for z in (26, 22, 19) if text_w(d, lab, font(z, "b")) <= w * s - 16), font(19, "b"))
            draw_label(d, lab, x * s + 8, y * s + 6, ff, w * s - 16)
            if h * s >= 64:
                draw_label(d, f"{counts[gname]} files", x * s + 8, y * s + 36, font(20), w * s - 16, fill=LABEL)
    im.paste(canvas, (0, head))
    hd = ImageDraw.Draw(im)
    hd.text((16, 40), "World map: repository tree", font=font(44, "b"), fill=INK, anchor="lm")
    in_top = {}
    for g, _, t in layout["groups"]:
        in_top[t] = in_top.get(t, 0) + counts[g]
    tops = ", ".join(f"{printed(t)} {in_top[t]}" for t, _ in layout["tops"][:6])
    total = len(layout["files"])
    hd.text(
        (16, 92),
        f"Squarified treemap of the {total} files of the world map; area = file count. Top folders: {tops} …",
        font=font(24),
        fill=LABEL,
        anchor="lm",
    )
    im.save(path, optimize=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    parser.add_argument("--slides", required=True, help="the slide list (JSON: slides[] with id, stem, lens, adrs, xml)")
    parser.add_argument("--data", default="out/minimaps", help="the folder highlights.ps1 wrote")
    parser.add_argument("--target", default="docs/.assets/explanation", help="the folder the minimaps and .md files go to")
    parser.add_argument("--overview", help="also write the full-size tree world map to this PNG")
    parser.add_argument("--facts", help="also write each slide's sidebar facts (lit cells, lit groups, file names) to this JSON")
    args = parser.parse_args()
    data, target = REPO / args.data, REPO / args.target
    target.mkdir(parents=True, exist_ok=True)
    labels = configure(data)
    slides = json.loads((REPO / args.slides).read_text(encoding="utf-8"))["slides"]
    world = json.loads((data / "world-map.json").read_text(encoding="utf-8"))
    chain = json.loads((data / "value-chain-map.json").read_text(encoding="utf-8"))
    highlights = json.loads((data / "highlights.json").read_text(encoding="utf-8"))
    missing = [s["id"] for s in slides if s["id"] not in highlights]
    if missing:
        raise SystemExit(f"render.py: no highlight for {missing}: run highlights.ps1 with the same slide list")
    adr_files = {f["path"] for f in world["files"] if f["basis"] == "adr-file"}
    layout = build_tree({f["path"]: f["track"] for f in world["files"]})
    if args.overview:
        render_overview(layout, REPO / args.overview)
    extensions = json.loads((data / "file-languages.json").read_text(encoding="utf-8"))
    ctx = describe.Context(world, chain, labels, json.loads((data / "references.json").read_text(encoding="utf-8")), extensions)
    facts = {}
    for slide in slides:
        world_lit, chain_lit = highlights[slide["id"]]["world"], highlights[slide["id"]]["chain"]
        stem = slide["stem"]
        files = lit_files(world_lit)
        groups = lit_groups(layout, files)
        render_grid(world, world_lit, extensions, LENS_BADGE[slide["lens"]], target / f"{stem}.grid.png")
        render_tree(layout, files, mentions_only(world_lit), adr_files, target / f"{stem}.tree.png")
        render_chain(chain, chain_lit, target / f"{stem}.chain.png")
        describe.write(ctx, target / f"{stem}.grid.md", slide, "grid", world_lit, {})
        describe.write(ctx, target / f"{stem}.tree.md", slide, "tree", world_lit, {"groups": groups})
        describe.write(ctx, target / f"{stem}.chain.md", slide, "chain", chain_lit, {})
        facts[stem] = describe.facts(ctx, slide, world_lit, chain_lit, groups)
    if args.facts:
        (REPO / args.facts).write_text(json.dumps(facts, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"render.py: {len(slides)} slides, {len(slides) * len(VIEWS)} minimaps and sister .md files -> {target}")


if __name__ == "__main__":
    main()
