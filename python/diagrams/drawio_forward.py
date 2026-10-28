# cspell:ignore mxfile minimaps pnginfo XMLMATCH
"""Fail-forward render of a .drawio.png: always a source copy and a result PNG, findings forwarded, never a silent stop.

usage: uv run --project python python -m catzc.diagrams.drawio_forward <src.drawio.png> [<out_dir>] [--page dark|model]
                                                     [--xml <model.xml | file.drawio>] [--assert <text.md>]

Deterministic. <out_dir> defaults to renderer.out and --page to renderer.page of drawio.yml beside this script. Writes
into <out_dir>: <name>.src.drawio.png (a byte copy of the source), <name>.out.drawio.png (the raster re-rendered from
the embedded model on the chosen page, or the source copy again when no model can be read), <name>.model.xml (the
decoded model, when one exists) and <name>.render.md (the report). With --xml the given model must match the embedded
one 100 percent after canonicalisation. With --assert every non-empty, non-heading line of the text file (a page, 66
lines) must appear in some cell label, whitespace-folded and case-folded. Exit 0: clean. Exit 2: transport or assertion findings, each an error (renderer findings-fail), every artifact still delivered. Exit 3: no source
file, nothing to forward. Prints one line per artifact (`src`, `result`, `model`, `report`), one per finding (`error`),
then `status`.

bulk:  uv run --project python python -m catzc.diagrams.drawio_forward [--theme <theme>] [--workers <n>] [--rows <file>] --all <root> [<root> ...]

--rows names the query rows file a C3 or C4 slide's cells are expanded from (query_rows.py); without it, no slide is expanded.

Rebuilds every diagram under <root> in place (the pair `<article-folder>/.assets/<name>.drawio.png` and `<name>.drawio.yml`;
the root itself when it names one): each declared diagram is put in the theme, its minimaps drawn from their computed data with
it (ADR-REPO-SLIDES-MINIMAPSFROMDATA); a diagram without a declaration is left as it is, its model extracted to
out/drawio/bulk/<root>/models/ only to check its article's Supports line against its subtitle, and reported, because its
minimaps can be rebuilt only once it has a declaration. A theme other than the default puts the declared diagrams to
out/drawio/themes/<theme>/ and leaves the committed rasters and the diagrams without a declaration alone. A legend diagram (its
drawio.yml role) is rendered from the kit's glyphs.xml, painted in the default theme. Same exit codes;
the report is out/drawio/bulk/<root>/bulk.md. One process rebuilds every root given in turn, prints one JSON row
`{"diagram": <root>, "exit": <code>}` after each, and exits with the worst code (1 when a root raised). --workers splits the roots
into that many disjoint slices, one worker process each, and prints every slice's lines in root order after all of them end.
"""

import html
import json
import os
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image
from PIL.PngImagePlugin import PngInfo

from . import minimaps
from .drawio_forward_single import FINDINGS_EXIT, FORWARD, REPO, SLIDE, forward_one
from .drawio_png import DEFAULTS, THEMES, decode, encode, mxfile_chunk, paint, plain, render
from .module_paths import KIT

RECORD_CODE = re.compile(r"(?<![\w-])" + minimaps.kinds() + r"(?:-[A-Z][A-Z0-9]*)+(?![\w-])")
NUMBERED = re.compile(r"(?<![\w-])" + minimaps.kinds() + r"(?:-[A-Z][A-Z0-9]*)+(?:[#:]\d|#\{)")
SOURCE = ".drawio.yml"
ROLES = ("slide", "legend")  # the closed set of diagram roles drawio.yml may name


def slide_of(stem):
    """The render of the diagram whose stem is `.assets/<name>`."""
    stem = Path(stem)
    return stem.with_name(stem.name + SLIDE)



def slide_facts(model):
    """What a slide says it supports, from its `subtitle` cell alone (`<codes> · <lens>`): the record codes the index knows, the
    lens, and every problem with the line. The sidebar's chips, badge and page name are outputs of these, never inputs."""
    subtitle = next(
        (
            plain(c.get("value") or "").strip()
            for c in ET.fromstring(model).iter("mxCell")
            if c.get("id") == "subtitle"
        ),
        None,
    )
    if subtitle is None:
        return [], None, ["the model has no subtitle cell"]
    problems = []
    lens = re.sub(r"\s+lens$", "", subtitle.rsplit("·", 1)[-1].strip())
    if lens not in DEFAULTS["lenses"]:
        problems.append(
            f"the subtitle ends with '{lens}', not a lens of drawio.yml ({', '.join(DEFAULTS['lenses'])})"
        )
        lens = None
    if NUMBERED.search(subtitle):
        problems.append(
            f"the subtitle cites a rule by number, a rule is cited by its name (ADR-REPO-DRSCODE): {subtitle!r}"
        )
    return records_of(subtitle), lens, problems


def diagram_role(folder):
    """A diagram's role: its entry under drawio.yml roles:, keyed by its stem's repository path, else renderer.role."""
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    role = DEFAULTS.get("roles", {}).get(path, DEFAULTS["renderer"]["role"])
    if role not in ROLES:
        raise ValueError(f"drawio.yml gives {path} the role '{role}', not one of {', '.join(ROLES)}")
    return role


def legend_model():
    """The kit's glyph library as a legend diagram's png carries it: glyphs.xml without its comments, each tag joined back onto one
    line (the file holds a long tag one attribute per line), its tokens painted in the default theme, and the language tags of its
    code glyphs added."""
    text = re.sub(r'\n[ \t]+(?=[\w:.-]+=")', " ", (KIT / "assets" / "glyphs.xml").read_text(encoding="utf-8"))
    return tagged_library(paint(chr(10).join(line for line in text.splitlines() if not line.lstrip().startswith("<!--")).strip()))


TAGGED_SAMPLES = {"g-code": "Get-Thing", "g-private": "Get-Thing", "g-runner": "Invoke-Thing", "g-type": "ThingConfig", "g-command-sample": None}  # the library glyphs that are code: each shows its tag row


def tagged_library(model):
    """The library model with the language tags of its code glyphs, their words from the language table by the shape of each label
    (a glyph kind falls back to the language that is its default), so the library holds no tag word of its own."""
    from xml.sax.saxutils import quoteattr

    from . import declaration

    cell = lambda cell_id: re.search(
        rf'<mxCell\s+id="{cell_id}"\s+value="([^"]*)"\s+style="([^"]*)"[^>]*>\s*<mxGeometry\s+x="(-?\d+)"\s+y="(-?\d+)"\s+width="(\d+)"\s+height="(\d+)"',
        model,
    )
    sheet = cell("g-type-tag")
    assert sheet, "the library holds its type-tag sheet, g-type-tag"
    lib = {"style": sheet.group(2), "size": (int(sheet.group(5)), int(sheet.group(6)))}
    model = re.sub(r'\s*<mxCell id="g-type-tag"[^>]*>\s*<mxGeometry[^>]*/>\s*</mxCell>', "", model, count=1)
    added = []
    for cid, sample in TAGGED_SAMPLES.items():
        found = cell(cid)
        assert found, f"the library holds the tagged sample {cid}"
        box = {"x": int(found.group(3)), "y": int(found.group(4)), "w": int(found.group(5)), "h": int(found.group(6))}
        label = plain(html.unescape(found.group(1))) if sample is None else sample
        kind = "code" if cid == "g-command-sample" else cid[2:]
        for tag in declaration.glyph_tags({"id": cid, "kind": kind, "label": label}, box, "1", lib):
            added.append(
                chr(10).join(
                    (
                        f'    <mxCell id="{tag["id"]}" value={quoteattr(tag["value"])} style={quoteattr(paint(tag["style"]))} vertex="1" parent="1">',
                        f'      <mxGeometry x="{tag["x"]}" y="{tag["y"]}" width="{tag["w"]}" height="{tag["h"]}" as="geometry" />',
                        "    </mxCell>",
                    )
                )
            )
    return model.replace("  </root>", chr(10).join(added) + chr(10) + "  </root>", 1)


def legend_stale(folder):
    """Whether a legend diagram's png carries another model than the painted glyph library: a kit change left it stale."""
    return decode(mxfile_chunk(Image.open(slide_of(folder)))).strip() != legend_model().strip()


def put_legend(folder):
    """Render a legend diagram's png from the kit's glyph library, its tokens painted in the default theme first, as every put paints
    them; the png carries the painted model, so draw.io opens what the raster shows."""
    model = legend_model()
    img = render(ET.fromstring(model)).convert("RGB")
    info = PngInfo()
    info.add_text("mxfile", encode(model, "Page-1"))
    target = slide_of(folder)
    img.save(target, "PNG", pnginfo=info)
    return target


def undeclared_findings(folder, source):
    """An E_UNDECLARED finding for a slide with no declaration; a legend draws no minimaps, so it needs none and has none."""
    if diagram_role(folder) == "legend":
        return []
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    return [f"E_UNDECLARED {path}: no {source}, so its minimaps are not rebuilt; declare it to put it"]


def subtitle_facts(folder, model):
    """slide_facts for a slide, with each problem as an E_SUBTITLE finding; a legend names no record and carries no subtitle, so it has none."""
    if diagram_role(folder) == "legend":
        return [], None, []
    records, lens, problems = slide_facts(model)
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    return records, lens, [f"E_SUBTITLE {path}: {p}" for p in problems]


def known_records():
    """The record codes the index's code tables list; a code quoted in its prose is no entry."""
    return set(
        re.findall(
            r"(?m)^\|\s*`(" + minimaps.kinds() + r"(?:-[A-Z][A-Z0-9]*)+)`",
            (REPO / minimaps.records_root() / "index.md").read_text(encoding="utf-8"),
        )
    )


def records_of(text, known=None):
    """The records a text cites, sorted: each code's longest prefix the index lists, so a rule's code names its record."""
    known = known_records() if known is None else known
    found = set()
    for code in RECORD_CODE.findall(text):
        while code not in known and "-" in code:
            code = code.rsplit("-", 1)[0]
        if code in known:
            found.add(code)
    return sorted(found)


def supports_drift(folder, records, lens):
    """The article's `Supports … (<lens> lens)` line against the subtitle: the article is the one page beside the diagram's
    `.assets` that embeds the slide. Returns the finding, or None when they agree or no article line exists."""
    slide = slide_of(folder).resolve()
    for page in sorted(folder.parent.parent.glob("*.md")):
        text = page.read_text(encoding="utf-8")
        targets = re.findall(r"!\[[^\]]*\]\(([^)\s]+\.drawio\.png)\)", text)
        if not any((page.parent / t).resolve() == slide for t in targets):
            continue
        line = re.search(r"^Supports (.+?) \((\w+) lens\)\.?$", text, flags=re.MULTILINE)
        if line is None:
            return None
        said = (records_of(line.group(1)), line.group(2))
        if said != (records, lens):
            return f"{page.relative_to(REPO).as_posix()} says Supports {said[0]} ({said[1]} lens), the subtitle {records} ({lens} lens)"
        return None
    return None


def diagrams(root):
    """The diagrams under a root, by stem, or the root itself when it names one: each `<article-folder>/.assets/<name>` with a
    `<name>.drawio.png`, a `<name>.drawio.yml` whose first put has not been run yet, or a `yml drawio` block in an article above an
    image of it, which needs no png yet. The root may be a stem or a file of a pair."""
    from . import declaration

    root = Path(root)
    for suffix in (SLIDE, SOURCE):
        if root.name.endswith(suffix):
            root = root.with_name(root.name[: -len(suffix)])
    root = root.resolve()
    # A diagram in the article carrier has no yml beside its png, and before its first put no png either: its block names it.
    if any(root.with_name(root.name + suffix).is_file() for suffix in (SLIDE, SOURCE)) or (
        root.parent.name == ".assets" and root in {s.resolve() for s in declaration.article_stems(root.parent.parent)}
    ):
        return [root]
    if not root.is_dir():
        return []
    found = {p.with_name(p.name[: -len(suffix)]) for suffix in (SLIDE, SOURCE) for p in root.rglob(f"*{suffix}") if p.parent.name == ".assets"}
    found |= {stem.resolve() for stem in declaration.article_stems(root)}
    return sorted(found)


def bulk(root, theme=None, bases=None):
    """Rebuild every diagram under a root in place; returns the exit code after printing the lines and the report. `bases` are the
    committed pairs the batch read at its start (committed_batch); without them each diagram reads its own."""
    root = root.resolve()
    rel = lambda p: str(Path(p).resolve().relative_to(REPO)).replace("\\", "/")
    work = REPO / DEFAULTS["renderer"]["out"] / "bulk" / rel(root).replace("/", "--")
    models = work / "models"
    folders = diagrams(root)
    findings, counts = [], {}
    if not folders:
        print(f"error E_SOURCE no diagram (.assets/<name>{SLIDE}) under {root}")
        print("status error")
        return 3
    # A diagram with a declaration is put from it, minimaps included; a diagram without one is only checked and reported.
    from . import declaration

    declared = [f for f in folders if declaration.declared(f)]
    folders = [f for f in folders if f not in declared]
    # Only the default theme is committed; another theme renders the declared diagrams on demand to out/, and nothing else.
    themed = theme is not None and theme != THEMES[0]
    if themed:
        findings += [f"E_THEME {rel(f)}: no declaration in its carrier, so it renders in the default theme only" for f in folders]
        folders = []
    put = 0
    for f in declared:
        try:
            # A conflicted pair waits for the author's put or get by name; the bulk run picks no side.
            both = [] if themed else declaration.conflict(f, declaration.committed(f, bases))
            if both:
                findings.append(f"E_CONFLICT {rel(f)}: the yml and the png both moved from HEAD and disagree in {', '.join(both)}")
                continue
            print(f"put {rel(declaration.put_png(f, declaration.load(f), theme))}")
            put += 1
        except (declaration.DeclarationError, OSError) as e:
            findings.append(f"E_PUT {rel(f)}: {e}")
    counts.update(put=put)
    # A legend diagram is drawn from the glyph library, in the default theme only, so it renders and is never left to be checked.
    legends = [f for f in folders if diagram_role(f) == "legend"]
    folders = [f for f in folders if f not in legends]
    for f in legends:
        try:
            print(f"put {rel(put_legend(f))}")
        except FORWARD as e:
            findings.append(f"E_PUT {rel(f)}: {e}")
    counts.update(legends=len(legends))
    model_of =lambda f: models / (rel(f).replace("/", "--") + ".model.xml")
    models.mkdir(parents=True, exist_ok=True)
    done = 0
    for f in folders:
        try:
            model_of(f).write_text(decode(mxfile_chunk(Image.open(slide_of(f)))).strip(), encoding="utf-8")
            done += 1
        except FORWARD as e:
            findings.append(f"E_PREPARE {rel(f)}: {e}")
    for f in folders:
        if not model_of(f).is_file():
            continue
        records, lens, subtitle_findings = subtitle_facts(f, model_of(f).read_text(encoding="utf-8"))
        findings += subtitle_findings
        if records and lens is not None:
            drift = supports_drift(f, records, lens)
            if drift:
                findings.append(f"E_SUPPORTS {drift}")
        findings += undeclared_findings(f, declaration.source_of(f).name if declaration.carrier_of(f) == "file" else f"`{declaration.FENCE}` block")
    counts.update(prepared=done, undeclared=len(folders))
    for w in findings:
        print(f"error {w}")
    status = "ok" if not findings else "error"
    work.mkdir(parents=True, exist_ok=True)
    report = work / "bulk.md"
    lines = [
        f"# {rel(root)}: bulk rebuild",
        "",
        f"- root: `{root}`",
        f"- diagrams: {len(folders)}",
        f"- status: {status}",
    ]
    lines += [f"- {k}: {v}" for k, v in counts.items()] + [
        f"- error: {w}" for w in findings
    ]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"report {report}")
    print(f"status {status}")
    return FINDINGS_EXIT if findings else 0


def main():
    args = sys.argv[1:]
    if "--all" in args:
        theme = None
        if "--theme" in args:
            i = args.index("--theme")
            theme = args[i + 1]
            del args[i : i + 2]
            if theme not in THEMES:
                raise SystemExit(f"theme '{theme}' is not one of: {', '.join(THEMES)}")
        if "--rows" in args:  # the query rows' address, named by Build-Diagrams; the spawned workers inherit it (DDR-VISUAL-ZOOMISANAXIS)
            i = args.index("--rows")
            from . import query_rows

            os.environ[query_rows.ROWS_VARIABLE] = str(Path(args[i + 1]).resolve())
            del args[i : i + 2]
        workers = 1
        if "--workers" in args:
            i = args.index("--workers")
            workers = max(1, int(args[i + 1]))
            del args[i : i + 2]
        i = args.index("--all")
        roots = [Path(a) for a in args[i + 1 :]]
        # The committed pairs are read once, at the batch's start, and handed to every worker: one git read per batch, never per diagram.
        bases = None if theme not in (None, THEMES[0]) else batch_bases(roots)
        if workers == 1 or len(roots) < 2:
            raise SystemExit(bulk_roots(roots, theme, bases))
        # Disjoint, contiguous slices: each worker pays the imports once for its slice, and the slices print back in stem order once
        # every worker has ended, so the first failure is raised only after all of them.
        size = -(-len(roots) // workers)
        slices = [roots[k : k + size] for k in range(0, len(roots), size)]
        from concurrent.futures import ProcessPoolExecutor

        with ProcessPoolExecutor(max_workers=len(slices)) as pool:
            done = list(pool.map(captured_roots, slices, [theme] * len(slices), [bases] * len(slices)))
        for text, _ in done:
            sys.stdout.write(text)
        raise SystemExit(max(code for _, code in done))
    return forward_one(args)


def batch_bases(roots):
    """The committed pairs of every declared diagram under the roots, read once for the whole batch."""
    from . import declaration

    # A root that cannot be listed raises again in its own bulk, which reports it; here it only leaves the batch without bases.
    try:
        found = [f for root in roots for f in diagrams(root) if declaration.declared(f)]
        return declaration.committed_batch(found) if found else {}
    except (*FORWARD, declaration.DeclarationError):
        return None


def bulk_roots(roots, theme, bases=None):
    """Rebuild each root in turn in this process, each ending with its JSON row; returns the worst exit code."""
    # Many roots share one process, so the imports and the loaded registries are paid once; each root ends with its own row.
    from . import declaration

    worst = 0
    for root in roots:
        try:
            code = bulk(root, theme, bases)
        except (*FORWARD, declaration.DeclarationError) as e:
            print(f"error E_RENDER {root}: {e}")
            code = 1
        print(json.dumps({"diagram": str(root).replace("\\", "/"), "exit": code}))
        worst = max(worst, code)
    return worst


def captured_roots(roots, theme, bases=None):
    """One worker's slice: its printed lines, held until the parent prints every slice in order, and its worst exit code."""
    import contextlib
    import io as text_io

    out = text_io.StringIO()
    with contextlib.redirect_stdout(out):
        code = bulk_roots(roots, theme, bases)
    return out.getvalue(), code


if __name__ == "__main__":
    main()
