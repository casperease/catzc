---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/Get-Config.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "454974e7bbc0"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/Get-Config.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$fragmentPath = $null`, written with `#`.

```text
A consumer overlay's fragment of this config (<overlay root>/<Module>/configs/<name>.yml), in build mode only
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). The cache key carries the fragment's stamp,
so an edited fragment is never served from a stale merge.
```

## comment:2

Above `$script:configCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
