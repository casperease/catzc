---
task:
  status: open
  plans: [plan-test-run-budget]
  value: medium
  blocked_on: the user's two full runs for step 3; D08 decided 2026-10-18 for steps 1 and 2
  targets:
    [
      docs/adr/repository/uniform-formatting.md,
      automation/Catzc.Base.QualityGates,
      automation/Catzc.Base.Engines,
      automation/Catzc.Base.Timeouts/configs/timeouts.yml,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task-test-run-budget.md"
    folder: plans
    name: task-test-run-budget
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-CACHE#10
      - ADR-REPO-FORMAT#8
---

# Task: the full test run under its 180 s roof

Last measured 265.8 s. Landed: greedy groups and the decayed duration maximum. The largest lever left is the format cache stamp: every
engine's stamp includes `tools.yml`, so any pin edit reformats the whole repository for every engine (PowerShell 58 to 76 s cold). The roof
is a rule, not a target; this task proposes no full run, the user runs them (memory: user handles commits and tests).

## Steps

1. [x] D08 recorded; `docs/adr/repository/uniform-formatting.md`: one sentence, an engine's cache stamp contains its own tool pin and its
       own settings files, nothing else. Check: Test-AdrRegistry, Test-Links. Done 2026-10-18: ADR-REPO-FORMAT#8 says an engine's
       `settings:` entries are its whole stamp, citing ADR-AUTO-CACHE#10; `ADRREG issues=0`, `LINKS issues=0`, `MDLINT issues=0`.
2. [x] The stamp: find where it is built (`Catzc.Base.Engines` or the Format-Code cache in QualityGates); per engine, hash only that
       engine's pin from `tools.yml` and its settings files. Two tests: an unrelated pin edit leaves another engine's cache warm; every
       declared stamp input invalidates it (the risk is a stale result from a missed input). Check: the Test-Formatting tests pass cold and
       warm. Correction 2026-10-18, from the tree: the work had already landed. `Get-FormatEngineStamp` (QualityGates, private) hashes each
       `<file>#<key>` entry by that key's value alone, and every engine in `languages.yml` lists `tools.yml#<tool>` keys, never the whole
       registry. Its tests already hold both cases: 'stays when only another key changes' and 'changes when that key's value changes', plus
       the missing-input and never-the-whole-registry cases; 13 of 13 pass. `Test-Formatting.Tests.ps1` passes 4 of 5 cold and warm (15.2 s,
       then 10.2 s); the failure is its integrity case, "formatting leaves the repository unchanged", over 18 unformatted working-tree
       files, none of them a stamp file.
3. After the user's two full runs with the new history: `Invoke-TestFile.Tests.ps1` no longer shares a shard with
   `Test-Formatting.Tests.ps1`; record the shard table and wall clock against the 265.8 s run in the plan. Check: the table in the plan.
4. Next three files by cost (Get-BicepParameterModel.Shipped 33.6 s, Import-Catzc 32.9 s, Build-Bicep.L2 31.3 s, then the Test-BuildArtifact
   files), one at a time through the `test-optimization` robot, each measured against the new balance. Check: same assertions, lower time,
   recorded per file.
   - `Get-BicepParameterModel.Shipped.Tests.ps1`, 2026-10-18, no edit: 3 tests, about 4 s each (14.3 s container, run alone twice,
     `out/test-file/20261018-114611-03d7dc`); the 33.6 s was contention in the full run. Each test is one real `az bicep build` per
     shipped template, which is what this L2 integrity test proves, so no rule in this file applies. Open for the user, both outside the
     file: one shared build per template for the whole run (other Build-Bicep tests may rebuild the same three), or the three builds in
     parallel in `BeforeAll`.
5. Items 2 and 3 of the carried draft (the Invoke-TestFile snapshot test, the config conventions test at 0.77 s) stay as they are unless the
   user decides otherwise; one Decided line. The markdown title test re-measured once Get-MarkdownScope landed. Check: the lines exist.
6. Tick the plan's steps; the carried draft goes; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
