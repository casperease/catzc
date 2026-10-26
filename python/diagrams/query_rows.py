"""The query rows of a C3 or C4 slide (DDR-VISUAL-ZOOMISANAXIS): the cells a level's query answers for one point of the tree.

Build-Diagrams asks the query and writes the rows to a file whose address it names (`--rows <file>`); the renderer hands the address to its
workers through ROWS_VARIABLE, and the declaration expands a slide's rows into generated cells, as it expands `rows:`, so the source holds
only its inputs (`about.zoom`, `about.point`) and never the cells. The cells carry count chips of their edges, not the edges themselves. Without an address nothing is expanded: get, sync and the tests read the
declaration alone.

The file: {"rows": [{"point": <path>, "level": C3|C4, "nodes": [{"id", "label", "kind"}], "edges": [{"from", "to", "label"?}]}]}
"""

import json
import os
from pathlib import Path

from .declaration_constants import PAGE
from .declaration_vocabulary import DeclarationError
from .drawio_png_base import DEFAULTS

ROWS_VARIABLE = "CATZC_QUERY_ROWS"
QUERY_LEVELS = ("C3", "C4")  # the levels whose cells come from a query
PREFIX = "query-"  # the generated cells' ids: get leaves them out, so the source never holds them

_loaded = {}


def rows_file():
    """The address the renderer was handed, or None."""
    value = os.environ.get(ROWS_VARIABLE)
    return Path(value) if value else None


def read(path):
    """The rows of one file, keyed by (point, level), each checked for its shape."""
    key = str(path)
    if key in _loaded:
        return _loaded[key]
    try:
        raw = json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError) as e:
        raise DeclarationError(f"{path}: the query rows cannot be read: {e}")
    if not isinstance(raw, dict) or not isinstance(raw.get("rows"), list):
        raise DeclarationError(f"{path}: the query rows are a map with one key, rows, a list")
    found = {}
    for n, row in enumerate(raw["rows"]):
        where = f"{path}: rows[{n}]"
        if not isinstance(row, dict) or set(row) - {"point", "level", "nodes", "edges"}:
            raise DeclarationError(f"{where} is a map of point, level, nodes and edges")
        point, level = row.get("point"), row.get("level")
        if not isinstance(point, str) or not point.strip():
            raise DeclarationError(f"{where}: point is the repository path the query answered for")
        if level not in QUERY_LEVELS:
            raise DeclarationError(f"{where}: level '{level}' is not one of {', '.join(QUERY_LEVELS)}")
        nodes, edges = row.get("nodes") or [], row.get("edges") or []
        if not isinstance(nodes, list) or not all(isinstance(x, dict) and {"id", "label", "kind"} <= set(x) for x in nodes):
            raise DeclarationError(f"{where}: nodes is a list of {{ id, label, kind }}")
        ids = [str(x["id"]) for x in nodes]
        if len(set(ids)) != len(ids):
            raise DeclarationError(f"{where}: a node id is listed twice")
        for edge in edges:
            if not isinstance(edge, dict) or not {"from", "to"} <= set(edge) or set(edge) - {"from", "to", "label"}:
                raise DeclarationError(f"{where}: edges is a list of {{ from, to, label? }}")
            for end in (edge["from"], edge["to"]):
                if str(end) not in ids:
                    raise DeclarationError(f"{where}: an edge names '{end}', which no node is")
        if (point, level) in found:
            raise DeclarationError(f"{where}: {point} at {level} is listed twice")
        found[(point, level)] = {"nodes": nodes, "edges": edges}
    _loaded[key] = found
    return found


def lanes(content, rows, band, cap):
    """At or under the cap, the cells in one column, a row each, and every edge in a vertical lane of its own right of the column: a row or
    a lane holds no other cell, so no edge crosses one. The layout pins the column and the band; returns None over the cap."""
    nodes, edges = rows["nodes"], rows["edges"]
    if len(nodes) > cap:
        return None
    x, y, h, row, gap = PAGE["x"] + 20, PAGE["band_y"] + 40, 44, 64, 10
    w = max([150] + [8 * len(str(n["label"])) + 24 for n in nodes])
    top = {PREFIX + str(n["id"]): y + k * row for k, n in enumerate(nodes)}
    layout = {gid: {"x": x, "y": cy, "w": w, "h": h} for gid, cy in top.items()}
    drawn = []
    for m, edge in enumerate(edges):
        a, b = PREFIX + str(edge["from"]), PREFIX + str(edge["to"])
        lane = x + w + 24 + m * gap
        drawn.append({"from": a, "to": b, "via": [[lane, top[a] + h // 2], [lane, top[b] + h // 2]]})
    width = (x + w + 24 + max(len(edges), 1) * gap + 20) - PAGE["x"]
    layout[band] = {"x": PAGE["x"], "y": PAGE["band_y"], "w": max(width, 400), "h": 40 + len(nodes) * row + 20}
    return {"edges": list(content.get("edges") or []) + drawn, "layout": layout}


def expand(content, point, level, where, path=None):
    """The content with the query's cells for the point written out in its first band, their ids, and the layout that pins them when the
    slide draws its edges; unchanged without an address."""
    path = path or rows_file()
    if path is None or level not in QUERY_LEVELS:
        return content, set(), {}
    rows = read(path).get((point, level))
    if rows is None:
        raise DeclarationError(f"{where}: the query rows at {path} hold nothing for {point} at {level}")
    bands = content.get("bands") or []
    if not bands:
        raise DeclarationError(f"{where}: a {level} slide places its query's cells in its first band; it has none")
    band = bands[0]["id"] if isinstance(bands[0], dict) else str(bands[0])
    glyphs, chips, generated = list(content.get("glyphs") or []), list(content.get("chips") or []), set()
    for node in rows["nodes"]:
        gid = PREFIX + str(node["id"])
        glyphs.append({"id": gid, "kind": str(node["kind"]), "label": str(node["label"]), "in": band})
        generated.add(gid)
    if not rows["edges"]:  # nothing to route: the grid places the cells, as for any band
        return {**content, "glyphs": glyphs}, generated, {}
    drawn = lanes(content, rows, band, int(DEFAULTS["renderer"]["query-edges-max-nodes"]))
    if drawn is not None:  # at or under the cap: every edge drawn in its lane, the column and its band pinned
        generated.add(band)
        return {**content, "glyphs": glyphs, "edges": drawn["edges"]}, generated, drawn["layout"]
    # Over the cap, the edges live one zoom down: each cell carries a count chip of its edges in and out instead.
    ins = {str(n["id"]): 0 for n in rows["nodes"]}
    outs = dict(ins)
    for edge in rows["edges"]:
        outs[str(edge["from"])] += 1
        ins[str(edge["to"])] += 1
    for node in rows["nodes"]:
        nid = str(node["id"])
        if ins[nid] or outs[nid]:
            chips.append({"at": PREFIX + nid, "kind": "count", "text": f"{ins[nid]} in {outs[nid]} out"})
    return {**content, "glyphs": glyphs, "chips": chips}, generated, {}


def drawn_by_query(cid):
    """True for a cell the query rows wrote, which get leaves out."""
    return str(cid).startswith(PREFIX)
