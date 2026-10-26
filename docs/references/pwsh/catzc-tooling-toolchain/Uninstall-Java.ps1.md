# pwsh/Tooling.Toolchain/Uninstall-Java.ps1

The uninstaller of Java through the platform package manager, the counterpart of `Install-Java`, and the entry of the removal escalation for
a Java the manager does not own.

## help

### synopsis

Uninstalls Java via the platform package manager.

### description

Removes Java through the configured manager and clears JAVA_HOME (on Unix, removes the marker block from $PROFILE) — the managed uninstall.
For a Java installed OUTSIDE the tooling system (a foreign JDK, an apt package on a uv-first box), escalate with -Remove -Force: the managed
uninstall runs best-effort and then falls through to Remove-Java, which evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

### parameter `Version`

Java version to uninstall. Defaults to the locked version in Get-ToolConfig.

### parameter `Remove`

After the managed uninstall, escalate to Remove-Java to evict an off-config install. Pair with -Force to actually remove; -Remove alone
reports the plan ([ADR-AUTO-REMOVE-DOUBLYGUARDED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-doublyguarded)).

### parameter `Force`

Confirm the destructive Remove-Java step of the escalation. Ignored without -Remove.

### example 1

```powershell
Uninstall-Java
```

### example 2

```powershell
Uninstall-Java -Remove -Force
```

## Failure of the managed uninstall

The managed uninstall is best effort. With `-Remove` a failure is logged and the escalation proceeds; without `-Remove` it propagates
([ADR-AUTO-ONEJOB-CALLERHANDLESERRORS](../../../drs/automation/single-responsibility-functions.md#rule-adr-auto-onejob-callerhandleserrors),
[ADR-AUTO-REMOVE-ONECALLESCALATION](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-onecallescalation)).

## JAVA_HOME

`JAVA_HOME` is cleaned up. Each removal is announced where it happens, and only when there was something to remove
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)).
