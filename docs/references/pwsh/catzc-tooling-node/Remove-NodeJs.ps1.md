# pwsh/Tooling.Node/Remove-NodeJs.ps1

The destructive removal of a Node.js that the tooling system does not manage: the escalation step behind `Uninstall-NodeJs -Remove -Force`.

## help

### synopsis

Removes a manually installed Node.js and cleans up system PATH.

### description

Deletes the Node.js installation folder and removes it from the system-level PATH. Requires Administrator. Auto-detects the install
directory from Get-Command if not specified.

This is for Node.js installations that do not appear in Apps & Features or winget. If Node.js is managed by winget, use Uninstall-NodeJs
instead.

### parameter `InstallDir`

Path to the Node.js installation folder. Auto-detected from PATH if omitted.

### parameter `Force`

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-NodeJs
```

### example 2

```powershell
Remove-NodeJs -Force
```

### example 3

```powershell
Remove-NodeJs -InstallDir 'D:\tools\nodejs' -Force
```

## When it refuses

An install the tooling system manages is refused and the caller is sent to `Uninstall-NodeJs`
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)).

## Unix

An off-config install is evicted by the mechanism that placed it: a native package manager, a uv-Python pip, or a stray binary. Elevation is
that mechanism's and is never asserted up front
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).
