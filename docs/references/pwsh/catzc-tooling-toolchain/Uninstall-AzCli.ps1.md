# pwsh/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls the Azure CLI.

### description

Removes az's dedicated uv venv via Uninstall-UvVenvTool — the managed uninstall (idempotent, skips if not installed). For an Azure CLI
installed OUTSIDE the tooling system (a lingering machine-scope MSI, an apt 'azure-cli', a pip install), escalate with -Remove -Force: the
managed uninstall runs best-effort and then falls through to Remove-AzCli, which destructively evicts whatever the configured manager did
not own ([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

### parameter `Remove`

After the managed uninstall, escalate to Remove-AzCli to evict an off-config install the managed path cannot touch. Pair with -Force to
actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE-DOUBLYGUARDED](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-doublyguarded)).

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

## comment:1

Above `try {`, written with `#`.

```text
Managed uninstall best-effort. With -Remove a failure (a foreign install the manager cannot touch — the
exact case -Remove exists for) is logged and the escalation proceeds to Remove-AzCli; without -Remove it
propagates as a normal uninstall failure. Catching only under -Remove is the escalation's single stated
purpose, not general catch-and-continue
([ADR-AUTO-ONEJOB-CALLERHANDLESERRORS](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob-callerhandleserrors),
[ADR-AUTO-REMOVE-ONECALLESCALATION](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).
```
