# pwsh/Tooling.Toolchain/Uninstall-AzCli.ps1

The uninstaller of the Azure CLI, the counterpart of `Install-AzCli`, and the entry of the removal escalation for an Azure CLI the manager
does not own.

## help

### synopsis

Uninstalls the Azure CLI.

### description

Removes az's dedicated uv venv via Uninstall-UvVenvTool — the managed uninstall (idempotent, skips if not installed). For an Azure CLI
installed OUTSIDE the tooling system (a lingering machine-scope MSI, an apt 'azure-cli', a pip install), escalate with -Remove -Force: the
managed uninstall runs best-effort and then falls through to Remove-AzCli, which destructively evicts whatever the configured manager did
not own ([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

### parameter `Remove`

After the managed uninstall, escalate to Remove-AzCli to evict an off-config install the managed path cannot touch. Pair with -Force to
actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE-DOUBLYGUARDED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-doublyguarded)).

### parameter `Force`

Confirm the destructive Remove-AzCli step of the escalation. Ignored without -Remove.

### example 1

```powershell
Uninstall-AzCli
```

### example 2

```powershell
Uninstall-AzCli -Remove -Force
```

## Failure of the managed uninstall

The managed uninstall is best effort. With `-Remove`, a failure means a foreign install the manager cannot touch, the exact case `-Remove`
exists for, so it is logged and the escalation proceeds to `Remove-AzCli`. Without `-Remove` the failure propagates as a normal uninstall
failure. Catching only under `-Remove` is the escalation's single stated purpose, not a general catch-and-continue
([ADR-AUTO-ONEJOB-CALLERHANDLESERRORS](../../../drs/automation/single-responsibility-functions.md#rule-adr-auto-onejob-callerhandleserrors),
[ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).
