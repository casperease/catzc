---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f2dc382197c9
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$names = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
[System.IO] (sorted ordinally) instead of Get-ChildItem -Directory — the cmdlet carries ~20ms of
per-call provider overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); the ordinal sort is
culture-independent (cross-platform).
```
