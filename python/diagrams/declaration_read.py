# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""What reading a drawn model back needs: the model embedded in a diagram's png, the signature of a style in the default theme, and
the shift span room gave a drawing area."""

from PIL import Image

from .declaration_constants import SHIFT_KEY, SIGNATURE_KEYS
from .declaration_source import slide_of
from .drawio_png import decode, mxfile_chunk, paint, style_map

# ---- get: the model becomes the declaration ------------------------------------------------------------------------


def signature(style):
    s = style_map(paint(style))  # the library's tokens in the default theme, the one a committed drawing is put in
    return tuple((k, s.get(k)) for k in SIGNATURE_KEYS if k in s)


def matches(sig, style):
    s = style_map(style)
    return all(s.get(k) == v for k, v in sig)


def model_of(folder):
    """The model embedded in the diagram's <name>.drawio.png."""
    return decode(mxfile_chunk(Image.open(slide_of(folder)))).strip()


def shift_of(title_style):
    """How far span room moved a drawing area down, from its title's style: 0 when it did not move."""
    return int(style_map(title_style or "").get(SHIFT_KEY, 0))
