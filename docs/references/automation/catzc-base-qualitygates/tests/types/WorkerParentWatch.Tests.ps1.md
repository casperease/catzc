---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/WorkerParentWatch.Tests.ps1.md
    kind: test-asset
    body_sha: d924f919f947
    adrs:
      - ADR-PWSH-ENV#4
---

# automation/Catzc.Base.QualityGates/tests/types/WorkerParentWatch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:savedPid = $env:CATZC_TEST_PARENT_PID`.

```text
Process-scope only, snapshot and restore
([ADR-PWSH-ENV#4](/docs/adr/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env4)): under the harness these hold the real
parent, and only the absent/malformed cases run here — a watch that starts in THIS process would
watch whatever the variables name.
```
