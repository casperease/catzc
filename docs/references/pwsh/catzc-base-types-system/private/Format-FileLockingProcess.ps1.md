# pwsh/Base.TypesSystem/private/Format-FileLockingProcess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Formats the processes holding a file as one human-readable phrase.

### description

Joins the holders into "pwsh.exe (PID 10276, started 2026-10-13 14:10) — the VS Code PowerShell extension, this session (PID 37552)". The
current process is labelled "this session"; a VS Code PowerShell Editor Services host is named as such, since its pwsh.exe is otherwise
indistinguishable from a console. Returns $null when there are no holders, so the caller can fall back to holder-free wording.

### parameter `Holder`

The holders, as returned by Get-FileLockingProcess.

### example 1

```powershell
Format-FileLockingProcess (Get-FileLockingProcess $dll)
```
