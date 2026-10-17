---
task:
  id: "024"
  status: open
  plans: [plan-assert-wait]
  value: medium
  blocked_on: nothing; steps 6 and 7 wait for the first measured run
  targets:
    [
      automation/Catzc.Base.Timeouts,
      automation/.internal/Catzc.Internal.Importer.psm1,
      automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1,
      docs/adr/automation/fail-fast-with-asserts.md,
      docs/adr/pwsh/assert-idioms.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task024.md"
    folder: plans
    name: task024
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task024: Assert-Wait, the config read, the measured run, the ADR pair

Q1 to Q5 are answered (plan-assert-wait, 2026-10-17). Built: `Assert-Wait.ps1` with 16 tests, `-DiagnoseBlocking` on importer.ps1,
Test-Automation and Invoke-TestRun with four standing points each. Open: the defaults move onto `TimeoutsConfig` (Q1), one failing suite
file caused by peers, the 110 ms first-tick source (Q3), help, and the ADR pair after a measured run (Q5). C# edits need a fresh pwsh.

## Steps

1. `automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs`: a `wait` map with `seconds` (default 1) and `millisecs` (default 1), one pair,
   not keyed by environment; an unknown key under `wait` and a zero or negative value are rejected at construction naming the key. Check:
   the file compiles in a fresh pwsh.
2. `tests/types/TimeoutsConfig.Tests.ps1`: defaults when the key is absent; an override read; unknown key rejected; zero and negative
   rejected. Check: passes.
3. `Assert-Wait.ps1`: the `param` block reads `Get-Config -Config timeouts` and restates no number; `ValidateRange` stays. Check:
   `Assert-Wait.Tests.ps1` still passes 16 of 16 with a 1.001 s default total.
4. `Test-Automation.Tests.ps1`: its one failure (source-conventions) comes from a peer's `FileKindReachability.Tests.ps1` name and "bash and
   zsh" wording in seven plans. Those plans are this folder's: fix the wording in each plan file, one at a time (the sanctioned form per the
   conventions config). Check: the file passes; grep "bash and zsh" in `.claude/plans` finds nothing.
5. Q3: run `importer.ps1 -DiagnoseBlocking` and `-DiagnoseLoadTime` side by side in the background (360 s cap); name where the fixed about
   110 ms first-tick lateness comes from (first-tick JIT of Stopwatch and Write-Message is the likely answer) in the plan. Check: the cause
   is named, or the tick no longer reports it.
6. Function help for `Assert-Wait` beyond the head block, per ADR-REPO-HELP; `watchpoint` as a glossary term only if the ADR of step 7 bolds
   it. Check: Test-Links on the touched pages.
7. After the first measured `Test-Automation -DiagnoseBlocking` run (the user's): `ADR-AUTO-FAILFAST#8` (mark a suspected block with a
   watchpoint, then bound it) and `ADR-PWSH-ASSERT#7` (the pwsh form) through adrs.yml and `Build-AdrIndex`; present tense. Check:
   Test-AdrRegistry, Test-Links clean; the function head cites #8.
8. After that run: each watchpoint that found a block becomes a `timeouts.yml` limit with `Invoke-WithTimeout`; every other `Assert-Wait`
   call is deleted; the `-DiagnoseBlocking` switch stays. Check: grep `Assert-Wait` outside its own module and tests finds no call without a
   recorded finding.
9. Tick the plan's steps; it is deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
