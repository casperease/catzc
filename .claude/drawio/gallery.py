# ---
# catzc:
#   derived:
#     path: ".claude/drawio/gallery.py"
#     kind: script
#     language: python
#     filekind: py
#     track: ".claude"
# ---

# cspell:ignore minimaps figcaption minmax
"""Write out/diagrams/index.html: one local page that links every diagram output for review.

usage: uv run -q python .claude/drawio/gallery.py

Sections: world maps, lens contact sheets, fan-out drawings (each with its three minimaps when they exist), and the earlier
waves. Re-run it any time; it only reads what is on disk and links by relative path.
"""
import html
from pathlib import Path

ROOT = Path("out/diagrams")


def card(path, caption, extra=""):
    rel = path.relative_to(ROOT).as_posix()
    return (f'<figure><a href="{rel}"><img loading="lazy" src="{rel}" alt="{html.escape(caption)}"></a>'
            f"<figcaption>{html.escape(caption)}{extra}</figcaption></figure>")


def section(title, cards):
    if not cards:
        return ""
    return f"<h2>{html.escape(title)} <small>({len(cards)})</small></h2><div class=grid>{''.join(cards)}</div>"


fan = ROOT / "fan-out"
parts = [section("World maps", [card(p, p.name) for p in sorted(fan.glob("world-map.*.png"))])]
parts.append(section("Lens contact sheets", [card(p, p.parent.name) for p in sorted(ROOT.glob("lenses/*/*.sheet.png"))]))
drawings = []
for p in sorted(fan.glob("*.drawio.png")):
    stem = p.name[: -len(".drawio.png")]
    minis = [fan / f"{stem}.{view}.png" for view in ("grid", "tree", "chain")]
    links = " ".join(f'<a href="{m.relative_to(ROOT).as_posix()}">{m.name.split(".")[-2]}</a>' for m in minis if m.exists())
    drawings.append(card(p, stem, f"<br>minimaps: {links}" if links else ""))
parts.append(section("Fan-out: ADR-support drawings", drawings))
for wave in sorted(ROOT.glob("wave-*")):
    parts.append(section(wave.name, [card(p, p.relative_to(wave).as_posix()) for p in sorted(wave.glob("*/*.drawio.png"))]))

page = f"""<!doctype html><html lang=en><meta charset=utf-8><meta name=viewport content="width=device-width,initial-scale=1">
<title>Diagram gallery</title>
<style>
:root{{--bg:#fff;--ink:#263238;--quiet:#607D8B;--line:#CFD8DC}}
@media (prefers-color-scheme:dark){{:root{{--bg:#111417;--ink:#ECEFF1;--quiet:#90A4AE;--line:#37474F}}}}
body{{margin:0;padding:16px;background:var(--bg);color:var(--ink);font:14px/1.4 system-ui,sans-serif}}
h1{{font-size:20px}} h2{{font-size:16px;margin-top:28px;border-bottom:1px solid var(--line)}} small{{color:var(--quiet)}}
.grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:14px}}
figure{{margin:0}} img{{width:100%;border:1px solid var(--line);border-radius:6px;background:#fff}}
figcaption{{font-size:12px;color:var(--quiet);word-break:break-all}} a{{color:inherit}}
</style>
<h1>Diagram gallery</h1><p>Click any image to open it full size. Generated from what is on disk by .claude/drawio/gallery.py.</p>
{''.join(parts)}
</html>"""
(ROOT / "index.html").write_text(page, encoding="utf-8")
print(f"ok {ROOT / 'index.html'} drawings={len(drawings)}")
