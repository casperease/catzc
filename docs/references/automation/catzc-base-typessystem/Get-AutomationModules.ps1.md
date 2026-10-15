---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md
    kind: comment-page
    body_sha: "931983a53460"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$names = [System.Collections.Generic.List[string]]::new()`.

```text
[System.IO] (sorted ordinally) instead of Get-ChildItem -Directory — the cmdlet carries ~20ms of
per-call provider overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); the ordinal sort is
culture-independent (cross-platform).
```
