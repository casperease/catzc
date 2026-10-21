# ---
# catzc:
#   immutable:
#     with_body_sha: "10f670767545"
# ---

# cspell:ignore mxfile minimaps pnginfo XMLMATCH
"""Fail-forward render of a .drawio.png: always a source copy and a result PNG, warnings forwarded, never a silent stop.

usage: uv run --with pillow python drawio_forward.py <src.drawio.png> [<out_dir>] [--page dark|model]
                                                     [--xml <model.xml | file.drawio>] [--assert <text.md>]

Deterministic. <out_dir> defaults to renderer.out and --page to renderer.page of drawio.yml beside this script. Writes
into <out_dir>: <name>.src.drawio.png (a byte copy of the source), <name>.out.drawio.png (the raster re-rendered from
the embedded model on the chosen page, or the source copy again when no model can be read), <name>.model.xml (the
decoded model, when one exists) and <name>.render.md (the report). With --xml the given model must match the embedded
one 100 percent after canonicalisation. With --assert every non-empty, non-heading line of the text file (a page, 66
lines) must appear in some cell label, whitespace-folded and case-folded. Exit 0: clean. Exit 2: transport or assertion warnings, every artifact still delivered. Exit 3: no source
file, nothing to forward. Prints one line per artifact (`src`, `result`, `model`, `report`), one per warning (`warn`),
then `status`.

bulk:  uv run --with pillow python drawio_forward.py --all <root> [--theme <theme>]

Rebuilds every diagram under <root> in place (the pair `<article-folder>/.assets/<name>.drawio.png` and `<name>.drawio.yml`;
the root itself when it names one): each declared diagram is put in the theme, its minimaps drawn from their computed data with
it (ADR-REPO-SLIDES-MINIMAPSFROMDATA); a diagram without a declaration is left as it is, its model extracted to
out/drawio/bulk/<root>/models/ only to check its article's Supports line against its subtitle, and reported, because its
minimaps can be rebuilt only once it has a declaration. A theme other than the default puts the declared diagrams to
out/drawio/themes/<theme>/ and leaves the committed rasters and the diagrams without a declaration alone. A legend diagram (its
drawio.yml role) is rendered from the kit's glyphs.xml, painted in the default theme. Same exit codes;
the report is out/drawio/bulk/<root>/bulk.md.
"""

import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path

import minimaps
from drawio_png import DEFAULTS, THEMES, decode, encode, mxfile_chunk, paint, plain, render
from PIL import Image
from PIL.PngImagePlugin import PngInfo

PAGE_LINES = 66
# A transport failure of any step becomes a warning and the artifacts still land: the exceptions the steps can raise.
FORWARD = (
    OSError,
    ValueError,
    KeyError,
    AttributeError,
    RuntimeError,
    subprocess.SubprocessError,
    ET.ParseError,
    zlib.error,
)
KIT = Path(__file__).resolve().parent
REPO = KIT.parents[1]
ADR_CODE = re.compile(r"(?<![\w-])" + minimaps.kinds() + r"(?:-[A-Z][A-Z0-9]*)+(?![\w-])")
NUMBERED = re.compile(r"(?<![\w-])" + minimaps.kinds() + r"(?:-[A-Z][A-Z0-9]*)+(?:[#:]\d|#\{)")
SLIDE = ".drawio.png"  # a diagram's render, `<name>.drawio.png`, put from the `<name>.drawio.yml` beside it
SOURCE = ".drawio.yml"
ROLES = ("slide", "legend")  # the closed set of diagram roles drawio.yml may name


def slide_of(stem):
    """The render of the diagram whose stem is `.assets/<name>`."""
    stem = Path(stem)
    return stem.with_name(stem.name + SLIDE)


def normalise(text):
    return " ".join(text.split()).lower()


def canonical(xml_text):
    root = ET.fromstring(xml_text.strip())
    if root.tag == "mxfile":
        inner = root.find("diagram")
        if inner is None:
            raise ValueError("mxfile without a diagram element")
        model = inner.find("mxGraphModel")
        if model is None:
            model = ET.fromstring(decode(f"<diagram>{inner.text}</diagram>"))
        root = model
    if root.tag != "mxGraphModel":
        raise ValueError(f"root must be mxGraphModel, got {root.tag}")
    for el in root.iter():
        el.attrib = dict(sorted(el.attrib.items()))
        if el.text is not None and not el.text.strip():
            el.text = None
        if el.tail is not None and not el.tail.strip():
            el.tail = None
    return ET.tostring(root, encoding="unicode")


def first_difference(a, b):
    for i, (x, y) in enumerate(zip(a, b)):
        if x != y:
            return f"at char {i}: {a[max(0, i - 40) : i + 40]!r} vs {b[max(0, i - 40) : i + 40]!r}"
    return f"lengths differ: {len(a)} vs {len(b)}"


def slide_facts(model):
    """What a slide says it supports, from its `subtitle` cell alone (`<codes> · <lens>`): the ADR codes the index knows, the
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
    return adrs_of(subtitle), lens, problems


def diagram_role(folder):
    """A diagram's role: its entry under drawio.yml roles:, keyed by its stem's repository path, else renderer.role."""
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    role = DEFAULTS.get("roles", {}).get(path, DEFAULTS["renderer"]["role"])
    if role not in ROLES:
        raise ValueError(f"drawio.yml gives {path} the role '{role}', not one of {', '.join(ROLES)}")
    return role


def legend_model():
    """The kit's glyph library as a legend diagram's png carries it: glyphs.xml without its comments, its tokens painted in the
    default theme."""
    lines = (KIT / "assets" / "glyphs.xml").read_text(encoding="utf-8").splitlines()
    return paint("\n".join(line for line in lines if not line.lstrip().startswith("<!--")).strip())


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


def undeclared_warnings(folder, source):
    """A W_UNDECLARED warning for a slide with no declaration; a legend draws no minimaps, so it needs none and has none."""
    if diagram_role(folder) == "legend":
        return []
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    return [f"W_UNDECLARED {path}: no {source}, so its minimaps are not rebuilt; declare it to put it"]


def subtitle_facts(folder, model):
    """slide_facts for a slide, with each problem as a W_SUBTITLE warning; a legend names no ADR and carries no subtitle, so it has none."""
    if diagram_role(folder) == "legend":
        return [], None, []
    adrs, lens, problems = slide_facts(model)
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    return adrs, lens, [f"W_SUBTITLE {path}: {p}" for p in problems]


def known_adrs():
    """The ADR codes the index's code tables list; a code quoted in its prose is no entry."""
    return set(
        re.findall(
            r"(?m)^\|\s*`(" + minimaps.kinds() + r"(?:-[A-Z][A-Z0-9]*)+)`",
            (REPO / minimaps.records_root() / "index.md").read_text(encoding="utf-8"),
        )
    )


def adrs_of(text, known=None):
    """The ADRs a text cites, sorted: each code's longest prefix the index lists, so a rule's code names its ADR."""
    known = known_adrs() if known is None else known
    found = set()
    for code in ADR_CODE.findall(text):
        while code not in known and "-" in code:
            code = code.rsplit("-", 1)[0]
        if code in known:
            found.add(code)
    return sorted(found)


def supports_drift(folder, adrs, lens):
    """The article's `Supports … (<lens> lens)` line against the subtitle: the article is the one page beside the diagram's
    `.assets` that embeds the slide. Returns the warning, or None when they agree or no article line exists."""
    slide = slide_of(folder).resolve()
    for page in sorted(folder.parent.parent.glob("*.md")):
        text = page.read_text(encoding="utf-8")
        targets = re.findall(r"!\[[^\]]*\]\(([^)\s]+\.drawio\.png)\)", text)
        if not any((page.parent / t).resolve() == slide for t in targets):
            continue
        line = re.search(r"^Supports (.+?) \((\w+) lens\)\.?$", text, flags=re.MULTILINE)
        if line is None:
            return None
        said = (adrs_of(line.group(1)), line.group(2))
        if said != (adrs, lens):
            return f"{page.relative_to(REPO).as_posix()} says Supports {said[0]} ({said[1]} lens), the subtitle {adrs} ({lens} lens)"
        return None
    return None


def diagrams(root):
    """The diagrams under a root, by stem, or the root itself when it names one: each `<article-folder>/.assets/<name>` with a
    `<name>.drawio.png`, a `<name>.drawio.yml` whose first put has not been run yet, or a stem drawio.yml's carriers: puts in an article.
    The root may be a stem or a file of a pair."""
    root = Path(root)
    for suffix in (SLIDE, SOURCE):
        if root.name.endswith(suffix):
            root = root.with_name(root.name[: -len(suffix)])
    root = root.resolve()
    # A diagram in the article carrier has no yml beside its png, and before its first put no png either: drawio.yml names it.
    in_articles = {(REPO / stem).resolve() for stem, carrier in DEFAULTS.get("carriers", {}).items() if carrier == "article"}
    if root in in_articles or any(root.with_name(root.name + suffix).is_file() for suffix in (SLIDE, SOURCE)):
        return [root]
    if not root.is_dir():
        return []
    found = {p.with_name(p.name[: -len(suffix)]) for suffix in (SLIDE, SOURCE) for p in root.rglob(f"*{suffix}") if p.parent.name == ".assets"}
    found |= {stem for stem in in_articles if stem.is_relative_to(root)}
    return sorted(found)


def bulk(root, theme=None):
    """Rebuild every diagram under a root in place; returns the exit code after printing the lines and the report."""
    root = root.resolve()
    rel = lambda p: str(Path(p).resolve().relative_to(REPO)).replace("\\", "/")
    work = REPO / DEFAULTS["renderer"]["out"] / "bulk" / rel(root).replace("/", "--")
    models = work / "models"
    folders = diagrams(root)
    warnings, counts = [], {}
    if not folders:
        print(f"warn E_SOURCE no diagram (.assets/<name>{SLIDE}) under {root}")
        print("status error")
        return 3
    # A diagram with a declaration is put from it, minimaps included; a diagram without one is only checked and reported.
    import declaration

    declared = [f for f in folders if declaration.declared(f)]
    folders = [f for f in folders if f not in declared]
    # Only the default theme is committed; another theme renders the declared diagrams on demand to out/, and nothing else.
    themed = theme is not None and theme != THEMES[0]
    if themed:
        warnings += [f"W_THEME {rel(f)}: no declaration in its carrier, so it renders in the default theme only" for f in folders]
        folders = []
    put = 0
    for f in declared:
        try:
            # A conflicted pair waits for the author's put or get by name; the bulk run picks no side.
            both = [] if themed else declaration.conflict(f, declaration.committed(f))
            if both:
                warnings.append(f"W_CONFLICT {rel(f)}: the yml and the png both moved from HEAD and disagree in {', '.join(both)}")
                continue
            print(f"put {rel(declaration.put_png(f, declaration.load(f), theme))}")
            put += 1
        except (declaration.DeclarationError, OSError) as e:
            warnings.append(f"W_PUT {rel(f)}: {e}")
    counts.update(put=put)
    # A legend diagram is drawn from the glyph library, in the default theme only, so it renders and is never left to be checked.
    legends = [f for f in folders if diagram_role(f) == "legend"]
    folders = [f for f in folders if f not in legends]
    for f in legends:
        try:
            print(f"put {rel(put_legend(f))}")
        except FORWARD as e:
            warnings.append(f"W_PUT {rel(f)}: {e}")
    counts.update(legends=len(legends))
    model_of =lambda f: models / (rel(f).replace("/", "--") + ".model.xml")
    models.mkdir(parents=True, exist_ok=True)
    done = 0
    for f in folders:
        try:
            model_of(f).write_text(decode(mxfile_chunk(Image.open(slide_of(f)))).strip(), encoding="utf-8")
            done += 1
        except FORWARD as e:
            warnings.append(f"W_PREPARE {rel(f)}: {e}")
    for f in folders:
        if not model_of(f).is_file():
            continue
        adrs, lens, subtitle_warnings = subtitle_facts(f, model_of(f).read_text(encoding="utf-8"))
        warnings += subtitle_warnings
        if adrs and lens is not None:
            drift = supports_drift(f, adrs, lens)
            if drift:
                warnings.append(f"W_SUPPORTS {drift}")
        warnings += undeclared_warnings(f, declaration.source_of(f).name if declaration.carrier_of(f) == "file" else f"`{declaration.FENCE}` block")
    counts.update(prepared=done, undeclared=len(folders))
    for w in warnings:
        print(f"warn {w}")
    status = "ok" if not warnings else "warn"
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
        f"- warning: {w}" for w in warnings
    ]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"report {report}")
    print(f"status {status}")
    return 0 if not warnings else 2


def main():
    args = sys.argv[1:]
    if "--all" in args:
        i = args.index("--all")
        folder = Path(args[i + 1])
        del args[i : i + 2]
        theme = None
        if "--theme" in args:
            i = args.index("--theme")
            theme = args[i + 1]
            del args[i : i + 2]
            if theme not in THEMES:
                raise SystemExit(f"theme '{theme}' is not one of: {', '.join(THEMES)}")
        raise SystemExit(bulk(folder, theme))
    xml_path = assert_path = root = None
    page = None
    for flag in ("--xml", "--assert", "--page"):
        if flag in args:
            i = args.index(flag)
            value = args[i + 1]
            del args[i : i + 2]
            if flag == "--xml":
                xml_path = Path(value)
            elif flag == "--assert":
                assert_path = Path(value)
            else:
                page = value
    src = Path(args[0])
    out_dir = Path(args[1]) if len(args) > 1 else REPO / DEFAULTS["renderer"]["out"]
    page = page or DEFAULTS["renderer"]["page"]
    if not src.is_file():
        print(f"warn E_SOURCE no such file: {src}")
        print("status error")
        raise SystemExit(3)
    out_dir.mkdir(parents=True, exist_ok=True)
    name = src.name.replace(SLIDE, "")
    src_copy = out_dir / f"{name}.src.drawio.png"
    result = out_dir / f"{name}.out.drawio.png"
    model_file = out_dir / f"{name}.model.xml"
    report = out_dir / f"{name}.render.md"
    warnings = []
    cells = 0
    shutil.copyfile(src, src_copy)
    print(f"src {src_copy}")

    model = None
    try:
        chunk = mxfile_chunk(Image.open(src))
        model = decode(chunk).strip()
    except FORWARD as e:  # a transport failure is a warning, the source copy stands in for the result
        warnings.append(f"W_CHUNK no readable mxfile chunk in the source: {e}")

    if model is not None:
        model_file.write_text(model, encoding="utf-8")
        print(f"model {model_file}")
        try:
            root = ET.fromstring(model)
            ids = [c.get("id") for c in root.iter("mxCell")]
            cells = len(ids)
            dup = sorted({i for i in ids if i is not None and ids.count(i) > 1})
            if dup:
                warnings.append(f"W_IDS duplicate cell ids: {dup}")
            img = render(root, page).convert("RGB")
            info = PngInfo()
            info.add_text("mxfile", encode(model, name))
            img.save(result, "PNG", pnginfo=info)
            back = decode(mxfile_chunk(Image.open(result)))
            if back != model:
                warnings.append(
                    "W_ROUNDTRIP the result's embedded model differs from the source model"
                )
        except FORWARD as e:
            warnings.append(f"W_RENDER the model could not be rendered: {e}")
            shutil.copyfile(src, result)
    else:
        shutil.copyfile(src, result)
    print(f"result {result}")

    if xml_path is not None:
        if not xml_path.is_file():
            warnings.append(f"W_XML no such model file: {xml_path}")
        elif model is None:
            warnings.append(
                "W_XML a model file was given but the source carries no model to compare"
            )
        else:
            try:
                given, embedded = (
                    canonical(xml_path.read_text(encoding="utf-8")),
                    canonical(model),
                )
                if given != embedded:
                    warnings.append(
                        f"W_XMLMATCH given model differs from the embedded one {first_difference(given, embedded)}"
                    )
            except FORWARD as e:
                warnings.append(f"W_XML the given model could not be read: {e}")

    if assert_path is not None:
        if not assert_path.is_file():
            warnings.append(f"W_ASSERT no such text file: {assert_path}")
        elif root is None:
            warnings.append(
                "W_ASSERT a text file was given but the source carries no model to assert against"
            )
        else:
            phrases = [
                normalise(line)
                for line in assert_path.read_text(encoding="utf-8").splitlines()
            ]
            phrases = [p for p in phrases if p and not p.startswith("#")]
            if len(phrases) > PAGE_LINES:
                warnings.append(
                    f"W_PAGE {len(phrases)} asserted lines, a page is {PAGE_LINES}; all were checked"
                )
            labels = " | ".join(
                normalise(plain(c.get("value") or "")) for c in root.iter("mxCell")
            )
            for p in [p for p in phrases if p not in labels]:
                warnings.append(f"W_TEXT asserted text not in any cell label: {p!r}")

    for w in warnings:
        print(f"warn {w}")
    status = "ok" if not warnings else "warn"
    lines = [
        f"# {name}: fail-forward render",
        "",
        f"- source: `{src}`",
        f"- source copy: `{src_copy}`",
        f"- result: `{result}` (page {page})",
        f"- model: `{model_file}`" if model is not None else "- model: none",
        f"- cells: {cells}",
        f"- status: {status}",
    ] + [f"- warning: {w}" for w in warnings]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"report {report}")
    print(f"status {status}")
    raise SystemExit(0 if not warnings else 2)


if __name__ == "__main__":
    main()
