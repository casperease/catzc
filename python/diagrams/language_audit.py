"""Read-only audit of the language tags of every code glyph of every diagram (languages_table): the label, the language its shape names,
the tags it would print, and whether it prints none (`untagged`: its label matches no shape). It writes only out/language-audit.md and changes no
declaration.

usage (repo root):
  uv run --no-sync --project python python python/catzc_diagrams/language_audit.py [--out out] [--stem <name-substring>]
"""

import sys
from collections import Counter
from pathlib import Path

import declaration
import edge_audit
import languages_table

REPO = edge_audit.REPO


def audit(root=REPO, needle=""):
    """One row per code glyph: stem, id, kind, label, language ("none" when no row matches), tags, untagged."""
    rows = []
    for stem in edge_audit.stems(root, needle):
        if not declaration.declared(stem):
            continue
        try:
            decl, _ = edge_audit.raw_of(stem)
        except (declaration.DeclarationError, OSError):
            continue
        name = stem.relative_to(root / "docs").as_posix() if stem.is_relative_to(root / "docs") else stem.as_posix()
        for glyph in (decl.get("content") or {}).get("glyphs") or []:
            if glyph.get("kind") not in declaration.TAGGED_KINDS:
                continue
            label = str(glyph.get("label", ""))
            lang = str(glyph.get("lang", "") or "")
            language = languages_table.detect(label, lang)
            words = languages_table.tags(label, lang)
            rows.append(
                {
                    "stem": name, "id": glyph["id"], "kind": glyph["kind"], "label": label, "language": language or "none",
                    "tags": " ".join(words), "untagged": not words,
                }
            )
    return rows


def report(rows):
    by_language = Counter(r["language"] for r in rows)
    untagged = [r for r in rows if r["untagged"]]
    lines = [
        "# Language audit",
        "",
        f"{len(rows)} code glyphs in {len({r['stem'] for r in rows})} diagrams, {len(untagged)} of them untagged. Read-only: nothing is rebuilt"
        " and no declaration changes.",
        "",
        "## Glyphs per language",
        "",
        "| language | tag | glyphs |",
        "| --- | --- | --- |",
        *[
            f"| {language} | {languages_table.tag_of(language) if language in languages_table.rows() else '-'} | {count} |"
            for language, count in by_language.most_common()
        ],
        "",
        f"## Untagged ({len(untagged)}): the label matches no shape, so the glyph prints no tag",
        "",
        "| diagram | glyph | kind | label |",
        "| --- | --- | --- | --- |",
        *[f"| {r['stem']} | {r['id']} | {r['kind']} | {' / '.join(r['label'].splitlines()).replace('|', '/')} |" for r in untagged],
        "",
        "## Command forms",
        "",
        f"{sum(1 for r in rows if len(r['tags'].split()) > 1)} glyphs name a command with a contract and list every form it has.",
    ]
    return lines


def main(argv=None):
    args = list(sys.argv[1:] if argv is None else argv)
    out = Path(args[args.index("--out") + 1]) if "--out" in args else REPO / "out"
    needle = args[args.index("--stem") + 1] if "--stem" in args else ""
    rows = audit(REPO, needle)
    lines = report(rows)
    out.mkdir(parents=True, exist_ok=True)
    (out / "language-audit.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
