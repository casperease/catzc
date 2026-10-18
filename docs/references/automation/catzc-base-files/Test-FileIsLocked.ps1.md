# automation/Catzc.Base.Files/Test-FileIsLocked.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether a file is held open by another handle (locked).

### description

Tries to open the file for reading with no sharing. If another handle is open (e.g. a loaded assembly
DLL), the open fails with an IOException and the file is reported locked; if the open succeeds it is
closed immediately and the file is reported not locked.

File locking is mandatory on Windows but advisory on Linux/macOS, where a file held open elsewhere may
still open — so this reports $false there. Callers that must not stall on a locked file (e.g. cache
cleanup) should still prefer a guarded delete; this predicate is for asserting and reporting state.

### parameter Path

Path to the file to test.

### example 1

```powershell
Test-FileIsLocked $dllPath
```
