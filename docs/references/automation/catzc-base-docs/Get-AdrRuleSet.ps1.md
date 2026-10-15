---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-AdrRuleSet.ps1.md
    kind: reference
    body_sha: "08a34494e24b"
    adrs: []
---

# automation/Catzc.Base.Docs/Get-AdrRuleSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the RuleSets of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig — mapped and
validated by the C# type, so this reads strong properties, not a slippery ordered dictionary). Each record
(Catzc.Base.Docs.AdrRuleSet) carries the internal kebab Slug, the full External citation code, the
domain Code in effect (a leaf override or the domain default), the folder-owning Domain and its Role, and
the optional Terminology token.
```
