# pwsh/Tooling.Provisioning/Uninstall-Postman.ps1

The uninstaller of Postman, the counterpart of `Install-Postman`.

## help

### synopsis

Uninstalls the Postman desktop app.

### description

Windows: Removes LOCALAPPDATA\Postman directory. macOS: brew uninstall --cask postman. Linux: Removes HOME/.local/Postman directory.
Idempotent — skips if not installed.

### example 1

```powershell
Uninstall-Postman
```
