# pwsh/Tooling.Node/Uninstall-Prettier.ps1

The uninstaller of Prettier, the counterpart of `Install-Prettier`.

## help

### synopsis

Uninstalls Prettier (the global npm package).

### description

Idempotent — skips if Prettier or npm is not present (nothing to uninstall).

### example 1

```powershell
Uninstall-Prettier
```
