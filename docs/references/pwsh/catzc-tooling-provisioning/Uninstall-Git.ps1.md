# pwsh/Tooling.Provisioning/Uninstall-Git.ps1

The uninstaller of Git, the counterpart of `Install-Git`.

## help

### synopsis

Uninstalls Git installed by Install-Git.

### description

Windows: Removes LOCALAPPDATA\Git and cleans PATH. macOS: brew uninstall git. Linux: apt-get remove git (requires root). Idempotent — skips
if not installed.

### example 1

```powershell
Uninstall-Git
```
