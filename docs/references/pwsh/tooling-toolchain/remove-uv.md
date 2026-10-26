# pwsh/Tooling.Toolchain/Remove-Uv.ps1

The removal of a uv that the managed install does not own, such as the copy Astral's standalone script puts in `~\.local\bin`: the step
`Get-ToolsStatus` names before `Install-Uv` when uv reads "Usable, other manager".

## help

### synopsis

Evicts an off-config uv, one the tooling's managed install does not own.

### description

The destructive escape hatch beside Install-Uv ([ADR-AUTO-REMOVE](../../../drs/automation/tool-removal-lifecycle.md)). It refuses the
managed install, judged for the folder it is about to clean, not for whatever `uv` resolves to on PATH.

Windows: the target folder defaults to the folder of the `uv` on PATH, else `~\.local\bin`. uv is a plain binary with no registered product,
and its folder is shared with other tools, so only `uv.exe`, `uvx.exe` and `uvw.exe` are deleted; the folder and its PATH entry stay.
Without -Force it lists what it would delete and touches nothing. No elevation is needed for a user-space folder.

Linux / macOS: evicts an off-config install by the mechanism that placed it (native package / uv-Python pip / stray binary).

### parameter `InstallDir`

The folder that holds the off-config uv.exe (Windows). Default: the folder of the `uv` on PATH, else `~\.local\bin`.

### parameter `Force`

Actually delete the binaries. Without this, shows what would be removed.

### example 1

```powershell
Remove-Uv
```

### example 2

```powershell
Remove-Uv -Force; Install-Uv
```

## Why it exists

Every install and removal goes through a Toolchain command. A standalone uv on PATH shadows the managed one, and `Install-Uv` only
self-updates it in place, so the stray copy needs its own eviction
([ADR-AUTO-REMOVE-OFFCONFIGTOOLSONLY](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-offconfigtoolsonly)).

## Binaries, not the folder

`Remove-OffConfigInstall` deletes a whole install folder with its machine PATH entry, which fits Go and .NET. `~\.local\bin` holds other
tools too, so on Windows this command deletes only uv's own executables; off Windows it shares that eviction.
