"""The flow lens's word glyphs (DDR-VISUAL-FLOWGLYPHSAREWORDS): each glyph a word of three symbols from `O 0 - _ = .`, drawn in three
equal parts of its box, every stroke the theme token `@ink`, which the renderer resolves to the theme's colour when it embeds the SVG."""

from pathlib import Path

from . import stamp
from .declaration_vocabulary import DeclarationError
from .drawio_png_base import DEFAULTS
from .module_paths import REPO

ALPHABET = "O0-_=."
# The glyphs' row in the writer registry, whose head the one renderer stamps on each SVG written.
WRITER = "flow_glyphs.py"
# The committed SVGs live in the source tree: the module itself may run from its editable build copy.
ASSETS = Path(REPO) / "python" / "diagrams" / "assets" / "flow"

# The height of each line symbol as a share of its part; adjacent lines at different heights join with a riser.
LINE_HEIGHTS = {"-": 0.5, "_": 0.85}


def _number(value):
    """A coordinate as the shortest exact text, so the same word always gives the same bytes."""
    return f"{value:.2f}".rstrip("0").rstrip(".")


def render(word, part=None, stroke=None, thin=None):
    """The SVG text of one word; a word not three symbols long, or a symbol outside the alphabet, is refused naming it."""
    if len(word) != 3:
        raise DeclarationError(f"flow glyph word '{word}' is not three symbols long")
    unknown = [symbol for symbol in word if symbol not in ALPHABET]
    if unknown:
        raise DeclarationError(f"flow glyph word '{word}' holds '{unknown[0]}', not one of: {' '.join(ALPHABET)}")
    lens = DEFAULTS["flow-lens"]
    part = float(part or lens["slot-size"])
    stroke = float(stroke or lens["stroke"])
    thin = float(thin or lens["thin-stroke"])
    n = _number
    shapes = []
    for index, symbol in enumerate(word):
        left = index * part
        centre = left + part / 2
        if symbol in "O0":
            shapes.append(f'<circle cx="{n(centre)}" cy="{n(part / 2)}" r="{n(part * 0.3)}" fill="none" stroke="@ink" stroke-width="{n(stroke)}"/>')
        if symbol in "0.":
            shapes.append(f'<circle cx="{n(centre)}" cy="{n(part / 2)}" r="{n(part * 0.1)}" fill="@ink"/>')
        if symbol in LINE_HEIGHTS:
            y = part * LINE_HEIGHTS[symbol]
            shapes.append(f'<line x1="{n(left)}" y1="{n(y)}" x2="{n(left + part)}" y2="{n(y)}" stroke="@ink" stroke-width="{n(stroke)}"/>')
            previous = word[index - 1] if index else ""
            if previous in LINE_HEIGHTS and LINE_HEIGHTS[previous] != LINE_HEIGHTS[symbol]:
                rise = part * LINE_HEIGHTS[previous]
                shapes.append(f'<line x1="{n(left)}" y1="{n(rise)}" x2="{n(left)}" y2="{n(y)}" stroke="@ink" stroke-width="{n(stroke)}"/>')
        if symbol == "=":
            for share in (0.4, 0.6):
                y = part * share
                shapes.append(f'<line x1="{n(left)}" y1="{n(y)}" x2="{n(left + part)}" y2="{n(y)}" stroke="@ink" stroke-width="{n(thin)}"/>')
    width, height = n(part * 3), n(part)
    body = "\n  ".join(shapes)
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">\n'
            f"  {body}\n</svg>\n")


def glyphs():
    """The closed flow-glyphs list of drawio.yml, each entry its id, word, meaning and hint."""
    return list(DEFAULTS["flow-glyphs"])


def write_all(folder=None):
    """Write every flow glyph's SVG into the assets folder bare, then stamp them all in one run of the head renderer, so a glyph
    whose word is unchanged ends byte for byte as it was; returns the paths written."""
    folder = Path(folder or ASSETS)
    folder.mkdir(parents=True, exist_ok=True)
    written = []
    for entry in glyphs():
        path = folder / f"{entry['id']}.svg"
        path.write_text(render(entry["word"]), encoding="utf-8", newline="\n")
        written.append(path)
    stamp.stamp(written, WRITER)
    return written


if __name__ == "__main__":
    for written in write_all():
        print(f"glyph {written}")
