# pwsh/Tooling.Python/Uninstall-Python.ps1

The uninstaller of the uv-managed Python, the counterpart of `Install-Python`.

## help

### synopsis

Uninstalls the uv-provisioned Python.

### description

Removes the uv-managed CPython (`uv python uninstall <version>`). Idempotent — skips if not installed.

### parameter `Version`

Python version to uninstall. Defaults to the locked version in Get-ToolConfig.

### example 1

```powershell
Uninstall-Python
```

### example 2

```powershell
Uninstall-Python -Version '3.12'
```
