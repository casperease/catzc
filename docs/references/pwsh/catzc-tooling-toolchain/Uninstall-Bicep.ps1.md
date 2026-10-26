# pwsh/Tooling.Toolchain/Uninstall-Bicep.ps1

The uninstaller of the Bicep CLI, the counterpart of `Install-Bicep`.

## help

### synopsis

Uninstalls the Bicep CLI that Install-Bicep installed.

### description

Windows and macOS delegate to Uninstall-Tool with the tools.yml `bicep` entry (winget, brew). On Linux it removes the binary Install-Bicep
placed in ~/.local/bin; a Bicep CLI elsewhere is not this module's to remove.

### parameter `Version`

The version to uninstall (Windows and macOS). Default: whichever is installed.

### example 1

```powershell
Uninstall-Bicep
```
