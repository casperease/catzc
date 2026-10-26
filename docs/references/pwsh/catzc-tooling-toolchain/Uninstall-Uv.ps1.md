# pwsh/Tooling.Toolchain/Uninstall-Uv.ps1

The uninstaller of uv, the counterpart of `Install-Uv`.

## help

### synopsis

Uninstalls uv.

### description

Removes the managed install via the platform package manager: winget (Windows) or brew (macOS). Delegates to Uninstall-Tool. Idempotent —
skips if not installed.

### parameter `Version`

uv version to uninstall. Defaults to the locked version in Get-ToolConfig.

### example 1

```powershell
Uninstall-Uv
```
