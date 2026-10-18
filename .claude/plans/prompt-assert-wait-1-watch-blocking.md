---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18
  written: 2026-10-18
  plan: plan-assert-wait
---

# Prompt: the measured run, Watch-Blocking, the ADR pair, the limits

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-assert-wait.md` (its Contract and Q1 to Q6 are binding) and `.claude/plans/task-assert-wait.md` steps 7 and 8, then in
full `docs/adr/automation/fail-fast-with-asserts.md` and `docs/adr/pwsh/assert-idioms.md`.

The measured run is cheap and yours: in the background, `timeout 60 pwsh -NoProfile -File out/watch-run.ps1` where that script dot-sources
`importer.ps1 -DiagnoseBlocking` and writes the four watchpoint lines to `out/watch-run.log`. Read them. Then, one file at a time:
`Assert-Wait.ps1` becomes `Watch-Blocking.ps1` (D17) with its test file, the `.psd1` export, every call site and the help, the assert
subkind untouched; `ADR-AUTO-FAILFAST#8` and `ADR-PWSH-ASSERT#7` written present tense in the two ADR pages and registered in
`pwsh/Catzc.Base.Docs/configs/adrs.yml` (re-read it right before the append; another session may append too), `Build-AdrIndex` run, never
`docs/adr/index.md` by hand; the function head cites #8. Then each watchpoint whose worst tick showed a block becomes a `timeouts.yml` limit
through `Invoke-WithTimeout`, every other call is deleted, the `-DiagnoseBlocking` switch stays; a grep over the tree finds no `Assert-Wait`
and no watchpoint call without a recorded finding.

Owns: `pwsh/Catzc.Base.Timeouts/**`, `pwsh/.internal/Catzc.Internal.Importer.psm1` and
`pwsh/Catzc.Base.QualityGates/private/Invoke- TestRun.ps1` and `Test-Automation.ps1` (the watchpoint lines only), the two ADR pages,
`adrs.yml`, `importer.ps1` through `Build-RootConfig` if its template changes. Re-read a file right before editing it; each verified by its
own test file under `Invoke-TestFile` (`Watch-Blocking.Tests.ps1` 16 of 16, `TimeoutsConfig.Tests.ps1`, `New-Importer.Tests.ps1`,
`Invoke-TestRun.Tests.ps1`), `Test-AdrRegistry`, `Test-Links -Path` on the ADR pages. Never run Test-Automation or a gate over the whole
tree; a final session does that once, last. Never edit `.claude/plans`. No git add, commit, push or mv. Every Bash call runs under the time
safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU `timeout` prefix). The typed DLL under `pwsh/.compiled` is
ignored.

End by writing `out/reports/assert-wait-1.md`: the four watchpoint readings, what landed with each verdict line, what is left, every file
touched.
