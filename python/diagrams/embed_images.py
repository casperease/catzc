"""Embed PNG and SVG files into a draw.io model's image cells, as data URIs.

usage: uv run -q --project python python -m catzc.diagrams.embed_images <model.xml> <cell-id>=<file.png|file.svg> [...] [--theme <name>]

Each named cell must already exist and carry `shape=image` in its style. Its `image=` value is replaced with `data:image/png,<base64>`
or `data:image/svg+xml,<base64>` (draw.io's in-style form: a comma, with no `;base64`, because `;` separates style keys). An SVG's
`@<token>` colours, such as the flow glyphs' `@ink`, are written as the theme's hex first, so the one SVG renders in dark and in light.
The image then travels inside the diagram, and draw.io shows it with no side file. The model is rewritten in place; rebuild the
`.drawio.png` with drawio_png.py afterwards.
"""

import base64
import re
import sys
from pathlib import Path

from .drawio_png_base import tokens


def themed_svg(text, theme=None):
    """An SVG's text with every `@<token>` colour written as the theme's hex; a token the theme lacks fails, naming it."""
    known = tokens(theme)

    def colour(match):
        name = match.group(1)
        if name not in known:
            raise SystemExit(f"svg colour @{name} is not a token of theme {theme or 'default'}: {', '.join(sorted(known))}")
        return known[name]

    return re.sub(r"@([a-z][a-z0-9-]*)", colour, text)


def data_uri(image_path, theme=None):
    """The in-style data URI of a PNG, or of an SVG with its tokens resolved for the theme."""
    path = Path(image_path)
    if path.suffix.lower() == ".svg":
        svg = themed_svg(path.read_text(encoding="utf-8"), theme)
        return "data:image/svg+xml," + base64.b64encode(svg.encode("utf-8")).decode()
    return "data:image/png," + base64.b64encode(path.read_bytes()).decode()


def embed(model, cell_id, image_path, theme=None):
    pattern = re.compile(r'(<mxCell\b[^>]*\bid="' + re.escape(cell_id) + r'"[^>]*\bstyle=")([^"]*)(")')
    match = pattern.search(model)
    if not match:
        raise SystemExit(f"no cell with id {cell_id!r}")
    style = match.group(2)
    if "shape=image" not in style:
        raise SystemExit(f"cell {cell_id!r} is not an image cell")
    parts = [p for p in style.split(";") if p and not p.startswith("image=")]
    parts.append(f"image={data_uri(image_path, theme)}")
    return model[: match.start(2)] + ";".join(parts) + ";" + model[match.end(2) :]


def main():
    args = sys.argv[1:]
    theme = None
    if "--theme" in args:
        at = args.index("--theme")
        theme = args[at + 1]
        del args[at : at + 2]
    path, pairs = args[0], args[1:]
    model = Path(path).read_text(encoding="utf-8")
    for pair in pairs:
        cell_id, image = pair.split("=", 1)
        model = embed(model, cell_id, image, theme)
    Path(path).write_text(model, encoding="utf-8")
    print(f"ok {path} embedded={len(pairs)}")


if __name__ == "__main__":
    main()
