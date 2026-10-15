---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
    kind: comment-page
    body_sha: "391e2c98da04"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#2
      - ADR-REPO-FILEMETA#4
---

# automation/Catzc.Base.QualityGates/types/FileMetaKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of the meta-kind registry; the defaults of an omitted key are declared here, once.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```

## comment:2

Above `public static string ConventionName(string id, FileMetaDirection direction)`, written with `//`.

```text
The function a module subscribes by default: Get-<Id>FileMetaFact, or Get-<Id>MarkdownConfigContribution
([ADR-REPO-FILEMETA#4](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta4)).
```
