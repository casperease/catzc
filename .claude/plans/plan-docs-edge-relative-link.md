---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: fix
  targets: [pwsh/Catzc.Base.QualityGates/types/LinkEngine.cs, pwsh/Catzc.Base.QualityGates/configs/file-meta.yml]
---

# Docs edge as a file-relative link

A navigation head's `docs` edge links its comment page by the repository-relative path, `"[X.cs.md](docs/references/...)"`. That target
resolves from the repository root, so it is broken in GitHub's code view and in an editor, both of which resolve a link from the file's own
folder. The head is written by a tool that knows both paths, so it can write a proper `../`-relative target.

## Why its value is medium

The `docs` edge exists so a reader can step from a code file to its page in one click
([ADR-REPO-FILEMETA-FEWLINKS](../../docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-fewlinks)). Today that click fails in every code
file that has a head.

## Decided (the user, 2026-10-21)

- The `docs` link target is relative to the file that carries the head, e.g. from
  `pwsh/Catzc.Base.QualityGates/types/AnalyzerDrsMapConfig.cs`:
  `"[AnalyzerDrsMapConfig.cs.md](../../../docs/references/pwsh/catzc-base-quality-gates/types/AnalyzerDrsMapConfig.cs.md)"`. This replaces
  the repository-relative form; one living version, no fallback for the old form.

## Open questions

- Should `test` and `code`, which are plain paths and not links, stay repository-relative or move to the same file-relative form?
  Recommendation: keep them repository-relative. They are not clickable as plain YAML values, and a repository path is what a dev greps for.

## Open steps

The last two steps land as one burst, after catzc-8b's b3 re-imprint and catzc-1c's re-declare (delegated, 2026-10-21): the link check goes
live on a tree the re-imprint has already made pass it.

- [ ] `pwsh/Catzc.Base.QualityGates/types/LinkEngine.cs`: `Test-Links` skips a code file's meta head whole, so a broken `docs` edge goes
      unreported (probed 2026-10-21); `AlignCode` resolves the head's `docs` link target from the file's folder and reports a missing
      target, with a Pester case for a broken edge (check: the case passes; `Test-Links` on a re-imprinted code file reports nothing).
- [ ] Re-imprint the heads with `Sync-FileMeta` (one-shot), which also covers the 269 heads drifted by the module renames and the kind
      change; peer-dirty code files are skipped and picked up on the next sync (check: `Test-FileMeta` over the tree at 0;
      `AnalyzerDrsMapConfig.cs` and `FileLanguage.cs` show the `../`-relative `docs` edge).
