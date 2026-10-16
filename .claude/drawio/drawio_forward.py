# ---
# catzc:
#   immutable:
#     path: ".claude/drawio/drawio_forward.py"
#     folder: drawio
#     name: drawio-forward
#     filetype: py
#     kind: drawio-kit
#     language: python
#     track: ".claude"
#     tracktype: vendor-settings
#     vendor: claude
#     module: ".claude"
#     moduletype: settings
# ---

# cspell:ignore mxfile minimaps
"""Fail-forward render of a .drawio.png: always a source copy and a result PNG, warnings forwarded, never a silent stop.

usage: uv run --with pillow python drawio_forward.py <src.drawio.png> [<out_dir>] [--page dark|model]
                                                     [--xml <model.xml | file.drawio>] [--assert <text.md>] [--minimaps]

Deterministic. <out_dir> defaults to renderer.out and --page to renderer.page of drawio.yml beside this script. Writes
into <out_dir>: <name>.src.drawio.png (a byte copy of the source), <name>.out.drawio.png (the raster re-rendered from
the embedded model on the chosen page, or the source copy again when no model can be read), <name>.model.xml (the
decoded model, when one exists) and <name>.render.md (the report). With --xml the given model must match the embedded
one 100 percent after canonicalisation. With --assert every non-empty, non-heading line of the text file (a page, 66
lines) must appear in some cell label, whitespace-folded and case-folded. With --minimaps the slide's three minimaps are
regenerated from the map processors (minimaps/highlights.ps1, render.py, join.py) into <out_dir>/<name>/, the slide
list derived from the slide itself: id and stem from the file name, lens from the last `--` segment, ADR codes from the
sister <name>.drawio.md, the model from <name>.model.xml; the joined slide is <out_dir>/<name>/<name>.drawio.png.
Exit 0: clean. Exit 2: transport or assertion warnings, every artifact still delivered. Exit 3: no source file,
nothing to forward. Prints one line per artifact (`src`, `result`, `model`, `report`, `slide`), one per warning (`warn`),
then `status`.
"""
import json
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image
from PIL.PngImagePlugin import PngInfo

from drawio_png import DEFAULTS, decode, encode, plain, render

PAGE_LINES = 66
KIT = Path(__file__).resolve().parent
REPO = KIT.parents[1]
ADR_CODE = re.compile(r"ADR-[A-Z]+(?:-[A-Z]+)*")


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
            return f"at char {i}: {a[max(0, i - 40):i + 40]!r} vs {b[max(0, i - 40):i + 40]!r}"
    return f"lengths differ: {len(a)} vs {len(b)}"


def run(cmd, seconds):
    """One pipeline step; its failure is the caller's warning, with the tail of what it said."""
    done = subprocess.run(cmd, cwd=REPO, capture_output=True, text=True, timeout=seconds)
    if done.returncode != 0:
        tail = (done.stderr.strip() or done.stdout.strip()).splitlines()[-3:]
        raise RuntimeError(f"{Path(cmd[-1] if cmd[0] == 'pwsh' else cmd[2]).name} rc={done.returncode}: {' | '.join(tail)}")
    return done.stdout.strip()


def minimaps(src, name, model_file, out_dir):
    """Regenerate the slide's three minimaps and the joined slide into out_dir/name; returns the joined slide path."""
    sister = src.with_name(f"{name}.drawio.md")
    if not sister.is_file():
        raise RuntimeError(f"no sister {sister.name} to read the slide's ADR codes from")
    text = sister.read_text(encoding="utf-8")
    head = text[3:].split("\n---", 1)[0] if text.startswith("---") else ""
    cites = head.split("cites:", 1)[1].split("links:", 1)[0] if "cites:" in head else ""
    adrs = sorted(set(ADR_CODE.findall(cites)))
    if not adrs:
        raise RuntimeError(f"{sister.name} cites no ADR code in its head")
    target = out_dir / name
    data = target / "minimaps-data"
    target.mkdir(parents=True, exist_ok=True)
    slides = target / "slides.json"
    slide = {"id": name, "stem": name, "lens": name.rsplit("--", 1)[-1], "adrs": adrs, "xml": str(model_file.resolve())}
    slides.write_text(json.dumps({"slides": [slide]}, indent=1) + "\n", encoding="utf-8")
    rel = lambda p: str(p.resolve().relative_to(REPO)).replace("\\", "/")
    run(["pwsh", "-NoProfile", "-File", str(KIT / "minimaps" / "highlights.ps1"), "-Slides", rel(slides), "-Data", rel(data)], 240)
    run([sys.executable, str(KIT / "minimaps" / "render.py"), "--slides", rel(slides), "--data", rel(data), "--target", rel(target)], 60)
    run([sys.executable, str(KIT / "minimaps" / "join.py"), "--slides", rel(slides), "--data", rel(data), "--target", rel(target)], 60)
    joined = target / f"{name}.drawio.png"
    if not joined.is_file():
        raise RuntimeError("join.py ended without the joined slide")
    return joined


def main():
    args = sys.argv[1:]
    xml_path = assert_path = root = None
    page, want_minimaps = None, False
    for flag in ("--xml", "--assert", "--page"):
        if flag in args:
            i = args.index(flag)
            value = args[i + 1]
            del args[i:i + 2]
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
    name = src.name.replace(".drawio.png", "")
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
        chunk = Image.open(src).text["mxfile"]
        model = decode(chunk).strip()
    except Exception as e:  # a transport failure is a warning, the source copy stands in for the result
        warnings.append(f"W_CHUNK no readable mxfile chunk in the source: {e}")

    if model is not None:
        model_file.write_text(model, encoding="utf-8")
        print(f"model {model_file}")
        try:
            root = ET.fromstring(model)
            ids = [c.get("id") for c in root.iter("mxCell")]
            cells = len(ids)
            dup = sorted({i for i in ids if ids.count(i) > 1})
            if dup:
                warnings.append(f"W_IDS duplicate cell ids: {dup}")
            img = render(root, page).convert("RGB")
            info = PngInfo()
            info.add_text("mxfile", encode(model, name))
            img.save(result, "PNG", pnginfo=info)
            back = decode(Image.open(result).text["mxfile"])
            if back != model:
                warnings.append("W_ROUNDTRIP the result's embedded model differs from the source model")
        except Exception as e:
            warnings.append(f"W_RENDER the model could not be rendered: {e}")
            shutil.copyfile(src, result)
    else:
        shutil.copyfile(src, result)
    print(f"result {result}")

    if xml_path is not None:
        if not xml_path.is_file():
            warnings.append(f"W_XML no such model file: {xml_path}")
        elif model is None:
            warnings.append("W_XML a model file was given but the source carries no model to compare")
        else:
            try:
                given, embedded = canonical(xml_path.read_text(encoding="utf-8")), canonical(model)
                if given != embedded:
                    warnings.append(f"W_XMLMATCH given model differs from the embedded one {first_difference(given, embedded)}")
            except Exception as e:
                warnings.append(f"W_XML the given model could not be read: {e}")

    if assert_path is not None:
        if not assert_path.is_file():
            warnings.append(f"W_ASSERT no such text file: {assert_path}")
        elif root is None:
            warnings.append("W_ASSERT a text file was given but the source carries no model to assert against")
        else:
            phrases = [normalise(line) for line in assert_path.read_text(encoding="utf-8").splitlines()]
            phrases = [p for p in phrases if p and not p.startswith("#")]
            if len(phrases) > PAGE_LINES:
                warnings.append(f"W_PAGE {len(phrases)} asserted lines, a page is {PAGE_LINES}; all were checked")
            labels = " | ".join(normalise(plain(c.get("value") or "")) for c in root.iter("mxCell"))
            for p in [p for p in phrases if p not in labels]:
                warnings.append(f"W_TEXT asserted text not in any cell label: {p!r}")

    if want_minimaps:
        if model is None:
            warnings.append("W_MINIMAPS no model to build the slide from")
        else:
            try:
                joined = minimaps(src, name, model_file, out_dir)
                print(f"slide {joined}")
            except Exception as e:
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
        f"- slide with minimaps: `{joined}`" if joined is not None else "- slide with minimaps: not requested" if not want_minimaps else "- slide with minimaps: failed, see warnings",
        f"- cells: {cells}",
        f"- status: {status}",
    ] + [f"- warning: {w}" for w in warnings]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"report {report}")
    print(f"status {status}")
    raise SystemExit(0 if not warnings else 2)


if __name__ == "__main__":
    main()
