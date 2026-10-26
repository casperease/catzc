# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The geometry of an edge: where it leaves and enters, how the router fans edges out, where a word or a pill stands on its line, and
where a drawn run crosses a cell. Every function here is pure geometry over rectangles and points."""

import html
import itertools
import math

from . import declaration_settings
from .declaration_cells import cell
from .declaration_constants import COMMITS, GHOST, LABEL_HEAD_CLEAR, LABEL_TAIL_CLEAR, WORD_GAP
from .drawio_png import DEFAULTS, font


def marker_xy(box, corner):
    """Where a marker sits on a box's corner: its 22 px disc centred on the corner."""
    x = box["x"] - 10 if corner.endswith("left") else box["x"] + box["w"] - 12
    y = box["y"] - 11 if corner.startswith("top") else box["y"] + box["h"] - 11
    return x, y


SIDE_ANCHOR = {"left": (0.0, None), "right": (1.0, None), "top": (None, 0.0), "bottom": (None, 1.0)}
LAST_ROUTES = []  # the routes of the latest put: each edge's polyline, its pill rectangle and its head's tip, for the audit and the keep-out check


def facing(a, b, orient="h"):
    """The sides two boxes face each other by: across the axis they overlap on, else the axis of their wider centre distance, so two
    cells standing level meet side to side and two standing one above the other meet top to bottom."""
    x_over = min(a["x"] + a["w"], b["x"] + b["w"]) - max(a["x"], b["x"])
    y_over = min(a["y"] + a["h"], b["y"] + b["h"]) - max(a["y"], b["y"])
    dx = (b["x"] + b["w"] / 2) - (a["x"] + a["w"] / 2)
    dy = (b["y"] + b["h"] / 2) - (a["y"] + a["h"] / 2)
    if (
        x_over <= 0 and y_over <= 0 and declaration_settings.EDGE_ROUTE == "elbow"
    ):  # no straight line joins them: out of the side facing across, into the side facing along
        if orient == "v":  # out of the side facing along, into the side facing across
            return ("bottom" if dy >= 0 else "top"), ("left" if dx >= 0 else "right"), True
        return ("right" if dx >= 0 else "left"), ("top" if dy >= 0 else "bottom"), True
    vertical = x_over > 0 and (y_over <= 0 or abs(dy) >= abs(dx)) or (x_over <= 0 and y_over <= 0 and abs(dy) > abs(dx))
    if vertical:
        return (("bottom", "top") if dy >= 0 else ("top", "bottom")) + (False,)
    return (("right", "left") if dx >= 0 else ("left", "right")) + (False,)


def plan_aims(edges, box_of, plain_box, orient=None):
    """Where each edge leaves and enters its boxes: the side the two face, and along that side an even spacing of every edge that shares
    it, in the order of the other ends so lines do not cross, one edge alone at the side's middle. `edges` are the indexes to route
    mapped to (from, to); returns index -> ((exitX, exitY), (entryX, entryY)) as box fractions."""
    ends = {}
    elbows = {}
    for i, (tail, head) in edges.items():
        a, b = box_of[tail], box_of[head]
        side_a, side_b, elbow = facing(a, b, (orient or {}).get(i, "h"))
        elbows[i] = elbow
        for cell_id, side, other in ((tail, side_a, b), (head, side_b, a)):
            along = (other["y"] + other["h"] / 2) if side in ("left", "right") else (other["x"] + other["w"] / 2)
            ends.setdefault((cell_id, side), []).append((along, i, cell_id == tail and "exit" or "entry"))
    aims = {}
    for (cell_id, side), items in ends.items():
        items.sort()
        for k, (_, i, which) in enumerate(items):
            fraction = (k + 1) / (len(items) + 1) if plain_box(cell_id) else 0.5
            fx, fy = SIDE_ANCHOR[side]
            point = (fx if fx is not None else fraction, fy if fy is not None else fraction)
            aims.setdefault(i, {})[which] = (round(point[0], 4), round(point[1], 4))
    for i, elbow in elbows.items():
        aims[i]["elbow"] = elbow
    return aims


def segment_hits_rect(p, q, rect):
    """Whether the segment p-q passes through the rectangle (x, y, w, h), by clipping it to the rectangle's slab (Liang-Barsky)."""
    x, y, w, h = rect
    t0, t1 = 0.0, 1.0
    dx, dy = q[0] - p[0], q[1] - p[1]
    for pk, qk in ((-dx, p[0] - x), (dx, x + w - p[0]), (-dy, p[1] - y), (dy, y + h - p[1])):
        if pk == 0:
            if qk < 0:
                return False
        else:
            t = qk / pk
            if pk < 0:
                t0 = max(t0, t)
            else:
                t1 = min(t1, t)
            if t0 > t1:
                return False
    return True


def keep_out_findings(routes, obstacles, holder):
    """The edges whose path enters the keep-out rectangle of a cell that is neither their tail nor their head (nor holds either): one
    E_KEEPOUT finding each, naming the edge and the cell. `obstacles` maps a cell id to its rectangle grown by the deadzone."""
    found = []
    for route in routes:
        ends = {route["from"], route["to"]}
        for cell_id, rect in obstacles.items():
            if cell_id in ends or any(end_chain_has(end, cell_id, holder) for end in ends):
                continue
            if any(segment_hits_rect(p, q, rect) for p, q in itertools.pairwise(route["points"])):
                found.append(f"E_KEEPOUT edge {route['from']} -> {route['to']} runs through the keep-out zone of {cell_id}")
    return found


def end_chain_has(end, cell_id, holder):
    """Whether a cell stands inside the end (a group the edge ends at holds the cells of its own frame)."""
    here = cell_id
    while here in holder:
        here = holder[here]
        if here == end:
            return True
    return False


def middle_leg(points):
    """The leg of a polyline that holds its halfway point, as its two ends."""
    legs = [(p, q, math.hypot(q[0] - p[0], q[1] - p[1])) for p, q in itertools.pairwise(points)]
    left = sum(leg[2] for leg in legs) / 2
    for p, q, length in legs:
        if left <= length:
            return p, q
        left -= length
    return legs[-1][0], legs[-1][1]


def cross_segment(p, q, a, b):
    """Where the leg p-q crosses the segment a-b, or None."""
    (x1, y1), (x2, y2), (x3, y3), (x4, y4) = p, q, a, b
    den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    if abs(den) < 1e-9:
        return None
    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
    u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den
    return (x1 + t * (x2 - x1), y1 + t * (y2 - y1)) if 0 <= t <= 1 and 0 <= u <= 1 else None


def cross_box(points, box):
    """The first point along a polyline where it crosses a box's border, or None."""
    x, y, w, h = box["x"], box["y"], box["w"], box["h"]
    sides = (((x, y), (x + w, y)), ((x + w, y), (x + w, y + h)), ((x + w, y + h), (x, y + h)), ((x, y + h), (x, y)))
    for p, q in itertools.pairwise(points):
        hits = [c for c in (cross_segment(p, q, a, b) for a, b in sides) if c]
        if hits:
            return min(hits, key=lambda c: math.hypot(c[0] - p[0], c[1] - p[1]))
    return None


def cross_circle(points, centre, r):
    """The first point along a polyline where it crosses a circle, or None."""
    cx, cy = centre
    for p, q in itertools.pairwise(points):
        dx, dy = q[0] - p[0], q[1] - p[1]
        fx, fy = p[0] - cx, p[1] - cy
        a, b, c = dx * dx + dy * dy, 2 * (fx * dx + fy * dy), fx * fx + fy * fy - r * r
        if a < 1e-9:
            continue
        disc = b * b - 4 * a * c
        if disc < 0:
            continue
        for t in sorted(((-b - math.sqrt(disc)) / (2 * a), (-b + math.sqrt(disc)) / (2 * a))):
            if 0 <= t <= 1:
                return (p[0] + t * dx, p[1] + t * dy)
    return None


TRANSITION = (
    "rounded=1;arcSize=50;html=1;fillColor=@band;strokeColor=@line;strokeWidth=1.5;fontColor=@ink;fontStyle=1;fontSize=10;spacing=0;"
)
WORD_MARGIN = int(DEFAULTS["renderer"]["word-margin"])  # the inner margin a transition bubble keeps around its word, every side


def transition(edge, word, at):
    """The word of a line as a bubble at the point where the line crosses into a new state: a round-cornered box hugging the word with
    the inner margin on every side and nothing more, so no letter is cut and no height goes to anything but text; the line itself
    goes on without its word. Returns the bubble cell."""
    edge["value"], edge["label_at"] = "", None
    width, height = round(6.2 * len(word) + 2 * WORD_MARGIN), 12 + 2 * WORD_MARGIN  # bold 10 px text, about 6.2 px a character
    return cell(
        f"{edge['id']}-word",
        f"<b>{html.escape(word, quote=False)}</b>",
        TRANSITION,
        round(at[0] - width / 2),
        round(at[1] - height / 2),
        width,
        height,
    )


def run_length(run):
    return sum(math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in itertools.pairwise(run))


def point_at(run, d):
    """The point d px along a polyline from its start, with the unit direction of the leg it stands on."""
    for p, q in itertools.pairwise(run):
        n = math.hypot(q[0] - p[0], q[1] - p[1])
        if n and d <= n:
            return (p[0] + (q[0] - p[0]) * d / n, p[1] + (q[1] - p[1]) * d / n), ((q[0] - p[0]) / n, (q[1] - p[1]) / n)
        d -= n
    p, q = run[-2], run[-1]
    n = math.hypot(q[0] - p[0], q[1] - p[1]) or 1
    return q, ((q[0] - p[0]) / n, (q[1] - p[1]) / n)


def arc_to(run, point):
    """How far along a polyline the point on it stands."""
    best, before = None, 0.0
    for p, q in itertools.pairwise(run):
        n = math.hypot(q[0] - p[0], q[1] - p[1])
        t = 0 if not n else max(0.0, min(1.0, ((point[0] - p[0]) * (q[0] - p[0]) + (point[1] - p[1]) * (q[1] - p[1])) / (n * n)))
        foot = (p[0] + (q[0] - p[0]) * t, p[1] + (q[1] - p[1]) * t)
        gap = math.hypot(point[0] - foot[0], point[1] - foot[1])
        if best is None or gap < best[0]:
            best = (gap, before + t * n)
        before += n
    assert best is not None, "a path of at least two points has a nearest segment"
    return best[1]


def overlaps(a, b, margin=2):
    return a[0] < b[0] + b[2] + margin and b[0] < a[0] + a[2] + margin and a[1] < b[1] + b[3] + margin and b[1] < a[1] + a[3] + margin


def label_spot(run, word, deadzone=0, crossing=None, avoid=()):
    """Where the pill of a word stands on the drawn run of a line (from the source box's border to the target box's): at the line's first
    band or ring crossing when it crosses one, else at its middle (then a third, two thirds, a quarter and three quarters along when a pill or cell stands there), and only where the line keeps LABEL_TAIL_CLEAR px clear of the pill
    towards its tail and LABEL_HEAD_CLEAR px towards its head, so the arrowhead is never covered. A line too short to hold it gets the
    same pill beside the line, WORD_GAP px off it at the middle (right of a steep line, above a flatter one, else the other side), where
    it overlaps none of the `avoid` rectangles (x, y, w, h); None only when no place is free."""
    width, height = 6.2 * len(word) + 2 * WORD_MARGIN, 12 + 2 * WORD_MARGIN
    length = run_length(run) - 2 * deadzone  # the line the model draws: the deadzone stops it short of both boxes
    legs = [math.hypot(q[0] - p[0], q[1] - p[1]) for p, q in itertools.pairwise(run)]
    longest = (
        [sum(legs[: legs.index(max(legs))]) + max(legs) / 2 - deadzone] if len(legs) > 1 else []
    )  # a bent run: the middle of its longer leg
    wanted = (
        longest
        + ([arc_to(run, crossing) - deadzone] if crossing and not longest else [])
        + [length * f for f in (0.5, 1 / 3, 2 / 3, 0.25, 0.75)]
    )
    for t in wanted:
        if 0 < t < length:
            spot, (ux, uy) = point_at(run, t + deadzone)
            half = min(width / 2 / abs(ux) if ux else math.inf, height / 2 / abs(uy) if uy else math.inf)  # the pill's reach along the line
            if t - half >= LABEL_TAIL_CLEAR and length - t - half >= LABEL_HEAD_CLEAR:
                rect = (spot[0] - width / 2, spot[1] - height / 2, width, height)
                if not any(overlaps(rect, box) for box in avoid):  # a pill never stands on a cell or on another pill
                    return spot
    spot, (ux, uy) = point_at(run, max(length, 0) / 2 + deadzone if length > 0 else run_length(run) / 2)
    nx, ny = -uy, ux  # the normal of the line
    reach = min(width / 2 / abs(nx) if nx else math.inf, height / 2 / abs(ny) if ny else math.inf) + WORD_GAP
    sides = sorted((1, -1), key=lambda k: -(k * nx) if abs(uy) > abs(ux) else k * ny)  # right of a steep line, above a flatter one
    for side in sides:
        centre = (spot[0] + side * nx * reach, spot[1] + side * ny * reach)
        if not any(overlaps((centre[0] - width / 2, centre[1] - height / 2, width, height), box) for box in avoid):
            return centre
    return None


def drawn_run(points, source, target):
    """A line's centre-to-centre polyline cut to the border of the source box and of the target box."""
    start = cross_box(points, source) or points[0]
    end = cross_box(points[::-1], target) or points[-1]
    return [start, *points[1:-1], end]


LABEL_INNER = int(DEFAULTS["renderer"]["label-inner-margin"])  # the margin between a diamond's text and its invisible text rect
LABEL_OUTER = int(DEFAULTS["renderer"]["label-outer-margin"])  # the margin between that rect's corner and the diamond's border
LABEL_RECT = (
    "text;html=1;whiteSpace=wrap;align=center;verticalAlign=middle;fontSize=12;fontColor=@ink;"  # the invisible rect: no fill, no line
)
LABEL_LINE_GAP = 3  # px between two printed lines, the painter's line spacing
LABEL_WRAP_PAD = 4  # px draw.io and the painter pad a wrapped label across its width


def diamond_fit(label, box=None):
    """How a diamond holds its label: the label is never printed on the border but in an invisible text rect inside it, the text with
    LABEL_INNER around it on every side, and the diamond keeps LABEL_OUTER between the rect's corner and its border, square to the border.
    Returns the wrapped `lines`, the text rect's `rect` (w, h) and the `size` (w, h) of the smallest diamond of the rect's own aspect
    that holds it. Without a box the wrap of the smallest diamond wins; given a box (a hand-moved diamond), the wrap that overflows it
    least wins, and its rect is still centred in the box."""
    face = font(12, True)
    ascent, descent = face.getmetrics()
    lines_in = [line.split(" ") for line in label.split("\n")]  # a newline in the label is a break the wrap keeps
    narrowest = max(face.getlength(word) for words in lines_in for word in words)
    widest = max(face.getlength(" ".join(words)) for words in lines_in)
    fits, seen, limit = [], set(), narrowest
    while True:
        lines = []
        for words in lines_in:
            current = ""
            for word in words:
                trial = f"{current} {word}" if current else word
                if current and face.getlength(trial) > limit:
                    lines.append(current)
                    current = word
                else:
                    current = trial
            lines.append(current)
        if tuple(lines) not in seen:
            seen.add(tuple(lines))
            w = math.ceil(max(face.getlength(line) for line in lines)) + LABEL_WRAP_PAD + 2 * LABEL_INNER
            h = len(lines) * (ascent + descent) + (len(lines) - 1) * LABEL_LINE_GAP + 2 * LABEL_INNER
            scale = 2 + 2 * LABEL_OUTER * math.hypot(w, h) / (w * h)  # the corner (w/2, h/2) sits LABEL_OUTER inside the border
            fits.append({"lines": lines, "rect": (w, h), "size": (math.ceil(scale * w), math.ceil(scale * h))})
        if limit >= widest:
            break
        limit += 4
    if box is None:
        return min(fits, key=lambda f: f["size"][0] * f["size"][1])
    return min(fits, key=lambda f: max(f["size"][0] / box[0], f["size"][1] / box[1]))


def edge_middle(a, b, via):
    """The point halfway along an edge's path, from box a's centre through its waypoints to box b's centre."""
    points = [(a["x"] + a["w"] / 2, a["y"] + a["h"] / 2), *map(tuple, via), (b["x"] + b["w"] / 2, b["y"] + b["h"] / 2)]
    legs = [((p, q), math.dist(p, q)) for p, q in itertools.pairwise(points)]
    left = sum(length for _, length in legs) / 2
    for (p, q), length in legs:
        if left <= length and length:
            return p[0] + (q[0] - p[0]) * left / length, p[1] + (q[1] - p[1]) * left / length
        left -= length
    return points[-1]


def auto_corner(box, sources):
    """The top corner away from the edges that arrive at a glyph: top-left unless they come in from the left."""
    from_left = sources and sum(s["x"] + s["w"] / 2 for s in sources) / len(sources) < box["x"]
    return "top-right" if from_left else "top-left"


def commit_style(base, state, ghost):
    """A commit's style in its palette state: the library commit's shape with the state's fill, stroke and ink, faded when a ghost."""
    fill, stroke, ink = COMMITS[state]
    style = ";".join(p for p in base.split(";") if p and not p.startswith(("fillColor=", "strokeColor=", "fontColor="))) + ";"
    return style + f"fillColor={fill};strokeColor={stroke};fontColor={ink};" + (GHOST if ghost else "")
