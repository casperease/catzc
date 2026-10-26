# cspell:ignore LANCZOS compressobj maxx maxy miny mxfile pnginfo prel textbbox textlength dout mxgraph
"""Build a .drawio.png from an mxGraphModel XML file, or re-render one from the model it already carries.

usage: uv run --project python python -m catzc.diagrams.drawio_png <model.xml | in.drawio.png> <out.drawio.png> [--name "Page-1"] [--page dark|model]

`--page` overrides the `renderer.page` default of drawio.yml beside this script for one run.

The PNG carries the diagram as a draw.io `mxfile` tEXt chunk (compressed the way draw.io writes it), so draw.io opens
and re-renders it. The raster is a Pillow preview (boxes, text, straight edges): the headless draw.io CLI cannot render
in this environment. A `.drawio.png` source is read through that chunk (its page name kept), so `in` and `out` may be
the same file: the raster is redrawn from the embedded model and the two stay honest to each other. The script
re-decodes the chunk and asserts the model round-trips.
"""

import base64
import html
import itertools
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.parse import unquote

from PIL import Image, ImageDraw
from PIL.PngImagePlugin import PngInfo

from .drawio_png_base import (
    BACKGROUND,
    DEFAULTS,
    EDGE_MIN_LINE,
    INK,
    LINE,
    SCALE,
    THEMES,
    color,
    decode,
    encode,
    faded,
    html_color,
    mxfile_chunk,
    paint,  # noqa: F401  (the entry still names paint for the declaration modules)
    plain,
    style_map,
    tokens,
    unpainted,
)
from .drawio_png_shapes import (
    Scaled,
    along,
    arrow,
    clip,
    dashed_line,
    drop_shadow,
    flex_arrow,
    font,
    halfway,
    label_background,
    nearest_leg,
    paint_shape,
    painted_box,
    rounded,
    wrapped,
)


def paint_svg(d, svg, x0, y0, x1, y1):
    """An embedded SVG of the kit's own subset, circles and lines in hex colours (the flow glyphs), painted into its box; the raster
    draws no other SVG, so an element outside the subset is refused naming it."""
    tree = ET.fromstring(re.sub(r"<!--.*?-->", "", svg, flags=re.S))
    _, _, vw, vh = (float(v) for v in tree.get("viewBox").split())
    sx, sy = (x1 - x0) / vw, (y1 - y0) / vh
    at = lambda x, y: (x0 + float(x) * sx, y0 + float(y) * sy)
    for element in tree:
        tag = element.tag.split("}")[-1]
        a = element.attrib
        width = float(a.get("stroke-width", 1)) * sx
        if tag == "circle":
            (cx, cy), r = at(a["cx"], a["cy"]), float(a["r"]) * sx
            fill = None if a.get("fill", "none") == "none" else a["fill"]
            outline = a.get("stroke")
            d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=fill, outline=outline, width=width if outline else 0)
        elif tag == "line":
            d.line([at(a["x1"], a["y1"]), at(a["x2"], a["y2"])], fill=a["stroke"], width=width)
        else:
            raise SystemExit(f"embedded svg element <{tag}> is outside the raster's subset of circle and line")


def render(root, page=None):
    page = page or DEFAULTS["renderer"]["page"]
    if page not in ("dark", "model"):
        raise SystemExit(f"page must be dark or model, got {page}")
    cells = {c.get("id"): c for c in root.iter("mxCell")}
    unpainted(root, cells)

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
    extent = [painted_box(style_map(cells[cid].get("style")), box) for cid, box in geo.items()]
    minx = min(v[0] for v in extent) - 20
    miny = min(v[1] for v in extent) - 20
    maxx = max(v[0] + v[2] for v in extent) + 20
    maxy = max(v[1] + v[3] for v in extent) + 20
    # page dark (the drawio.yml default): every rendered output sits on the dark page, painted first behind everything, so a
    # dark- or light-mode viewer shows the same page, and a model's own background wins only when it is a real colour, not
    # white or the retired light page. page model: the model's own background as draw.io would paint it, white included.
    model_bg = color(root.get("background"), BACKGROUND)
    if page == "model":
        bg = model_bg
    else:
        # A model on another theme's page is drawn on the default page; a declared model renders with page="model", in its theme.
        bg = BACKGROUND if model_bg.lower() in {"#fff", *(tokens(t)["page"].lower() for t in THEMES[1:])} else model_bg
    page_size = (int(maxx - minx), int(maxy - miny))
    # RGBA so each shadow composites onto what is under it; SCALE times the page, downsampled once at the end.
    img = Image.new("RGBA", (page_size[0] * SCALE, page_size[1] * SCALE), bg)
    d = Scaled(ImageDraw.Draw(img))
    off = lambda x, y: (x - minx, y - miny)

    def vertex(cid, c):
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
            sw = max(0, sw_raw)  # a hairline (< 1 px, the private-helper rim) still draws, thin, on the scaled page
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
            box = (max(1, int(x1 - x0)) * SCALE, max(1, int(y1 - y0)) * SCALE)
            img.paste(pic.resize(box, Image.Resampling.LANCZOS), (int(x0) * SCALE, int(y0) * SCALE))
        elif s.get("shape") == "image" and uri.startswith("data:image/svg+xml,"):
            paint_svg(d, base64.b64decode(uri.split(",", 1)[1]).decode("utf-8"), x0, y0, x1, y1)
        text = "" if s.get("noLabel") == "1" else plain(c.get("value"))  # noLabel: the value is data, as draw.io shows it
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
            left = float(s["spacingLeft"]) - 2 if "spacingLeft" in s else 6  # a band's spacingLeft=8 keeps its 6; a title box's 5 puts it 3
            tx = x0 + left if align == "left" else (x1 - tw - 6 if align == "right" else (x0 + x1 - tw) / 2)
            ty = y0 + 6 + float(s.get("spacingTop", 0)) if top else (y0 + y1 - th) / 2  # a title box's -3 lifts its word to a band's 6
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
        s = style_map(c.get("style"))
        centre = lambda box: off(box[0] + box[2] / 2, box[1] + box[3] / 2)
        # An exit or entry point fixed in the style (exitX/exitY, entryX/entryY, fractions of the box) is where the edge leaves or
        # arrives, as draw.io reads them; without one the edge runs from the centre and is cut at the shape's outline.
        at = lambda box, kx, ky: off(box[0] + box[2] * float(s[kx]), box[1] + box[3] * float(s.get(ky, 0.5)))
        a = (at(src, "exitX", "exitY") if "exitX" in s else centre(src)) if src else (point(ends["sourcePoint"]) if "sourcePoint" in ends else None)
        b = (at(dst, "entryX", "entryY") if "entryX" in s else centre(dst)) if dst else (point(ends["targetPoint"]) if "targetPoint" in ends else None)
        if a is None or b is None:
            return None
        pts = [a, *waypoints, b]
        if src and "exitX" not in s:
            pts[0] = clip(pts[0], pts[1], src, minx, miny, outline(c.get("source")))
        if dst and "entryX" not in s:
            pts[-1] = clip(pts[-1], pts[-2], dst, minx, miny, outline(c.get("target")))
        # The deadzone, as draw.io reads source/targetPerimeterSpacing: the box grown outward by that many px, so the end stands the
        # same perpendicular distance from the side it meets whatever the line's angle (a diamond or ellipse keeps the gap along the line).
        # Both ends together never take more than the path's length less EDGE_MIN_LINE, so a short arrow keeps a visible line.
        moves = []
        for i, j, key, cid in ((0, 1, "sourcePerimeterSpacing", c.get("source")), (-1, -2, "targetPerimeterSpacing", c.get("target"))):
            box = geo.get(cid)
            gap = float(s.get(key, 0)) if box else 0.0
            dx, dy = pts[j][0] - pts[i][0], pts[j][1] - pts[i][1]
            length = (dx * dx + dy * dy) ** 0.5
            if box is None or not gap or length < 1e-9:
                continue
            ux, uy = dx / length, dy / length
            step = gap
            if outline(cid) == "box":
                left, top = off(box[0], box[1])
                near_side = min(  # the side the end sits on: its outward normal (nx, ny)
                    (abs(pts[i][0] - left), -1, 0),
                    (abs(pts[i][0] - (left + box[2])), 1, 0),
                    (abs(pts[i][1] - top), 0, -1),
                    (abs(pts[i][1] - (top + box[3])), 0, 1),
                )
                across = abs(ux * near_side[1] + uy * near_side[2])  # how much of a step goes straight out of that side
                step = gap / across if across > 1e-6 else gap
            moves.append([i, ux, uy, min(step, length / 2)])
        total = sum(m[3] for m in moves)
        path_length = sum(((q[0] - p[0]) ** 2 + (q[1] - p[1]) ** 2) ** 0.5 for p, q in itertools.pairwise(pts))
        room = max(0.0, path_length - EDGE_MIN_LINE)
        shrink = min(1.0, room / total) if total else 1.0
        for i, ux, uy, step in moves:
            pts[i] = (pts[i][0] + ux * step * shrink, pts[i][1] + uy * step * shrink)
        return pts

    def outline(cid):  # the shape an edge end is cut at: a diamond, an ellipse, or the box
        s = style_map(cells[cid].get("style")) if cid in cells else {}
        return "rhombus" if "rhombus" in s else ("ellipse" if "ellipse" in s else "box")

    def edge(c):
        s = style_map(c.get("style"))
        pts = path(c)
        if pts is None or all(abs(p[0] - pts[0][0]) < 1 and abs(p[1] - pts[0][1]) < 1 for p in pts):
            return  # no end, or ends that meet (a cell's loop onto itself): nothing to draw, so no arrowhead pointing nowhere
        if s.get("shape") == "flexArrow":
            flex_arrow(d, pts[0], pts[-1], s)
            return
        ink = color(s.get("strokeColor"), LINE)
        width = int(float(s.get("strokeWidth", 1))) + 1
        line = rounded(pts) if s.get("rounded") == "1" and len(pts) > 2 else pts
        if s.get("dashed") == "1":
            # A dashPattern is in stroke widths, as draw.io scales it; without one, the kit's dash.
            pattern = [float(n) * width for n in s["dashPattern"].split()] if s.get("dashPattern") else (6, 4)
            dashed_line(d, line, ink, width, *pattern[:2])
        else:
            d.line(line, fill=ink, width=width, joint="curve")
        if s.get("endArrow", "classic") != "none":
            arrow(d, pts[-2], pts[-1], ink, s.get("endArrow", "classic"))
        if s.get("startArrow", "none") != "none":
            arrow(d, pts[1], pts[0], ink, s.get("startArrow", "none"))
        label = plain(c.get("value"))
        if label:
            f = font(int(float(s.get("fontSize", 11))), False)
            g = c.find("mxGeometry")
            if g is not None and g.get("x") is not None:
                # Placed by its relative geometry, as draw.io reads it: x is the fraction along the edge (-1 the source, 1 the target)
                # and y the offset along the normal, positive to the right of travel, so below a rightward edge; centred on that point.
                mx, my = along(pts, (float(g.get("x")) + 1) / 2)
                p, q = nearest_leg(pts, mx, my)
                length = max(1e-9, ((q[0] - p[0]) ** 2 + (q[1] - p[1]) ** 2) ** 0.5)
                nx, ny = -(q[1] - p[1]) / length, (q[0] - p[0]) / length
                mx, my = mx + nx * float(g.get("y", 0)), my + ny * float(g.get("y", 0))
                tw, th = d.textlength(label, font=f), float(s.get("fontSize", 11))
                left = mx if s.get("align") == "left" else mx - tw / 2  # an align=left label extends rightwards from its point
                label_background(d, s, left, my - th / 2, tw, th)
                d.text((left, my - th / 2), label, font=f, fill=color(s.get("fontColor"), INK))
            else:
                # Centred on the line's halfway point and just above it, as draw.io lays an edge label out.
                mx, my = halfway(pts)
                tw, th = d.textlength(label, font=f), float(s.get("fontSize", 11))
                label_background(d, s, mx - tw / 2, my - 16, tw, th)
                d.text((mx - tw / 2, my - 16), label, font=f, fill=color(s.get("fontColor"), INK))

    def paint_cell(cid, c):
        if c.get("edge") == "1":
            edge(c)
        elif cid in geo:
            vertex(cid, c)

    # draw.io's z-order: a cell, then its children, each list in document order, edges and vertices alike.
    children: dict = {}
    for cid, c in cells.items():
        children.setdefault(c.get("parent"), []).append(cid)
    painted = set()

    def walk(pid):
        for cid in children.get(pid, []):
            if cid not in painted:
                painted.add(cid)
                paint_cell(cid, cells[cid])
                walk(cid)

    walk(None)
    for cid, c in cells.items():  # a cell whose parent the model lacks
        if cid not in painted:
            paint_cell(cid, c)
    return img.resize(page_size, Image.Resampling.LANCZOS)


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
