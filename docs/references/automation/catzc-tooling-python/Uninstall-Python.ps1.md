# automation/Catzc.Tooling.Python/Uninstall-Python.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls the uv-provisioned Python.

### description

Removes the uv-managed CPython (`uv python uninstall <version>`). Idempotent — skips if not installed.

### parameter Version

Python version to uninstall. Defaults to the locked version in Get-ToolConfig.

### example 1

```powershell
Uninstall-Python
```

### example 2

```powershell
Uninstall-Python -Version '3.12'
```
