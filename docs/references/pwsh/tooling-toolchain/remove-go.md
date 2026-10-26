# pwsh/Tooling.Toolchain/Remove-Go.ps1

The removal of a Go install that the managed user-space install does not own, such as a machine-wide Go that shadows it on the machine PATH:
the escalation step behind `Uninstall-Go -Remove`.

## help

### synopsis

Evicts an off-config Go install, one the tooling's managed user-space install does not own.

### description

The destructive escape hatch beside Install-/Uninstall-Go ([ADR-AUTO-REMOVE](../../../drs/automation/tool-removal-lifecycle.md)). It refuses
the managed install — Uninstall-Go owns that — and decides "managed" for the folder it is about to remove, not for whatever `go` resolves to
on PATH.

Windows: the target folder defaults to the install above the `go` on PATH, or, when that is the managed install, the machine-wide C:\Program
Files\Go. A folder that the Windows-registered Go installer owns (the "Go Programming Language" entry in Apps & features) is not deleted by
hand — that would orphan the entry. Without -Force the product is listed with its uninstall command, printed so it pastes into pwsh as is,
and nothing is touched. With -Force, from an elevated shell, the command runs that uninstaller itself: one child process per product,
bundles first, each bounded by the command's time limit, its exit code checked (0, or 1641 / 3010 when Windows wants a restart), its output
kept in a transcript under out/remove-go/; it then re-reads the registration and deletes what is left of the folder, with its bin entry on
the machine PATH and GOROOT (needs Administrator,
[ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).

Linux / macOS: evicts an off-config install by the mechanism that placed it (native package / uv-Python pip / stray binary).

### parameter `InstallDir`

The Go installation folder to evict (Windows), the folder that holds bin\go.exe. Default: the install above the `go` on PATH, or the
machine-wide C:\Program Files\Go when the one on PATH is the managed install.

### parameter `Force`

Actually perform the removal, running any registered installer's uninstall first. Without this, shows what would be removed.

### example 1

```powershell
Remove-Go
```

### example 2

```powershell
Remove-Go -InstallDir 'C:\Program Files\Go' -Force
```

## Why it exists

A machine-wide Go comes first on every PATH a process builds from the machine and user parts, so it wins in VS Code and every GUI tool even
where the managed Go wins in a catzc session. Uninstall-Go removes only the managed install, so the shadowing one needs its own eviction
([ADR-AUTO-REMOVE-OFFCONFIGTOOLSONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-offconfigtoolsonly)).

## One mechanism with Remove-Dotnet

The refusal, the registered-product check, the dry run and the elevated delete are the shared private `Remove-OffConfigInstall`, which
`Remove-Dotnet` calls too; this command only names Go's folders, its installer's product name, the bin folder on PATH and GOROOT.
