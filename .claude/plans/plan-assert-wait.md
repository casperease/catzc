---
plan:
  status: active
  value: medium
  reviewed: 2026-10-16
  blocked_on:
    nothing; Q1-Q5 are answered below, and the open steps are the config move, a green Test-Automation file and the first measured run
  targets:
    [
      automation/Catzc.Base.Timeouts,
      automation/.internal/Catzc.Internal.Importer.psm1,
      automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-assert-wait.md"
    folder: plans
    name: plan-assert-wait
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
      - ADR-AUTO-CONSOLE#7
      - ADR-AUTO-DEFAULT#{2,6}
      - ADR-AUTO-FAILFAST#{5,7}
      - ADR-AUTO-TEST#3
      - ADR-PWSH-ASSERT#6
      - ADR-PWSH-VERBS#2
      - ADR-REPO-HELP#1
    links:
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
---

# Assert-Wait: a watchpoint for a suspected block

`Assert-Wait` is one line you stand at a place where the thread or process may be blocked. It holds the calling thread for `-Seconds` +
`-Millisecs` (default 1 s + 1 ms), writes a line per tick through `Write-Message`, ends with one `Write-Message -Warning`, and lets go. It
stops nothing and throws on nothing. First uses: the startup of the importer and of `Test-Automation`.

## Why its value is medium

A hang today shows nothing about where it stopped (ADR-AUTO-FAILFAST#7, "A hang is the slowest failure"). The watchpoint finds the place so
a limit can be put there and tuned. It is a diagnostic that leaves the tree once the block is bounded, so its lasting value is the limits it
leads to, not the function. It needs one ADR pair and one L0 test file.

## Contract (final for v1; Q1-Q3 answered below)

- `Assert-Wait [-Seconds <int>] [-Millisecs <int>]`, both `ValidateRange` (Seconds 0-3600, Millisecs 0-3600000), defaults read from the
  `wait` map of `TimeoutsConfig` (1 s and 1 ms); the total must be above zero (`Assert-True`).
- Waits `Seconds + Millisecs` in ten evenly spaced ticks (a named constant, not a knob). Each tick line gives due, actual and lateness from
  a `Stopwatch`; the opening line names `<file>:<line>` from `Get-PSCallStack` frame 1.
- Information stream always, never `-Verbose`-gated; silent under Pester like every writer.
- The closing line is `Write-Message -Warning`, always, blocked or not: asked, measured, worst tick late, and "remove this watchpoint once
  the block is bounded". It is not the `Write-Warning` cmdlet: the importer sets `$WarningPreference = 'Stop'`, so the cmdlet would
  terminate.
- Returns nothing; throws only for invalid arguments, never caught (ADR-AUTO-FAILFAST#5).
- Sees the calling thread's schedule only; a starved process shows as late ticks too. Telling thread from process apart (a second thread's
  heartbeat, as `Invoke-WithProgress` runs) is out of scope.
- Home: `Catzc.Base.Timeouts`, beside `Assert-CompletesWithin`. `ADR-PWSH-ASSERT#6` bans an unbounded wait; this one is bounded by
  construction, so its `Start-Sleep` is not a finding.

## Needed docs

- `ADR-AUTO-FAILFAST#8`: mark a suspected block with a watchpoint, then bound it (Q5). `ADR-PWSH-ASSERT#7`: the pwsh form. Both go through
  `automation/Catzc.Base.Docs/configs/adrs.yml` and `Build-AdrIndex`; present tense, no history.
- Function help for `Assert-Wait` (ADR-REPO-HELP); a glossary entry only if `watchpoint` becomes a defined term (`glossary-keeper`).
- The `timeouts.yml` page documents the new `wait` keys (Q1).

## Needed tests

- `tests/Assert-Wait.Tests.ps1`, L0 logic, neutral fixture names (ADR-AUTO-TEST#3); lift `$global:__PesterRunning` in the test's own scope.
  - default total is 1.001 s with ten ticks; `-Seconds 0 -Millisecs 30` runs 30 ms
  - zero total and a negative value throw the assertion message
  - output order: opening, ten ticks, exactly one warning, the warning last
  - the warning is on the information stream and `$WarningPreference = 'Stop'` does not terminate it
  - a late tick (mocked clock or `Start-Sleep`) is named in the closing line
  - returns nothing
- `TimeoutsConfig` tests for the `wait` keys (Q1): the defaults 1 and 1 when the key is absent, an override read, an unknown key under
  `wait` rejected, and a zero or negative value rejected.
- Module-graph check that `Catzc.Base.Timeouts` -> `Catzc.Base.Writers` makes no cycle (ADR-AUTO-DEPM).

## Open questions

- **Q1. Answered 2026-10-17 at the user's request: on the config type.** The defaults 1 s and 1 ms are declared once on `TimeoutsConfig`, as
  a `wait` map with `seconds` and `millisecs`, one pair and not keyed by environment (a watchpoint is a diagnostic; a pipeline run of one is
  the rare case). The `param` block reads them from `Get-Config -Config timeouts` and restates no number. Why:
  [ADR-AUTO-DEFAULT#6](../../docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6) declares a sensible default exactly once, on
  the setting's config type, and ADR-AUTO-DEFAULT#2 pulls defaults from configuration. Projected outcome: `timeouts.yml` may set `wait`, a
  fresh checkout behaves as the type says, and `Assert-Wait.Tests.ps1` still pins a 1.001 s total. The literals now in `Assert-Wait.ps1` are
  replaced in the same change (ADR-PRIN-ONELIVE).
- **Q2. Answered 2026-10-17 at the user's request: as drafted.** `Assert-Wait` really waits and measures its own ticks (not a threshold on
  time since a start mark); `Millisecs` adds to `Seconds` (not a tick interval); the closing warning always fires. Why: a threshold needs a
  start mark and a second function, so a one-line watchpoint cannot be one; the request's own wording ("write-aggressively ... conclude with
  write-warning and then let go") describes a function that stands and speaks; and an always-on warning keeps a temporary diagnostic from
  being parked in the tree (ADR-PRIN-ONELIVE). Projected outcome: the 16 tests in `Assert-Wait.Tests.ps1` stand as they are, and the
  contract above is final for v1.
- **Q3. Answered 2026-10-17 at the user's request: v1 as built; the Bootstrap span stays uncovered until a measured run asks for it.** The
  standing points sit only after the module import. The Bootstrap phases (loader, vendor, type compile) keep `-DiagnoseLoadTime`, which
  already times them. A Bootstrap copy of `Assert-Wait` would be a second living version (ADR-PRIN-ONELIVE), and the other shape (a
  heartbeat thread started before the first module, as `Invoke-WithProgress` runs one) is a new function, so it waits for evidence. Evidence
  to collect first: run `importer.ps1 -DiagnoseBlocking` and `-DiagnoseLoadTime` side by side; a Bootstrap phase that dominates the load
  time without a visible cause is the trigger to open that shape as its own plan. Observation from the first real run: all four importer
  watchpoints reported a worst tick about 110 ms late (116, 114, 106, 109), the same each time, so it looks like a fixed cost of the first
  tick in that session and not a stall; find its source before reading a late tick in the importer as a block. Projected outcome: no new
  code now; the follow-up is a measured step below.
- **Q4 (built, not yet confirmed).** The opt-in switch is `-DiagnoseBlocking`, beside `-DiagnoseLoadTime`, on `importer.ps1`,
  `Test-Automation` and `Invoke-TestRun`; a call site reads `if ($DiagnoseBlocking) { Assert-Wait }`, because each point costs its full
  duration on every run. The importer's standing points add about four seconds to its own "Loaded in" line.
- **Q5. Answered 2026-10-17 at the user's request: after the first measured run, not with the code.** `ADR-AUTO-FAILFAST#8` and
  `ADR-PWSH-ASSERT#7` are written once a run has shown what a watchpoint finds and whether the ten-tick shape and the always-on warning
  hold. An ADR states the current design in the present tense and is cited by code (`ADR-AUTO-FAILFAST#8`); a rule written before the shape
  is proven would be edited or retired again, and a retired number is never reused. The function's head block cites ADR-AUTO-FAILFAST#{5,7},
  which is what governs it meanwhile. Projected outcome: the ADR step stays open with that trigger.

## Open steps

One file at a time, each verified before the next (`.claude/CLAUDE.md`, Editing); C# edits need a fresh `pwsh`.

- [x] Answer Q1, Q2, Q3 and Q5. Done 2026-10-17: each is recorded above with its outcome and folded into the contract.
- [x] Q1: add the `wait` map (`seconds`, `millisecs`, defaults 1 and 1) to `TimeoutsConfig.cs` and its tests, then replace the literals in
      `Assert-Wait.ps1` with the config read (check: `tests/types/TimeoutsConfig.Tests.ps1` and `Assert-Wait.Tests.ps1` pass; C# edits need
      a fresh `pwsh`). Done 2026-10-17 (task024): `[Invoke-TestFile] Passed` for both (`out/test-file/20261017-201413-8a6544`,
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
      (check: the file passes under Invoke-TestFile). 2026-10-17 (task024): the wording is fixed everywhere; the one finding left is that
      file name, a `git mv` to `Test-FileKindReachability.Tests.ps1` that is the user's.
- [x] Q3: run `importer.ps1 -DiagnoseBlocking` and `-DiagnoseLoadTime` side by side and find where the fixed ~110 ms first-tick lateness
      comes from (check: the cause is named here, or the tick no longer reports it). Done 2026-10-17 (task024, `out/t024-diag.ps1`): it was
      never the first tick. Each `Start-Sleep -Milliseconds 100` overruns by about 9 ms (a bare session measures 107 ms, the first call 148
      ms), and the loop slept the full slice every tick, so the overrun accumulated: ticks late by 3, 15, 22, 30, 42, 49, 65, 72, 79, 86 ms,
      the worst always the last. The loop now sleeps until the tick is due; the same four importer watchpoints then report a worst tick of
      13 to 14 ms and 1.002 to 1.012 s measured for 1.001 s asked. `-DiagnoseLoadTime` shows no phase that hides a block (types 203 ms,
      the largest module imports 56 to 66 ms).
- [x] Function help beyond the head blocks (check: `Test-Links` on the touched pages). Corrected 2026-10-17 (task024): the head's config
      part is the whole help (ADR-REPO-HELP#1), and it now names the registry defaults.
- [ ] Q6, raised by the read-only review of 2026-10-17 (session catzc-6c): `Assert-Wait` throws only for a bad argument and otherwise lets
      go, while ADR-PWSH-VERBS#2 and #3 make an Assert- function one that stops the caller, and the file sits in the `assert` subkind of
      file-kinds.yml ("stops the caller"). The user decides: a watch verb (`Watch-Blocking`) with the assert subkind untouched, or a VERBS#7
      exemption for a watchpoint that never stops (check: a Decided line, then the rename or the exemption in the same change as the ADR
      pair of Q5).
- [ ] Q5: after the first measured run, write `ADR-AUTO-FAILFAST#8` and `ADR-PWSH-ASSERT#7` (check: `Build-AdrIndex`, `Test-Links` and the
      ADR gates on the touched pages).
- [ ] After the first measured run: replace each watchpoint that found a block with a limit in `timeouts.yml`, and delete the rest (check:
      no `Assert-Wait` call left without a finding).

## Refs

- docs/adr/automation/fail-fast-with-asserts.md (ADR-AUTO-FAILFAST#5, #7)
- docs/adr/pwsh/assert-idioms.md (ADR-PWSH-ASSERT#6)
- docs/adr/automation/console-output-matters.md (ADR-AUTO-CONSOLE#7, #10)
- docs/adr/principles/one-living-version.md (ADR-PRIN-ONELIVE)
- automation/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1, automation/Catzc.Base.Writers/Write-Message.ps1
- automation/Catzc.Base.Execution/Invoke-WithProgress.ps1 (the heartbeat thread Q3 may reuse)
