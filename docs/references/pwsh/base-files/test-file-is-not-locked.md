# pwsh/Base.Files/Test-FileIsNotLocked.ps1

The inverse query of `Test-FileIsLocked`: it tells whether a file is free to open.

## help

### synopsis

Tests whether a file is free to open (not locked by another handle).

### description

The inverse of Test-FileIsLocked. See its notes on Windows (mandatory) vs Linux/macOS (advisory) locking.

### parameter `Path`

Path to the file to test.

### example 1

```powershell
Test-FileIsNotLocked $dllPath
```
