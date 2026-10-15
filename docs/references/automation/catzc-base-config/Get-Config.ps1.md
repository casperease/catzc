---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/Get-Config.ps1.md
    kind: comment-page
    body_sha: d2168305b610
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/Get-Config.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$fragmentPath = $null`.

```text
A consumer overlay's fragment of this config (<overlay root>/<Module>/configs/<name>.yml), in build mode only
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). The cache key carries the fragment's stamp,
so an edited fragment is never served from a stale merge.
```

## comment:5

Above `$script:configCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
