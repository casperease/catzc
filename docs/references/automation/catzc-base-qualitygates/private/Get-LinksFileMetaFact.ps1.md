---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LinksFileMetaFact.ps1.md
    kind: comment-page
    body_sha: e1172b1bbcb9
    adrs:
      - ADR-REPO-FILEMETA#3
---

# automation/Catzc.Base.QualityGates/private/Get-LinksFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A link into the file itself, to an anchor in it, or to its own comment page stays internal and is not listed.
[ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
```
