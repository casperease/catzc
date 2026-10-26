# cspell:ignore pixelated
"""A fact slide as one PNG a person reads, and the picture it shows.

A fact slide (`pattern: fact` in the slides kit) states one checkable proposition beside a picture of the diagram it comes from. The head's
`picture` says how the picture is made, in one of three modes, and how it is viewed:

  mode: reduce   the whole source png scaled down (scale)
  mode: zoom     one box of the source png, [x, y, w, h] in page pixels, scaled (box, scale)
  mode: redraw   the diagram drawn again from its declaration by one named, isolated variation (variation, words, moves, scale)
  rotate: <deg>  turned in the page plane (z) afterwards; tilt: { y: <0..1>, shear: <-1..1> } foreshortens and leans it (an x-y view angle)

`picture` writes the picture beside the slide file where the slide's `## Image` names it; `render` draws the slide itself at the deck's size
with the kit's tokens and lands it beside the slide too, so the source catalogue holds what the person reads.

usage (repo root, background):
  uv run --no-sync --project python python python/diagrams/slide_png.py picture <slide.md>
  uv run --no-sync --project python python python/diagrams/slide_png.py render <slide.md> [<out.png>]
(render lands in the source catalogue, beside the slide at .assets/<id>.slide.png, unless <out.png> says otherwise: a costly render is a
committed build output, never parked under out/)
"""

import re
import sys
from pathlib import Path

import yaml
from PIL import Image, ImageDraw, ImageFont

KIT = Path(__file__).resolve().parent
sys.path.insert(0, str(KIT))
import declaration  # noqa: E402  (the kit folder joins the path first, as the kit's scripts import each other by bare name)

SLIDES = yaml.safe_load((KIT / "assets" / "slides" / "slides.yml").read_text(encoding="utf-8"))
FONTS = {"display": ("georgia.ttf", "DejaVuSerif.ttf"), "text": ("segoeui.ttf", "arial.ttf", "DejaVuSans.ttf")}
FONT_DIRS = [Path("C:/Windows/Fonts"), Path("/usr/share/fonts/truetype/dejavu")]
MODES = ("reduce", "zoom", "redraw")
# The redraw variations: each one named, hardcoded and isolated here; a variation reads the declaration and paints with the kit's tokens.
VARIATIONS = ("ladder-strip",)
FACT, STRIP = SLIDES["fact"], SLIDES["strip"]  # every size of the fact picture and the ladder strip, declared once in slides.yml
FONTS["bold"] = ("segoeuib.ttf", "arialbd.ttf", "DejaVuSans-Bold.ttf")


def head_and_fields(path):
    """The slide file's head config and its fields: the level-one heading as title, each `## Name` section as a field by lower name."""
    text = path.read_text(encoding="utf-8")
    match = re.match(r"---\n(.*?)\n---\n(.*)", text, re.S)
    head = (yaml.safe_load(match.group(1)) or {}).get("catzc", {}) if match else {}
    body = match.group(2) if match else text
    fields = {"title": ""}
    current = None
    for line in body.split("\n"):
        if line.startswith("# "):
            fields["title"] = line[2:].strip()
        elif line.startswith("## "):
            current = line[3:].strip().lower()
            fields[current] = ""
        elif current:
            fields[current] = (fields[current] + " " + line.strip()).strip()
    return head.get("config", {}), fields


def font(face, size):
    for name in FONTS[face]:
        for folder in FONT_DIRS:
            candidate = folder / name
            if candidate.exists():
                return ImageFont.truetype(str(candidate), size)
    return ImageFont.load_default()


def wrapped(d, text, f, width):
    lines, line = [], ""
    for word in text.split():
        trial = f"{line} {word}".strip()
        if d.textlength(trial, font=f) <= width or not line:
            line = trial
        else:
            lines.append(line)
            line = word
    if line:
        lines.append(line)
    return lines


def scaled(img, scale):
    return img.resize((max(1, round(img.width * scale)), max(1, round(img.height * scale))), Image.NEAREST)


def viewed(img, spec, bg):
    """The picture under its view: foreshortened and leaned by tilt (the x-y angle), then turned by rotate (z)."""
    tilt = spec.get("tilt") or {}
    if tilt:
        y = float(tilt.get("y", 1))
        shear = float(tilt.get("shear", 0))
        img = img.resize((img.width, max(1, round(img.height * y))), Image.BILINEAR)
        if shear:
            extra = round(abs(shear) * img.height)
            canvas = Image.new("RGB", (img.width + extra, img.height), bg)
            # The lean samples input x + shear * y: a positive shear pulls the lower rows left, so the picture starts `extra` in.
            canvas.paste(img, (extra if shear > 0 else 0, 0))
            img = canvas.transform(canvas.size, Image.AFFINE, (1, shear, 0, 0, 1, 0), Image.BILINEAR, fillcolor=bg)
    rotate = float(spec.get("rotate", 0))
    if rotate:
        img = img.rotate(rotate, expand=True, fillcolor=bg, resample=Image.BILINEAR)
    return img


def rung_shape(d, kind, box, fill, rim):
    x, y, w, h = box
    if kind == "gate":
        d.polygon([(x + w / 2, y), (x + w, y + h / 2), (x + w / 2, y + h), (x, y + h / 2)], fill=fill, outline=rim, width=2)
    elif kind == "env":
        n = h / 2
        d.polygon([(x + n, y), (x + w - n, y), (x + w, y + h / 2), (x + w - n, y + h), (x + n, y + h), (x, y + h / 2)], fill=fill, outline=rim, width=2)
    elif kind == "runner":
        d.rounded_rectangle((x, y, x + w, y + h), radius=h // 2, fill=fill, outline=rim, width=2)
    else:
        d.rounded_rectangle((x, y, x + w, y + h), radius=6, fill=fill, outline=rim, width=2)


def ladder_strip(content, spec, token):
    """The ladder-strip variation: every rung of the diagram's first ladder as one small shape of its kind, climbing right and up, a 3-8
    character word or a number in each (the head's words by id, else the marker's number, else the label's first word), and a word on
    each climb (the head's moves, in order) along the horizontal leg."""
    ladder = (content.get("ladders") or [None])[0]
    if not ladder:
        raise SystemExit("ladder-strip needs a diagram with a ladders: hint")
    rungs = declaration.ladder_rungs(content, ladder["band"])
    marker = {m["at"]: str(m["number"]) for m in content.get("markers") or []}
    words = spec.get("words") or {}
    moves = [str(m) for m in (spec.get("moves") or [])]
    n = len(rungs)
    tw, th, rise, gap, line = (int(STRIP[k]) for k in ("tile_width", "tile_height", "rise", "gap", "line"))
    pad = gap // 2
    width = n * (tw + gap) - gap + 2 * pad
    height = th + (n - 1) * rise + 2 * pad
    # Two layers: the forms, then the words painted last over everything, bold and outlined, so a word never loses to a shape.
    forms = Image.new("RGBA", (width, height), token["bg_raised"])
    text = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    d, t = ImageDraw.Draw(forms), ImageDraw.Draw(text)
    word_font, move_font = font("bold", int(STRIP["word_size"])), font("bold", int(STRIP["move_size"]))
    stroke = int(STRIP["word_stroke"])
    fills = {"gate": (token["bg_raised_2"], token["accent"]), "env": (token["bg_raised_2"], token["ink_soft"]), "runner": (token["accent"], token["ink"])}
    for i, rung in enumerate(rungs):
        x = pad + i * (tw + gap)
        y = height - pad - th - i * rise
        kind = rung.get("kind", "commit")
        fill, rim = fills.get(kind, (token["ink_muted"], token["ink"]))
        rung_shape(d, kind, (x, y, tw, th), fill, rim)
        word = str(words.get(rung["id"]) or marker.get(rung["id"]) or rung["label"].split()[0])[:8]
        t.text((x + tw / 2, y + th / 2), word, font=word_font, fill=token["ink"], anchor="mm", stroke_width=stroke, stroke_fill=token["bg"])
        if i + 1 < n:  # the climb: up out of the top centre, then right into the next rung's left centre
            nx, ny = x + tw + gap, y - rise + th / 2
            d.line([(x + tw / 2, y), (x + tw / 2, ny), (nx, ny)], fill=token["accent"], width=line)
            head = 3 * line
            d.polygon([(nx, ny), (nx - head, ny - head / 2), (nx - head, ny + head / 2)], fill=token["accent"])
            if i < len(moves):
                t.text((x + tw / 2 + gap / 2, ny - line), moves[i][:8], font=move_font, fill=token["ink"], anchor="lb", stroke_width=stroke, stroke_fill=token["bg"])
    return Image.alpha_composite(forms, text).convert("RGB")


def picture(slide):
    """The picture the slide shows, made by its head's picture: mode and viewed by its tilt and rotate, written where Image names it."""
    config, fields = head_and_fields(slide)
    spec = config.get("picture")
    if not spec:
        raise SystemExit(f"{slide}: the head's config has no picture: {{ mode, source, ... }}")
    mode = spec.get("mode", "reduce")
    if mode not in MODES:
        raise SystemExit(f"{slide}: picture mode '{mode}' is not one of: {', '.join(MODES)}")
    token = SLIDES["token"]
    source = (slide.parent / spec["source"]).resolve()
    scale = float(spec.get("scale", 0.5))
    if mode == "redraw":
        variation = spec.get("variation", VARIATIONS[0])
        if variation not in VARIATIONS:
            raise SystemExit(f"{slide}: picture variation '{variation}' is not one of: {', '.join(VARIATIONS)}")
        content = declaration.load(declaration.diagram_of(source))["content"]
        img = scaled(ladder_strip(content, spec, token), scale)
    else:
        img = Image.open(source).convert("RGB")
        if mode == "zoom":
            x, y, w, h = (int(v) for v in spec["box"])
            img = img.crop((x, y, x + w, y + h))
        img = scaled(img, scale)
    img = viewed(img, spec, token["bg_deep"])
    dst = slide.parent / fields["image"]
    dst.parent.mkdir(parents=True, exist_ok=True)
    img.save(dst)
    return dst


def render(slide, out=None):
    """The fact slide drawn at the deck's size: eyebrow, title, lead on the left; the picture and its caption on the right; the page row."""
    config, fields = head_and_fields(slide)
    token, scale, layout = SLIDES["token"], SLIDES["scale"], SLIDES["layout"]
    width, height, gutter = int(layout["width"]), int(layout["height"]), int(layout["gutter"])
    pic_w, pic_h, wide, gap = int(FACT["picture_width"]), int(FACT["picture_height"]), float(FACT["wide_ratio"]), int(FACT["gap"])
    img = Image.new("RGB", (width, height), token["bg_deep"])
    d = ImageDraw.Draw(img)
    shown = slide.parent / fields["image"]
    pic = Image.open(shown).convert("RGB") if shown.exists() else None
    under = pic is not None and pic.width > wide * pic.height  # a wide picture lies under the text at the full inner width
    column = width - 2 * gutter if under else width - 2 * gutter - pic_w - gap
    y = gutter
    eyebrow = font("text", int(scale["caption"]))
    d.text((gutter, y), fields.get("eyebrow", "").upper(), font=eyebrow, fill=token["accent"])
    y += int(scale["caption"]) + 40
    title = font("display", int(scale["h2"]) - 8)
    for line in wrapped(d, fields["title"], title, column):
        d.text((gutter, y), line, font=title, fill=token["ink"])
        y += int(scale["h2"]) + 4
    y += 24
    lead = font("text", int(scale["body"]))
    for line in wrapped(d, fields.get("lead", ""), lead, column):
        d.text((gutter, y), line, font=lead, fill=token["ink_soft"])
        y += int(scale["body"]) + 12
    if pic is not None:
        caption = font("text", int(scale["caption"]))
        caption_h = int(scale["caption"]) + 8
        if under:
            room_h = height - int(layout["footer_bottom"]) - int(scale["caption"]) - gap - y - 2 * caption_h
            ratio = min(column / pic.width, room_h / pic.height, 1)
            pic = pic.resize((round(pic.width * ratio), round(pic.height * ratio)), Image.NEAREST)
            px, py, cap_x, cap_w = gutter + (column - pic.width) // 2, y + gap, gutter, column
        else:
            ratio = min(pic_w / pic.width, pic_h / pic.height, 1)
            pic = pic.resize((round(pic.width * ratio), round(pic.height * ratio)), Image.NEAREST)
            px, py, cap_x, cap_w = width - gutter - pic_w + (pic_w - pic.width) // 2, (height - pic.height) // 2 - gap, width - gutter - pic_w, pic_w
        img.paste(pic, (px, py))
        cy = py + pic.height + caption_h // 2
        for line in wrapped(d, fields.get("caption", ""), caption, cap_w):
            d.text((cap_x, cy), line, font=caption, fill=token["ink_muted"])
            cy += caption_h
    page = font("text", int(scale["caption"]))
    d.text((gutter, height - int(layout["footer_bottom"]) - int(scale["caption"])), str(config.get("order", "")), font=page, fill=token["ink_muted"])
    dst = Path(out) if out else slide.parent / ".assets" / f"{slide.name.removesuffix('.slide.md')}.slide.png"
    dst.parent.mkdir(parents=True, exist_ok=True)
    img.save(dst)
    return dst


def main():
    args = sys.argv[1:]
    if len(args) >= 2 and args[0] == "picture":
        print(f"picture {picture(Path(args[1]))}")
    elif len(args) >= 2 and args[0] == "render":
        print(f"render {render(Path(args[1]), args[2] if len(args) > 2 else None)}")
    else:
        raise SystemExit(__doc__)


if __name__ == "__main__":
    main()
