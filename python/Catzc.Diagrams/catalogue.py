# cspell:ignore lstrip makedirs pathlib setdefault startswith keepends
"""Inventory the review drawings on disk for the Diagram Waves Review page.

usage: uv run -q python python/Catzc.Diagrams/catalogue.py

Writes out/print-artifacts/catalogue.json, one entry per diagram id (<area>.<name>) with its versions (wave, png path,
size, and the check-note counts when a .verify.md sits beside the drawing), and prints one line per diagram and a total.
Wave folders sort numerically, so wave-10 follows wave-9. Deterministic; it reads out/diagrams/ only.
"""
import glob
import json
import os
import pathlib
import re
import struct

items = {}
for p in sorted(glob.glob("out/diagrams/wave-*/*/*.drawio.png")):
    rel = pathlib.PurePath(p).as_posix().split("out/diagrams/")[1]
    wave, area, fn = rel.split("/")
    name = fn[: -len(".drawio.png")]
    d = pathlib.Path(p).read_bytes()
    w, h = struct.unpack(">II", d[16:24])
    v = {"wave": wave, "png": rel, "w": w, "h": h}
    vm = p[: -len(".drawio.png")] + ".verify.md"
    if os.path.exists(vm):
        counts = {"confirmed": 0, "adr": 0, "contradicted": 0}
        for line in pathlib.Path(vm).read_text(encoding="utf-8").splitlines(keepends=True):
            if not line.startswith("|") or line.startswith(("|---", "| #")):
                continue
            verdict = [c.strip() for c in line.strip().strip("|").split("|")][-1].lower().lstrip("*")
            for key, word in (("confirmed", "confirmed"), ("adr", "adr-only"), ("contradicted", "contradicted")):
                if verdict.startswith(word):
                    counts[key] += 1
        v["verify"] = rel[: -len(".drawio.png")] + ".verify.md"
        v["counts"] = counts
    items.setdefault((area, name), []).append(v)
wave_number = lambda v: int(re.sub(r"\D", "", v["wave"]) or 0)
out = [{"id": f"{a}.{n}", "area": a, "name": n, "versions": sorted(vs, key=wave_number)} for (a, n), vs in sorted(items.items())]
os.makedirs("out/print-artifacts", exist_ok=True)
with pathlib.Path("out/print-artifacts/catalogue.json").open("w") as f:
    json.dump(out, f, separators=(",", ":"))
for o in out:
    print(o["id"], " ".join(v["wave"] for v in o["versions"]))
print(len(out), "diagrams,", sum(len(o["versions"]) for o in out), "drawings")
