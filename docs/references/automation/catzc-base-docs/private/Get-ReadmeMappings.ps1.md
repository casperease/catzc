---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-ReadmeMappings.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "26f05cbbd5fc"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($dir in ([System.IO.Directory]::EnumerateDirectories($prefixPath) |...`, written with `#`.

```text
[System.IO] (sorted) rather than Get-ChildItem — the cmdlet carries ~20ms of per-call provider
overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)). '*' excludes dot-prefixed
infrastructure folders.
```
