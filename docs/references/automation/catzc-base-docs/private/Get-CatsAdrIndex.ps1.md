---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsAdrIndex.ps1.md
    folder: docs/references/automation/catzc-base-docs/private
    name: get-cats-adr-index-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ed6c00018bbd
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/private/Get-CatsAdrIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:catsAdrIndexCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
