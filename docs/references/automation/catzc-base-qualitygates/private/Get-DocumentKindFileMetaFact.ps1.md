---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-DocumentKindFileMetaFact.ps1.md
    kind: comment-page
    body_sha: d25070ca4808
    adrs:
      - ADR-PRIN-CONFIG#1
---

# automation/Catzc.Base.QualityGates/private/Get-DocumentKindFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The first class whose globs match the path wins; a file no class matches is `other`. The classes are data in the
registry (`settings.classes`), never a list in this function ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
```
