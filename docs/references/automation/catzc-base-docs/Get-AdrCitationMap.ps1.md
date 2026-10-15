---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
    kind: comment-page
    body_sha: "063c910ce429"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$script:adrCitationMapCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
