---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-18
  waits_on: the final session's full run (task-user-runs-and-commits, last step)
  targets:
    [
      pwsh/Catzc.Base.QualityGates/configs/file-meta.yml,
      pwsh/Catzc.Base.QualityGates,
      pwsh/Catzc.Base.Globs/configs/file-kinds.yml,
      pwsh/Catzc.Base.Variants/configs/module-types.yml,
      contracts/catzc/0.0.0,
      docs/adr/repository/file-meta.md,
    ]
---

# The file head: immutable place facts plus declared edges, with globs spelled once as classes

The head's shape is in the tree: `immutable` holds the place facts read from registries, `edges` what the file declares or points at
(ADR-REPO-FILEMETA#13); file-kinds.yml's ordered classes are the one place a glob lives and every meta kind selects by class or language
(ADR-REPO-FILEMETA#2, #11); the path splits into asserted parts and the head carries `module`, `moduletype` and `catzc_bundle`
(ADR-REPO-FILEMETA#11, #12). Which files carry a head at all is the head policy (ADR-REPO-FILEMETA#1, #14). What remains is the user's gate
run.

## Why its value is medium-high

The head is the carrier every other plan writes into; this plan settled its shape, and the last step proves it against the whole tree.

## Decided in the questionnaire round of 2026-10-16 (Q39 to Q54)

- Q39 the contract schema and sample stay hand-written; no generator; the key-set test guards them.
- Q42 the visibility head key stays. Q43 generated heads stay minimal. Q44 no glossary term for catzc_bundle.
- Q45 identifiers use pwsh (engine, folder) or powershell (language id), prose may say PowerShell (ADR-REPO-VOCAB#9); the one literal
  Powershell is in the vendored dotnet-install.ps1 and stays.
- Q52 this stays one plan for the whole head.

## Open steps

- [ ] The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; no earlier step runs it
      or Test-FileMeta over the tree) (check: that run's report in out/ shows no finding from the head shape, the class selectors or the
      path split).
- Context, not a step: glossary entries for individual kinds are not written (only the concepts kind and subkind are terms), and
  contracts/.gitkeep resolves to `other` and is left alone.

## Refs

- docs/adr/repository/file-meta.md, docs/adr/repository/code-file-meta.md
- pwsh/Catzc.Base.Globs/configs/file-kinds.yml, pwsh/Catzc.Base.QualityGates/configs/file-meta.yml
