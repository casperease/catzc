---
task:
  status: open
  plans: [plan-bounded-folder-enumeration]
  value: medium
  blocked_on: step 2 is the user's full run
  targets: [pwsh/Catzc.Base.Folders, pwsh/.scriptanalyzer/NoUnboundedEnumeration.psm1, docs/adr/pwsh/bounded-enumeration.md]
---

# Task: bounded enumeration closed

Everything is built and migrated: Catzc.Base.Folders (FolderWalker, Get-ChildPath, depth 2 by default), the analyzer rule, ADR-PWSH-ENUM.
Three bad ADR test tags were fixed on 2026-10-16 and the level-2 gate was not rerun, so that is unconfirmed. The plan is deleted on green.

## Steps

1. [x] Level-2 gate rerun in the background (`timeout 360 pwsh -NoProfile -File out/run-folders-verify.ps1`, the rerun script the harvest
       kept); fix only findings in this feature's files, report the rest. Check: the report under `out/test-automation` shows the three tags
       accepted. Done 2026-10-17 (correction: the script runs the three Folders test files through Invoke-TestFile and seven gates, so its
       reports sit under `out/test-file` and the gates' own folders, not `out/test-automation`): `[Invoke-TestFile] Passed`
       (`out/test-file/20261017-210740-a00b00`, the three tags accepted), and `No ... issues found.` for Test-Comments, Test-FileMeta,
       Test-Links, Test-Spelling, Test-Markdownlint, Test-ShippedConfigs, Test-ModuleDependency and Test-ShippedTypes (reports
       `out/test-*/20261017-2107..`). Nothing to fix.
2. The user runs all tests in their own time. Check: the user's report shows no finding from this feature.
3. On green: `plan-bounded-folder-enumeration.md` and `prompt-bounded-folder-enumeration-continue.md` are deleted (`git rm` is the user's);
   one "deleted, why" line in value-of-plan.md; `out/run-folders-tests.ps1` and `run-folders-verify.ps1` listed for the next probe batch.
   Check: both files gone; Test-Links clean on `.claude/plans`.

## Report

As report-fixed.
