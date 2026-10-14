# cspell:ignore minimaps
"""Write a gallery PDF: every diagram output as image pages, for readers without an HTML viewer.

usage: uv run -q --with pillow python .claude/drawio/gallery_pdf.py [<slides-dir>]

With no argument it reads out/diagrams/fan-out and writes out/diagrams/gallery.pdf. With a slides dir (e.g. out/diagrams/wave-5) it
writes <slides-dir>/gallery.pdf.

Page order: world maps, lens contact sheets (fan-out only), then every slide, each followed by its standalone minimaps when they
exist and by its two markdown companions, <stem>.md (the presentation) and <stem>.visual.md (the visual description), rendered
as text pages. Each page is the image scaled to 1600 px wide under a caption bar with its file name. Pillow writes the PDF
directly, so no Markdown or HTML step is needed.
"""
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path("out/diagrams")
WIDTH = 1600
BAR = 44
MARGIN = 48
INK, QUIET, RULE = "#37474F", "#546E7A", "#CFD8DC"
BACKGROUND = "#E6ECF2"  # the grey-bluish base layer of every rendered output (.claude/drawio/STYLE.md)


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
    d.rectangle([0, 0, WIDTH, BAR], fill="#37474F")
    d.text((14, 11), f"{section}  ·  {path.name}", font=font(20, bold=True), fill="#ffffff")
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


def markdown_page(path, section):
    """Render one markdown file as a text image: headings, paragraphs, lists, and tables as monospace rows."""
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
    for raw in path.read_text(encoding="utf-8").splitlines():
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
    height = MARGIN * 2 + sum(gap + len(lines) * round(f.size * 1.4) for f, _, lines, gap in blocks)
    img = Image.new("RGB", (WIDTH, height), BACKGROUND)
    d = ImageDraw.Draw(img)
    y = MARGIN
    for f, colour, lines, gap in blocks:
        y += gap
        for ln in lines:
            d.text((MARGIN, y), ln, font=f, fill=colour)
            y += round(f.size * 1.4)
    d.line([MARGIN, height - 12, WIDTH - MARGIN, height - 12], fill=RULE, width=2)
    return caption(img, path, section)


slides_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "fan-out"
target = (ROOT / "gallery.pdf") if len(sys.argv) == 1 else slides_dir / "gallery.pdf"
items = [(p, "World map", page) for p in sorted(slides_dir.glob("world-map.*.png"))]
if len(sys.argv) == 1:
    items += [(p, "Lens sheet", page) for p in sorted(ROOT.glob("lenses/*/*.sheet.png"))]
for p in sorted(slides_dir.rglob("*.drawio.png"), key=lambda q: q.name):
    stem = p.name[: -len(".drawio.png")]
    folder = p.parent
    items.append((p, "Slide", page))
    items += [(m, "Minimap", page) for m in (folder / f"minimap-{stem}.stack.png", folder / f"minimap-{stem}.tree.png")
              if m.exists()]
    items += [(m, label, markdown_page) for m, label in ((folder / f"{stem}.md", "Presentation"),
                                                         (folder / f"{stem}.visual.md", "Visual description"))
              if m.exists()]
pages = [render(p, s) for p, s, render in items]
pages[0].save(target, "PDF", save_all=True, append_images=pages[1:], resolution=150)
print(f"ok {target} pages={len(pages)}")
