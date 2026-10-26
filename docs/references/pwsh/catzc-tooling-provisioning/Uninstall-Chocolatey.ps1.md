# pwsh/Tooling.Provisioning/Uninstall-Chocolatey.ps1

The remover of Chocolatey, a package manager this toolset does not use
([ADR-AUTO-PKGMGR](../../../drs/automation/use-proper-package-managers.md)). `Install-DevBoxTools` runs it first.

## help

### synopsis

Uninstalls Chocolatey from the current machine.

### description

Removes the Chocolatey package manager if it is installed. Idempotent — safe to run when Chocolatey is not present. Windows-only; returns
immediately on other platforms.

### example 1

```powershell
Uninstall-Chocolatey
```

## Environment and PATH

The `ChocolateyInstall` variable is removed through `Set-PermanentEnvironmentVariable`; the seam announces each removal and does nothing in
a scope where the variable is not set. Chocolatey leaves the machine and user PATH through the PATH seams, which announce the change
([ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../drs/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)).
