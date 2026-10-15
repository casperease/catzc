---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
    kind: comment-page
    body_sha: "78f4aeecb496"
    adrs:
      - ADR-AUTO-DEFAULT#6
    links: []
---

# automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One writer Test-GeneratedFiles runs report-only; every default is declared here once (ADR-AUTO-DEFAULT#6).
The check says which report shape the writer's -PassThru result has.
```

## comment:2

Above `public string check { get; }`.

```text
How the writer is checked: file (one result per file, with a path property), english-dictionary (the committed list against its stamp),
or root-config (the managed root files, each attributed to the generator the root-config registry names). Default: file.
```
