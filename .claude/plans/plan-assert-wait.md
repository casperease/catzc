---
plan:
  status: open
  value: medium
  reviewed: 2026-10-16
  blocked_on: Q1-Q5 below are unanswered; steps 1-2 wait for Q2 and Q3
  targets: [automation/Catzc.Base.Timeouts, automation/.internal/Catzc.Internal.Importer.psm1, automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1]
---

# Assert-Wait: a watchpoint for a suspected block

`Assert-Wait` is one line you stand at a place where the thread or process may be blocked. It holds the calling thread for
`-Seconds` + `-Millisecs` (default 1 s + 1 ms), writes a line per tick through `Write-Message`, ends with one `Write-Message -Warning`, and
lets go. It stops nothing and throws on nothing. First uses: the startup of the importer and of `Test-Automation`.

## Why its value is medium

A hang today shows nothing about where it stopped (ADR-AUTO-FAILFAST#7, "A hang is the slowest failure"). The watchpoint finds the place so
a limit can be put there and tuned. It is a diagnostic that leaves the tree once the block is bounded, so its lasting value is the limits it
leads to, not the function. It needs one ADR pair and one L0 test file.

## Contract (as drafted; Q1-Q3 confirm it)

- `Assert-Wait [-Seconds <int>] [-Millisecs <int>]`, both `ValidateRange(0, ...)`; the total must be above zero (`Assert-True`).
- Waits `Seconds + Millisecs` in ten evenly spaced ticks (a named constant, not a knob). Each tick line gives due, actual and lateness from a
  `Stopwatch`; the opening line names `<file>:<line>` from `Get-PSCallStack` frame 1.
- Information stream always, never `-Verbose`-gated; silent under Pester like every writer.
- The closing line is `Write-Message -Warning`, always, blocked or not: asked, measured, worst tick late, and "remove this watchpoint once the
  block is bounded". It is not the `Write-Warning` cmdlet: the importer sets `$WarningPreference = 'Stop'`, so the cmdlet would terminate.
- Returns nothing; throws only for invalid arguments, never caught (ADR-AUTO-FAILFAST#5).
- Sees the calling thread's schedule only; a starved process shows as late ticks too. Telling thread from process apart (a second thread's
  heartbeat, as `Invoke-WithProgress` runs) is out of scope.
- Home: `Catzc.Base.Timeouts`, beside `Assert-CompletesWithin`. `ADR-PWSH-ASSERT#6` bans an unbounded wait; this one is bounded by
  construction, so its `Start-Sleep` is not a finding.

## Needed docs

- `ADR-AUTO-FAILFAST#8`: mark a suspected block with a watchpoint, then bound it (Q5). `ADR-PWSH-ASSERT#7`: the pwsh form. Both go through
  `automation/Catzc.Base.Docs/configs/adrs.yml` and `Build-AdrIndex`; present tense, no history.
- Function help for `Assert-Wait` (ADR-REPO-HELP); a glossary entry only if `watchpoint` becomes a defined term (`glossary-keeper`).
- If Q1 settles on config defaults: the `timeouts.yml` page documents the new keys.

## Needed tests

- `tests/Assert-Wait.Tests.ps1`, L0 logic, neutral fixture names (ADR-TEST:3); lift `$global:__PesterRunning` in the test's own scope.
  - default total is 1.001 s with ten ticks; `-Seconds 0 -Millisecs 30` runs 30 ms
  - zero total and a negative value throw the assertion message
  - output order: opening, ten ticks, exactly one warning, the warning last
  - the warning is on the information stream and `$WarningPreference = 'Stop'` does not terminate it
  - a late tick (mocked clock or `Start-Sleep`) is named in the closing line
  - returns nothing
- `TimeoutsConfig` tests for the default keys, if Q1 picks config defaults.
- Module-graph check that `Catzc.Base.Timeouts` -> `Catzc.Base.Writers` makes no cycle (ADR-AUTO-DEPM).

## Open questions

- **Q1.** Defaults 1 s and 1 ms: declared once on `TimeoutsConfig` (devbox tight, pipeline may differ, like every limit) or literals in the
  `param` block? Recommendation: on the config type. Read ADR-AUTO-DEFAULT#6 first.
- **Q2.** Reading of the request: it really waits and measures its own ticks (not a threshold on time since a start mark); `Millisecs` adds to
  `Seconds` (not a tick interval); the closing warning always fires. Recommendation: as drafted.
- **Q3.** Is "complete startup time" the whole span with Bootstrap included? The writers do not exist before `Import-AllModules`, and a
  Bootstrap copy would be a second living version (ADR-PRIN-ONELIVE), so that span needs a different shape (a heartbeat thread started
  before the first module). Recommendation: v1 as in step 3, then decide once a run shows whether Bootstrap ever blocks.
- **Q4.** Name of the opt-in switch (`-DiagnoseBlocking`, beside `-DiagnoseLoadTime`) and that a call site reads
  `if ($DiagnoseBlocking) { Assert-Wait }`, because each point costs its full duration on every run.
- **Q5.** Do the two ADR rules land with the code, or after the first use proves the shape?

## Open steps

One file at a time, each verified before the next (`.claude/CLAUDE.md`, Editing); C# edits need a fresh `pwsh`.

- [ ] Answer Q1-Q5 (check: each recorded here with its outcome, then fold into the contract above).
- [ ] If Q1 is config: add the default to `TimeoutsConfig.cs` and its test (check: `tests/types/TimeoutsConfig.Tests.ps1` passes).
- [ ] Write `Assert-Wait.ps1`, add it to the `.psd1` export list and `CatzcFiles`, write its test (check: `Assert-Wait.Tests.ps1` passes, then
      the module's tests).
- [ ] Importer: the opt-in switch and four standing points, all after the writers load: after `Import-AllModules`, after
      `Assert-CatzcRunModeExclusive`, after `Invoke-ImporterJanitors`, after the UNC `PSModulePath` check (check: `Invoke-Importer` tests pass;
      a run with the switch shows four warnings).
- [ ] `Invoke-TestRun` (startup is everything before the workers launch): the same switch through `Test-Automation`, four points: after
      `Get-TestDiscovery`, after `Assert-TestTagGate`, after `Get-TestRunContext`, before `Invoke-TestAutomationWorkers` (check: the
      `Invoke-TestRun` and `Test-Automation` tests pass; a worker's own switch stays off).
- [ ] Function help, then the ADR rules if Q5 says so (check: `Test-Links` and the ADR gates on the touched pages).
- [ ] After the first measured run: replace each watchpoint that found a block with a limit in `timeouts.yml`, and delete the rest (check: no
      `Assert-Wait` call left without a finding).

## Refs

- docs/adr/automation/fail-fast-with-asserts.md (ADR-AUTO-FAILFAST#5, #7)
- docs/adr/pwsh/assert-idioms.md (ADR-PWSH-ASSERT#6)
- docs/adr/automation/console-output-matters.md (ADR-AUTO-CONSOLE#7, #10)
- docs/adr/principles/one-living-version.md (ADR-PRIN-ONELIVE)
- automation/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1, automation/Catzc.Base.Writers/Write-Message.ps1
- automation/Catzc.Base.Execution/Invoke-WithProgress.ps1 (the heartbeat thread Q3 may reuse)
