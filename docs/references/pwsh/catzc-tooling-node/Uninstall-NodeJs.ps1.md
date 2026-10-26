# pwsh/Tooling.Node/Uninstall-NodeJs.ps1

The uninstaller of Node.js through the configured package manager, and the entry of the removal escalation for a Node.js the manager does
not own.

## help

### synopsis

Uninstalls Node.js via the platform package manager.

### description

Removes Node.js (and its bundled npm) through the configured manager — the managed uninstall. Idempotent — skips if not installed. For a
Node.js installed OUTSIDE the tooling system (a stray binary, a foreign package), escalate with -Remove -Force: the managed uninstall runs
best-effort and then falls through to Remove-NodeJs, which destructively evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

### parameter `Version`

Node.js version to uninstall. Defaults to the locked version in Get-ToolConfig.

### parameter `Remove`

After the managed uninstall, escalate to Remove-NodeJs to evict an off-config install the managed path cannot touch. Pair with -Force to
actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE-DOUBLYGUARDED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-doublyguarded)).

### parameter `Force`

Confirm the destructive Remove-NodeJs step of the escalation. Ignored without -Remove.

### example 1

```powershell
Uninstall-NodeJs
```

### example 2

```powershell
Uninstall-NodeJs -Remove -Force
```

## Failure of the managed uninstall

The managed uninstall is best effort. With `-Remove` a failure means a foreign install that the escalation still removes, so it is logged
and the escalation goes on; without `-Remove` the failure propagates
([ADR-AUTO-ONEJOB-CALLERHANDLESERRORS](../../../drs/automation/single-responsibility-functions.md#rule-adr-auto-onejob-callerhandleserrors),
[ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).
