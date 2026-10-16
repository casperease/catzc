---
catzc:
  immutable:
    with_body_sha: "47f1aab341e7"
    path: docs/references/automation/catzc-azure-firewall/types/CsvExportRef.cs.md
    folder: docs/references/automation/catzc-azure-firewall/types
    name: csv-export-ref-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Firewall/types/CsvExportRef.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A reference to one exported firewall-rules CSV on disk: which rule kind it holds, where the local file
is, and the provenance of the blob it came from. The handle passed down the export → convert chain.
```
