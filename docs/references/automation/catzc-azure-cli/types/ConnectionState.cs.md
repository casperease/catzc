---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/types/ConnectionState.cs.md
    folder: docs/references/automation/catzc-azure-cli/types
    name: connection-state-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cb92fdfe77f1
---

# automation/Catzc.Azure.Cli/types/ConnectionState.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The az CLI session's connection state measured against an expected tenant and/or subscription. Pairs
what was asked for (expected_*) with what the active session actually has (actual_*) plus the verdict.
A point-in-time probe of the CLI session, not a config record.
```
