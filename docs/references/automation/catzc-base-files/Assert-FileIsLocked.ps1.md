# automation/Catzc.Base.Files/Assert-FileIsLocked.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a file is held open by another handle (locked); throws otherwise.

### description

Throws when the file is not locked. See Test-FileIsLocked for how lock state is determined and the
Windows-vs-Unix locking caveat.

### parameter Path

Path to the file to assert is locked.

### parameter ErrorText

Optional message to throw instead of the default.

### example 1

```powershell
Assert-FileIsLocked $dllPath
```
