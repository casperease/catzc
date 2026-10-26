# pwsh/Base.Environment/Sync-SessionPath.ps1

The command that brings the session PATH back in step with the Windows registry, in both directions, and does nothing on Unix.

## help

### synopsis

Rebuilds the session PATH from the registry on Windows. No-op on Unix.

### description

Reads Machine and User PATH from the Windows registry and rebuilds $env:PATH. Registry entries form the base; session-only entries (e.g.
from Add-PermanentPath or a tool's install script) are kept only if their directory still exists on disk.

This handles both directions:

- New entries added to the registry by an installer appear in the session.
- Entries removed from the registry by an uninstaller disappear from the session (even if the directory still exists on disk).

On Linux/macOS this function is a no-op — package managers update PATH through profile scripts that take effect on next shell launch.

### example 1

```powershell
Sync-SessionPath
```

## Announcing only a change

The session PATH is rewritten, and the change announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)),
only when an entry arrives or leaves. On a settled devbox nothing changes, so the import stays quiet.

## Empty kept set

The set of kept entries is wrapped in `@()`, so an empty set is an empty array: the constructor of the hash set that tracks the entries
accepts an empty array where it rejects null.
