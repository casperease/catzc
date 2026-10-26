# pwsh/Tooling.Toolchain/Remove-Dotnet.ps1

The removal of a .NET install that the managed user-space install does not own: the escalation step behind `Uninstall-Dotnet -Remove`.

## help

### synopsis

Evicts an off-config .NET install, one the tooling's managed user-space install does not own.

### description

The destructive escape hatch beside Install-/Uninstall-Dotnet ([ADR-AUTO-REMOVE](../../../drs/automation/tool-removal-lifecycle.md)). It
refuses the managed install — Uninstall-Dotnet owns that — and decides "managed" for the folder it is about to remove, not for whatever
`dotnet` resolves to on PATH: in a catzc session PATH always leads to the managed install, so asking about PATH would refuse every stray
one.

Windows: the target folder defaults to the `dotnet` on PATH, or, when that is the managed install, the machine-wide C:\Program Files\dotnet.
A folder that Windows-registered products own (the .NET SDK / runtime installers, listed in Apps & features) is not deleted by hand — that
would orphan every entry — so the products are listed with the command that removes each by its own installer, and nothing is touched.
Installer bundles come first and alone: a bundle holds the MSI products it installed, which go only with it, so the next run names whatever
is left. Only an unregistered folder is deleted, with its machine PATH entry and DOTNET_ROOT (needs Administrator,
[ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).

Linux / macOS: evicts an off-config install by the mechanism that placed it (native package / uv-Python pip / stray binary).

### parameter `InstallDir`

The .NET installation folder to evict (Windows). Default: the `dotnet` on PATH, or the machine-wide C:\Program Files\dotnet when the one on
PATH is the managed install.

### parameter `Force`

Actually perform the removal. Without this, shows what would be removed.

### example 1

```powershell
Remove-Dotnet
```

### example 2

```powershell
Remove-Dotnet -InstallDir 'C:\Program Files\dotnet' -Force
```

## Unix

An off-config install is evicted by the mechanism that placed it: a native package manager, a uv-Python pip, or a stray binary. Elevation is
that mechanism's and is never asserted up front
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).
The off-config install there is the one on PATH, so the managed check asks about PATH.

## When it refuses

The managed install is `Uninstall-Dotnet`'s, judged for the folder at hand
([ADR-AUTO-REMOVE-REMOVEREFUSESMANAGED](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-removerefusesmanaged)).

## Registered products

A folder that registered products own is removed by their mechanism, never by deleting it
([ADR-AUTO-REMOVE-THREEPLATFORMCORES](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-threeplatformcores)). The
registrations are checked before the folder itself, so registrations whose files are already gone are still reported. The .NET installers
place their products in the machine-wide folders; a stray copy elsewhere is nobody's.

A bundle holds the MSI products it installed as their dependent, so uninstalling one of those directly reports success and removes nothing.
While any bundle is registered, only the bundles are named, each takes its products with it, and the next run names whatever is left.

## Elevation

Deleting the folder and the machine PATH entry needs Administrator, asserted for this step only
([ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationfollowsmechanism)).
