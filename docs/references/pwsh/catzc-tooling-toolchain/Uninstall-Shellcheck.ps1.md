# pwsh/Tooling.Toolchain/Uninstall-Shellcheck.ps1

The uninstaller of ShellCheck, the counterpart of `Install-Shellcheck`.

## help

### synopsis

Uninstalls ShellCheck installed by Install-Shellcheck.

### description

Delegates to Uninstall-Tool, which removes the winget or brew package the tools.yml `shellcheck` entry names.

### parameter `Version`

The installed version to remove. Default: whatever is installed.

### example 1

```powershell
Uninstall-Shellcheck
```
