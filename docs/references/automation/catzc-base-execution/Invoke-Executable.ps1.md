---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "000e07c88ba1"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Execution/Invoke-Executable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Invoke-Executable {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:2

Above `if ($env:CATZC_BLOCK_REAL_PROCESS -and -not $DryRun) {`, written with `#`.

```text
Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this
throws). When a unit (L1) run sets $env:CATZC_BLOCK_REAL_PROCESS, a real process launch means a Mock
failed to intercept — almost always a -ModuleName pointing at the wrong module — so the test was
silently hitting the live tool. Fail loudly instead. -DryRun is exempt (it never launches).
See [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md).
```
