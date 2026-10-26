# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""The declaration of a diagram: its source beside its .drawio.png, and the two directions between them.

A diagram is two flat files in an `.assets/` folder, named by the diagram: `<name>.drawio.yml`, its one source, and `<name>.drawio.png`,
the drawing put from it. The kit names a diagram by its stem, `<page-folder>/.assets/<name>`, and takes either file of the pair for it.
The source has three keys: `description:` says in a sentence or two what the diagram shows; `content:` says it in the closed
vocabulary of the kit (bands, spans, groups, glyphs, edges, markers, chips, the legend, the flow and its relation, the theme, the
three minimaps); `layout:` says where a named cell sits (x, y, w, h). A cell without a layout entry is placed by the grid; a cell
with one keeps it; a cell whose id is not in the content is removed. The diagram names no article: articles and slides embed the
png, any number of them, and the build finds them by what embeds it.

put:  the declaration becomes the mxGraphModel XML embedded in the .drawio.png, and the raster is drawn from that XML (drawio_png).
get:  the XML embedded in the .drawio.png becomes the declaration again, written into the source (its description kept), so a
      hand edit in the draw.io editor is folded back before anything else reads it. Both are deterministic: put then get gives the
      same declaration, get then put the same XML.

usage (repo root, background):
  uv run --no-sync --project python python -m catzc.diagrams.declaration put <diagram> [--xml <out.xml>]
  uv run --no-sync --project python python -m catzc.diagrams.declaration get <diagram>
  uv run --no-sync --project python python -m catzc.diagrams.declaration check <diagram>...
  uv run --no-sync --project python python -m catzc.diagrams.declaration sync <diagram>
  uv run --no-sync --project python python -m catzc.diagrams.declaration tidy <diagram>
  uv run --no-sync --project python python -m catzc.diagrams.declaration minimaps <diagram>
  uv run --no-sync --project python python -m catzc.diagrams.declaration reflow <diagram>
  uv run --no-sync --project python python -m catzc.diagrams.declaration carry <diagram> article|file
  uv run --no-sync --project python python -m catzc.diagrams.declaration rekey <from-stem> <to-stem> [<drawio.yml>]
(<diagram> is the stem `.assets/<name>` or either file of its pair; `--rows <file>` before any direction names the query rows a C3 or C4
slide is expanded from, as the renderer takes it)

A pair whose yml and png both moved from the pair committed at git HEAD, and now disagree, is a conflict: check names its cells, the bulk
put skips it, and only put or get by name, the author's pick of the side that wins, clears it. Nothing merges.

Every vocabulary (glyph kinds, edge kinds, span labels, minimap ids, flows, themes, lenses, kinds) is closed: a value outside it
fails validation with the list the author may choose from, so the errors teach the kit.
"""

import json
import sys
from pathlib import Path

from . import edge_rules, minimaps
from .declaration_action_content import WRAP_GLUED, WRAP_LATE, WRAP_SPACED, cause_sizes, contract_call, unwrap_lines, wrap_line
from .declaration_cells import TAGGED_KINDS, glyph_tags, ladder_rungs
from .declaration_constants import (
    ACTION,
    ACTION_MARGIN,
    ACTION_WIDTH,
    BYPASS_DIP,
    COMMITS,
    DERIVED,
    DERIVED_PREFIXES,
    EDGE_DEADZONE,
    FLOWS,
    KIT,
    LABEL_ROW,
    OPERATORS,
    PAD,
)
from .declaration_dump import dump, flow_yaml, print_width
from .declaration_expand import shown_minimaps, undrawn
from .declaration_get import get
from .declaration_normalise import normalise
from .declaration_place import place
from .declaration_read import model_of, shift_of
from .declaration_routes import LAST_ROUTES, cross_segment, segment_hits_rect
from .declaration_settings import LABEL_PRESENTATIONS
from .declaration_source import (
    FENCE,
    article_stems,
    articles,
    carrier_findings,
    carrier_of,
    carry,
    declared,
    diagram_of,
    load,
    read_source,
    rekeyed,
    save,
    slide_of,
    source_of,
)
from .declaration_sync import (
    committed,
    committed_batch,
    conflict,
    declare_minimaps,
    drift,
    kind_of,
    minimaps_block,
    put,
    put_png,
    reflow,
    sync,
    with_data,
)
from .declaration_vocabulary import EDGE_KINDS, EDGE_LABELS, EDGE_SEMANTICS, GLYPH_KINDS, LIB, DeclarationError, choices, span_vocabulary
from .drawio_png import DEFAULTS, paint, plain, render, style_map
from .module_paths import REPO

__all__ = [
    "ACTION",
    "ACTION_MARGIN",
    "ACTION_WIDTH",
    "BYPASS_DIP",
    "COMMITS",
    "CONFIG",
    "DEFAULTS",
    "DERIVED",
    "DERIVED_PREFIXES",
    "EDGE_DEADZONE",
    "EDGE_KINDS",
    "EDGE_LABELS",
    "EDGE_SEMANTICS",
    "FENCE",
    "FLOWS",
    "GLYPH_KINDS",
    "KIT",
    "LABEL_PRESENTATIONS",
    "LABEL_ROW",
    "LAST_ROUTES",
    "LIB",
    "OPERATORS",
    "PAD",
    "TAGGED_KINDS",
    "WRAP_GLUED",
    "WRAP_LATE",
    "WRAP_SPACED",
    "DeclarationError",
    "article_stems",
    "articles",
    "carrier_findings",
    "carrier_of",
    "carry",
    "cause_sizes",
    "choices",
    "committed",
    "committed_batch",
    "conflict",
    "contract_call",
    "cross_segment",
    "declare_minimaps",
    "declared",
    "diagram_of",
    "drift",
    "dump",
    "edge_rules",
    "flow_yaml",
    "get",
    "glyph_tags",
    "ladder_rungs",
    "load",
    "minimaps",
    "minimaps_block",
    "model_of",
    "normalise",
    "paint",
    "place",
    "plain",
    "print_width",
    "put",
    "put_png",
    "read_source",
    "reflow",
    "rekeyed",
    "render",
    "save",
    "segment_hits_rect",
    "shift_of",
    "shown_minimaps",
    "slide_of",
    "source_of",
    "span_vocabulary",
    "style_map",
    "sync",
    "undrawn",
    "unwrap_lines",
    "with_data",
    "wrap_line",
]

CONFIG = KIT / "configs" / "drawio.yml"  # the kit's defaults, whose roles: a diagram move re-keys


def main():
    args = sys.argv[1:]
    if "--rows" in args:  # the query rows' address, named by its caller, so a check puts a C3 or C4 slide as its render did
        import os

        from . import query_rows

        i = args.index("--rows")
        os.environ[query_rows.ROWS_VARIABLE] = str(Path(args[i + 1]).resolve())
        del args[i : i + 2]
    if len(args) >= 2 and args[0] == "check":  # one JSON line per diagram: conflicted or drifted cells, stale minimaps, or the error
        from . import drawio_forward

        for name in args[1:]:
            folder = diagram_of(name)
            try:
                # A legend diagram has no source: its png is checked against the painted glyph library, stale when a kit change moved it.
                if drawio_forward.diagram_role(folder) == "legend":
                    stale = ["legend"] if drawio_forward.legend_stale(folder) else []
                    print(json.dumps({"diagram": name, "conflict": [], "drift": [], "stale": stale}))
                    continue
                # A diagram declared in both carriers is a finding before anything is compared.
                twice = carrier_findings(folder)
                if twice:
                    print(json.dumps({"diagram": name, "error": "; ".join(twice)}))
                    continue
                both = conflict(folder, committed(folder))
                cells, stale = ([], []) if both else drift(folder)
                print(json.dumps({"diagram": name, "conflict": both, "drift": cells, "stale": stale}))
            except (DeclarationError, OSError, ValueError) as error:
                print(json.dumps({"diagram": name, "error": str(error)}))
        return
    if len(args) == 2 and args[0] == "tidy":  # the source re-saved through the kit: normalised, the retired about keys dropped
        folder = diagram_of(args[1])
        save(folder, load(folder))
        print(f"tidy {read_source(folder)[1]}")
        return
    if len(args) == 2 and args[0] == "reflow":  # the source rewritten in the printed form, its head and rows kept, its load() unchanged
        print(f"reflow {reflow(diagram_of(args[1]))}")
        return
    if len(args) == 3 and args[0] == "carry":  # the declaration moved to the other carrier
        where, png = carry(diagram_of(args[1]), args[2])
        target = png.resolve().relative_to(REPO).as_posix() if png.resolve().is_relative_to(REPO) else png
        print(f"carry {where}; render with: Build-Diagrams -Path {target}")
        return
    if len(args) in (3, 4) and args[0] == "rekey":  # a moved stem's roles: entries re-keyed, in the kit's drawio.yml or the given one
        config = Path(args[3]) if len(args) == 4 else CONFIG
        before = config.read_text(encoding="utf-8")
        after = rekeyed(before, args[1], args[2])
        if after != before:
            config.write_text(after, encoding="utf-8", newline="\n")
        print(f"rekey {config}: {'re-keyed' if after != before else 'unchanged'}")
        return
    if len(args) == 2 and args[0] == "minimaps":  # the diagram's minimap inputs rewritten in the printed form
        print(f"minimaps {declare_minimaps(diagram_of(args[1]))}")
        return
    if len(args) == 2 and args[0] == "sync":  # one JSON line: the directions run, or the conflict that stopped them
        folder = diagram_of(args[1])
        try:
            print(json.dumps({"diagram": args[1], "ran": sync(folder, committed(folder))}))
        except DeclarationError as error:
            print(json.dumps({"diagram": args[1], "error": str(error)}))
        return
    if len(args) < 2 or args[0] not in ("put", "get"):
        raise SystemExit(__doc__)
    direction, folder = args[0], diagram_of(args[1])
    if direction == "put":
        declaration = load(folder)
        if "--xml" in args:
            Path(args[args.index("--xml") + 1]).write_text(put(declaration), encoding="utf-8")
        dst = put_png(folder, declaration)
        print(f"put {dst}")
    else:
        save(folder, get(model_of(folder), kind_of(folder)))
        print(f"get {read_source(folder)[1]}")


if __name__ == "__main__":
    main()
