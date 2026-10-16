# ---
# catzc:
#   immutable:
#     repo_status: clean
#     path: ".claude/drawio/embed_images.py"
#     folder: drawio
#     name: embed-images
#     filetype: py
#     kind: drawio-kit
#     language: python
#     track: ".claude"
#     tracktype: vendor-settings
#     vendor: claude
#     module: ".claude"
#     moduletype: settings
# ---

"""Embed PNG files into a draw.io model's image cells, as data URIs.

usage: uv run -q --with pillow python embed_images.py <model.xml> <cell-id>=<file.png> [<cell-id>=<file.png> ...]

Each named cell must already exist and carry `shape=image` in its style. Its `image=` value is replaced with
`data:image/png,<base64>` (draw.io's in-style form: a comma, with no `;base64`, because `;` separates style keys). The PNG
then travels inside the diagram, and draw.io shows it with no side file. The model is rewritten in place; rebuild the
`.drawio.png` with drawio_png.py afterwards.
"""
import base64
import re
import sys
from pathlib import Path


def embed(model, cell_id, png_path):
    data = base64.b64encode(Path(png_path).read_bytes()).decode()
    pattern = re.compile(r'(<mxCell\b[^>]*\bid="' + re.escape(cell_id) + r'"[^>]*\bstyle=")([^"]*)(")')
    match = pattern.search(model)
    if not match:
        raise SystemExit(f"no cell with id {cell_id!r}")
    style = match.group(2)
    if "shape=image" not in style:
        raise SystemExit(f"cell {cell_id!r} is not an image cell")
    parts = [p for p in style.split(";") if p and not p.startswith("image=")]
    parts.append(f"image=data:image/png,{data}")
    return model[:match.start(2)] + ";".join(parts) + ";" + model[match.end(2):]


def main():
    path, pairs = sys.argv[1], sys.argv[2:]
    model = Path(path).read_text(encoding="utf-8")
    for pair in pairs:
        cell_id, png = pair.split("=", 1)
        model = embed(model, cell_id, png)
    Path(path).write_text(model, encoding="utf-8")
    print(f"ok {path} embedded={len(pairs)}")


if __name__ == "__main__":
    main()
