# pwsh/Tooling.Toolchain/Remove-Java.ps1

The destructive removal of a manually installed Java JDK that the tooling system does not manage: the escalation step behind
`Uninstall-Java -Remove`.

## help

### synopsis

Removes a manually installed Java JDK and cleans up system PATH.

### description

Deletes the JDK installation folder and removes it (and its bin subdirectory) from the system-level PATH. Requires Administrator.
Auto-detects the install directory from Get-Command if not specified.

This is for JDK installations (Oracle, AdoptOpenJDK, etc.) that are not managed by winget/brew/apt. If Java is managed by the tooling
system, use Uninstall-Java instead.

### parameter `InstallDir`

Path to the JDK installation folder. Auto-detected from PATH if omitted.

### parameter `Force`

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-Java
```

### example 2

```powershell
Remove-Java -Force
```

### example 3

```powershell
Remove-Java -InstallDir 'C:\Program Files\Java\jdk-17' -Force
```

## When it refuses

An install the tooling system manages is refused and the caller is sent to `Uninstall-Java`
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)).

## Unix

An off-config install is evicted by the mechanism that placed it: a native package manager, a uv-Python pip, or a stray binary. Elevation is
that mechanism's and is never asserted up front
([ADR-AUTO-REMOVE-ELEVATIONBYMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationbymechanism)).
