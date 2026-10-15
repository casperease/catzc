---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Resolve-ManagedGuid.ps1.md
    kind: reference
    body_sha: fcd052cd9899
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Resolve-ManagedGuid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one comparison source behind Test-ManagedGuid and Assert-ManagedGuid — both route through this
lookup, so the bool and the throw can never drift. Comparison is by [guid] value, so any input casing
matches the canonical lowercase form the registry stores.
```
