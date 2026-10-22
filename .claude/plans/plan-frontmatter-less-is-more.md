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
- **Markdown is a config subtype of code**: authored Markdown follows the same rule as code and config, a head only when it has a comment
  page (`docs:`) or cites rule codes (`cites:`); **generated Markdown keeps its generated head**, the warning and `with_body_sha` while
  tracked.
- **A generated head holds the warning and `with_body_sha` while tracked, nothing else**: `role`, `track`, `generator`, `source` and a
  generated code file's `cites` go.

## Decided (the orchestrator, delegated, 2026-10-22)

- A language that declares `no_formatter` with its reason counts as covered (a decision made in config); one with no reason does not.
- The `file-heads` variant and ADR-REPO-VARIANT-FILEHEADS go: the rule above replaces them (PDR-ONELIVE).

## Open steps

- [ ] Every tracked generated head lists `with_body_sha` first in its `immutable` part, then the warning, so it reads "immutable for this
      body" (the user, 2026-10-22): `Format-GeneratedFileHead` writes that order and every generated file is regenerated (catzc-a0). (check:
      the writer's test asserting the order, `Test-GeneratedFiles` at 0, and a grep over generated heads for an `immutable:` part whose
      first key is not `with_body_sha` at 0)
- [ ] `Get-RootConfigInputStamp` hashes `generated-head.yml` and the module that writes generated heads, so a head-format change
      invalidates `Build-RootConfig`'s memo (six root files kept the old key order through `Sync-GeneratedFile` and `Test-GeneratedFiles`
      until the memo was cleared by hand; catzc-a0, 2026-10-22; decided as delegated). Import-path, a burst. (check: its test file green
      with a case where a changed `generated-head.yml` changes the stamp)
- [ ] The tree re-imprinted, one module folder, then one docs folder, at a time, by `Format-Code -Path` on each, so every head matches the
      rule: about 2,400 hashes and 1,666 test/code edges removed, 560 heads dropped (the scans). (check: per folder, `Test-FileMeta` at 0
      and `git diff` showing head lines only)

## Refs

- The scans of the tree as it is: `out/frontmatter-scan-code.md` (catzc-e3) and `out/frontmatter-scan-docs.md` (catzc-54).
- The mechanism today: `out/frontmatter-mechanism-map.md` (catzc-a0).
