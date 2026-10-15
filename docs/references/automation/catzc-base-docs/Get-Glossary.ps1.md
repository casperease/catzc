---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-Glossary.ps1.md
    kind: comment-page
    body_sha: "019d5ff849b0"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/Get-Glossary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:glossaryCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
