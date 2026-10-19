# cspell:ignore mxfile minimaps pnginfo XMLMATCH
"""Fail-forward render of a .drawio.png: always a source copy and a result PNG, warnings forwarded, never a silent stop.

usage: uv run --with pillow python drawio_forward.py <src.drawio.png> [<out_dir>] [--page dark|model]
                                                     [--xml <model.xml | file.drawio>] [--assert <text.md>] [--minimaps]

Deterministic. <out_dir> defaults to renderer.out and --page to renderer.page of drawio.yml beside this script. Writes
into <out_dir>: <name>.src.drawio.png (a byte copy of the source), <name>.out.drawio.png (the raster re-rendered from
the embedded model on the chosen page, or the source copy again when no model can be read), <name>.model.xml (the
decoded model, when one exists) and <name>.render.md (the report). With --xml the given model must match the embedded
one 100 percent after canonicalisation. With --assert every non-empty, non-heading line of the text file (a page, 66
lines) must appear in some cell label, whitespace-folded and case-folded. With --minimaps the slide's three minimaps are
regenerated from the map processors (Export-MinimapData, minimap_render.py, Update-MinimapPageHead, minimap_join.py) into <out_dir>/<name>/, a
diagram folder of its own: ADR codes and lens from the model's `subtitle` cell (`<codes> · <lens>`, the lens one of
drawio.yml `lenses`), the article the one page beside the source's `.assets` that embeds it; the joined slide is
<out_dir>/<name>/diagram.drawio.png. A slide named diagram.drawio.png is named <name> by its folder.
Exit 0: clean. Exit 2: transport or assertion warnings, every artifact still delivered. Exit 3: no source file,
nothing to forward. Prints one line per artifact (`src`, `result`, `model`, `report`, `slide`), one per warning (`warn`),
then `status`.

bulk:  uv run --with pillow python drawio_forward.py --all <root> [--stage prepare|highlight|join|all] [--migrate]
                                                      [--start A --end B]

Rebuilds every diagram folder under <root> in place (`<article-folder>/.assets/<name>/` holding diagram.drawio.png; the
root itself when it is one), in stages that each fit the time safeguard: `prepare` (optionally migrates each slide to the
dark tokens, extracts its model to out/drawio/bulk/<root>/models/, reads its subtitle, checks the article's Supports line,
and writes the slide list, skipping a slide with no ADR code); `highlight` (the map processors for the listed slides, then
grid, tree and chain as .png and .md beside each slide, each page given its generated head by Update-MinimapPageHead); `join` (the
sidebar laid out, the minimaps embedded, the slide rebuilt); `all` runs the three. --start/--end slice the slide list of
the per-slide stages. Same exit codes; the report is out/drawio/bulk/<root>/bulk.md.
"""

import json
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path

from drawio_png import DEFAULTS, decode, encode, mxfile_chunk, plain, render
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
ADR_CODE = re.compile(r"(?<![\w-])ADR(?:-[A-Z][A-Z0-9]*)+(?![\w-])")
NUMBERED = re.compile(r"(?<![\w-])ADR(?:-[A-Z][A-Z0-9]*)+(?:[#:]\d|#\{)")
SLIDE = "diagram.drawio.png"  # a diagram folder's slide; its minimaps are <view>.png and <view>.md beside it
ROLES = ("slide", "legend")  # the closed set of diagram-folder roles drawio.yml may name


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


def catzc_command(command):
    """A catzc command run in a fresh pwsh that loads the repository's importer first: the PowerShell steps of the pipeline."""
    importer = str(REPO / "importer.ps1").replace("'", "''")
    return ["pwsh", "-NoProfile", "-Command", f". '{importer}' *> $null; {command}"]


def run(cmd, seconds):
    """One pipeline step; its failure is the caller's warning, with the tail of what it said."""
    done = subprocess.run(
        cmd, cwd=REPO, capture_output=True, text=True, timeout=seconds, check=False
    )
    if done.returncode != 0:
        tail = (done.stderr.strip() or done.stdout.strip()).splitlines()[-3:]
        step = cmd[-1].split(";")[-1].split()[0] if cmd[0] == "pwsh" else Path(cmd[1]).name
        raise RuntimeError(
            f"{step} rc={done.returncode}: {' | '.join(tail)}"
        )
    return done.stdout.strip()


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
            f"the subtitle cites a rule by number, a rule is cited by its name (ADR-REPO-ADRCODE): {subtitle!r}"
        )
    return adrs_of(subtitle), lens, problems


def folder_role(folder):
    """A diagram folder's role: its entry under drawio.yml roles:, keyed by repository path, else renderer.role."""
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    role = DEFAULTS.get("roles", {}).get(path, DEFAULTS["renderer"]["role"])
    if role not in ROLES:
        raise ValueError(f"drawio.yml gives {path} the role '{role}', not one of {', '.join(ROLES)}")
    return role


def subtitle_facts(folder, model):
    """slide_facts for a slide, with each problem as a W_SUBTITLE warning; a legend names no ADR and carries no subtitle, so it has none."""
    if folder_role(folder) == "legend":
        return [], None, []
    adrs, lens, problems = slide_facts(model)
    path = str(Path(folder).resolve().relative_to(REPO)).replace("\\", "/")
    return adrs, lens, [f"W_SUBTITLE {path}: {p}" for p in problems]


def known_adrs():
    """The ADR codes the index's code tables list; a code quoted in its prose is no entry."""
    return set(
        re.findall(
            r"(?m)^\|\s*`(ADR(?:-[A-Z][A-Z0-9]*)+)`",
            (REPO / "docs" / "adr" / "index.md").read_text(encoding="utf-8"),
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
    """The article's `Supports … (<lens> lens)` line against the subtitle: the article is the one page beside the folder's
    `.assets` that embeds the slide. Returns the warning, or None when they agree or no article line exists."""
    slide = (folder / SLIDE).resolve()
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


def slide_entry(folder, source, model_file, adrs, lens):
    """One slide of the list the map processors read: its diagram folder is its id and where every output lands."""
    rel = lambda p: str(Path(p).resolve().relative_to(REPO)).replace("\\", "/")
    return {
        "id": rel(folder),
        "stem": Path(folder).name,
        "folder": rel(folder),
        "source": rel(source),
        "lens": lens,
        "badge": DEFAULTS["lenses"][lens],
        "adrs": adrs,
        "xml": rel(model_file),
    }


def diagram_folders(root):
    """The diagram folders under a root, or the root itself when it is one: each `<article-folder>/.assets/<name>/` that
    holds a diagram.drawio.png."""
    root = root.resolve()
    if (root / SLIDE).is_file():
        return [root]
    return sorted(
        p.parent for p in root.rglob(SLIDE) if p.parent.parent.name == ".assets"
    )


def minimaps(src, name, model_file, out_dir):
    """Regenerate the slide's three minimaps and the joined slide into out_dir/name, a diagram folder of its own; the
    article is the source slide's. Returns the joined slide path."""
    adrs, lens, problems = slide_facts(model_file.read_text(encoding="utf-8"))
    if problems or not adrs:
        raise RuntimeError(
            "; ".join(problems) or "the subtitle names no ADR code to light the minimaps from"
        )
    target = out_dir / name
    data = target / "minimaps-data"
    target.mkdir(parents=True, exist_ok=True)
    slides = target / "slides.json"
    slide = slide_entry(target, src, model_file, adrs, lens)
    slides.write_text(
        json.dumps({"slides": [slide]}, indent=1) + "\n", encoding="utf-8"
    )
    rel = lambda p: str(p.resolve().relative_to(REPO)).replace("\\", "/")
    run(catzc_command(f"Export-MinimapData -Slides '{rel(slides)}' -Data '{rel(data)}'"), 240)
    run(
        [
            sys.executable,
            str(KIT / "minimap_render.py"),
            "--slides",
            rel(slides),
            "--data",
            rel(data),
        ],
        60,
    )
    run(catzc_command(f"Update-MinimapPageHead -Slides '{rel(slides)}'"), 240)
    run(
        [
            sys.executable,
            str(KIT / "minimap_join.py"),
            "--slides",
            rel(slides),
            "--data",
            rel(data),
        ],
        60,
    )
    joined = target / SLIDE
    if not joined.is_file():
        raise RuntimeError("minimap_join.py ended without the joined slide")
    return joined


def bulk(root, stage, migrate, start, end):
    """Rebuild every diagram folder under a root in place, by stage; returns the exit code after printing the lines and the
    report. The per-slide stages take the slice start..end of the folder list."""
    root = root.resolve()
    rel = lambda p: str(Path(p).resolve().relative_to(REPO)).replace("\\", "/")
    work = REPO / DEFAULTS["renderer"]["out"] / "bulk" / rel(root).replace("/", "--")
    models, data = work / "models", work / "data"
    slides_json, slice_json = work / "slides.json", work / "slice.json"
    folders = diagram_folders(root)
    warnings, counts = [], {}
    if not folders:
        print(f"warn E_SOURCE no diagram folder (.assets/<name>/{SLIDE}) under {root}")
        print("status error")
        return 3
    model_of = lambda f: models / (rel(f).replace("/", "--") + ".model.xml")
    if stage in ("prepare", "all"):
        models.mkdir(parents=True, exist_ok=True)
        done = 0
        for f in folders:
            try:
                if migrate:
                    run(
                        [sys.executable, str(KIT / "migrate_dark.py"), str(f / SLIDE), str(f / SLIDE)],
                        120,
                    )
                model_of(f).write_text(
                    decode(mxfile_chunk(Image.open(f / SLIDE))).strip(), encoding="utf-8"
                )
                done += 1
            except FORWARD as e:
                warnings.append(f"W_PREPARE {rel(f)}: {e}")
        slides, skipped = [], []
        for f in folders:
            if not model_of(f).is_file():
                continue
            adrs, lens, subtitle_warnings = subtitle_facts(f, model_of(f).read_text(encoding="utf-8"))
            warnings += subtitle_warnings
            if not adrs or lens is None:
                skipped.append(rel(f))
                continue
            drift = supports_drift(f, adrs, lens)
            if drift:
                warnings.append(f"W_SUPPORTS {drift}")
            slides.append(slide_entry(f, f / SLIDE, model_of(f), adrs, lens))
        slides_json.write_text(
            json.dumps({"slides": slides}, indent=1) + "\n", encoding="utf-8"
        )
        counts.update(prepared=done, listed=len(slides), skipped=skipped)
        print(f"slides {slides_json} listed={len(slides)} skipped={skipped}")
    if stage in ("highlight", "all"):
        try:
            listed = json.loads(slides_json.read_text(encoding="utf-8"))["slides"]
            slice_json.write_text(
                json.dumps({"slides": listed[start:end]}, indent=1) + "\n", encoding="utf-8"
            )
            run(catzc_command(f"Export-MinimapData -Slides '{rel(slice_json)}' -Data '{rel(data)}'"), 300)
            out = run(
                [
                    sys.executable,
                    str(KIT / "minimap_render.py"),
                    "--slides",
                    rel(slice_json),
                    "--data",
                    rel(data),
                ],
                120,
            )
            print(f"minimaps {out.splitlines()[-1] if out else 'rendered'}")
            stamped = run(catzc_command(f"Update-MinimapPageHead -Slides '{rel(slice_json)}'"), 300)
            print(stamped.splitlines()[-1] if stamped else "stamped")
        except FORWARD as e:
            warnings.append(f"W_HIGHLIGHT {e}")
    if stage in ("join", "all"):
        try:
            cmd = [
                sys.executable,
                str(KIT / "minimap_join.py"),
                "--slides",
                rel(slides_json),
                "--data",
                rel(data),
                "--start",
                str(start),
            ]
            if end is not None:
                cmd += ["--end", str(end)]
            out = run(cmd, 340)
            print(f"joined {out.splitlines()[-1] if out else 'done'}")
        except FORWARD as e:
            warnings.append(f"W_JOIN {e}")
    for w in warnings:
        print(f"warn {w}")
    status = "ok" if not warnings else "warn"
    work.mkdir(parents=True, exist_ok=True)
    report = work / "bulk.md"
    lines = [
        f"# {rel(root)}: bulk rebuild, stage {stage}",
        "",
        f"- root: `{root}`",
        f"- diagram folders: {len(folders)}",
        f"- slice: {start}..{end if end is not None else len(folders)}",
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
        stage, migrate, start, end = "all", False, 0, None
        if "--stage" in args:
            i = args.index("--stage")
            stage = args[i + 1]
            del args[i : i + 2]
        if "--migrate" in args:
            args.remove("--migrate")
            migrate = True
        if "--start" in args:
            i = args.index("--start")
            start = int(args[i + 1])
            del args[i : i + 2]
        if "--end" in args:
            i = args.index("--end")
            end = int(args[i + 1])
            del args[i : i + 2]
        if stage not in ("prepare", "highlight", "join", "all"):
            raise SystemExit(
                f"stage must be prepare, highlight, join or all, got {stage}"
            )
        raise SystemExit(bulk(folder, stage, migrate, start, end))
    xml_path = assert_path = root = None
    page, want_minimaps = None, False
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
    if "--minimaps" in args:
        args.remove("--minimaps")
        want_minimaps = True
    src = Path(args[0])
    out_dir = Path(args[1]) if len(args) > 1 else REPO / DEFAULTS["renderer"]["out"]
    page = page or DEFAULTS["renderer"]["page"]
    if not src.is_file():
        print(f"warn E_SOURCE no such file: {src}")
        print("status error")
        raise SystemExit(3)
    out_dir.mkdir(parents=True, exist_ok=True)
    # A diagram folder's slide is named by its folder; any other .drawio.png by its own stem.
    name = src.parent.name if src.name == SLIDE else src.name.replace(".drawio.png", "")
    src_copy = out_dir / f"{name}.src.drawio.png"
    result = out_dir / f"{name}.out.drawio.png"
    model_file = out_dir / f"{name}.model.xml"
    report = out_dir / f"{name}.render.md"
    warnings = []
    cells = 0
    joined = None
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

    if want_minimaps:
        if model is None:
            warnings.append("W_MINIMAPS no model to build the slide from")
        else:
            try:
                joined = minimaps(src, name, model_file, out_dir)
                print(f"slide {joined}")
            except FORWARD as e:
                warnings.append(f"W_MINIMAPS {e}")

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
        f"- slide with minimaps: `{joined}`"
        if joined is not None
        else "- slide with minimaps: not requested"
        if not want_minimaps
        else "- slide with minimaps: failed, see warnings",
        f"- cells: {cells}",
        f"- status: {status}",
    ] + [f"- warning: {w}" for w in warnings]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"report {report}")
    print(f"status {status}")
    raise SystemExit(0 if not warnings else 2)


if __name__ == "__main__":
    main()
