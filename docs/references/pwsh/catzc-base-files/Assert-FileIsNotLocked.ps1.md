# automation/Catzc.Base.Files/Assert-FileIsNotLocked.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
