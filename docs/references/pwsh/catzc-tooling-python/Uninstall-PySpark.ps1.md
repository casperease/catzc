# pwsh/Tooling.Python/Uninstall-PySpark.ps1

The uninstaller of PySpark, the counterpart of `Install-PySpark`, through the private `Uninstall-PipTool`.

## help

### synopsis

Uninstalls PySpark from the uv-managed Python via `uv pip`.

### description

Idempotent — skips if PySpark is not installed or if Python is not available (nothing to uninstall).

### example 1

```powershell
Uninstall-PySpark
```
