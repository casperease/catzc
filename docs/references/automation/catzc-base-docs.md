# Catzc.Base.Docs

The generated-README module. It owns the rule that a `README.md` in a conventional folder is a **derived copy-in** of one authored docs
source, never hand-kept (see [generated-readmes](../../adr/repository/generated-readmes.md)). It copies each mapped source out to its
folder's README, rebasing the source's relative links to the new location and injecting a standard "generated file" warning after the title.
What it deliberately does **not** own is the prose itself — that lives in the authored sources under `docs/`, and the README is only their
rendering; the importer keeps the renderings current on every load.

## Domains

| Domain   | Area   | Name                                             |
| -------- | ------ | ------------------------------------------------ |
| domain:1 | render | [README generation](#domain1--readme-generation) |
| domain:2 | map    | [Copy-in map](#domain2--copy-in-map)             |

### domain:1 — README generation

Turning an authored source into a folder's README. This domain reads the source, rebases its relative links so they resolve from the target
folder rather than the source's, injects the portable "generated file" warning after the first H1, and writes the result — but only when the
composed content differs from what is on disk, compared without regard to line endings. That idempotence is what lets the importer
regenerate every README on each load at no steady-state cost (see [generated-readmes](../../adr/repository/generated-readmes.md)).

### domain:2 — Copy-in map

Which folder is generated from which source. The map is `readme.yml`: a glob `patterns` list whose every matched folder derives its source
by convention (the folder's leaf name, kebab-cased — `automation/*` → `docs/references/automation/<kebab>.md`), plus explicit `mappings` for
the folders that follow no convention (an explicit mapping wins over a pattern). It is validated when it loads so a malformed or duplicated
entry can never produce a run, and its patterns are expanded against the filesystem to the concrete folder-to-source list before generation.
The map is the single place the folder-to-source pairing is stated; the generator reads it through [Catzc.Base.Config](catzc-base-config.md)
and never hard-codes a path.

The map is also the **opt-in switch** for the generated (copy-out) README. Listing a folder here opts it in: its `README.md` becomes a
derived copy-out of the named source, gitignored so it is never edited by hand and never gates the markdown or spelling checks (the source
under `docs/` is what those gates check). A folder _not_ listed opts out — it keeps a hand-authored, committed `README.md` that is
un-ignored in `.gitignore` and checked like any other doc. Two details keep the opt-in safe: a `patterns` glob supports only a trailing `/*`
and matches just the immediate, non-dot-prefixed subdirectories of its prefix (so `.vendor`, `.internal`, and other dot-folders can never be
swept in), and a matched folder whose derived source does not exist yet is skipped rather than generated — so a module with no reference
article is fine; it simply has no generated README until its source lands.

## What the module does

The module is small and single-purpose: it keeps every conventional folder's README in step with one authored source. The source of truth is
the docs file; the README is a build output, gitignored like the generated module manifests and excluded from the markdown and spelling
gates (those check the source). A reader is told so by the injected banner, which names the exact source and renders as a plain-blockquote
warning in GitHub, Azure DevOps, and VS Code alike — the one form all three render.

Generation is designed to run unattended from the importer tail, so it is idempotent by construction: output is canonical (UTF-8, LF, one
trailing newline) and a README is rewritten only on a real content change. Links are the one non-verbatim part of the copy — because the
README lives in a different folder than its source, a relative link is re-expressed against the target folder so it still resolves. The map
and its record types (`DocsConfig`, `DocMapping`, `DocPattern`) are validated at load, then the glob patterns are expanded against the
filesystem to the concrete folder-to-source list, so a bad entry fails fast rather than producing a broken README.

## Division

The module's public surface, sorted into the domains above.

| Domain                       | Function       |
| ---------------------------- | -------------- |
| domain:1 — README generation | `Build-Readme` |
| domain:2 — Copy-in map       | `readme.yml`   |
