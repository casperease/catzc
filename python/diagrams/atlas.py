# cspell:ignore minimaps lightbox
"""Build the clickable review page for claude.ai: out/atlas.html plus the list of files it references.

usage: uv run -q python python/diagrams/atlas.py

Writes out/atlas.html (a self-contained page whose data is an embedded JSON catalogue) and out/atlas.files.json (the
out/-relative paths to publish beside it, split into batches of at most 250 for the Artifact tool's per-publish limit).
Everything is read from disk, so it can be rerun after any wave.
"""
import json
from pathlib import Path

OUT = Path("out")
D = OUT / "diagrams"
PLANS = ["plan-diagram-waves.md", "plan-output-formats.md", "plan-worldmap-processor.md", "plan-inspiration-module.md"]


def rel(p):
    return p.relative_to(OUT).as_posix()


slugs = json.loads((D / "fan-out/_slugs.json").read_text(encoding="utf-8")) if (D / "fan-out/_slugs.json").exists() else {}
by_stem = {v["stem"]: v for v in slugs.values()}

fan = []
for p in sorted((D / "fan-out").glob("*.drawio.png")):
    stem = p.name[: -len(".drawio.png")]
    adr, _, rest = stem.partition("--")
    lens = stem.rsplit("--", 1)[-1]
    meta = by_stem.get(stem, {})
    minis = [rel(m) for m in (D / f"fan-out/{stem}.{view}.png" for view in ("grid", "tree", "chain")) if m.exists()]
    fan.append({"src": rel(p), "group": adr.upper(), "lens": lens, "title": meta.get("title", stem), "minimaps": minis})

lenses = []
for p in sorted(D.glob("lenses/*/*.drawio.png")):
    diagram, lens = p.name[: -len(".drawio.png")].rsplit(".", 1)
    lenses.append({"src": rel(p), "group": diagram, "lens": lens, "title": f"{diagram} · {lens}"})

sheets = [{"src": rel(p), "group": "contact sheets", "title": p.parent.name} for p in sorted(D.glob("lenses/*/*.sheet.png"))]
waves = [{"src": rel(p), "group": p.relative_to(D).parts[0], "title": p.relative_to(D / p.relative_to(D).parts[0]).as_posix()}
         for p in sorted(D.glob("wave-*/*/*.drawio.png"))]
worlds = [{"src": rel(p), "group": "world map", "title": p.name} for p in sorted((D / "fan-out").glob("world-map.*.png"))]
docs = [{"src": p, "title": p.removeprefix("plan-").removesuffix(".md").replace("-", " "), "kind": "plan"}
        for p in PLANS if (OUT / p).exists()]
docs += [{"src": rel(p), "title": p.parent.name + " · " + p.name.split(".")[0], "kind": "claim table"}
         for p in sorted(list(D.glob("lenses/*/*.verify.md")) + list(D.glob("wave-*/*/*.verify.md")))]
pdfs = [{"src": rel(p), "title": p.name} for p in [D / "selection-round-1.pdf"] if p.exists()]

catalogue = {"fan": fan, "lenses": lenses, "sheets": sheets, "waves": waves, "worlds": worlds, "docs": docs, "pdfs": pdfs}
files = sorted({i["src"] for k in ("fan", "lenses", "sheets", "waves", "worlds", "docs", "pdfs") for i in catalogue[k]}
               | {m for i in fan for m in i["minimaps"]})
batches = [files[i:i + 250] for i in range(0, len(files), 250)]
(OUT / "atlas.files.json").write_text(json.dumps(batches), encoding="utf-8")

template = (Path(__file__).resolve().parent / "assets" / "atlas.template.html").read_text(encoding="utf-8")
page = template.replace("/*__CATALOGUE__*/ null", json.dumps(catalogue, ensure_ascii=False))
(OUT / "atlas.html").write_text(page, encoding="utf-8")
print(f"ok out/atlas.html files={len(files)} batches={[len(b) for b in batches]}")
