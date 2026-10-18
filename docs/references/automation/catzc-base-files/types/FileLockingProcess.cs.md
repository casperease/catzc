# automation/Catzc.Base.Files/types/FileLockingProcess.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A process that holds a file open, as reported by the Windows Restart Manager (RestartManager) and enriched
with the process's own facts. The Restart Manager part (ProcessId, AppName, Started) is always present; the
enrichment (Name, CommandLine, ParentProcessId) is null when the process exited between the two lookups.
```
