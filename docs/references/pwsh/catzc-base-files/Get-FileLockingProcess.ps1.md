# pwsh/Base.Files/Get-FileLockingProcess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the processes that hold a file open (lock it).

### description

Asks the Windows Restart Manager which processes hold the file — the same API behind Explorer's "file in use by …" dialog. It needs no admin
rights and sees both an open handle and a loaded (mapped) DLL, so it names the session holding a stale assembly. Each holder is enriched
with its executable name, command line and parent process (one CIM query for all holders); a process that exits between the two lookups
keeps only the Restart Manager's facts (id, app name, start time).

File locking is mandatory on Windows but advisory on Linux/macOS, where an open file blocks neither a delete nor a rename — so there is no
holder to report and this returns nothing there (matching Test-FileIsLocked, which reports $false).

### parameter `Path`

Path to the file whose holders to list.

### outputs

`[Catzc.Base.Files.FileLockingProcess]` per holding process; nothing when the file is not held.

### example 1

```powershell
Get-FileLockingProcess $dllPath
```

### example 2

```powershell
Get-FileLockingProcess $dllPath | ForEach-Object { "$_" }   # "pwsh.exe (PID 10276, started 2026-10-13 14:10)"
```
