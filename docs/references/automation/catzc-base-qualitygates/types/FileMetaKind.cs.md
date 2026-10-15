---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
    kind: reference
    body_sha: df7167f4ce88
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#2
      - ADR-REPO-FILEMETA#4
---

# automation/Catzc.Base.QualityGates/types/FileMetaKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One entry of the meta-kind registry; the defaults of an omitted key are declared here, once.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```

## comment:2

Above `public static string ConventionName(string id, FileMetaDirection direction)`.

```text
The function a module subscribes by default: Get-<Id>FileMetaFact, or Get-<Id>MarkdownConfigContribution
([ADR-REPO-FILEMETA#4](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta4)).
```
