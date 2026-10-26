# pwsh/Base.Files/Assert-FileIsLocked.ps1

The throwing form of the lock query: it asserts that another handle holds a file open and throws when none does. `Test-FileIsLocked` is the
query behind it.

## help

### synopsis

Asserts that a file is held open by another handle (locked); throws otherwise.

### description

Throws when the file is not locked. See Test-FileIsLocked for how lock state is determined and the Windows-vs-Unix locking caveat.

### parameter `Path`

Path to the file to assert is locked.

### parameter `ErrorText`

Optional message to throw instead of the default.

### example 1

```powershell
Assert-FileIsLocked $dllPath
```
