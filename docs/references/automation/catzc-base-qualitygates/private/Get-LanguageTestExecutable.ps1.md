---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
    kind: comment-page
    body_sha: abae1f5d404c
    adrs:
      - ADR-AUTO-ENGINE#1
---

# automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name`.

```text
The engines other than the running pwsh, which every language's tests also run under
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1): the model's engines, never
a restated list): each located once here, since a build run's worker cannot locate it (its tools.yml entry is
not in the build).
```
