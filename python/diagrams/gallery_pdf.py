# cspell:ignore minimaps consola cour arialbd textlength
"""Write a gallery PDF: every diagram output as image pages, for readers without an HTML viewer.

usage: uv run -q --project python python -m catzc.diagrams.gallery_pdf [<slides-dir>]
       uv run -q --project python python -m catzc.diagrams.gallery_pdf --assets [<assets-dir>] [--no-text]

Assets mode writes out/diagrams/assets-gallery.pdf: every PNG under <assets-dir> (default docs/.assets) in path order, captioned
with its folder, each followed by its description as a text page: for a declared diagram the `description:` of the
<name>.drawio.yml beside it, for any other PNG the page the sidecar carrier of file-carriers.yml names (the registry is the one
lookup); --no-text leaves the text pages out (the full PDF with them is large).

With no argument it reads out/diagrams/fan-out and writes out/diagrams/gallery.pdf. With a slides dir (e.g. out/diagrams/wave-5) it
writes <slides-dir>/gallery.pdf.

Page order: world maps, then every slide, each followed by the `description:` of its <name>.drawio.yml when it has one, as a
text page. Each page is the image scaled to 1600 px wide under a caption bar with its file name. Pillow writes the PDF directly, so
no Markdown or HTML step is needed.
"""
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

from .module_paths import REPO, module_file

ROOT = Path("out/diagrams")
WIDTH = 1600
PAGE_HEIGHT = 24000  # the most text one page holds; a longer markdown file continues on the next page
BAR = 44
MARGIN = 48
INK, QUIET, RULE = "#CDD3DC", "#949FAE", "#3A4555"  # the dark-theme tokens (assets/STYLE.md)
BACKGROUND = "#1E2430"  # the dark page, the base layer of every rendered output
BAR_FILL, BAR_INK = "#262E3B", "#DDE2E9"  # the caption bar: band fill, title ink


def font(size, bold=False, mono=False):
    names = ("consola.ttf", "cour.ttf") if mono else (("arialbd.ttf",) if bold else ("arial.ttf",))
    for name in names:
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            pass
    return ImageFont.load_default()


def caption(img, path, section):
    out = Image.new("RGB", (WIDTH, img.height + BAR + 16), BACKGROUND)
    d = ImageDraw.Draw(out)
    d.rectangle([0, 0, WIDTH, BAR], fill=BAR_FILL)
    d.text((14, 11), f"{section}  ·  {path.name}", font=font(20, bold=True), fill=BAR_INK)
    out.paste(img, ((WIDTH - img.width) // 2, BAR + 8))
    return out


def page(path, section):
    img = Image.open(path).convert("RGB")
    scale = min(WIDTH / img.width, 2.0)
    img = img.resize((round(img.width * scale), round(img.height * scale)))
    return caption(img, path, section)


def inline(text):
    """Markdown inline syntax down to plain text: links keep their label, emphasis and code marks go."""
    text = re.sub(r"!\[[^\]]*\]\([^)]*\)", "", text)
    text = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", text)
    return text.replace("**", "").replace("`", "")


def wrap(d, text, f, width):
    lines, line = [], ""
    for word in text.split(" "):
        cand = f"{line} {word}".strip()
        if line and d.textlength(cand, font=f) > width:
            lines.append(line)
            line = word
        else:
            line = cand
    return lines + [line] if line else lines


def description_page(path, section):
    """A diagram declaration's `description:` as a text page: the diagram's folder name as its heading, the sentence or two below."""
    lines, held = [], False
    for raw in path.read_text(encoding="utf-8").splitlines():
        if raw.startswith("description:"):
            held = True
            rest = raw.split(":", 1)[1].strip()
            if rest and rest not in (">-", ">", "|", "|-"):
                lines.append(rest.strip("\"'"))
            continue
        if held and raw.startswith((" ", "\t")):
            lines.append(raw.strip())
        elif held:
            break
    return markdown_page(path, section, f"# {path.parent.name}\n\n{' '.join(lines)}\n")


def markdown_page(path, section, text=None):
    """Render one markdown file (or the markdown text given for it) as a text image: headings, paragraphs, lists, and tables as
    monospace rows."""
    probe = ImageDraw.Draw(Image.new("RGB", (1, 1)))
    width = WIDTH - 2 * MARGIN
    blocks = []  # (font, colour, lines, gap_before)
    para = []
    item = []  # [indent, bullet, text] of the open list item; its wrapped source lines join it

    def flush():
        if para:
            f = font(22)
            blocks.append((f, INK, wrap(probe, inline(" ".join(para)), f, width), 10))
            para.clear()
        if item:
            indent, bullet, body = item
            f = font(22)
            pad = "    " * indent
            lines = wrap(probe, inline(body), f, width - 40 - 30 * indent)
            blocks.append((f, INK, [f"{pad}{bullet} {lines[0]}"] + [f"{pad}    {ln}" for ln in lines[1:]], 6))
            item.clear()

    fenced = False
    for raw in (path.read_text(encoding="utf-8") if text is None else text).splitlines():
        s = raw.strip()
        if s.startswith("```"):  # a fenced block (e.g. an article's text overview) keeps its lines, monospace
            flush()
            fenced = not fenced
            continue
        if fenced:
            blocks.append((font(19, mono=True), QUIET, [raw.rstrip() or " "], 0))
            continue
        if not s or s.startswith("!["):
            flush()
            continue
        if item and raw.startswith(" ") and not re.match(r"^(\d+\.|-)\s", s):
            item[2] += " " + s
            continue
        if s.startswith("#"):
            flush()
            level = len(s) - len(s.lstrip("#"))
            f = font({1: 34, 2: 27}.get(level, 23), bold=True)
            blocks.append((f, INK, wrap(probe, inline(s.lstrip("# ")), f, width), 26 if level > 1 else 0))
        elif s.startswith("|"):
            flush()
            if re.fullmatch(r"\|[\s:|-]+\|", s):
                continue
            cells = [inline(c.strip()) for c in s.strip("|").split("|")]
            f = font(19, mono=True)
            blocks.append((f, INK, wrap(probe, " │ ".join(cells), f, width), 2))
        elif re.match(r"^(\d+\.|-)\s", s):
            flush()
            indent = (len(raw) - len(raw.lstrip())) // 2
            marker, body = s.split(" ", 1)
            item.extend([indent, "•" if marker == "-" else marker, body])
        else:
            para.append(s)
    flush()
    # Cut the text into pages below the encoder's 65500 px roof: a minimap page runs to thousands of rows.
    sheets, sheet, used = [], [], 0
    for block in blocks:
        f, _, lines, gap = block
        tall = gap + len(lines) * round(f.size * 1.4)
        if sheet and used + tall > PAGE_HEIGHT:
            sheets.append(sheet)
            sheet, used = [], 0
        sheet.append(block)
        used += tall
    sheets.append(sheet)
    images = []
    for number, sheet in enumerate(sheets, 1):
        height = MARGIN * 2 + sum(gap + len(lines) * round(f.size * 1.4) for f, _, lines, gap in sheet)
        img = Image.new("RGB", (WIDTH, height), BACKGROUND)
        d = ImageDraw.Draw(img)
        y = MARGIN
        for f, colour, lines, gap in sheet:
            y += gap
            for ln in lines:
                d.text((MARGIN, y), ln, font=f, fill=colour)
                y += round(f.size * 1.4)
        d.line([MARGIN, height - 12, WIDTH - MARGIN, height - 12], fill=RULE, width=2)
        label = section if len(sheets) == 1 else f"{section} ({number}/{len(sheets)})"
        images.append(caption(img, path, label))
    return images


CARRIERS = module_file("Catzc.Base.Languages", "configs", "file-carriers.yml")


def sidecar_rules():
    """The sidecar carriers of file-carriers.yml as (globs, pattern) pairs: the registry is the one lookup, read, never re-spelled."""
    rules, entry = [], None
    for line in CARRIERS.read_text(encoding="utf-8").splitlines():
        head = re.match(r"^  ([a-z][a-z0-9-]*):\s*$", line)
        if head:
            entry = {}
            rules.append(entry)
            continue
        if entry is None:
            continue
        files = re.match(r"^\s+files:\s*\[(.*)\]\s*$", line)
        if files:
            entry["files"] = [g.strip().strip("\"'") for g in files.group(1).split(",") if g.strip()]
        sidecar = re.match(r"^\s+sidecar:\s*\"?([^\"]+?)\"?\s*$", line)
        if sidecar:
            entry["sidecar"] = sidecar.group(1)
    return [(r["files"], r["sidecar"]) for r in rules if "sidecar" in r and "files" in r]


def glob_regex(glob):
    """A registry glob as a regex over a '/'-separated repository-relative path: '**/' spans folders, '*' stays inside one segment."""
    pattern = re.escape(glob).replace(r"\*\*/", "(?:.*/)?").replace(r"\*\*", ".*").replace(r"\*", "[^/]*")
    return re.compile("^" + pattern + "$")


def companion(png):
    """The description page of a PNG: through the sidecar rule whose glob matches a diagram, else the same-stem markdown beside it."""
    relative = png.resolve().relative_to(REPO).as_posix()
    for globs, pattern in sidecar_rules():
        if any(glob_regex(g).match(relative) for g in globs):
            stem = png.name[: -len(".drawio.png")]
            hits = sorted(REPO.glob(pattern.replace("{stem}", stem)))
            return hits[0] if hits else None
    beside = png.with_suffix(".md")
    return beside if beside.exists() else None


def assets_items(assets_dir, with_text):
    """Every PNG under the assets dir in path order, each followed by its description page when one exists."""
    items = []
    for p in sorted(assets_dir.rglob("*.png")):
        section = p.parent.relative_to(assets_dir).as_posix()
        items.append((p, section if section != "." else assets_dir.name, page))
        if not with_text:
            continue
        # A declared diagram describes itself in its yml's description:; any other PNG through its companion page.
        declared = p.with_name(p.name.replace(".drawio.png", ".drawio.yml"))
        if p.name.endswith(".drawio.png") and declared.is_file():
            items.append((declared, "Description", description_page))
            continue
        description = companion(p)
        if description is not None:
            items.append((description, "Description", markdown_page))
    return items


args = [a for a in sys.argv[1:] if not a.startswith("--")]
if "--assets" in sys.argv:
    assets_dir = Path(args[0]) if args else Path("docs/.assets")
    target = ROOT / "assets-gallery.pdf"
    items = assets_items(assets_dir, "--no-text" not in sys.argv)
else:
    slides_dir = Path(args[0]) if args else ROOT / "fan-out"
    target = (ROOT / "gallery.pdf") if not args else slides_dir / "gallery.pdf"
    items = [(p, "World map", page) for p in sorted(slides_dir.glob("world-map.*.png"))]
    for p in sorted(slides_dir.rglob("*.drawio.png"), key=lambda q: q.as_posix()):
        items.append((p, "Slide", page))
        declared = p.with_name(p.name.replace(".drawio.png", ".drawio.yml"))
        if declared.is_file():
            items.append((declared, "Description", description_page))
if not items:
    sys.exit(f"no PNG to render under {args[0] if args else 'the default folder'}")
target.parent.mkdir(parents=True, exist_ok=True)


def rendered(items, counter):
    """One page at a time: Pillow walks the iterable while it writes, so a tree of hundreds of diagrams needs no page list."""
    for p, s, render in items:
        out = render(p, s)
        for img in out if isinstance(out, list) else [out]:
            counter[0] += 1
            yield img


counter = [0]
renders = rendered(items, counter)
next(renders).save(target, "PDF", save_all=True, append_images=renders, resolution=150)
print(f"ok {target} pages={counter[0]}")
