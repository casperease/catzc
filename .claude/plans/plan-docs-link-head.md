---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.QualityGates/configs/file-meta.yml,
      pwsh/Catzc.Base.QualityGates/types/FileHeadPolicy.cs,
      docs/adr/repository/file-meta.md,
      docs/adr/repository/code-file-meta.md,
    ]
---

# Docs-link head: the head of a file with a comment page

Every code file with a comment page under `docs/references/` requires a meta head (`head_policy.pages`, required on the type), and that head
links the page as `edges.docs: "[<page>.md](docs/references/...)"`, by its repository-relative path (ADR-REPO-FILEMETA-HEADPOLICY,
ADR-REPO-FILEMETA-FEWLINKS). One choice is still open.

## Open questions

- **Q1: What does the head of a file with a page hold?** It holds every kind that selects the file, about 19 lines: path, name, filetype,
  role, language, track, tracktype, module, moduletype, catzc_bundle, visibility, test, docs and cites. The question is whether to keep that
  or trim it to `path` + `docs`. Recommendation: keep it. The facts are derived, no tool reads them back (ADR-REPO-FILEMETA-NOREADBACK), and
  trimming them means a second head shape. Trimming needs a `select:` on each kind in `file-meta.yml` that leaves out the classes policy
  makes paged; ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY would then name the trimmed set.

## Open steps

- [ ] If Q1 is answered "trim": add the `select:` to each kind in `file-meta.yml` and restate ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY. Then
      run `Invoke-TestFile` on `tests/Invoke-FileMetaEngine.Tests.ps1`, and `Format-FileMeta` on the pilot module `pwsh/Catzc.Base.Folders`.
      Check: `Get-ChildPath.ps1` holds only `path` and `docs`. If Q1 is answered "keep", this plan is done and is deleted.
