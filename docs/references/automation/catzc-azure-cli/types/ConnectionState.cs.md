---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/types/ConnectionState.cs.md
    kind: comment-page
    body_sha: d1813a2ef229
    adrs: []
---

# automation/Catzc.Azure.Cli/types/ConnectionState.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The az CLI session's connection state measured against an expected tenant and/or subscription. Pairs
what was asked for (expected_*) with what the active session actually has (actual_*) plus the verdict.
A point-in-time probe of the CLI session, not a config record.
```
