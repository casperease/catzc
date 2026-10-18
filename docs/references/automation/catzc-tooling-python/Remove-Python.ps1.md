# automation/Catzc.Tooling.Python/Remove-Python.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes a manually installed Python and cleans up system PATH.

### description

Deletes the Python installation folder and removes it (and its Scripts subdirectory) from the system-level PATH. Requires Administrator.
Auto-detects the install directory from Get-Command if not specified.

This is for Python installations that do not appear in Apps & Features or winget. If Python is managed by winget, use Uninstall-Python
instead.

### parameter InstallDir

Path to the Python installation folder. Auto-detected from PATH if omitted.

### parameter Force

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-Python
```

### example 2

```powershell
Remove-Python -Force
```

### example 3

```powershell
Remove-Python -InstallDir 'C:\Python312' -Force
```
