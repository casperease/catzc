---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  blocked_on: the user's git mv of FileKindReachability.Tests (task-user-runs-and-commits step 2), the one open step
  targets: [pwsh/Catzc.Base.Timeouts, pwsh/.internal/Catzc.Internal.Importer.psm1, pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1]
---

# Assert-Wait: a watchpoint for a suspected block

`Assert-Wait` is one line you stand at a place where the thread or process may be blocked. It holds the calling thread for `-Seconds` +
`-Millisecs` (default 1 s + 1 ms), writes a line per tick through `Write-Message`, ends with one `Write-Message -Warning`, and lets go. It
stops nothing and throws on nothing. First uses: the startup of the importer and of `Test-Automation`.

## Why its value is medium

A hang today shows nothing about where it stopped (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT, "A hang is the slowest failure"). The watchpoint finds
the place so a limit can be put there and tuned. It is a diagnostic that leaves the tree once the block is bounded, so its lasting value is
the limits it leads to, not the function. It needs one ADR pair and one L0 test file.

## Contract (final for v1; Q1-Q3 answered below)

- `Assert-Wait [-Seconds <int>] [-Millisecs <int>]`, both `ValidateRange` (Seconds 0-3600, Millisecs 0-3600000), defaults read from the
  `wait` map of `TimeoutsConfig` (1 s and 1 ms); the total must be above zero (`Assert-True`).
- Waits `Seconds + Millisecs` in ten evenly spaced ticks (a named constant, not a knob). Each tick line gives due, actual and lateness from
  a `Stopwatch`; the opening line names `<file>:<line>` from `Get-PSCallStack` frame 1.
- Information stream always, never `-Verbose`-gated; silent under Pester like every writer.
- The closing line is `Write-Message -Warning`, always, blocked or not: asked, measured, worst tick late, and "remove this watchpoint once
  the block is bounded". It is not the `Write-Warning` cmdlet: the importer sets `$WarningPreference = 'Stop'`, so the cmdlet would
  terminate.
- Returns nothing; throws only for invalid arguments, never caught (ADR-AUTO-FAILFAST-NEVERCATCHASSERTIONS).
- Sees the calling thread's schedule only; a starved process shows as late ticks too. Telling thread from process apart (a second thread's
  heartbeat, as `Invoke-WithProgress` runs) is out of scope.
- Home: `Catzc.Base.Timeouts`, beside `Assert-CompletesWithin`. `ADR-PWSH-ASSERT-TWOWAITBOUNDS` bans an unbounded wait; this one is bounded
  by construction, so its `Start-Sleep` is not a finding.

## Needed docs

- ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND (mark a suspected block with a watchpoint, then bound it) and
  ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH (the pwsh form): written 2026-10-18.
- Function help for `Assert-Wait` (ADR-REPO-HELP); a glossary entry only if `watchpoint` becomes a defined term (`glossary-keeper`).
- The `timeouts.yml` page documents the new `wait` keys (Q1).

## Needed tests

- `tests/Assert-Wait.Tests.ps1`, L0 logic, neutral fixture names (ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES); lift `$global:__PesterRunning`
  in the test's own scope.
  - default total is 1.001 s with ten ticks; `-Seconds 0 -Millisecs 30` runs 30 ms
  - zero total and a negative value throw the assertion message
  - output order: opening, ten ticks, exactly one warning, the warning last
  - the warning is on the information stream and `$WarningPreference = 'Stop'` does not terminate it
  - a late tick (mocked clock or `Start-Sleep`) is named in the closing line
  - returns nothing
- `TimeoutsConfig` tests for the `wait` keys (Q1): the defaults 1 and 1 when the key is absent, an override read, an unknown key under
  `wait` rejected, and a zero or negative value rejected.
- Module-graph check that `Catzc.Base.Timeouts` -> `Catzc.Base.Writers` makes no cycle (ADR-AUTO-DEPM).

## Decided

- Q1: the defaults (1 s, 1 ms) are declared once on `TimeoutsConfig` as a `wait` map; the function restates no number.
- Q2: the watchpoint really waits, measures its own ticks and always ends with a warning.
- Q3: the standing points sit after the module import only; the Bootstrap span keeps `-DiagnoseLoadTime`.
- Q4: the switch is `-DiagnoseBlocking` on `importer.ps1`, `Test-Automation` and `Invoke-TestRun`. Since the measured run of 2026-10-18
  found no block, no watchpoint stands; the switch and `Watch-Blocking` stay as the mark, measure, bound, remove mechanism.
- Q5: the rules were written after that run, in the named form: ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND and
  ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH.

## Open steps

One file at a time, each verified before the next (`.claude/CLAUDE.md`, Editing); C# edits need a fresh `pwsh`.

- [x] Answer Q1, Q2, Q3 and Q5. Done 2026-10-17: each is recorded above with its outcome and folded into the contract.
- [x] Q1: add the `wait` map (`seconds`, `millisecs`, defaults 1 and 1) to `TimeoutsConfig.cs` and its tests, then replace the literals in
      `Assert-Wait.ps1` with the config read (check: `tests/types/TimeoutsConfig.Tests.ps1` and `Assert-Wait.Tests.ps1` pass; C# edits need
      a fresh `pwsh`). Done 2026-10-17 (task-assert-wait): `[Invoke-TestFile] Passed` for both (`out/test-file/20261017-201413-8a6544`,
      `out/test-file/20261017-201434-2a266e`).
- [x] Write `Assert-Wait.ps1`, add it to the `.psd1` export list and `CatzcFiles`, write its test. Done 2026-10-17: `Assert-Wait.Tests.ps1`
      passes 16 of 16. The rest of the module's tests were not run.
- [x] Importer: the opt-in switch and four standing points (after `Import-AllModules`, `Assert-CatzcRunModeExclusive`,
      `Invoke-ImporterJanitors`, the UNC `PSModulePath` check). Done 2026-10-17: a `-DiagnoseBlocking` import printed four watchpoints;
      `importer.ps1` regenerated with `Build-RootConfig 'importer.ps1'`, and `New-Importer.Tests.ps1` passes 9 of 9. Docs updated:
      `invoke-importer-in-code-order.md` and the getting-started `index.md`. `Invoke-Importer` has no test of its own for the switch.
- [x] `Invoke-TestRun` and `Test-Automation`: the same switch, four points (after `Get-TestDiscovery`, `Assert-TestTagGate`,
      `Get-TestRunContext`, and just before the workers). Done 2026-10-17: `Invoke-TestRun.Tests.ps1` passes 21 of 21, including two new
      tests (four waits then workers; none by default). A real `Test-Automation -DiagnoseBlocking` run was not made.
- [ ] Run `Test-Automation.Tests.ps1` green. Its one failure on 2026-10-17 is the source-conventions check, caused by other files: a peer's
      `Catzc.Base.Globs/tests/FileKindReachability.Tests.ps1` name and an engine-pair wording in seven other plans, none of them this one
      (check: the file passes under Invoke-TestFile). 2026-10-17 (task-assert-wait): the wording is fixed everywhere; the one finding left
      is that file name, a `git mv` to `Test-FileKindReachability.Tests.ps1` that is the user's.
- [x] Q3: run `importer.ps1 -DiagnoseBlocking` and `-DiagnoseLoadTime` side by side and find where the fixed ~110 ms first-tick lateness
      comes from (check: the cause is named here, or the tick no longer reports it). Done 2026-10-17 (task-assert-wait,
      `out/t024-diag.ps1`): it was never the first tick. Each `Start-Sleep -Milliseconds 100` overruns by about 9 ms (a bare session
      measures 107 ms, the first call 148 ms), and the loop slept the full slice every tick, so the overrun accumulated: ticks late by 3,
      15, 22, 30, 42, 49, 65, 72, 79, 86 ms, the worst always the last. The loop now sleeps until the tick is due; the same four importer
      watchpoints then report a worst tick of 13 to 14 ms and 1.002 to 1.012 s measured for 1.001 s asked. `-DiagnoseLoadTime` shows no
      phase that hides a block (types 203 ms, the largest module imports 56 to 66 ms).
- [x] Function help beyond the head blocks (check: `Test-Links` on the touched pages). Corrected 2026-10-17 (task-assert-wait): the head's
      config part is the whole help (ADR-REPO-HELP-HELPONCOMMENTPAGE), and it now names the registry defaults.
- [x] Done 2026-10-18 with the rename (catzc-93; task-assert-wait step 7). Q6, raised by the read-only review of 2026-10-17 (session
      catzc-6c): `Assert-Wait` throws only for a bad argument and otherwise lets go, while ADR-PWSH-VERBS-SEMANTICCONTRACT and
      ADR-PWSH-VERBS-TESTANDASSERT make an Assert- function one that stops the caller, and the file sits in the `assert` subkind of
      file-kinds.yml ("stops the caller"). The user decides: a watch verb (`Watch-Blocking`) with the assert subkind untouched, or a VERBS#7
      exemption for a watchpoint that never stops (check: a Decided line, then the rename or the exemption in the same change as the ADR
      pair of Q5). Decided 2026-10-18 (D17): the rename to `Watch-Blocking`, the assert subkind untouched; it lands with the Q5 pair.
- [x] Done 2026-10-18 by session catzc-93: the run found no block (worst tick 12-14 ms); the rules landed in the named form as
      ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND and ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH ("Build-AdrIndex ok; Test-AdrRegistry 0;
      Test-Links 0, Test-Markdownlint 0 and Test-Spelling 0 on both ADRs and index.md"); Watch-Blocking.Tests 16/16. Q5: after the first
      measured run (`importer.ps1 -DiagnoseBlocking`, four seconds, the user's; the Test-Automation points are read only if the final full
      run carries the switch, and nothing waits on that), write the two rules with the D17 rename to `Watch-Blocking` (check:
      `Build-AdrIndex`, `Test-Links` and the ADR gates on the touched pages; the renamed test file passes under `Invoke-TestFile`).
- [x] Done 2026-10-18 (catzc-93; task-assert-wait step 8): no watchpoint found a block, so all eight calls are deleted. After that run:
      replace each watchpoint that found a block with a limit in `timeouts.yml`, and delete the rest (check: a grep finds no watchpoint call
      left without a finding).

## Refs

- docs/adr/automation/fail-fast-with-asserts.md (ADR-AUTO-FAILFAST-NEVERCATCHASSERTIONS, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT)
- docs/adr/pwsh/assert-idioms.md (ADR-PWSH-ASSERT-TWOWAITBOUNDS)
- docs/adr/automation/console-output-matters.md (ADR-AUTO-CONSOLE-SPARINGCOLOUR, ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING)
- docs/adr/principles/one-living-version.md (ADR-PRIN-ONELIVE)
- pwsh/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1, pwsh/Catzc.Base.Writers/Write-Message.ps1
- pwsh/Catzc.Base.Execution/Invoke-WithProgress.ps1 (the heartbeat thread Q3 may reuse)
