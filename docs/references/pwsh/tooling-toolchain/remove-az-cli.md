# pwsh/Tooling.Toolchain/Remove-AzCli.ps1

The destructive removal of an Azure CLI the tooling system does not manage, so that the managed uv-venv build can win. It is the escalation
step behind `Uninstall-AzCli -Remove`.

## help

### synopsis

Destructively evicts an off-config Azure CLI so the managed (uv-venv) build can win.

### description

Removes an Azure CLI installed OUTSIDE the tooling system — the destructive `Remove-` verb of the tool lifecycle
([ADR-AUTO-REMOVE](../../../drs/automation/tool-removal-lifecycle.md)). Refuses a managed install and redirects to Uninstall-AzCli
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)). Per
platform:

- Windows: delete the MSI install folder and strip it from the machine PATH (needs Administrator).
- Linux: evict via the mechanism that placed it — apt package / uv-Python pip / stray binary (Remove-LinuxToolInstall); elevation is scoped
  to the mechanism
  ([ADR-AUTO-REMOVE-ELEVATIONBYMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationbymechanism)).

-Force confirms the destructive action; without it the plan is reported and nothing changes
([ADR-AUTO-REMOVE-DOUBLYGUARDED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-doublyguarded)). Usually reached
through the escalation `Uninstall-AzCli -Remove -Force`
([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

### parameter `InstallDir`

Path to the Azure CLI installation folder. Auto-detected from PATH if omitted.

### parameter `Force`

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-AzCli
```

### example 2

```powershell
Remove-AzCli -Force
```

### example 3

```powershell
Remove-AzCli -InstallDir 'C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2' -Force
```

## When it refuses

An install the tooling system manages is refused and the caller is sent to `Uninstall-AzCli`
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)).

## Unix

An off-config install is evicted by the mechanism that placed it: a native package manager, a uv-Python pip, or a stray binary. Elevation is
that mechanism's and is never asserted up front
([ADR-AUTO-REMOVE-ELEVATIONBYMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationbymechanism)).
