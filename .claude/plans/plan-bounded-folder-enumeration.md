---
plan:
  status: active
  class: feature
  value: medium
  reviewed: 2026-10-18
  waits_on: the final session's full run (task-user-runs-and-commits, last step), which confirms the level-2 rerun of 2026-10-17
  targets: [pwsh/Catzc.Base.Folders, pwsh/.scriptanalyzer/NoUnboundedEnumeration.psm1, docs/adr/pwsh/bounded-enumeration.md]
---

# Bounded folder enumeration: raw .NET, depth 2 by default, nothing deeply loaded

Built and migrated: the walker and `Get-ChildPath` in Catzc.Base.Folders, ADR-PWSH-ENUM at docs/adr/pwsh/bounded-enumeration.md, the
migration of every non-test and test site, and the analyzer rule NoUnboundedEnumeration. What remains is the user's full test run; then this
plan and its prompt are deleted.

## Why its value is medium

About 70 call sites enumerated with no depth limit and 8 used Get-ChildItem; a deep tree or a vendor folder made any of them slow or wrong.
The value is delivered; what is left is the proof.

## Done, and why

- The ADR, the walker, the migration and the analyzer rule are in the tree, so the drafts this plan once carried are gone; git keeps them.
- The level-2 gate failed once on three ADR test tags; every test citation needs the `ADR-<CODE>#<n>` form naming a real rule. The fixes
  pass in the rerun of 2026-10-17 (the open step below).
- node_modules compares to .vendor, tracked or not: the walker's prune sets name both, and a vendor-track rule says the same
  (plan-module-kinds-tracks; questionnaire round C1, 2026-10-16).

## Open steps

- [x] Rerun the level-2 gate in the background; fix only findings in this feature, report the rest (check: its report in out/test-automation
      shows the three tags accepted). Done 2026-10-17 (task-bounded-enumeration-closeout): the three Folders test files pass with their tags
      (`out/test-file/20261017-210740-a00b00`) and the eight gates of `out/run-folders-verify.ps1` report nothing; verdicts in
      task-bounded-enumeration-closeout.
- [ ] The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; no earlier step runs it)
      confirms this feature; then this plan and its prompt are deleted (the plans plan's rule) (check: that run's report shows no finding
      from this feature; both files are gone).

## Refs

- memory: bounded-folder-enumeration.md
- prompt-bounded-folder-enumeration-continue.md (beside this file)
