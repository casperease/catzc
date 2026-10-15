---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md
    kind: comment-page
    body_sha: "823ec729d989"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Execution/Invoke-Executable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:11

Above `function Invoke-Executable {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:12

Above `if ($env:CATZC_BLOCK_REAL_PROCESS -and -not $DryRun) {`.

```text
Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this
throws). When a unit (L1) run sets $env:CATZC_BLOCK_REAL_PROCESS, a real process launch means a Mock
failed to intercept — almost always a -ModuleName pointing at the wrong module — so the test was
silently hitting the live tool. Fail loudly instead. -DryRun is exempt (it never launches).
See [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md).
```
