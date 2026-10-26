# cspell:ignore compressobj mxfile
"""What a .drawio.png build reads before it paints: the kit's defaults and theme tokens, the style and label helpers, and the mxfile chunk
a png carries its model in."""

import base64
import hashlib
import html
import re
import zlib
from pathlib import Path
from urllib.parse import quote, unquote

from PIL.PngImagePlugin import PngImageFile

from .kit_yaml import load_yaml_text


def kit_defaults(path=None):
    """The kit's sensible defaults from configs/drawio.yml of this module: each section a mapping of setting to its text as written, so
    a value the formatter wraps onto indented lines reads as one; a section that holds only comments is an empty mapping."""
    path = path or Path(__file__).resolve().parent / "configs" / "drawio.yml"
    data = load_yaml_text(path.read_text(encoding="utf-8")) or {}
    return {section: {} if value == "" else value for section, value in data.items()}


DEFAULTS = kit_defaults()
EDGE_MIN_LINE = float(DEFAULTS["renderer"]["edge-deadzone-min-line"])  # the line an edge keeps whatever its deadzone, px
THEMES = tuple(DEFAULTS["themes"])  # the first is the default, the one whose raster is committed


def tokens(theme=None):
    """A theme's token set (the default theme's when none is named): each token's colour as `#HEX`."""
    return {name: "#" + value for name, value in DEFAULTS[f"theme-{theme or THEMES[0]}"].items()}


def paint(style, theme=None):
    """A style with every `@<token>` reference replaced by its theme's colour; a token the theme lacks fails, naming the tokens."""
    known = tokens(theme)

    def colour(match):
        if match.group(1) not in known:
            raise KeyError(f"style token '@{match.group(1)}' is not one of: {', '.join(known)}")
        return known[match.group(1)]

    return re.sub(r"@([a-z][a-z0-9-]*)", colour, style)


BACKGROUND = tokens()["page"]  # the page every rendered output sits on
INK = tokens()["ink"]  # text that sets no fontColor
LINE = tokens()["line"]  # an edge or outline that sets no strokeColor
SHADOW = (0, 0, 0, 77)  # the one shadow every filled shape casts (STYLE.md, Canvas): black at 30 %
SHADOW_OFFSET = (2, 3)  # 2 px right, 3 px down
HALF_DISC_SEGMENTS = 32  # the straight pieces a cause's semicircle is drawn with, named once
SHADOW_BLUR = 2
SCALE = 3  # supersampling: every shape, line and label is painted at this multiple and the page is downsampled once, so curves are smooth


def style_map(style):
    out = {}
    for part in (style or "").split(";"):
        if "=" in part:
            k, v = part.split("=", 1)
            out[k] = v
        elif part:
            out[part] = "1"
    return out


def color(value, default):
    if not value or value == "none":
        return default
    return value if value.startswith("#") else default


def faded(hex_color, style):
    """Blend a fill toward white by the cell's opacity (draw.io `opacity` / `fillOpacity`, 0-100)."""
    op = float(style.get("fillOpacity", style.get("opacity", 100))) / 100
    if not hex_color or op >= 1:
        return hex_color
    r, g, b = (int(hex_color[i:i + 2], 16) for i in (1, 3, 5))
    red, green, blue = (round(c * op + 255 * (1 - op)) for c in (r, g, b))
    return f"#{red:02x}{green:02x}{blue:02x}"



def html_color(value):
    m = re.search(r'color[=:]\s*"?(#[0-9a-fA-F]{6})', value or "")
    if m:
        return m.group(1)
    m = re.search(r"color:\s*rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)", value or "")
    return "#{:02x}{:02x}{:02x}".format(*(int(v) for v in m.groups())) if m else None


def plain(value):
    # A block element starts a new line where it opens and where it closes, as draw.io lays it out; the boundary between
    # two blocks is one line break, and a <br><br> stays a blank line.
    text = re.sub(r"</(?:div|p)>\s*<(?:div|p)[^>]*>", "\n", value or "", flags=re.IGNORECASE)
    text = re.sub(r"<br\s*/?>|<div[^>]*>|</div>|<p[^>]*>|</p>|</li>", "\n", text, flags=re.IGNORECASE)
    text = re.sub(r"<[^>]+>", "", text)
    return html.unescape(text).strip()


def encode(model_xml, name):
    comp = zlib.compressobj(9, zlib.DEFLATED, -15)
    raw = comp.compress(quote(model_xml, safe="!~*'()-_.").encode()) + comp.flush()
    inner = base64.b64encode(raw).decode()
    mxfile = (
        f'<mxfile host="Electron" type="device"><diagram id="{hashlib.sha1(model_xml.encode()).hexdigest()[:20]}" '
        f'name="{html.escape(name, quote=True)}">{inner}</diagram></mxfile>'
    )
    return quote(mxfile, safe="!~*'()-_.")


def decode(chunk):
    mxfile = unquote(chunk)
    diagram = re.search(r"<diagram[^>]*>(.*)</diagram>", mxfile, re.DOTALL)
    if diagram is None:
        raise SystemExit("the mxfile chunk holds no <diagram>")
    return unquote(zlib.decompress(base64.b64decode(diagram.group(1)), -15).decode())


def mxfile_chunk(img):
    """The still-encoded mxfile text chunk of an opened .drawio.png."""
    if not isinstance(img, PngImageFile):
        raise SystemExit(f"{img.filename} is not a PNG")
    return img.text["mxfile"]


COLOUR_KEYS = ("fillColor", "strokeColor", "fontColor", "gradientColor", "labelBackgroundColor", "labelBorderColor")
COLOUR_WORDS = ("none", "default", "inherit")  # the draw.io keywords a colour key may hold instead of a hex value


def unpainted(root, cells):
    """Fails on a colour that is neither hex nor a draw.io keyword, such as an `@token` left unpainted, naming the cell and the key:
    the raster would otherwise draw the default in its place without a word."""
    found = [("background", "mxGraphModel", root.get("background"))] if root.get("background") else []
    for cid, c in cells.items():
        s = style_map(c.get("style"))
        found += [(key, cid, s[key]) for key in COLOUR_KEYS if s.get(key)]
    bad = [f"{cid} {key}={value}" for key, cid, value in found if not value.startswith("#") and value not in COLOUR_WORDS]
    if bad:
        raise SystemExit(f"colours that are neither hex nor {', '.join(COLOUR_WORDS)} (an unpainted @token? paint the model first): {'; '.join(bad)}")
