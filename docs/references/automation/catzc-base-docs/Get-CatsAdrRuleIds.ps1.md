---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "10a3bd2e098c"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:catsAdrRuleIdsCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$adrRoot = Split-Path $IndexPath -Parent`, written with `#`.

```text
Index rows carry ADR paths relative to the index's own folder (docs/adr/), so resolve against it rather
than a hardcoded docs/adr — that keeps a fixture index beside fixture ADR files working the same way.
```
