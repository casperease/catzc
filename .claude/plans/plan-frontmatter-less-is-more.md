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
- **Out of scope:** agent and skill files keep Claude's own front matter as authored (the `agent` and `capability` classes).

## Open steps

- [ ] `docs/drs/repository/file-meta.md`: ADR-REPO-FILEMETA-HEADPOLICY and ADR-REPO-FILEMETA-FEWLINKS rewritten to the decided rule (every
      file on disk format-managed; generated: warning, sha only while tracked; authored: `docs` and `cites` only, else no head), the
      `test`/`code` edges and the authored `with_body_sha` removed from the rules, in the same change as the code (decisions become rules).
      (check: `Test-DrsRegistry` and `Test-Links` on the file at 0)
- [ ] `pwsh/Catzc.Base.QualityGates/configs/file-meta.yml` and the types it binds: `body-sha` selected for generated files tracked in git
      only; `relative-edges` keeps the `docs` relation alone; `drs-codes` unchanged; the default head policy for an authored file is a head
      only when `docs` or `cites` has a value. A shared config, so it lands with its code in one burst. (check: the file-meta type tests and
      `Format-FileMeta.Tests.ps1` green, one fresh full import)
- [ ] The imprint (`Format-FileMeta`, `Invoke-ImprintStep`, `Get-RelativeEdgesFileMetaFact`, `Test-FileMeta`, `Sync-FileMeta`): a head the
      rule does not call for is removed, an untracked generated file gets the warning without a sha, and `Test-FileMeta` reports a head key
      the rule does not allow. Exact files per `out/frontmatter-mechanism-map.md` (catzc-a0). (check: each command's test file green, with a
      case per class: generated tracked, generated untracked, authored with page, authored with cites, authored with neither)
- [ ] A file no `Format-*` command covers is a finding of `Test-Formatting` (the "every file is format-managed" half). (check: its test file
      green with an uncovered-file case)
- [ ] The tree re-imprinted, one module folder, then one docs folder, at a time, by `Format-Code -Path` on each, so every head matches the
      rule. (check: per folder, `Test-FileMeta` at 0 and `git diff` showing head lines only)

## Refs

- The scans of the tree as it is: `out/frontmatter-scan-code.md` (catzc-e3) and `out/frontmatter-scan-docs.md` (catzc-54).
- The mechanism today: `out/frontmatter-mechanism-map.md` (catzc-a0).
