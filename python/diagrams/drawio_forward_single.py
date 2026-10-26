# cspell:ignore mxfile pnginfo XMLMATCH
"""The fail-forward render of one .drawio.png: a source copy and a result PNG always land, every transport or assertion failure a
finding, the model compared with a given one and the cell labels with a text page."""

import shutil
import subprocess
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path

from PIL import Image
from PIL.PngImagePlugin import PngInfo

from .drawio_png import DEFAULTS, decode, encode, mxfile_chunk, plain, render
from .module_paths import REPO

PAGE_LINES = 66
# A transport failure of any step becomes a finding and the artifacts still land: the exceptions the steps can raise.
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
FINDINGS_EXIT = 2 if DEFAULTS["renderer"]["findings-fail"] == "yes" else 0  # the exit of a run with findings: every finding is an error, one setting for all
SLIDE = ".drawio.png"  # a diagram's render, `<name>.drawio.png`, put from the `<name>.drawio.yml` beside it


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


def forward_one(args):
    """Render one source png (the argument list left once the flags of the bulk mode are out) and exit with the run's code."""
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
        print(f"error E_SOURCE no such file: {src}")
        print("status error")
        raise SystemExit(3)
    out_dir.mkdir(parents=True, exist_ok=True)
    name = src.name.replace(SLIDE, "")
    src_copy = out_dir / f"{name}.src.drawio.png"
    result = out_dir / f"{name}.out.drawio.png"
    model_file = out_dir / f"{name}.model.xml"
    report = out_dir / f"{name}.render.md"
    findings = []
    cells = 0
    shutil.copyfile(src, src_copy)
    print(f"src {src_copy}")

    model = None
    try:
        chunk = mxfile_chunk(Image.open(src))
        model = decode(chunk).strip()
    except FORWARD as e:  # a transport failure is a finding, the source copy stands in for the result
        findings.append(f"E_CHUNK no readable mxfile chunk in the source: {e}")

    if model is not None:
        model_file.write_text(model, encoding="utf-8")
        print(f"model {model_file}")
        try:
            root = ET.fromstring(model)
            ids = [c.get("id") for c in root.iter("mxCell")]
            cells = len(ids)
            dup = sorted({i for i in ids if i is not None and ids.count(i) > 1})
            if dup:
                findings.append(f"E_IDS duplicate cell ids: {dup}")
            img = render(root, page).convert("RGB")
            info = PngInfo()
            info.add_text("mxfile", encode(model, name))
            img.save(result, "PNG", pnginfo=info)
            back = decode(mxfile_chunk(Image.open(result)))
            if back != model:
                findings.append(
                    "E_ROUNDTRIP the result's embedded model differs from the source model"
                )
        except FORWARD as e:
            findings.append(f"E_RENDER the model could not be rendered: {e}")
            shutil.copyfile(src, result)
    else:
        shutil.copyfile(src, result)
    print(f"result {result}")

    if xml_path is not None:
        if not xml_path.is_file():
            findings.append(f"E_XML no such model file: {xml_path}")
        elif model is None:
            findings.append(
                "E_XML a model file was given but the source carries no model to compare"
            )
        else:
            try:
                given, embedded = (
                    canonical(xml_path.read_text(encoding="utf-8")),
                    canonical(model),
                )
                if given != embedded:
                    findings.append(
                        f"E_XMLMATCH given model differs from the embedded one {first_difference(given, embedded)}"
                    )
            except FORWARD as e:
                findings.append(f"E_XML the given model could not be read: {e}")

    if assert_path is not None:
        if not assert_path.is_file():
            findings.append(f"E_ASSERT no such text file: {assert_path}")
        elif root is None:
            findings.append(
                "E_ASSERT a text file was given but the source carries no model to assert against"
            )
        else:
            phrases = [
                normalise(line)
                for line in assert_path.read_text(encoding="utf-8").splitlines()
            ]
            phrases = [p for p in phrases if p and not p.startswith("#")]
            if len(phrases) > PAGE_LINES:
                findings.append(
                    f"E_PAGE {len(phrases)} asserted lines, a page is {PAGE_LINES}; all were checked"
                )
            labels = " | ".join(
                normalise(plain(c.get("value") or "")) for c in root.iter("mxCell")
            )
            for p in [p for p in phrases if p not in labels]:
                findings.append(f"E_TEXT asserted text not in any cell label: {p!r}")

    for w in findings:
        print(f"error {w}")
    status = "ok" if not findings else "error"
    lines = [
        f"# {name}: fail-forward render",
        "",
        f"- source: `{src}`",
        f"- source copy: `{src_copy}`",
        f"- result: `{result}` (page {page})",
        f"- model: `{model_file}`" if model is not None else "- model: none",
        f"- cells: {cells}",
        f"- status: {status}",
    ] + [f"- error: {w}" for w in findings]
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"report {report}")
    print(f"status {status}")
    raise SystemExit(FINDINGS_EXIT if findings else 0)
