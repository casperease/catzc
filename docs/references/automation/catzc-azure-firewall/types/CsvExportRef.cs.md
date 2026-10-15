---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/types/CsvExportRef.cs.md
    kind: comment-page
    body_sha: f5a6a88d35f4
    adrs: []
    links: []
---

# automation/Catzc.Azure.Firewall/types/CsvExportRef.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A reference to one exported firewall-rules CSV on disk: which rule kind it holds, where the local file
is, and the provenance of the blob it came from. The handle passed down the export → convert chain.
```
