---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1]
---

# Debt test speed: the slowest Pester files measured and fixed one at a time

The test-optimization role ranked the files of the last full run, `out/test-automation/20261021-032407` (a failed run, 895 files, 1373 s
summed). `Invoke-TestFile.Tests.ps1` was measured at 55.1 s and 43.4 s and stays as it is: its cost is the snapshot path it proves. Left
out: `Test-ScriptAnalyzer.Tests.ps1` and `Get-ContractCheckResults.Assets.Tests.ps1` (catzc-e9 handled them), `Test-Spelling.Tests.ps1` and
`Test-Automation.Tests.ps1` (catzc-e9 checks whether they are still red), and the `Language.Bridge.ps1` rows, which run the language test
folders. Heavy runs wait for a turn in the orchestrator's memory queue, one run per call.

## Open steps

1. [ ] `pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` (86.6 s in the ranked run): two baseline runs and a timing per block;
       its one L2 test runs the gate over the whole tree, which is what it proves, so a fix is made only for a cause outside that check.
       Check: `Invoke-TestFile` on the file twice, the same test names and `Should` count before and after.
2. [ ] The next three files by cost, each measured and fixed as step 1: `Get-AdrUsage.Tests.ps1` (22.5 s), `Import-Catzc.Tests.ps1` (22.1 s)
       and `Invoke-Executable.Tests.ps1` (20.5 s). Check: `Invoke-TestFile` twice per file, the same test names and `Should` count, and
       `Test-ScriptAnalyzer -Path` at 0 on each changed file.
3. [ ] The role's report, `out/test-optimization-2026-10-22.md`: the roofs, the run measured, the table, per file the cause, rule, timings
       and counts, and the next three files. Check: the file exists and names every file measured.

## Open questions

- Does the hindsight log, `.claude/hindsight/`, get a decision record? Its line shape and validity rule live only in the `hindsight-log`
  capability, and no ADR outside `research/` names it (the user's decision).
- `docs/references/pwsh/CLAUDE.md` still prescribes `Format-Code -Language markdown -Path docs/references/pwsh`, against `catzc-run`'s
  `Format-Code -Path` on the files touched (decided in plan-agent-friction); a `CLAUDE.md` is the user's to edit.
