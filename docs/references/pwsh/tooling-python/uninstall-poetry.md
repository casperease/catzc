# pwsh/Tooling.Python/Uninstall-Poetry.ps1

The uninstaller of Poetry, the counterpart of `Install-Poetry`.

## help

### synopsis

Uninstalls Poetry.

### description

Removes the uv-managed install (`uv tool uninstall poetry`) via Uninstall-UvTool. Idempotent — skips if Poetry is not installed.

### example 1

```powershell
Uninstall-Poetry
```
