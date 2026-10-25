# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The numbers, keys, styles and vocabularies of a declaration that stay as they are: the keys a source may hold, the action and proof
lens numbers, the page and the grid, the commit states and the cell styles."""

from pathlib import Path

import yaml
from drawio_png import DEFAULTS

# libyaml's safe loader parses when it is present; the pure-Python one is several times slower. Every kit read goes through it.
LOADER = getattr(yaml, "CSafeLoader", yaml.SafeLoader)


def load_yaml(text):
    """One YAML document, safely loaded with the kit's one loader."""
    return yaml.load(text, Loader=LOADER)


KIT = Path(__file__).resolve().parent
SLIDE = ".drawio.png"
SOURCE = ".drawio.yml"  # the diagram's one source: its description, its content and the layout of the cells off the grid
FLOWS = ("left-to-right", "top-to-bottom")
KINDS = tuple(DEFAULTS["kinds"])
# The action lens: one action, its cause on the left rim and its effects in zones between rings, in accosted words. Its glyph kinds, its
# where chips, its layout numbers and the cause's sizes are declared once in drawio.yml under action-lens; the lens itself is one of
# lenses: there. The kit validates a declaration's shape only; Test-Diagrams proves its calls against the contracts and the proof file.
ACTION_LENS = "action"
ACTION_KEYS = ("cause", "action", "effects")  # the content keys only the action lens draws
EFFECT_KEYS = ("id", "zone", "where", "show", "says", "proves", "call", "after")  # an effect's keys, in the order the yml prints them
SHOWS = ("words", "call", "both")  # what an effect's note prints: its words, its observation or call, or both
# The lens's operators, the word every edge carries: cats from the cause (an actor runs the command), executes from the action (the
# statement is handed to the state machine), then affects into an execution and effects into a state change; each has its check.
OPERATORS = {
    "cats": "an actor runs it",
    "executes": "to the state machine",
    "affects": "triggers an execution",
    "effects": "changes state",
}
WHERES = tuple(DEFAULTS["wheres"])
ACTION = DEFAULTS["action-lens"]
ACTION_KINDS = tuple(str(ACTION["glyphs"]).replace(",", " ").split())
ACTION_LANE = int(ACTION["lane-height"])  # the invisible centre lane's height: where the cause, the action and every effect note are drawn
ACTION_MARGIN = int(ACTION["ring-margin"])  # the margin above and below the lane where the rings crawl before the frame cuts them
ACTION_WIDTH = int(ACTION["action-width"])  # the widest action glyph; a longer call wraps inside it
ACTION_CLEARANCE = int(ACTION["clearance"])  # how far the action clears the cause's round, and the first ring the action's right edge
# The Proof: a box under an action's frame, as wide as it, that knows the action's normalized statement alone and prints the words each
# engine runs it as; the proof lens draws that box on its own. Its engines and their idioms, and whether an action diagram shows it,
# are declared once in drawio.yml.
PROOF_LENS = "proof"
PROOF_SHOWN = str(ACTION["proof"]).strip() == "shown"
PROOF_ENGINES = [tuple(pair.split()) for pair in str(ACTION["proof-engines"]).split(",")]  # (engine, idiom), idiom pascal or kebab
PROOF_ROW = 22  # one engine's words, one row
EDGE_DEADZONE = int(DEFAULTS["renderer"]["edge-deadzone"])  # how far an edge stops short of each box it joins, written into the model

WORD_GAP = int(DEFAULTS["renderer"]["word-gap"])  # how far a steep edge's word stands right of its line, written into the model

LABEL_LEGEND = {
    "pill": f"label: {DEFAULTS['renderer']['edge-label-legend-pill']}",
    "word": f"transition: {DEFAULTS['renderer']['edge-label-legend-word']}",
}  # the legend entry of each presentation
LABEL_TAIL_CLEAR = int(DEFAULTS["renderer"]["edge-label-tail-clear"])  # px of line a pill leaves between itself and the tail's end
LABEL_HEAD_CLEAR = int(DEFAULTS["renderer"]["edge-label-head-clear"])  # px of line a pill leaves between itself and the arrowhead's tip

DEFAULT_WHERE = str(ACTION["where"]).strip()  # the diagram's where unless content.where says otherwise
DEFAULT_SHOW = str(ACTION["show"]).strip()  # what a note prints unless the effect's show: says otherwise
# The cells put derives from the kit and the registries, never from the author: get skips them, and a change to them is stale.
DERIVED = ("sidebar-bg", "legend", "legend-proof", "lens-badge", "mapkey")
DERIVED_PREFIXES = ("lg-", "mk-", "minimap-", "lane-", "actor-")  # lane- is a lane's furniture, actor- the stick man: the kit's alone
ACTOR_LINE = "endArrow=none;html=1;strokeColor=@ink;strokeWidth=2;shadow=0;"  # one line of the stick man's body
CONTENT_KEYS = (
    "title",
    "kind",
    "flow",
    "relation",
    "thick",
    "theme",
    "cause",
    "action",
    "effects",
    "proof",
    "where",
    "bands",
    "spans",
    "templates",
    "rows",
    "lanes",
    "rules",
    "ladders",
    "groups",
    "glyphs",
    "edges",
    "markers",
    "chips",
    "notes",
    "legend",
    "minimaps",
)
# A note: a free text block drawn on the panel; `noteBlock=1` lets get tell it from every glyph.
NOTE = "text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;spacing=10;fontSize=11;fontColor=@ink;fillColor=@panel;strokeColor=@panel-rim;rounded=1;arcSize=4;noteBlock=1;"
NOTE_WIDTH = 380
ROW_PITCH, ROW_DROP = 92, 52
BYPASS_DIP = 12  # how far a bypass runs below and beside the dots it joins: halfway down to the drops
SHIFT_KEY = "drawingShift"  # the title's style key for how far span room moved the drawing area down, written only when it did
# The keys an author writes as shorthand: dump writes them back, never the cells they expand to.
SHORTHAND = ("templates", "rows", "lanes", "rules")
LANE_KEYS = ("band", "steps", "trunk", "commits", "glyphs", "marks")
# A ladder: a band whose glyphs climb left to right along their forward edges, spread over the band's width, each `rise` px above the one
# before and the first on the band's floor, every rung `w` by `h` when given; a hint for the grid, so the drawing carries it only as the
# places it gives (get keeps them, the source keeps the hint).
LADDER_KEYS = ("band", "rise", "w", "h")
RULE_KINDS = ("manual", "automated")  # a gate rule: a solid red line for a manual gate, a dashed line for an automated one
SPAN_ROW = DEFAULTS["span"]["row"]  # a span's default row: stacked above what it overlaps
LANE_SLOTS = ("left", "centre", "right")  # where a lane's commit stands in its row at a step
LANE_SLOT, LANE_SLOT_GAP = (
    DEFAULTS["lane"]["slot"],
    int(DEFAULTS["lane"]["slot-gap"]),
)  # the default slot, and the gap of a left and a right
LANE_HEIGHT, LANE_ROW = 150, 38  # a lane band's height, and how far a branch row sits above or below the trunk
TRUNK = "endArrow=block;html=1;strokeColor=@line;strokeWidth=3;shadow=0;"
TRUNK_LABEL = "text;html=1;align=right;verticalAlign=middle;fontSize=11;fontStyle=1;fontColor=@ink;"
MARK_TEXT = "text;html=1;whiteSpace=wrap;align=center;verticalAlign=bottom;fontSize=10;fontColor=@red-rim;"
RULE_STYLES = {
    "manual": "endArrow=none;html=1;strokeColor=@red-rim;strokeWidth=3;shadow=0;",
    "automated": "endArrow=none;html=1;strokeColor=@line;strokeWidth=2;dashed=1;shadow=0;",
}  # a template row: the step between its dots, and how far below a dot its drop sits
PAGE = {"x": 20, "width": 1260, "title_y": 14, "subtitle_y": 44, "span_y": 84, "band_y": 108, "min_height": 640}
GAP, PAD, LABEL_ROW, ROW_GAP, COL_GAP = 20, 20, 40, 36, 40
SIDEBAR_X, SIDEBAR_W = 1316, 240
SIDEBAR = (("minimap-1", 16, 150), ("minimap-2", 182, 180), ("minimap-3", 378, 150))
# The style keys that identify a glyph or edge kind: the shape and the two colours, with the marks that set a variant apart (a read edge's
# dots and open arrow, a junction's oval start).
SIGNATURE_KEYS = (
    "shape",
    "ellipse",
    "rhombus",
    "rounded",
    "curved",
    "arcSize",
    "fillColor",
    "strokeColor",
    "dashed",
    "dashPattern",
    "strokeWidth",
    "startArrow",
    "endArrow",
    "fontColor",
    "fontSize",
    "fontStyle",
    "align",
)
TEXT = "text;html=1;align=left;verticalAlign=middle;fontSize=11;fontColor=@quiet;"
KEY = "text;html=1;align=left;verticalAlign=middle;fontSize=10;fontStyle=1;fontColor=@band-label;"
# The locked commit palette from drawio.yml: state -> (fill, stroke, digit ink); the first state is a commit's default.
COMMITS = {state: tuple("#" + v for v in str(value).split()) for state, value in DEFAULTS["commits"].items()}
COMMIT_STATES = tuple(COMMITS)
COMMIT_SHAPES = ("dot", "box")  # a commit is a dot unless it is a state drawn as a box
# A commit drawn as a box: a named rounded box the palette colours; `commitShape=box` lets get tell it from a glyph of the same fill.
COMMIT_BOX = "rounded=1;whiteSpace=wrap;html=1;arcSize=12;fontStyle=1;fontSize=12;commitShape=box;"
COMMIT_BOX_SIZE = (134, 50)
GHOST = "strokeWidth=1.2;dashed=1;opacity=60;"
CORNERS = ("top-left", "top-right", "bottom-left", "bottom-right")
CHIP_CORNER = {"rule": "top-right", "count": "bottom-right"}  # where a chip sits unless it names a corner

TITLE = "text;html=1;align=left;verticalAlign=middle;fontSize=16;fontStyle=1;fontColor=@title;"
SUBTITLE = "text;html=1;whiteSpace=wrap;align=left;verticalAlign=top;fontSize=12;fontColor=@quiet;"  # wraps to a second line
BAND = "rounded=1;html=1;arcSize=3;fillColor=@band;strokeColor=@band-rim;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;fontSize=12;fontColor=@band-label;"
# A band's title: a borderless box of its own, filled as the band, inset clear of the band's rim and rounded corners, its word where the
# band's own label stood; painted over the edges that cross the band, so an edge passes under the word (layer `titles`).
BAND_TITLE = "html=1;whiteSpace=nowrap;fillColor=@band;strokeColor=none;shadow=0;verticalAlign=top;align=left;spacingLeft=5;spacingTop=-3;fontStyle=1;fontSize=12;fontColor=@band-label;"
BAND_TITLE_INSET, BAND_TITLE_HEIGHT = 3, 20  # px the title box stands in from its band's corner, and its height
LEGEND = "rounded=1;whiteSpace=wrap;html=1;arcSize=6;fillColor=@panel;strokeColor=@panel-rim;align=left;verticalAlign=top;spacing=8;fontSize=11;fontColor=@ink;"
SPAN_LABEL = "text;html=1;align=center;verticalAlign=middle;fontSize=11;fontStyle=1;fontColor=@band-label;"
ANCHOR = "text;html=1;strokeColor=none;fillColor=none;"
SIDEBAR_BG = "rounded=1;arcSize=2;html=1;fillColor=@sidebar;strokeColor=@sidebar-rim;shadow=0;"
MINIMAP = "shape=image;imageAspect=0;rounded=1;arcSize=4;whiteSpace=wrap;html=1;fillColor=@band;strokeColor=@map-border-lit;dashed=1;fontColor=@quiet;fontSize=11;"
BADGE = "rounded=0;whiteSpace=wrap;html=1;align=center;verticalAlign=middle;fontSize=12;fontStyle=1;fontColor=@mark-ink;fillColor=@mark;strokeColor=none;"

TOP_KEYS = ("description", "about", "content", "layout")
# Content the drawing cannot carry exactly: the kind is never drawn, a layout can place the bands against the flow, and the legend
# prints the relation without its parenthesis or not at all. get guesses each for a drawing without a source; a source keeps its own.
SOURCE_ONLY = ("kind", "flow", "relation", "thick")

ABOUT_KEYS = ("adrs", "lens", "zoom", "proves")  # the subject's ADR codes, its lens, its optional zoom level, an action diagram's proof file
# The subject's former lists: read and ignored, never written back, so a get or a save drops them (the minimaps' rework).
RETIRED_ABOUT_KEYS = ("tracks", "languages", "modules", "files")
