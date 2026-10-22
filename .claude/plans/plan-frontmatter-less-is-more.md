---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/configs/file-meta.yml, pwsh/Catzc.Base.CodeMeta, docs/drs/repository]
---

# Frontmatter less is more: every file on disk is format-managed, and its head says only what pays

Every file in the structure on disk is format-managed: a `Format-*` command corrects its format and decides whether it carries a head
(frontmatter) and which one. The default is none; a head is printed only where it carries a fact worth its lines.

## Why its value

Today almost every authored file carries a head with `with_body_sha` and, on code, `test:` and `code:` edges, so heads are noise on most of
the tree, they churn on every body edit, and agents read them on every file they open. The rule cuts that to the files where a head helps.

## Decided (the user, 2026-10-22)

- **Every file on disk is format-managed:** a `Format-*` command covers it and decides its head, yes or no, and which; a file no format
  command covers is a finding.
- **Generated file:** a head with the do-not-edit warning, there for convenience; while git tracks the file the head also carries
  `with_body_sha`, the body it is immutable with; an untracked generated file carries the warning only, no sha.
- **Authored file tracked in git** (source, config, template, doc): a head only when (1) a comment page exists under `docs/references`,
  shown as `docs:`, a GitHub-clickable link relative to the file, or (2) decision records cite it, shown as `cites:`; nothing else, so no
  `with_body_sha`, no `test:` or `code:` edge (a test is found by convention, its stem under `tests/`).
- **Every other file:** no head; a `Format-*` run removes a head the rule does not call for, so the default clears today's heads.
- **Out of scope:** agent and skill files keep Claude's own front matter as authored (the `agent` and `capability` classes), and a slide's
  front matter belongs to the slide tooling (the `slide` class).
- **`cites:`** holds the codes the file and its comment page cite (today's derivation), for every authored class.
- **Diagram declarations** (`*.drawio.yml`) carry no head; their codes stay in the body's `about.adrs`.
- **Binary generated files** (`pwsh/.compiled`) are format-managed with no head possible, never a finding.

## Decided (the orchestrator, delegated, 2026-10-22)

- A language that declares `no_formatter` with its reason counts as covered (a decision made in config); one with no reason does not.
- The `file-heads` variant and ADR-REPO-VARIANT-FILEHEADS go: the rule above replaces them (PDR-ONELIVE).

## Open steps

- [ ] `docs/drs/repository/file-meta.md` ADR-REPO-FILEMETA-IMPRINTEDPARTS and ADR-REPO-FILEMETA-FILEISNODE rewritten to the rule (catzc-e9;
      HEADPOLICY and FEWLINKS landed). (check: `Test-DrsRegistry` at 0 and `Test-Links` over `docs/drs` at 0)
- [ ] The engine, in one burst, per `out/frontmatter-mechanism-map.md` (catzc-a0): `file-meta.yml` (no authored `body-sha`, `relative-edges`
      `[docs]`, `drs-codes` every authored class, a head only when a fact is non-empty), `generated-head.yml` `[warning, with_body_sha]`,
      `Format-GeneratedFileHead` (sha only while tracked, no docs edge), the `file_heads` variant with `Get-FileHeadVariant` and
      `Test-FileHeadVariant` deleted, `FileHeadPolicy`, `HeadPolicy`, `FileMetaConfig`, `Invoke-FileMetaEngine`, `Get-FileMetaInputStamp`;
      with the variant goes ADR-REPO-VARIANT-FILEHEADS in `docs/drs/repository/repo-variants.md`, every head and test tag citing it moved to
      ADR-REPO-FILEMETA-HEADPOLICY, so no citation is left dangling (catzc-e9's point, decided as delegated). (check: each touched test file
      green with a case per class, one fresh full import, `Test-DrsRegistry` at 0 and `Test-Links` over `docs/drs` at 0)
- [ ] `Test-Formatting` reports a file no formatter covers (landed, catzc-54: 38 found); it reads a declared `no_formatter` with a reason as
      covered, and `languages.yml` gains entries for the 18 files with no language, in a burst (catzc-54). (check: the test file green and
      the coverage count at 0)
- [ ] The ten files committed unformatted that keep the formatting integrity test red, each formatted, `terminology.yml` with its generator
      (catzc-e3). (check: `Test-Formatting -Path` on the ten at 0, `git diff` whitespace and wrapping only)
- [ ] The tree re-imprinted, one module folder, then one docs folder, at a time, by `Format-Code -Path` on each, so every head matches the
      rule: about 2,400 hashes and 1,666 test/code edges removed, 560 heads dropped (the scans). (check: per folder, `Test-FileMeta` at 0
      and `git diff` showing head lines only)

## Refs

- The scans of the tree as it is: `out/frontmatter-scan-code.md` (catzc-e3) and `out/frontmatter-scan-docs.md` (catzc-54).
- The mechanism today: `out/frontmatter-mechanism-map.md` (catzc-a0).
