---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-VisibilityFileMetaFact.ps1.md
    kind: comment-page
    body_sha: "2037b4eda535"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-VisibilityFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A file in the module's private folder is private, and any other file of the module is public. The modules root and the folder name
are the kind's `root` and `private_folder` settings, `automation` and `private` unless the registry says otherwise.
```
