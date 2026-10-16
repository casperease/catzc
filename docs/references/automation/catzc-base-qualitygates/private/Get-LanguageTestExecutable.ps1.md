---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b6cb5e31021f
    adrs:
      - ADR-AUTO-ENGINE#1
---

# automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name`, written with `#`.

```text
The engines other than the running pwsh, which every language's tests also run under
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1): the model's engines, never
a restated list): each located once here, since a build run's worker cannot locate it (its tools.yml entry is
not in the build).
```
