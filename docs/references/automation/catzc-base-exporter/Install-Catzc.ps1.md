---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Install-Catzc.ps1.md
    kind: comment-page
    body_sha: "8d1d4efbcdf6"
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-ENGINE#2
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/Install-Catzc.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `function Install-Catzc {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:7

Above `if (-not $IsWindows) {`.

```text
A copy drops the executable bit, which an engine whose scripts need it (bash) requires on Unix
([ADR-AUTO-ENGINE#2](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine2)): every shipped script
of such an engine that starts with its shebang is made executable again.
```

## comment:8

Above `foreach ($script in Get-ChildPath $moduleTarget -File -Filter "*$extension"...`.

```text
A named whole-tree walk
([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every shebang
script of the installed module is re-marked.
```
