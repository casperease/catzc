---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-ReadmeMappings.ps1.md
    kind: comment-page
    body_sha: "9d81d8b85a22"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `foreach ($dir in ([System.IO.Directory]::EnumerateDirectories($prefixPath) |...`.

```text
[System.IO] (sorted) rather than Get-ChildItem — the cmdlet carries ~20ms of per-call provider
overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)). '*' excludes dot-prefixed
infrastructure folders.
```
