---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/types/CliResult.cs.md
    kind: comment-page
    body_sha: ac3e5a26b085
---

# automation/Catzc.Base.Execution/types/CliResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The captured result of running an external command: stdout and stderr kept separate, plus convenience
views derived from them. The constructor owns the derivation, so the result can never be in an
inconsistent state (the views always agree with Output/Errors).
```

## comment:2

Above `public byte[] Bytes { get; }`.

```text
The exact stdout bytes of a binary run (Invoke-Executable -AsBytes); null for a text run, whose stdout is
Output. A binary run's Output is empty: its stdout is not text.
```
