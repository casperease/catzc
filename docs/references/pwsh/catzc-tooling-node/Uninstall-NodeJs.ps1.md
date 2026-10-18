# pwsh/Catzc.Tooling.Node/Uninstall-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls Node.js via the platform package manager.

### description

Removes Node.js (and its bundled npm) through the configured manager — the managed uninstall. Idempotent — skips if not installed. For a
Node.js installed OUTSIDE the tooling system (a stray binary, a foreign package), escalate with -Remove -Force: the managed uninstall runs
best-effort and then falls through to Remove-NodeJs, which destructively evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE#5](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).

### parameter `Version`

Node.js version to uninstall. Defaults to the locked version in Get-ToolConfig.

### parameter `Remove`

After the managed uninstall, escalate to Remove-NodeJs to evict an off-config install the managed path cannot touch. Pair with -Force to
actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE#4](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).

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

## comment:1

Above `try {`, written with `#`.

```text
Managed uninstall best-effort; with -Remove a failure (a foreign install) is logged and the escalation
proceeds, without -Remove it propagates
([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```
