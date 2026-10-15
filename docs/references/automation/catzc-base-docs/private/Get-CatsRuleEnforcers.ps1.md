---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
    kind: comment-page
    body_sha: "1484d599f30d"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$cached =...`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:5

Above `$isCommand = { param($node) $node -is...`.

```text
Test enforcers — the `-Tag` citations of Describe/Context/It, read by AST so a citation-shaped fixture
string is never mistaken for a real tag.
```
