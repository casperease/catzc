---
plan:
  status: active
  class: feature
  value: medium
  reviewed: 2026-10-18
  waits_on: the final session's full run (task-user-runs-and-commits, last step)
  targets: [pwsh/Catzc.Base.Folders, pwsh/.scriptanalyzer/NoUnboundedEnumeration.psm1, docs/adr/pwsh/bounded-enumeration.md]
---

# Bounded folder enumeration: raw .NET, depth 2 by default, nothing deeply loaded

The walker and `Get-ChildPath` (Catzc.Base.Folders), ADR-PWSH-ENUM, the migrated call sites and the analyzer rule NoUnboundedEnumeration
are in the tree. The proof left is the user's full test run.

## Why its value is medium

About 70 call sites enumerated with no depth limit; a deep tree or a vendor folder made any of them slow or wrong. The value is delivered;
what is left is the proof.

## Open steps

- [ ] The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; no earlier step runs it)
      confirms this feature; then this plan and its prompt are deleted (check: that run's report shows no finding from this feature; both
      files are gone).

## Refs

- memory: bounded-folder-enumeration.md
- prompt-bounded-folder-enumeration-continue.md (beside this file)
