---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/types/CsvExportRef.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "47f1aab341e7"
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
