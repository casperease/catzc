# pwsh/Tooling.Toolchain/Install-OsvScanner.ps1

The installer of osv-scanner, the scanner `Test-DependencyAdvisories` runs over the Python lock file, at the `tools.yml` pin. On Windows and
macOS it delegates to the `osv_scanner` entry; on Linux it installs the verified release binary through `Install-OsvScannerStandalone`.

## help

### synopsis

Installs osv-scanner, the dependency advisory scanner, at the tools.yml pin.

### description

osv-scanner reads a lock file against the OSV advisory database. Windows and macOS delegate to Install-Tool: winget Google.OSVScanner as a
user-scope install (no admin), or brew ([ADR-AUTO-PKGMGR](../../../drs/automation/use-proper-package-managers.md)). Linux installs the
release binary, verified against its published SHA-256, into ~/.local/bin (Install-OsvScannerStandalone). Idempotent: a scanner already at
the pinned version is left alone; another version throws unless -Force.

### parameter `Version`

The version prefix to install. Default: the tools.yml pin.

### parameter `Force`

Replace an installed osv-scanner at another version.

### example 1

```powershell
Install-OsvScanner
```
