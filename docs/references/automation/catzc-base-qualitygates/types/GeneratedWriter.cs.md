---
catzc:
  immutable:
    with_body_sha: "5d0c08659752"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: generated-writer-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One writer Test-GeneratedFiles runs report-only; every default is declared here once (ADR-AUTO-DEFAULT#6).
The check says which report shape the writer's -PassThru result has.
```

## comment:2

Above `public string check { get; }`, written with `//`.

```text
How the writer is checked: file (one result per file, with a path property), english-dictionary (the committed list against its stamp),
or root-config (the managed root files, each attributed to the generator the root-config registry names). Default: file.
```
