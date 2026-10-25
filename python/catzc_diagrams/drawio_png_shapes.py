# cspell:ignore arialbd maxx maxy miny mxgraph prel segoeui segoeuib textbbox textlength dout
"""How a .drawio.png is painted: the supersampled drawing surface, the shapes and shadows of a vertex, the routed polylines of an edge
and its arrowheads, and the fonts."""

import itertools

from drawio_png_base import BACKGROUND, HALF_DISC_SEGMENTS, LINE, SCALE, SHADOW, SHADOW_BLUR, SHADOW_OFFSET, color, faded
from PIL import Image, ImageDraw, ImageFilter, ImageFont


class Scaled:
    """An ImageDraw spoken to in page pixels while it paints at SCALE times the size: coordinates, widths, radii, spacing and
    fonts go up by SCALE on the way in, and measurements come back down, so the drawing code never sees the factor."""

    def __init__(self, draw):
        self.d = draw

    @staticmethod
    def xy(points):
        return [tuple(v * SCALE for v in p) if isinstance(p, (tuple, list)) else p * SCALE for p in points]

    @staticmethod
    def px(width):
        return max(1, round(width * SCALE)) if width else 0

    @staticmethod
    def big(f):
        return big_font(f)

    def rounded_rectangle(self, xy, radius=0, fill=None, outline=None, width=1):
        self.d.rounded_rectangle(self.xy(xy), radius=radius * SCALE, fill=fill, outline=outline, width=self.px(width))

    def rectangle(self, xy, fill=None, outline=None, width=1):
        self.d.rectangle(self.xy(xy), fill=fill, outline=outline, width=self.px(width))

    def ellipse(self, xy, fill=None, outline=None, width=1):
        self.d.ellipse(self.xy(xy), fill=fill, outline=outline, width=self.px(width))

    def polygon(self, xy, fill=None, outline=None, width=1):
        self.d.polygon(self.xy(xy), fill=fill, outline=outline, width=self.px(width))

    def arc(self, xy, start, end, fill=None, width=1):
        self.d.arc(self.xy(xy), start, end, fill=fill, width=self.px(width))

    def line(self, xy, fill=None, width=1, joint=None):
        self.d.line(self.xy(xy), fill=fill, width=self.px(width), joint=joint)

    def multiline_text(self, xy, text, font, fill=None, spacing=4, align="left"):
        self.d.multiline_text(self.xy([xy])[0], text, font=self.big(font), fill=fill, spacing=spacing * SCALE, align=align)

    text = multiline_text

    def multiline_textbbox(self, xy, text, font, spacing=4):
        return tuple(v / SCALE for v in self.d.multiline_textbbox(self.xy([xy])[0], text, font=self.big(font), spacing=spacing * SCALE))

    def textlength(self, text, font):
        return self.d.textlength(text, font=self.big(font)) / SCALE


def drop_shadow(img, box, painter, pad=8):
    """Paint the kit's shadow of one shape onto `img` (RGBA, at SCALE) just before the shape itself: `painter(draw, box, colour)`
    draws the shape's silhouette, which is offset, blurred and composited so it fades into the dark page."""
    x0, y0, x1, y1 = box
    w, h = (int(x1 - x0) + 2 * pad) * SCALE, (int(y1 - y0) + 2 * pad) * SCALE
    layer = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    painter(Scaled(ImageDraw.Draw(layer)), (pad, pad, pad + (x1 - x0), pad + (y1 - y0)), SHADOW)
    layer = layer.filter(ImageFilter.GaussianBlur(SHADOW_BLUR * SCALE))
    left, top = (int(x0) - pad + SHADOW_OFFSET[0]) * SCALE, (int(y0) - pad + SHADOW_OFFSET[1]) * SCALE
    crop = (max(0, -left), max(0, -top), min(w, img.width - left), min(h, img.height - top))
    if crop[2] <= crop[0] or crop[3] <= crop[1]:
        return
    img.alpha_composite(layer.crop(crop), (max(0, left), max(0, top)))


def paint_shape(d, s, box, w, h, fill, stroke, sw, dashed):
    """Draw one vertex's shape by its draw.io style: the glyph shapes of STYLE.md, in the given fill and stroke."""
    import math

    x0, y0, x1, y1 = box
    if dashed and not any(k in s for k in ("ellipse", "rhombus")) and s.get("shape") != "hexagon":
        d.rounded_rectangle([x0, y0, x1, y1], radius=8 if s.get("rounded") == "1" else 0, fill=fill)
        if stroke:
            dashed_line(d, [(x0, y0), (x1, y0), (x1, y1), (x0, y1), (x0, y0)], stroke, max(1, sw))
    elif s.get("shape") == "hexagon":
        pts = [(x0 + w * .25, y0), (x1 - w * .25, y0), (x1, (y0 + y1) / 2), (x1 - w * .25, y1), (x0 + w * .25, y1), (x0, (y0 + y1) / 2)]
        d.polygon(pts, fill=fill, outline=stroke, width=sw)
    elif s.get("shape") == "delay":  # a cause: a flat left side and a semicircle on the right, the half-disc of the action lens
        ry = h / 2
        rx = min(ry, w)
        cx, cy = x1 - rx, (y0 + y1) / 2
        arc = [
            (cx + rx * math.sin(math.pi * i / HALF_DISC_SEGMENTS), cy - ry * math.cos(math.pi * i / HALF_DISC_SEGMENTS))
            for i in range(HALF_DISC_SEGMENTS + 1)
        ]
        d.polygon([(x0, y0), *arc, (x0, y1)], fill=fill, outline=stroke, width=sw)
    elif s.get("shape") == "mxgraph.basic.arc":  # a ring: the stroke of an arc of the box's ellipse, angles as turns clockwise from 3 o'clock
        if stroke:
            d.arc([x0, y0, x1, y1], float(s.get("startAngle", 0)) * 360, float(s.get("endAngle", 1)) * 360, fill=stroke, width=max(1, sw))
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
    elif s.get("shape") == "crossbar":  # a span bar: a line with an end tick on each side; rotated 90, it stands beside bands
        ink = stroke or LINE
        if s.get("rotation") in ("90", "-90", "270"):
            xm = (x0 + x1) / 2
            d.line([(xm, y0), (xm, y1)], fill=ink, width=max(1, sw))
            d.line([(x0, y0), (x1, y0)], fill=ink, width=max(1, sw))
            d.line([(x0, y1), (x1, y1)], fill=ink, width=max(1, sw))
        else:
            ym = (y0 + y1) / 2
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


def painted_box(s, box):
    """The part of a cell's box that paint covers, as (x, y, w, h): an arc covers only its stroke's span of the box's ellipse (a ring's
    box is the whole ellipse, its left half unpainted), every other shape its whole box."""
    import math

    x, y, w, h = box
    if s.get("shape") != "mxgraph.basic.arc":
        return box
    start = float(s.get("startAngle", 0))
    span = (float(s.get("endAngle", 1)) - start) % 1 or 1
    points = [
        (x + w / 2 + w / 2 * math.cos(2 * math.pi * (start + span * i / 90)), y + h / 2 + h / 2 * math.sin(2 * math.pi * (start + span * i / 90)))
        for i in range(91)
    ]
    xs, ys = [p[0] for p in points], [p[1] for p in points]
    return min(xs), min(ys), max(xs) - min(xs), max(ys) - min(ys)


def dashed_line(d, pts, fill, width, dash: float = 6, gap: float = 4):
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


FONTS = {}


def font(size, bold):
    names = ["arialbd.ttf", "segoeuib.ttf"] if bold else ["arial.ttf", "segoeui.ttf"]
    key = (size, bold)
    if key not in FONTS:
        FONTS[key] = next((f for f in (truetype(n, size) for n in names) if f), None) or ImageFont.load_default(size)
    return FONTS[key]


def truetype(name, size):
    try:
        return ImageFont.truetype(name, size)
    except OSError:
        return None


def big_font(f):
    """The same face at SCALE times the size, for painting on the supersampled page."""
    key = ("big", f.getname(), f.size)
    if key not in FONTS:
        FONTS[key] = f.font_variant(size=f.size * SCALE)
    return FONTS[key]


def clip(p, q, box, minx, miny, shape="box"):
    """Where the line from the box's centre towards q leaves the shape: the box's edge, a diamond's edge or an ellipse's rim."""
    x, y, w, h = box[0] - minx, box[1] - miny, box[2], box[3]
    cx, cy = x + w / 2, y + h / 2
    dx, dy = q[0] - cx, q[1] - cy
    if dx == 0 and dy == 0:
        return p
    rx, ry = w / 2, h / 2
    if shape == "rhombus" and rx and ry:
        t = 1 / (abs(dx) / rx + abs(dy) / ry)
    elif shape == "ellipse" and rx and ry:
        t = 1 / ((dx / rx) ** 2 + (dy / ry) ** 2) ** 0.5
    else:
        t = min(rx / abs(dx) if dx else 1e9, ry / abs(dy) if dy else 1e9)
    return (cx + dx * t, cy + dy * t)


def label_background(d, s, x, y, w, h):
    """The box an edge's word sits on when its style names a labelBackgroundColor, as draw.io paints one: the colour, 2 px around the
    text, so the word reads over whatever the line crosses."""
    if s.get("labelBackgroundColor") not in (None, "", "none"):
        d.rectangle([x - 2, y - 2, x + w + 2, y + h + 2], fill=color(s.get("labelBackgroundColor"), BACKGROUND))


def along(pts, fraction):
    """The point at a fraction of the routed length along a polyline."""
    import math
    legs = [math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in itertools.pairwise(pts)]
    left = sum(legs) * fraction
    for (a, b), leg in zip(itertools.pairwise(pts), legs):
        if leg and left <= leg:
            return a[0] + (b[0] - a[0]) * left / leg, a[1] + (b[1] - a[1]) * left / leg
        left -= leg
    return pts[-1]


def halfway(pts):
    """The point half the routed length along a polyline, where draw.io centres an edge's label."""
    return along(pts, 0.5)


def nearest_leg(pts, x, y):
    """The polyline's leg nearest a point, for the normal a label is offset along."""
    import math

    def distance(a, b):
        dx, dy = b[0] - a[0], b[1] - a[1]
        t = 0.0 if dx == dy == 0 else max(0.0, min(1.0, ((x - a[0]) * dx + (y - a[1]) * dy) / (dx * dx + dy * dy)))
        return math.hypot(a[0] + dx * t - x, a[1] + dy * t - y)

    return min(itertools.pairwise(pts), key=lambda leg: distance(*leg))


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


def arrow(d, a, b, ink, kind="block"):
    import math
    if kind == "oval":
        d.ellipse([b[0] - 4, b[1] - 4, b[0] + 4, b[1] + 4], fill=ink)
        return
    ang = math.atan2(b[1] - a[1], b[0] - a[0])
    pts = [b, (b[0] - 10 * math.cos(ang - .4), b[1] - 10 * math.sin(ang - .4)), (b[0] - 10 * math.cos(ang + .4), b[1] - 10 * math.sin(ang + .4))]
    if kind == "open":
        d.line([pts[1], b, pts[2]], fill=ink, width=2, joint="curve")
        return
    d.polygon(pts, fill=ink)

