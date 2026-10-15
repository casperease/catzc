---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md
    kind: comment-page
    body_sha: "73a67df77f74"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$script:catsAdrRuleIdsCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:6

Above `$adrRoot = Split-Path $IndexPath -Parent`.

```text
Index rows carry ADR paths relative to the index's own folder (docs/adr/), so resolve against it rather
than a hardcoded docs/adr — that keeps a fixture index beside fixture ADR files working the same way.
```
