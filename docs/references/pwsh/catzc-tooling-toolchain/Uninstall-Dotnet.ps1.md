# pwsh/Tooling.Toolchain/Uninstall-Dotnet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls the .NET SDK installed by Install-Dotnet.

### description

Removes the managed user-space install directory and cleans persistent environment variables (DOTNET_ROOT and PATH) — the managed uninstall.
Idempotent — skips if the directory does not exist.

Nothing is deleted while a process holds the install open (Get-DotnetInstallHolder — an MSBuild node, the compiler server, an editor's C#
language server): the uninstall throws, naming each holder, so a locked file can never leave a half-deleted install. -Force stops exactly
those named processes first. On Windows it also refuses to run elevated: the managed install is user-space and needs no elevation, so an
elevated shell means the target is a machine-scope .NET (C:\Program Files\dotnet), which winget removes — never this one.

For a .NET installed OUTSIDE the tooling system (a system SDK, an apt package), escalate with -Remove -Force: the managed uninstall runs
best-effort and then falls through to Remove-Dotnet, which evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

### parameter `Remove`

After the managed uninstall, escalate to Remove-Dotnet to evict an off-config install. Pair with -Force to actually remove; -Remove alone
reports the plan ([ADR-AUTO-REMOVE-DOUBLYGUARDED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-doublyguarded)).

### parameter `Force`

Confirm the destructive steps: stop the processes named as holding the install open, and — with -Remove — the Remove-Dotnet eviction.

### example 1

```powershell
Uninstall-Dotnet
```

### example 2

```powershell
Uninstall-Dotnet -Force    # also stops the named processes holding the install open
```

### example 3

```powershell
Uninstall-Dotnet -Remove -Force
```

## comment:1

Above `try {`, written with `#`.

```text
Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
-Remove it propagates ([ADR-AUTO-ONEJOB-CALLERHANDLESERRORS](/docs/drs/automation/single-responsibility-functions.md#rule-adr-auto-onejob-callerhandleserrors),
[ADR-AUTO-REMOVE-ONECALLESCALATION](/docs/drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).
```
