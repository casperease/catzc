# pwsh/Catzc.Tooling.Toolchain/Remove-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
  ([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).

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

## comment:1

Above `if (Test-ExpectedPackageManager -Config $config) {`, written with `#`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-AzCli
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](/docs/drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)).
```

## comment:2

Above `if ($IsLinux -or $IsMacOS) {`, written with `#`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](/docs/drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)), so no admin assert
here.
```
