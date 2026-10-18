# automation/Catzc.Base.Files/Test-FileIsNotLocked.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether a file is free to open (not locked by another handle).

### description

The inverse of Test-FileIsLocked. See its notes on Windows (mandatory) vs Linux/macOS (advisory) locking.

### parameter Path

Path to the file to test.

### example 1

```powershell
Test-FileIsNotLocked $dllPath
```
