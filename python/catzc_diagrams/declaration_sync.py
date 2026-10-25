# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""Putting and syncing a diagram: the declaration put as the png, the minimaps and the printed form kept in step, and a pair that moved
from the committed pair on both sides found a conflict."""

import io
import json
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path

import declaration_settings
import minimap_contract
from declaration_constants import ACTION_LENS, DERIVED, DERIVED_PREFIXES, KINDS, KIT, PROOF_LENS, SLIDE, SOURCE, load_yaml
from declaration_dump import flow_yaml, print_width
from declaration_expand import drawn, undrawn
from declaration_finish import to_xml
from declaration_get import get
from declaration_normalise import normalise
from declaration_place import place
from declaration_read import model_of
from declaration_source import article_block, blocks_in, carrier_of, diagram_of, load, read_source, save, slide_of, write_source
from declaration_vocabulary import EDGE_LABELS, DeclarationError
from drawio_png import THEMES, decode, encode, mxfile_chunk, render
from PIL import Image
from PIL.PngImagePlugin import PngInfo


def uniform_label(content):
    """The one label every flow edge of a diagram shares, or "": a diagram whose flow edges all say `calls` says it once, in the legend of
    the plain arrow, and draws no pill (renderer `uniform-label: legend`). A diagram with its own relation, with one flow edge, with an
    edge of another or no label, or an action diagram keeps its pills; failure edges and other kinds do not count."""
    if (
        declaration_settings.UNIFORM_LABEL != "legend"
        or str(content.get("relation", "") or "").strip()
        or content.get("lens") in (ACTION_LENS, PROOF_LENS)
    ):
        return ""
    labels = [e["label"] for e in content.get("edges", []) if e["kind"] == "flow"]
    return labels[0] if len(labels) > 1 and len(set(labels)) == 1 and labels[0] in EDGE_LABELS else ""


def put(declaration, theme=None):
    """The model XML of a declaration, in the theme named (the declaration's own theme when none is)."""
    theme = theme or declaration["content"]["theme"]
    word = uniform_label(declaration["content"])
    if word:  # derived at render time and never written back: the edges say nothing, the plain arrow's legend entry says the word
        edges = [{**e, "label": ""} if e["kind"] == "flow" else e for e in declaration["content"]["edges"]]
        declaration = {**declaration, "content": {**declaration["content"], "edges": edges, "relation": word}}
    cells, height = place({**declaration, "content": {**declaration["content"], "theme": theme}}, check_routes=True)
    if word:  # the legend entry carries the mark that its word is derived, so get never reads it back as the diagram's own relation
        for c in cells:
            if c["id"] == "lg-edge-flow-t":
                c["style"] += "uniformLabel=1;"
    return to_xml(cells, height, theme)


def put_png(folder, declaration, theme=None):
    """put, then the raster: the diagram's <name>.drawio.png with the model embedded, drawn by drawio_png. The default theme's
    render is the diagram's own png; any other theme renders on demand to out/drawio/themes/<theme>/<name>.drawio.png."""
    theme = theme or declaration["content"]["theme"]
    model = put(with_data(folder, declaration), theme).strip()
    img = render(ET.fromstring(model), page="model").convert("RGB")  # the model's own page: its theme's
    info = PngInfo()
    info.add_text("mxfile", encode(model, declaration["content"]["lens"]))
    dst = slide_of(folder) if theme == THEMES[0] else KIT.parents[1] / "out" / "drawio" / "themes" / theme / slide_of(folder).name
    dst.parent.mkdir(parents=True, exist_ok=True)
    img.save(dst, "PNG", pnginfo=info)
    return dst


def minimap_data(folder):
    """A diagram's three minimaps as Catzc.Base.Maps computed them, in order: out/minimaps/<stem>/minimaps.json names the ids and
    <id>.json holds each, its computed lit cells less the ones the declaration excludes, checked against the minimap contract. Missing
    data fails, naming the commands that write it."""
    folder = diagram_of(folder).resolve()
    repo = KIT.parents[1]
    rel = folder.relative_to(repo).as_posix() if folder.is_relative_to(repo) else folder.name
    root = repo / "out" / "minimaps" / rel
    index = root / "minimaps.json"
    if not index.is_file():
        raise DeclarationError(
            f"{rel}: no minimap data in out/minimaps/{rel}; Build-Diagrams or Test-Diagrams computes it (Write-DiagramMinimapData)"
        )
    return {view: minimap_contract.load_minimap(root / f"{view}.json") for view in json.loads(index.read_text(encoding="utf-8"))}


def minimaps_block(entries, width=None):
    """content.minimaps as the source's text writes it, two spaces in under content: and in the printed form save writes (flow_yaml):
    the shown ids as one flow line when they fit the print width, an entry with an exclude: as its own item. No entries, no lines."""
    if not entries:
        return []
    width = width or print_width()
    return ["  " + line for line in flow_yaml({"minimaps": entries}, width - 2).rstrip("\n").split("\n")]


def declare_minimaps(folder):
    """Write a diagram's minimaps into its source as their inputs only, in the printed form: the shown ids, each with the exclude: its
    author gave it, and never a computed cell. Only that key's lines change: the rest of the text, its generated head and its formatting
    included, is kept as it was read, never re-dumped, which would drop the head and what a row or lane expands to."""
    text, source = read_source(folder)
    placed = normalise(load_yaml(text) or {}, where=str(source))["content"]["minimaps"]
    lines = text.split("\n")
    content = next((i for i, line in enumerate(lines) if line.rstrip() == "content:"), None)
    if content is None:
        raise DeclarationError(f"{source}: no top-level content: block to write the minimaps into")
    # The content block runs to the next top-level line; its minimaps key, when it has one, runs to the next key of the same depth.
    end = next((i for i in range(content + 1, len(lines)) if lines[i] and not lines[i].startswith((" ", "#"))), len(lines))
    while end > content + 1 and not lines[end - 1].strip():
        end -= 1
    start = next((i for i in range(content + 1, end) if lines[i].startswith("  minimaps:")), None)
    if start is None:
        start = stop = end
    else:
        # A list item at the key's own depth (`  - grid`, as yaml.safe_dump writes a list) is still the key's.
        stop = next(
            (
                i
                for i in range(start + 1, end)
                if lines[i].strip() and len(lines[i]) - len(lines[i].lstrip()) <= 2 and not lines[i].startswith("  - ")
            ),
            end,
        )
    return write_source(folder, "\n".join(lines[:start] + minimaps_block(placed) + lines[stop:]))


def reflow(folder):
    """Rewrite a diagram's source in the printed form (flow_yaml at the print width): its generated head and its keys kept as read, rows
    and lanes unexpanded. Nothing is written when the declaration the new text loads differs from the one the old text loads."""
    text, source = read_source(folder)
    lines = text.split("\n")
    body = next((i for i, line in enumerate(lines) if line.strip() and not line.startswith("#")), len(lines))
    head = "\n".join(lines[:body])
    new = (head + "\n" if body else "") + flow_yaml(load_yaml(text) or {}, print_width())
    where = str(source)
    if normalise(load_yaml(new) or {}, where=where) != normalise(load_yaml(text) or {}, where=where):
        raise DeclarationError(f"{source}: the reflowed text loads a different declaration, so nothing was written")
    return write_source(folder, new)


def with_data(folder, declaration):
    """The declaration with its folder's minimap data, which put draws the sidebar from."""
    return {**declaration, "minimap_data": minimap_data(folder)}


def drift(folder):
    """How a folder's png differs from put of its yml: the drawn cells that differ, and apart from them the cells the kit derives and
    get never reads back (the minimaps, the legend, the map key and the sidebar), which change when a registry or the kit changes and
    so are stale rather than drifted. Both empty when the png is what put would write."""
    changed = changed_cells(model_of(folder), put(with_data(folder, load(folder))).strip())
    stale = [i for i in changed if i in DERIVED or i.startswith(DERIVED_PREFIXES)]
    return [i for i in changed if i not in stale], stale


def changed_cells(one, other):
    """The ids of the cells two models draw differently, sorted; empty when the models are the same."""
    if one == other:
        return []
    ids = lambda model: {str(c.get("id")): ET.tostring(c, encoding="unicode") for c in ET.fromstring(model).iter("mxCell")}
    old, new = ids(one), ids(other)
    return sorted(i for i in old.keys() | new.keys() if old.get(i) != new.get(i))


def committed(folder, bases=None):
    """The pair as committed at git HEAD: the source's text (the file, or the article's block) and the model embedded in the png, read
    with `git show`. None when the diagram is outside a repository or either side is not committed: an untracked pair has no base.
    A batch passes the bases committed_batch read at its start, so its diagrams cost no git call of their own."""
    stem = diagram_of(folder).resolve()
    if bases is not None and str(stem) in bases:
        return bases[str(stem)]
    root = toplevel(stem.parent)
    if root is None:
        return None
    # Never raises: a non-zero return code means that side is not committed.
    show = lambda path: (lambda r: r.stdout if r.returncode == 0 else None)(git(root, "show", f"HEAD:{path}"))
    return base_from(stem, root, show)


def committed_batch(folders):
    """The committed pair of every diagram of a batch, by resolved stem, read at the batch's start: per repository one HEAD and one
    short-lived `git cat-file --batch` for every side, so a commit made after it is seen by the next batch. A diagram whose article
    carrier fails is left out, and committed() reads it alone, raising as it would."""
    by_root = {}
    for folder in folders:
        stem = diagram_of(folder).resolve()
        by_root.setdefault(toplevel(stem.parent), []).append(stem)
    bases = {}
    for root, stems in by_root.items():
        head = None if root is None else git(root, "rev-parse", "--verify", "HEAD")
        if head is None or head.returncode != 0:
            bases.update({str(stem): None for stem in stems})
            continue
        sha = head.stdout.decode("utf-8").strip()
        wanted = {}
        for stem in stems:
            try:
                wanted[stem] = sides(stem, root)
            except DeclarationError:
                continue
        specs = sorted({path for paths in wanted.values() for path in paths})
        blobs = cat_file(root, [f"{sha}:{path}" for path in specs])
        held = dict(zip(specs, blobs))
        for stem in wanted:
            bases[str(stem)] = base_from(stem, root, held.get)
    return bases


def git(root, *args):
    return subprocess.run(["git", "-C", str(root), *args], capture_output=True, check=False)


def toplevel(folder):
    """The repository root a folder sits in, or None outside one."""
    top = git(folder, "rev-parse", "--show-toplevel")
    return Path(top.stdout.decode("utf-8").strip()).resolve() if top.returncode == 0 else None


def sides(stem, root):
    """The repository paths that hold a diagram's committed pair: its png, and its yml or its article page."""
    return png_side(stem, root), source_side(stem, root)


def png_side(stem, root):
    return f"{stem.relative_to(root).as_posix()}{SLIDE}"


def source_side(stem, root):
    if carrier_of(stem) == "file":
        return f"{stem.relative_to(root).as_posix()}{SOURCE}"
    return article_block(stem)[0].resolve().relative_to(root).as_posix()


def cat_file(root, specs):
    """The content of each `<commit>:<path>` spec, or None for one that is missing, from one `git cat-file --batch` that ends with it."""
    request = "".join(f"{spec}\n" for spec in specs).encode("utf-8")
    run = subprocess.run(["git", "-C", str(root), "cat-file", "--batch"], input=request, capture_output=True, check=False)
    out, at, found = run.stdout, 0, []
    for _ in specs:
        eol = out.index(b"\n", at)
        header = out[at:eol].split()
        at = eol + 1
        if len(header) == 3 and header[1] != b"missing":
            size = int(header[2])
            found.append(out[at : at + size])
            at += size + 1
        else:
            found.append(None)
    return found


def base_from(stem, root, show):
    """The base of one diagram from `show(path)`, the committed bytes of a repository path or None."""
    png = show(png_side(stem, root))
    if png is None:
        return None
    shown = show(source_side(stem, root))
    if shown is None:
        return None
    if carrier_of(stem) == "file":
        text = shown.decode("utf-8")
    else:
        # The committed block is the one the committed article page holds; a page that is not committed, or holds none or two, has no base.
        whole = shown.decode("utf-8")
        spans = blocks_in(whole, stem.name)
        if len(spans) != 1:
            return None
        text = whole[spans[0][0] : spans[0][1]]
    return text, decode(mxfile_chunk(Image.open(io.BytesIO(png)))).strip()


def kind_of(folder):
    """The diagram kind its path names (explanation or reference), or None."""
    return next((k for k in KINDS if f"/{k}/" in Path(folder).resolve().as_posix()), None)


def conflict(folder, base):
    """The cells of a pair whose two sides both moved from the committed pair and now disagree: the yml differs from the base's,
    the png's model differs from the base's, and get of the png states other content than the yml. Empty when only one side moved,
    when the sides agree, or when there is no base (base None: an untracked pair is never a conflict). A conflicted pair is put or
    got only by name, so the author picks the side that wins; nothing merges."""
    if base is None:
        return []
    # The base is compared as data, never validated: it was valid against the registries of its own commit, not today's.
    source, model = load(folder), model_of(folder)
    unmoved = load_yaml(read_source(folder)[0]) == load_yaml(base[0])
    if unmoved or model == base[1]:
        return []
    back = undrawn(get(model, kind_of(folder))["content"], source)
    if drawn(back) == drawn(source["content"]):
        return []
    # The cells that diverge are drawn ones: a derived cell (a minimap, the legend) is stale at worst, never a side to pick.
    return [
        i for i in changed_cells(model, put(with_data(folder, source)).strip()) if i not in DERIVED and not i.startswith(DERIVED_PREFIXES)
    ]


def sync(folder, base):
    """The sync after an edit: get when the drawing moved from the base (or there is no base), then put, so the yml and the png
    agree again; put alone when only the yml moved. The directions run, in order. A conflicted pair runs nothing and fails with
    its cells, so the author picks the side by name."""
    both = conflict(folder, base)
    if both:
        raise DeclarationError(
            f"{folder}: the yml and the png both moved from HEAD and disagree in {', '.join(both)}; put or get it by name"
        )
    ran = []
    if base is None or model_of(folder) != base[1]:
        save(folder, get(model_of(folder), kind_of(folder)))
        ran.append("get")
    put_png(folder, load(folder))
    return ran + ["put"]
