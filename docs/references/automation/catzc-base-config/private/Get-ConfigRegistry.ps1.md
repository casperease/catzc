---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md
    kind: comment-page
    body_sha: "707b7dd2321a"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$cached =...`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
