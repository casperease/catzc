# Catzc.Base.Docs

The generated-README module. It owns the rule that a `README.md` in a conventional folder is a **filesystem link** to one authored docs
source, never a hand-kept copy (see [generated-readmes](../../adr/repository/generated-readmes.md)): the README IS the source, so an edit
through either path lands in the one authored file and there is no second copy to drift. What it deliberately does **not** own is the prose
itself — that lives in the authored sources under `docs/` — nor the link mechanism, which is `Set-FileLink`
([Catzc.Base.Files](catzc-base-files.md)); the importer keeps every link current on every load.

## Domains

| Domain   | Area    | Name                                                       |
| -------- | ------- | ---------------------------------------------------------- |
| domain:1 | link    | [README materialisation](#domain1--readme-materialisation) |
| domain:2 | map     | [README map](#domain2--readme-map)                         |
| domain:3 | markers | [Managed .gitkeep files](#domain3--managed-gitkeep-files)  |

### domain:1 — README materialisation

Ensuring each mapped folder's README is a link to its authored source. This domain resolves the mapping's paths and hands them to
`Set-FileLink` ([Catzc.Base.Files](catzc-base-files.md)): an effective link is a no-op, and anything else — the old plain-file copy, a wrong
or orphaned link — is recreated with the running OS's best mechanism. That idempotence is what lets the importer re-materialise every README
on each load at no steady-state cost (see [generated-readmes](../../adr/repository/generated-readmes.md)).

### domain:2 — README map

Which folder is generated from which source. The map is `readme.yml`: a glob `patterns` list whose every matched folder derives its source
by convention (the folder's leaf name, kebab-cased — `automation/*` → `docs/references/automation/<kebab>.md`), plus explicit `mappings` for
the folders that follow no convention (an explicit mapping wins over a pattern). It is validated when it loads so a malformed or duplicated
entry can never produce a run, and its patterns are expanded against the filesystem to the concrete folder-to-source list before generation.
The map is the single place the folder-to-source pairing is stated; the generator reads it through [Catzc.Base.Config](catzc-base-config.md)
and never hard-codes a path.

The map is also the **opt-in switch** for the generated README. Listing a folder here opts it in: its `README.md` becomes a derived link to
the named source, gitignored and out of the markdown and spelling gates' scope (the source under `docs/` is what those gates check). A
folder _not_ listed opts out — it keeps a hand-authored, committed `README.md` that is un-ignored in `.gitignore` and checked like any other
doc. Two details keep the opt-in safe: a `patterns` glob supports only a trailing `/*` and matches just the immediate, non-dot-prefixed
subdirectories of its prefix (so `.vendor`, `.internal`, and other dot-folders can never be swept in), and a matched folder whose derived
source does not exist yet is skipped rather than generated — so a module with no reference article is fine; it simply has no generated
README until its source lands.

### domain:3 — Managed .gitkeep files

Reproducing every `.gitkeep` from the one generic authored source (`assets/gitkeep`). The folder is the registration — a filesystem walk
(skipping `.git`, the vendored modules, and the output root's contents) finds the set, so there is no list to maintain. The generic text
points the reader at the folder's `README.md`, and an integrity test makes that pointer binding: every `.gitkeep` folder must be a
readme-mapped target (domain:2), so dropping a `.gitkeep` anywhere demands its reference article. Unlike the gitignored READMEs, the
`.gitkeep` copies stay committed — tracking the folder is their purpose — so a source change lands as a reviewable, repo-wide diff.

## What the module does

The module is small and single-purpose: it makes every conventional folder's README the one authored source, by link. The source of truth is
the docs file; the README is a derived artifact, gitignored like the generated module manifests and out of the markdown and spelling gates'
scope (those check the source at its own location — which is also where the article's relative links are guaranteed to resolve; the README
is a pointer into that reading surface, not a second rendering).

Materialisation is designed to run unattended from the importer tail, so it is idempotent by construction: an effective link is a no-op and
a stale artifact is recreated, per OS, by the shared `Set-FileLink` primitive. The map and its record types (`DocsConfig`, `DocMapping`,
`DocPattern`) are validated at load, then the glob patterns are expanded against the filesystem to the concrete folder-to-source list, so a
bad entry fails fast rather than producing a broken README.

## Division

The module's public surface, sorted into the domains above.

| Domain                            | Function        |
| --------------------------------- | --------------- |
| domain:1 — README materialisation | `Build-Readme`  |
| domain:2 — README map             | `readme.yml`    |
| domain:3 — Managed .gitkeep files | `Build-GitKeep` |
