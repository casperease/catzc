# docs/references/automation/catzc-base-files/types/RestartManager.cs.md

`automation/Catzc.Base.Files/types/RestartManager.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Asks the Windows Restart Manager (rstrtmgr.dll) which processes hold a file open — the API behind
Explorer's "file in use by …" dialog. It needs no admin rights and sees both an open handle and a mapped
(loaded) DLL image. Windows-only: the P/Invoke binds lazily, so the type loads on every platform, but
GetHolders must only be called on Windows (it throws PlatformNotSupportedException elsewhere).
```
