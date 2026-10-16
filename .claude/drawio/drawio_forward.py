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

# cspell:ignore mxfile
"""Fail-forward render of a .drawio.png: always a source copy and a result PNG, warnings forwarded, never a silent stop.

usage: uv run --with pillow python drawio_forward.py <src.drawio.png> <out_dir> [--xml <model.xml | file.drawio>]
                                                     [--assert <text.md>]

Deterministic. Writes into <out_dir>: <name>.src.drawio.png (a byte copy of the source), <name>.out.drawio.png (the raster
re-rendered from the embedded model, or the source copy again when no model can be read), <name>.model.xml (the decoded
model, when one exists) and <name>.render.md (the report). With --xml the given model must match the embedded one
100 percent after canonicalisation. With --assert every non-empty, non-heading line of the text file (a page, 66 lines)
must appear in some cell label, whitespace-folded and case-folded. Exit 0: clean. Exit 2: transport or assertion
warnings, every artifact still delivered. Exit 3: no source file, nothing to forward. Prints one line per artifact
(`src`, `result`, `model`, `report`), one per warning (`warn`), then `status`.
"""
import shutil
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image
from PIL.PngImagePlugin import PngInfo

from drawio_png import decode, encode, plain, render

PAGE_LINES = 66


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


def main():
    args = sys.argv[1:]
    xml_path = assert_path = root = None
    if "--xml" in args:
        i = args.index("--xml")
        xml_path = Path(args[i + 1])
        del args[i:i + 2]
    if "--assert" in args:
        i = args.index("--assert")
        assert_path = Path(args[i + 1])
        del args[i:i + 2]
    src, out_dir = Path(args[0]), Path(args[1])
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
            img = render(root).convert("RGB")
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
        elif model is None:
            warnings.append("W_ASSERT a text file was given but the source carries no model to assert against")
        else:
            phrases = [normalise(line) for line in assert_path.read_text(encoding="utf-8").splitlines()]
            phrases = [p for p in phrases if p and not p.startswith("#")]
            if len(phrases) > PAGE_LINES:
                warnings.append(f"W_PAGE {len(phrases)} asserted lines, a page is {PAGE_LINES}; all were checked")
            labels = " | ".join(normalise(plain(c.get("value") or "")) for c in root.iter("mxCell"))
            missing = [p for p in phrases if p not in labels]
            for p in missing:
                warnings.append(f"W_TEXT asserted text not in any cell label: {p!r}")

    for w in warnings:
        print(f"warn {w}")
    status = "ok" if not warnings else "warn"
    lines = [
        f"# {name}: fail-forward render",
        "",
        f"- source: `{src}`",
        f"- source copy: `{src_copy}`",
        f"- result: `{result}`",
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
