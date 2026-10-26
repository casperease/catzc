# pwsh/Base.Repository/Get-CatzcModuleRoot.ps1

The one lookup from a module to its own folder in the loaded catzc code tree, optionally joined with a child path, correct in both run
modes.

## help

### synopsis

Returns a module's own folder inside the loaded catzc code tree, optionally joined with a child path.

### description

The one sanctioned way for module code to locate content that ships with it — its configs/ and assets/, or another module's
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).
Resolves against Get-CatzcModulesRoot, so the answer is correct in both run modes ([DDR-RUNMODE](../../../drs/design/run-modes.md)):
`<RepositoryRoot>/pwsh/<Module>` in source mode, and `<build>/<version>/<Module>` in build mode, where the merged `<Module>.ps1` sits beside
the same configs/ and assets/ folders.

-Module defaults to the module of the calling function, so module code writes only the child path. Pass -ChildPath as a string literal at
every call site: Get-InternalAssetDependency derives the inventory of internal asset dependencies from those literals
([ADR-AUTO-ASSETDEP-LITERALCHILDPATH](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-literalchildpath)).

Asserts the module folder exists; the child path is not asserted, so a caller may name a file it is about to create, or test for an optional
one.

In build mode a consumer overlay may replace a module's asset: when `<overlay root>/<Module>/<ChildPath>` is a file under assets/, that path
is returned instead of the bundled one ([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)). Only assets/ is looked up there —
configs merge through Get-Config, and the registry and other module files are never replaced wholesale. A consumer's local module — an
overlay folder that names no bundled module — resolves to its overlay folder.

### parameter `ChildPath`

A path below the module folder, '/'-separated (e.g. 'assets/gitkeep', 'configs/configs.yml'). Omit for the module folder itself.

### parameter `Module`

The module whose folder to resolve. Defaults to the module of the calling function; required when called from outside a module (a script or
the console).

### example 1

```powershell
Get-CatzcModuleRoot 'assets/gitkeep'
```

### example 2

```powershell
Get-CatzcModuleRoot 'configs/configs.yml' -Module Catzc.Base.Config
```

## Why the folder comes from the loaded module

The module's folder comes from the loaded module, never from its name: the folder drops the namespace the name carries
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
