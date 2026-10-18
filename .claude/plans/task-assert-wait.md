---
task:
  status: open
  plans: [plan-assert-wait]
  value: medium
  blocked_on: nothing; steps 6 and 7 wait for the first measured run
  targets:
    [
      pwsh/Catzc.Base.Timeouts,
      pwsh/.internal/Catzc.Internal.Importer.psm1,
      pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1,
      docs/adr/automation/fail-fast-with-asserts.md,
      docs/adr/pwsh/assert-idioms.md,
    ]
---

# Task: Assert-Wait, the config read, the measured run, the ADR pair

Q1 to Q5 are answered (plan-assert-wait, 2026-10-17). Built: `Assert-Wait.ps1` with 16 tests, `-DiagnoseBlocking` on importer.ps1,
Test-Automation and Invoke-TestRun with four standing points each. Open: the defaults move onto `TimeoutsConfig` (Q1), one failing suite
file caused by peers, the 110 ms first-tick source (Q3), help, and the ADR pair after a measured run (Q5). C# edits need a fresh pwsh.

## Steps

1. [x] `pwsh/Catzc.Base.Timeouts/types/TimeoutsConfig.cs`: a `wait` map with `seconds` (default 1) and `millisecs` (default 1), one pair,
       not keyed by environment; an unknown key under `wait` and a zero or negative value are rejected at construction naming the key.
       Check: the file compiles in a fresh pwsh. Done 2026-10-17: `wait`, `WaitDefaultSeconds`, `WaitDefaultMillisecs`, `ReadWait`; compiled
       by the import of `out/t024-a.ps1`.
2. [x] `tests/types/TimeoutsConfig.Tests.ps1`: defaults when the key is absent; an override read; unknown key rejected; zero and negative
       rejected. Check: passes. Done 2026-10-17: `[Invoke-TestFile] Passed` (`out/test-file/20261017-201413-8a6544`).
3. [x] `Assert-Wait.ps1`: the `param` block reads `Get-Config -Config timeouts` and restates no number; `ValidateRange` stays. Check:
       `Assert-Wait.Tests.ps1` still passes 16 of 16 with a 1.001 s default total. Done 2026-10-17: both defaults read `wait` from the
       registry, the help names the registry; `[Invoke-TestFile] Passed` (`out/test-file/20261017-201434-2a266e`). After the step 5 loop
       change (sleep until the tick is due) the tick test asserts the due times and the requested sleeps instead of ten equal slices; 16 of
       16 pass (`out/test-file/20261017-202939-c2cea9`).
4. `Test-Automation.Tests.ps1`: its one failure (source-conventions) comes from a peer's `FileKindReachability.Tests.ps1` name and an
   engine-pair wording in seven plans. Those plans are this folder's: fix the wording in each plan file, one at a time (the sanctioned form
   per the conventions config). Check: the file passes; a grep for the engine pair in `.claude/plans` finds nothing. 2026-10-17: the wording
   is gone from six plan lines, three ADRs and the cats glossary entry, and the two tests that assert real rule codes are exempted with
   their reason in source-conventions.yml; `SOURCECONV issues=1`, the one left being the file name
   `Catzc.Base.Globs/tests/FileKindReachability.Tests.ps1`, whose rename to `Test-FileKindReachability.Tests.ps1` is a `git mv`, the user's;
   the test file fails on that one finding until then (`out/test-file/20261017-201739-d549ec`).
5. [x] Q3: run `importer.ps1 -DiagnoseBlocking` and `-DiagnoseLoadTime` side by side in the background (360 s cap); name where the fixed
       about 110 ms first-tick lateness comes from (first-tick JIT of Stopwatch and Write-Message is the likely answer) in the plan. Check:
       the cause is named, or the tick no longer reports it. Done 2026-10-17: the cause is accumulated sleep overrun, about 9 ms per tick,
       not a first-tick cost (named in plan-assert-wait Q3); `Assert-Wait` now sleeps until each tick is due, and the worst tick fell from
       86 to 94 ms to 13 to 14 ms over the four importer watchpoints (`out/t024-c.ps1`). The tick test is rewritten for the new loop; its
       verdict is in the report.
6. [x] Function help for `Assert-Wait` beyond the head block, per ADR-REPO-HELP; `watchpoint` as a glossary term only if the ADR of step 7
       bolds it. Check: Test-Links on the touched pages. Corrected 2026-10-17: ADR-REPO-HELP#1 makes the head's `config` part the whole
       help, so there is nothing beyond it; the head's parameter entries now name the registry defaults (step 3), and `watchpoint` waits for
       step 7.
7. [x] ADR half landed 2026-10-18 too: ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND and ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH ("Test-AdrRegistry
   0; Test-Links 0"). Code half landed 2026-10-18 by session catzc-93, verdict: "Watch-Blocking.Tests 16/16; TimeoutsConfig.Tests, Invoke-TestRun.Tests,
   PesterRunner.Tests and Import-AllModules.Tests pass under Invoke-TestFile in a fresh pwsh; no Assert-Wait anywhere outside
   .claude/plans and the generated .assets pages; Test-Spelling 0" (renamed by plain mv: the user's `git add` records it). Open: the ADR
   half, written in the named form now that the rule renaming landed; held by catzc-93. Original step: After the first measured run
   (`importer.ps1 -DiagnoseBlocking`, the user's, task-user-runs-and-commits step 5; the Test-Automation points
   are read only if the final full run carries the switch, and nothing waits on that): `ADR-AUTO-FAILFAST#8` (mark a suspected block with a
   watchpoint, then bound it) and `ADR-PWSH-ASSERT#7` (the pwsh form) through adrs.yml and `Build-AdrIndex`; present tense. In the same
   change, D17 (2026-10-18): `Assert-Wait.ps1` becomes `Watch-Blocking.ps1` with its test file, the `.psd1` export, every call site and the
   help, the assert subkind of file-kinds.yml untouched. Check: Test-AdrRegistry, Test-Links clean; the function head cites #8;
   `Watch-Blocking.Tests.ps1` passes 16 of 16; a grep for `Assert-Wait` over the tree finds nothing.
8. [x] Landed 2026-10-18 by session catzc-93 (the same verdict as step 7): no watchpoint found a block, so all eight calls are deleted
   (Importer.psm1 four, Invoke-TestRun four); the switch and Watch-Blocking stay as the mark/measure/bound/remove mechanism. Original
   step: After that run: each watchpoint that found a block becomes a `timeouts.yml` limit with `Invoke-WithTimeout`; every other `Assert-Wait`
   call is deleted; the `-DiagnoseBlocking` switch stays. Check: grep `Assert-Wait` outside its own module and tests finds no call without a
   recorded finding.
9. [x] Ticked 2026-10-18 but one: the plan's `Test-Automation.Tests.ps1` step waits on the user's `git mv` of FileKindReachability.Tests
   (task-user-runs-and-commits step 2). Original step: Tick the plan's steps; it is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.

- 2026-10-18, session catzc-93: the measured run (`importer.ps1 -DiagnoseBlocking`, `out/diagnose-blocking.txt`) found no block; the four
  importer watchpoints' worst ticks were 12, 12, 13 and 14 ms late, the timer's resolution. The four Invoke-TestRun watchpoints were never
  measured (no full run carried the switch). All eight calls are deleted; `-DiagnoseBlocking` and `Watch-Blocking` stay as the mechanism.
