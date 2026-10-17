---
task:
  id: "029"
  status: open
  plans: [plan-test-run-budget]
  value: medium
  blocked_on: D08 for steps 1 and 2; the user's two full runs for step 3
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
    path: ".claude/plans/task029.md"
    folder: plans
    name: task029
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task029: the full test run under its 180 s roof

Last measured 265.8 s. Landed: greedy groups and the decayed duration maximum. The largest lever left is the format cache stamp: every
engine's stamp includes `tools.yml`, so any pin edit reformats the whole repository for every engine (PowerShell 58 to 76 s cold). The roof
is a rule, not a target; this task proposes no full run, the user runs them (memory: user handles commits and tests).

## Steps

1. D08 recorded; `docs/adr/repository/uniform-formatting.md`: one sentence, an engine's cache stamp contains its own tool pin and its own
   settings files, nothing else. Check: Test-AdrRegistry, Test-Links.
2. The stamp: find where it is built (`Catzc.Base.Engines` or the Format-Code cache in QualityGates); per engine, hash only that engine's
   pin from `tools.yml` and its settings files. Two tests: an unrelated pin edit leaves another engine's cache warm; every declared stamp
   input invalidates it (the risk is a stale result from a missed input). Check: the Test-Formatting tests pass cold and warm.
3. After the user's two full runs with the new history: `Invoke-TestFile.Tests.ps1` no longer shares a shard with
   `Test-Formatting.Tests.ps1`; record the shard table and wall clock against the 265.8 s run in the plan. Check: the table in the plan.
4. Next three files by cost (Get-BicepParameterModel.Shipped 33.6 s, Import-Catzc 32.9 s, Build-Bicep.L2 31.3 s, then the Test-BuildArtifact
   files), one at a time through the `test-optimization` robot, each measured against the new balance. Check: same assertions, lower time,
   recorded per file.
5. Items 2 and 3 of the carried draft (the Invoke-TestFile snapshot test, the config conventions test at 0.77 s) stay as they are unless the
   user decides otherwise; one Decided line. The markdown title test re-measured once Get-MarkdownScope landed. Check: the lines exist.
6. Tick the plan's steps; the carried draft goes; the plan is deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
