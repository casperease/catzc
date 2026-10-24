"""Read-only audit of the language tags of every code glyph of every diagram (languages_table): the label, the language its shape names,
the tags it would print, and whether the language was a fallback by glyph kind. It writes only out/language-audit.md and changes no
declaration; the diagrams of the folders `edge-rules audit-skip` names are left out, as in the edge audit.

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
    """One row per code glyph: stem, id, kind, label, language (None when no row matches), tags, fell_back."""
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
            language, fell_back = languages_table.detect(label, glyph["kind"], lang)
            words, _ = languages_table.tags(label, glyph["kind"], lang)
            rows.append(
                {
                    "stem": name, "id": glyph["id"], "kind": glyph["kind"], "label": label, "language": language or "none",
                    "tags": " ".join(words), "fell_back": fell_back and not lang,
                }
            )
    return rows


def report(rows):
    by_language = Counter(r["language"] for r in rows)
    fallbacks = [r for r in rows if r["fell_back"]]
    fallback_by_language = Counter(r["language"] for r in fallbacks)
    lines = [
        "# Language audit",
        "",
        f"{len(rows)} code glyphs in {len({r['stem'] for r in rows})} diagrams. Read-only: nothing is rebuilt and no declaration changes.",
        "",
        "## Glyphs per language",
        "",
        "| language | tag | glyphs | of them fallbacks by glyph kind |",
        "| --- | --- | --- | --- |",
        *[
            f"| {language} | {languages_table.tag_of(language) if language in languages_table.rows() else '-'} | {count} | {fallback_by_language[language]} |"
            for language, count in by_language.most_common()
        ],
        "",
        f"## Fallbacks ({len(fallbacks)}): the label matched no shape, so its glyph kind chose the language",
        "",
        "| diagram | glyph | kind | label | language |",
        "| --- | --- | --- | --- | --- |",
        *[f"| {r['stem']} | {r['id']} | {r['kind']} | {' / '.join(r['label'].splitlines()).replace('|', '/')} | {r['language']} |" for r in fallbacks],
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
