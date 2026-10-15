---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ModuleNameFileMetaFact.ps1.md
    kind: reference
    body_sha: "0fa04f2a05ba"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The modules root is the kind's `root` setting, `automation` unless the registry says otherwise. A file outside any module is an error,
since the kind's globs should never select one.
```
