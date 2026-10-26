# pwsh/Base.Files/Assert-FileIsNotLocked.ps1

The throwing form of the lock query: it asserts that a file is free to open and throws when another handle holds it. `Test-FileIsLocked` is
the query behind it.

## help

### synopsis

Asserts that a file is free to open (not locked by another handle); throws otherwise.

### description

Throws when the file is locked. See Test-FileIsLocked for how lock state is determined and the Windows-vs-Unix locking caveat.

### parameter `Path`

Path to the file to assert is not locked.

### parameter `ErrorText`

Optional message to throw instead of the default.

### example 1

```powershell
Assert-FileIsNotLocked $dllPath
```
