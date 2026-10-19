# cspell:ignore LANCZOS arialbd compressobj maxx maxy miny mxfile pnginfo prel segoeui segoeuib textbbox textlength dout
"""Build a .drawio.png from an mxGraphModel XML file, or re-render one from the model it already carries.

usage: uv run --with pillow python drawio_png.py <model.xml | in.drawio.png> <out.drawio.png> [--name "Page-1"] [--page dark|model]

`--page` overrides the `renderer.page` default of drawio.yml beside this script for one run.

The PNG carries the diagram as a draw.io `mxfile` tEXt chunk (compressed the way draw.io writes it), so draw.io opens
and re-renders it. The raster is a Pillow preview (boxes, text, straight edges): the headless draw.io CLI cannot render
in this environment. A `.drawio.png` source is read through that chunk (its page name kept), so `in` and `out` may be
the same file: the raster is redrawn from the embedded model and the two stay honest to each other. The script
re-decodes the chunk and asserts the model round-trips.
"""
import base64
import hashlib
import html
import itertools
import re
import sys
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path
from urllib.parse import quote, unquote

from PIL import Image, ImageDraw, ImageFilter, ImageFont
from PIL.PngImagePlugin import PngImageFile, PngInfo


def kit_defaults():
    """The kit's sensible defaults from configs/drawio.yml of this module: a two-level mapping read without a YAML library."""
    out, section = {}, None
    for raw in (Path(__file__).resolve().parent / "configs" / "drawio.yml").read_text(encoding="utf-8").splitlines():
        line = raw.split("#", 1)[0].rstrip()
        if not line.strip():
            continue
        if not line.startswith(" "):
            section = line.rstrip(":").strip()
            out[section] = {}
        else:
            key, value = line.strip().split(":", 1)
            out[section][key.strip()] = value.strip()
    return out


DEFAULTS = kit_defaults()
BACKGROUND = "#1E2430"  # the dark page every rendered output sits on (assets/STYLE.md, dark-theme tokens)
INK = "#CDD3DC"  # text that sets no fontColor: light grey on the dark page
LINE = "#AAB4C3"  # an edge or outline that sets no strokeColor: quiet ink
SHADOW = (0, 0, 0, 77)  # the one shadow every filled shape casts (STYLE.md, Canvas): black at 30 %
SHADOW_OFFSET = (2, 3)  # 2 px right, 3 px down
SHADOW_BLUR = 2


def drop_shadow(img, box, painter, pad=8):
    """Paint the kit's shadow of one shape onto `img` (RGBA) just before the shape itself: `painter(draw, box, colour)`
    draws the shape's silhouette, which is offset, blurred and composited so it fades into the dark page."""
    x0, y0, x1, y1 = box
    w, h = int(x1 - x0) + 2 * pad, int(y1 - y0) + 2 * pad
    layer = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    painter(ImageDraw.Draw(layer), (pad, pad, pad + (x1 - x0), pad + (y1 - y0)), SHADOW)
    layer = layer.filter(ImageFilter.GaussianBlur(SHADOW_BLUR))
    left, top = int(x0) - pad + SHADOW_OFFSET[0], int(y0) - pad + SHADOW_OFFSET[1]
    crop = (max(0, -left), max(0, -top), min(w, img.width - left), min(h, img.height - top))
    if crop[2] <= crop[0] or crop[3] <= crop[1]:
        return
    img.alpha_composite(layer.crop(crop), (max(0, left), max(0, top)))


def paint_shape(d, s, box, w, h, fill, stroke, sw, dashed):
    """Draw one vertex's shape by its draw.io style: the glyph shapes of STYLE.md, in the given fill and stroke."""
    x0, y0, x1, y1 = box
    if dashed and not any(k in s for k in ("ellipse", "rhombus")) and s.get("shape") != "hexagon":
        d.rounded_rectangle([x0, y0, x1, y1], radius=8 if s.get("rounded") == "1" else 0, fill=fill)
        if stroke:
            dashed_line(d, [(x0, y0), (x1, y0), (x1, y1), (x0, y1), (x0, y0)], stroke, max(1, sw))
    elif s.get("shape") == "hexagon":
        pts = [(x0 + w * .25, y0), (x1 - w * .25, y0), (x1, (y0 + y1) / 2), (x1 - w * .25, y1), (x0 + w * .25, y1), (x0, (y0 + y1) / 2)]
        d.polygon(pts, fill=fill, outline=stroke, width=sw)
    elif "ellipse" in s:
        d.ellipse([x0, y0, x1, y1], fill=fill, outline=stroke, width=sw)
    elif "rhombus" in s:
        d.polygon([((x0 + x1) / 2, y0), (x1, (y0 + y1) / 2), ((x0 + x1) / 2, y1), (x0, (y0 + y1) / 2)], fill=fill, outline=stroke, width=sw)
    elif s.get("shape") == "cylinder3":  # a store: body, then the top ellipse drawn over it
        lid = min(h * .3, float(s.get("size", 10)) * 2)
        d.rectangle([x0, y0 + lid / 2, x1, y1 - lid / 2], fill=fill)
        d.ellipse([x0, y1 - lid, x1, y1], fill=fill, outline=stroke, width=sw)
        d.rectangle([x0 + sw, y0 + lid / 2, x1 - sw, y1 - lid / 2], fill=fill)
        d.line([(x0, y0 + lid / 2), (x0, y1 - lid / 2)], fill=stroke, width=sw)
        d.line([(x1, y0 + lid / 2), (x1, y1 - lid / 2)], fill=stroke, width=sw)
        d.ellipse([x0, y0, x1, y0 + lid], fill=fill, outline=stroke, width=sw)
    elif s.get("shape") == "crossbar":  # a span bar: a horizontal line with an end tick on each side
        ym = (y0 + y1) / 2
        ink = stroke or LINE
        d.line([(x0, ym), (x1, ym)], fill=ink, width=max(1, sw))
        d.line([(x0, y0), (x0, y1)], fill=ink, width=max(1, sw))
        d.line([(x1, y0), (x1, y1)], fill=ink, width=max(1, sw))
    elif s.get("shape") == "note":  # a file: a page with a folded top-right corner
        k = min(float(s.get("size", 14)), w / 3, h / 3)
        d.polygon([(x0, y0), (x1 - k, y0), (x1, y0 + k), (x1, y1), (x0, y1)], fill=fill, outline=stroke, width=sw)
        d.line([(x1 - k, y0), (x1 - k, y0 + k), (x1, y0 + k)], fill=stroke, width=sw)
    else:
        pill = s.get("rounded") == "1" and float(s.get("arcSize", 0)) >= 50
        r = min(w, h) / 2 if pill else (8 if s.get("rounded") == "1" else 0)
        d.rounded_rectangle([x0, y0, x1, y1], radius=r, fill=fill, outline=stroke, width=sw)


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


def dashed_line(d, pts, fill, width, dash=6, gap=4):
    import math
    for (x0, y0), (x1, y1) in itertools.pairwise(pts):
        length = math.hypot(x1 - x0, y1 - y0)
        if length == 0:
            continue
        ux, uy = (x1 - x0) / length, (y1 - y0) / length
        t = 0.0
        while t < length:
            e = min(t + dash, length)
            d.line([(x0 + ux * t, y0 + uy * t), (x0 + ux * e, y0 + uy * e)], fill=fill, width=width)
            t = e + gap


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


def font(size, bold):
    names = ["arialbd.ttf", "segoeuib.ttf"] if bold else ["arial.ttf", "segoeui.ttf"]
    for name in names:
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            pass
    return ImageFont.load_default()


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


def render(root, page=None):
    page = page or DEFAULTS["renderer"]["page"]
    if page not in ("dark", "model"):
        raise SystemExit(f"page must be dark or model, got {page}")
    cells = {c.get("id"): c for c in root.iter("mxCell")}

    def own(c):  # a vertex's geometry relative to its parent, or None for edges and the two root cells
        g = c.find("mxGeometry")
        if g is None or c.get("edge") == "1":
            return None
        return float(g.get("x", 0)), float(g.get("y", 0)), float(g.get("width", 0)), float(g.get("height", 0))

    geo = {}
    for cid, c in cells.items():
        rel = own(c)
        if rel is None:
            continue
        x, y = rel[0], rel[1]
        seen = {cid}
        parent = cells.get(c.get("parent"))
        while parent is not None and parent.get("id") not in seen:  # every level up, in any document order
            seen.add(parent.get("id"))
            prel = own(parent)
            if prel is None:
                break
            x, y = x + prel[0], y + prel[1]
            parent = cells.get(parent.get("parent"))
        geo[cid] = (x, y, rel[2], rel[3])
    if not geo:
        raise SystemExit("no vertices with geometry")
    minx = min(v[0] for v in geo.values()) - 20
    miny = min(v[1] for v in geo.values()) - 20
    maxx = max(v[0] + v[2] for v in geo.values()) + 20
    maxy = max(v[1] + v[3] for v in geo.values()) + 20
    # page dark (the drawio.yml default): every rendered output sits on the dark page, painted first behind everything, so a
    # dark- or light-mode viewer shows the same page, and a model's own background wins only when it is a real colour, not
    # white or the retired light page. page model: the model's own background as draw.io would paint it, white included.
    model_bg = color(root.get("background"), BACKGROUND)
    if page == "model":
        bg = model_bg
    else:
        bg = BACKGROUND if model_bg.lower() in ("#ffffff", "#fff", "#e6ecf2") else model_bg
    img = Image.new("RGBA", (int(maxx - minx), int(maxy - miny)), bg)  # RGBA so each shadow composites onto what is under it
    d = ImageDraw.Draw(img)
    off = lambda x, y: (x - minx, y - miny)

    for cid, c in cells.items():  # vertices first, in document order (= z-order)
        if cid not in geo:
            continue
        s = style_map(c.get("style"))
        x, y, w, h = geo[cid]
        (x0, y0), (x1, y1) = off(x, y), off(x + w, y + h)
        is_text = "text" in s and s.get("strokeColor", "none") == "none"
        bare = is_text or "group" in s  # a group only places its children; it paints nothing of its own
        fill = None if bare else faded(color(s.get("fillColor"), None), s)
        stroke = None if s.get("strokeColor") == "none" or bare else faded(color(s.get("strokeColor"), LINE), s)
        dashed = s.get("dashed") == "1"
        if fill or stroke:
            sw_raw = float(s.get("strokeWidth", 1))
            sw = max(1, int(sw_raw)) if sw_raw > 0 else 0  # a hairline (< 1 px, the private-helper rim) still draws 1 px
            box = (x0, y0, x1, y1)
            if fill and s.get("shadow") != "0":  # a filled shape casts the kit's shadow; a bare line (span bar) does not
                drop_shadow(
                    img,
                    box,
                    lambda dd, b, c, s=s, w=w, h=h, stroke=stroke, sw=sw, dashed=dashed: paint_shape(
                        dd, s, b, w, h, c, c if stroke else None, sw, dashed
                    ),
                )
            paint_shape(d, s, box, w, h, fill, stroke, sw, dashed)
        uri = s.get("image", "")
        if s.get("shape") == "image" and uri.startswith("data:image/png,"):
            import io
            pic = Image.open(io.BytesIO(base64.b64decode(uri.split(",", 1)[1]))).convert("RGB")
            img.paste(pic.resize((max(1, int(x1 - x0)), max(1, int(y1 - y0))), Image.Resampling.LANCZOS), (int(x0), int(y0)))
        text = plain(c.get("value"))
        if text:
            size = int(float(s.get("fontSize", 12)))
            bold = int(s.get("fontStyle", 0)) & 1 == 1 or "<b>" in (c.get("value") or "")
            f = font(size, bold)
            ink = html_color(c.get("value")) or color(s.get("fontColor"), INK)
            top = s.get("verticalAlign") == "top" or s.get("swimlane") == "1" or "swimlane" in s
            align = s.get("align", "center")
            if s.get("whiteSpace") == "wrap" and w > 4:  # draw.io pads a wrapped label about 2 px a side
                text = wrapped(d, text, f, w - 4)
            bbox = d.multiline_textbbox((0, 0), text, font=f, spacing=3)
            tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
            tx = x0 + 6 if align == "left" else (x1 - tw - 6 if align == "right" else (x0 + x1 - tw) / 2)
            ty = y0 + 6 if top else (y0 + y1 - th) / 2
            d.multiline_text((tx, ty), text, font=f, fill=ink, spacing=3, align=align if align in ("left", "right") else "center")

    def origin(c):  # the absolute offset of an edge's own coordinates: its parent group's position (geo is absolute), or none
        parent = geo.get(c.get("parent"))
        return (parent[0], parent[1]) if parent else (0.0, 0.0)

    def path(c):  # an edge's points on the canvas: its source end, its waypoints, its target end; None when an end is missing
        g = c.find("mxGeometry")
        ox, oy = origin(c)
        point = lambda p: off(float(p.get("x", 0)) + ox, float(p.get("y", 0)) + oy)
        ends = {p.get("as"): p for p in (g.findall("mxPoint") if g is not None else [])}
        waypoints = [point(p) for p in g.find("Array").findall("mxPoint")] if g is not None and g.find("Array") is not None else []
        src, dst = geo.get(c.get("source")), geo.get(c.get("target"))
        centre = lambda box: off(box[0] + box[2] / 2, box[1] + box[3] / 2)
        a = centre(src) if src else (point(ends["sourcePoint"]) if "sourcePoint" in ends else None)
        b = centre(dst) if dst else (point(ends["targetPoint"]) if "targetPoint" in ends else None)
        if a is None or b is None:
            return None
        pts = [a, *waypoints, b]
        if src:
            pts[0] = clip(pts[0], pts[1], src, minx, miny)
        if dst:
            pts[-1] = clip(pts[-1], pts[-2], dst, minx, miny)
        return pts

    for cid, c in cells.items():
        if c.get("edge") != "1":
            continue
        s = style_map(c.get("style"))
        pts = path(c)
        if pts is None or all(abs(p[0] - pts[0][0]) < 1 and abs(p[1] - pts[0][1]) < 1 for p in pts):
            continue  # no end, or ends that meet (a cell's loop onto itself): nothing to draw, so no arrowhead pointing nowhere
        if s.get("shape") == "flexArrow":
            flex_arrow(d, pts[0], pts[-1], s)
            continue
        ink = color(s.get("strokeColor"), LINE)
        width = int(float(s.get("strokeWidth", 1))) + 1
        line = rounded(pts) if s.get("rounded") == "1" and len(pts) > 2 else pts
        if s.get("dashed") == "1":
            dashed_line(d, line, ink, width)
        else:
            d.line(line, fill=ink, width=width, joint="curve")
        if s.get("endArrow", "classic") != "none":
            arrow(d, pts[-2], pts[-1], ink)
        if s.get("startArrow", "none") != "none":
            arrow(d, pts[1], pts[0], ink)
        label = plain(c.get("value"))
        if label:
            mx, my = halfway(pts)
            f = font(int(float(s.get("fontSize", 11))), False)
            d.text((mx + 4, my - 14), label, font=f, fill=color(s.get("fontColor"), INK))
    return img


def clip(p, q, box, minx, miny):
    x, y, w, h = box[0] - minx, box[1] - miny, box[2], box[3]
    cx, cy = x + w / 2, y + h / 2
    dx, dy = q[0] - cx, q[1] - cy
    if dx == 0 and dy == 0:
        return p
    t = min((w / 2) / abs(dx) if dx else 1e9, (h / 2) / abs(dy) if dy else 1e9)
    return (cx + dx * t, cy + dy * t)


def halfway(pts):
    """The point half the routed length along a polyline, where draw.io centres an edge's label."""
    import math
    legs = [math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in itertools.pairwise(pts)]
    left = sum(legs) / 2
    for (a, b), leg in zip(itertools.pairwise(pts), legs):
        if leg and left <= leg:
            return a[0] + (b[0] - a[0]) * left / leg, a[1] + (b[1] - a[1]) * left / leg
        left -= leg
    return pts[-1]


def wrapped(d, text, f, width):
    """Each line of a `whiteSpace=wrap` label broken at spaces so it fits the width; a word longer than the width stays whole."""
    out = []
    for line in text.split("\n"):
        current = ""
        for word in line.split(" "):
            trial = f"{current} {word}" if current else word
            if current and d.textlength(trial, font=f) > width:
                out.append(current)
                current = word
            else:
                current = trial
        out.append(current)
    return "\n".join(out)


def rounded(pts, radius=10, steps=8):
    """A polyline whose every waypoint corner is replaced by a quadratic curve cutting it, as draw.io draws `rounded=1`."""
    import math
    out = [pts[0]]
    for a, p, b in zip(pts, pts[1:], pts[2:]):
        din, dout = math.hypot(p[0] - a[0], p[1] - a[1]), math.hypot(b[0] - p[0], b[1] - p[1])
        if din == 0 or dout == 0:
            out.append(p)
            continue
        r = min(radius, din / 2, dout / 2)
        start = (p[0] - (p[0] - a[0]) / din * r, p[1] - (p[1] - a[1]) / din * r)
        end = (p[0] + (b[0] - p[0]) / dout * r, p[1] + (b[1] - p[1]) / dout * r)
        for i in range(steps + 1):
            t = i / steps
            out.append(tuple((1 - t) ** 2 * s + 2 * (1 - t) * t * c + t ** 2 * e for s, c, e in zip(start, p, end)))
    out.append(pts[-1])
    return out


def flex_arrow(d, a, b, s):
    """A draw.io `shape=flexArrow` edge from a to b: a filled band `width` wide ending in a head `endWidth` wide and
    `endSize` x 2 long, outlined in the stroke colour."""
    import math
    length = math.hypot(b[0] - a[0], b[1] - a[1])
    if length == 0:
        return
    ux, uy = (b[0] - a[0]) / length, (b[1] - a[1]) / length
    nx, ny = -uy, ux
    body, head = float(s.get("width", 10)) / 2, float(s.get("endWidth", 20)) / 2
    head_len = min(length, float(s.get("endSize", 7)) * 2) if s.get("endArrow", "classic") != "none" else 0
    base = (b[0] - ux * head_len, b[1] - uy * head_len)
    side = lambda p, w: (p[0] + nx * w, p[1] + ny * w)
    outline = [side(a, body), side(base, body), side(base, head), b, side(base, -head), side(base, -body), side(a, -body)]
    if not head_len:
        outline = [side(a, body), side(b, body), side(b, -body), side(a, -body)]
    d.polygon(outline, fill=faded(color(s.get("fillColor"), LINE), s), outline=color(s.get("strokeColor"), LINE))


def arrow(d, a, b, ink):
    import math
    ang = math.atan2(b[1] - a[1], b[0] - a[0])
    pts = [b, (b[0] - 10 * math.cos(ang - .4), b[1] - 10 * math.sin(ang - .4)), (b[0] - 10 * math.cos(ang + .4), b[1] - 10 * math.sin(ang + .4))]
    d.polygon(pts, fill=ink)


def main():
    args = sys.argv[1:]
    name, page = "Page-1", None
    if "--name" in args:
        i = args.index("--name")
        name = args[i + 1]
        del args[i:i + 2]
    if "--page" in args:
        i = args.index("--page")
        page = args[i + 1]
        del args[i:i + 2]
    src, dst = args
    if src.lower().endswith(".png"):
        chunk = mxfile_chunk(Image.open(src))
        carried = re.search(r'name="([^"]*)"', unquote(chunk))
        if carried and "--name" not in sys.argv:
            name = html.unescape(carried.group(1))
        model = decode(chunk).strip()
    else:
        model = Path(src).read_text(encoding="utf-8").strip()
    root = ET.fromstring(model)
    if root.tag != "mxGraphModel":
        raise SystemExit(f"root must be mxGraphModel, got {root.tag}")
    ids = [c.get("id") for c in root.iter("mxCell")]
    dup = {i for i in ids if i is not None and ids.count(i) > 1}
    if dup:
        raise SystemExit(f"duplicate cell ids: {sorted(dup)}")
    img = render(root, page).convert("RGB")
    info = PngInfo()
    info.add_text("mxfile", encode(model, name))
    img.save(dst, "PNG", pnginfo=info)
    back = decode(mxfile_chunk(Image.open(dst)))
    assert back == model, "round-trip mismatch"
    print(f"ok {dst} {img.size[0]}x{img.size[1]} cells={len(ids)} page={page or DEFAULTS['renderer']['page']}")


if __name__ == "__main__":
    main()
