---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoAzModuleNaming.psm1.md
    kind: comment-page
    body_sha: a7bcdce9f640
    adrs:
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoAzModuleNaming.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Functions must not use the Verb-Az<Noun> naming pattern of the Az PowerShell
modules (Get-AzResource, New-AzVM, …). Name Azure-platform functions
Verb-Azure<Noun> — Azure spelled out, so it cannot collide with Az.* cmdlets.

The only sanctioned Az* prefixes are Verb-AzCli* (az CLI wrappers, e.g.
Invoke-AzCli, Assert-AzCliIsConnected) and Verb-AzBicep* (az bicep checks).
Both cover the az CLI itself, not the Az PowerShell modules — see the ADR to
prefer Az CLI over Az PowerShell modules.
```

## comment:2

Above `$isFunctionDefinition = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
