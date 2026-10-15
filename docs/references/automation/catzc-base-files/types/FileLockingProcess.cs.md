---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/types/FileLockingProcess.cs.md
    kind: reference
    body_sha: "8b6054e2687f"
    adrs: []
---

# automation/Catzc.Base.Files/types/FileLockingProcess.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A process that holds a file open, as reported by the Windows Restart Manager (RestartManager) and enriched
with the process's own facts. The Restart Manager part (ProcessId, AppName, Started) is always present; the
enrichment (Name, CommandLine, ParentProcessId) is null when the process exited between the two lookups.
```
