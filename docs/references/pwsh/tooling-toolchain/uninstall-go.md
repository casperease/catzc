# pwsh/Tooling.Toolchain/Uninstall-Go.ps1

The uninstaller of the Go toolchain, the counterpart of `Install-Go`.

## help

### synopsis

Uninstalls the Go toolchain installed by Install-Go.

### description

Removes the managed user-space home (Get-ScriptInstallDir: Windows %LOCALAPPDATA%\go, Unix ~/.go) and takes its bin folder off the session
and persistent PATH — the managed uninstall. Idempotent — skips when the home does not exist. A Go installed elsewhere (a machine-wide MSI,
a distro package) is not the managed install and is left untouched; `-Remove` escalates to Remove-Go for it
([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)). The module
cache and build cache (GOPATH, GOCACHE) are Go's own data, not the install, and are kept.

### parameter `Remove`

After the managed uninstall, escalate to Remove-Go to evict an off-config Go the managed uninstall cannot touch. A managed uninstall that
fails is logged and the escalation proceeds.

### parameter `Force`

With -Remove, perform the eviction; without it, Remove-Go only shows what it would remove.

### example 1

```powershell
Uninstall-Go
```

### example 2

```powershell
Uninstall-Go -Remove -Force
```
