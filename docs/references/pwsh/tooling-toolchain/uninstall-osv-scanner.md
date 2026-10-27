# pwsh/Tooling.Toolchain/Uninstall-OsvScanner.ps1

The uninstaller of osv-scanner: the `osv_scanner` entry's package on Windows and macOS, the release binary in ~/.local/bin on Linux.

## help

### synopsis

Removes osv-scanner.

### description

Windows and macOS delegate to Uninstall-Tool with the osv_scanner entry. Linux removes the release binary Install-OsvScanner placed in
~/.local/bin, and reports when there is none.

### parameter `Version`

The version to remove, for a package manager that tracks one. Default: whichever is installed.

### example 1

```powershell
Uninstall-OsvScanner
```
