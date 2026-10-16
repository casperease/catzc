---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/WorkerParentWatch.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6e39aeeb1668"
    adrs:
      - ADR-PWSH-ENV#4
---

# automation/Catzc.Base.QualityGates/tests/types/WorkerParentWatch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:savedPid = $env:CATZC_TEST_PARENT_PID`, written with `#`.

```text
Process-scope only, snapshot and restore
([ADR-PWSH-ENV#4](/docs/adr/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env4)): under the harness these hold the real
parent, and only the absent/malformed cases run here — a watch that starts in THIS process would
watch whatever the variables name.
```
