# pwsh/.internal/Catzc.Internal.Builder.psm1

The build-mode engine: `Invoke-ModuleBuild` builds the selected modules into one installable, versioned Catzc package
([ADR-AUTO-BUNDLE](../../../drs/automation/platform-bundle.md), [DDR-RUNMODE](../../../drs/design/run-modes.md)).

## What a build holds

Every module stays its own PowerShell module of the same name, its function files merged into one `<Module>.functions.ps1` behind a
generated manifest. Beside the modules sit the runtime loader (`.internal`), the vendored dependencies (`.vendor`), the full combined-types
DLL with its sources (`.compiled`) and the package entry points.

## How it is loaded

It is a `.internal` multi-function module, so the one-function-per-file convention does not apply. It loads on demand
(`Import-InternalModule Builder`) from `Build-Modules` after a normal source-mode import, so it calls the public catzc functions
(`Get-ModuleProfile`, `Write-FileIfChanged`, `Get-InternalAssetDependency`, `Get-CatzcContentHash` and others). It reads the per-function
source tree, so it never ships in a build itself. The larger build functions live one per file in `assets/builder/` and share its scope.

## The merged file name

The merged function file of a built module is `<Module>.functions.ps1`, never `<Module>.ps1`: a nested script module is named for its file,
so `<Module>.ps1` would load a second module named `<Module>` under the manifest's, and `Get-Module`, `Mock -ModuleName` and `InModuleScope`
would each see two modules of that name.

## Vendor policy

`testToolVendorModules` names the vendored modules that serve only the quality checks, the two the importer loads lazily (Pester and
PSScriptAnalyzer). The `runtime` vendor policy leaves them out; every other vendored module is a runtime dependency and always ships. The
`full` policy also ships the analyzer rules and settings, because the build run executes the tests.

## The functions

- `Resolve-BuildModuleSet` returns the closure-expanded, ordinally sorted module set of a build: the union of a profile and explicit module
  names, each expanded through `Get-ModuleProfile` (`dependencies.yml`).
- `Get-BuildFileCopy` lists the plan entries that copy a source folder's tracked files to a build-relative, forward-slashed folder. The index
  from `Get-BuildSourceIndex` says which files may ship and in which line-ending form, and an ignored file is skipped. Folder names given as
  excluded (tests, for one) are skipped at any depth. Only the types folders take untracked files, because their sources must equal the type
  set that the DLL name proves. The walk is a named whole-tree one
  ([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the build copies
  every shippable file, so nothing is pruned.
- `Copy-BuildFileIfChanged` copies a file only when the target is missing or differs, and returns whether it wrote. Normalising yields the
  bytes git stores for an LF-only file, whatever line endings the checkout wrote.
- `Get-BuildSourceCommit` returns the commit the build was made from, or `$null` when git cannot answer (no work tree, no git).
- `Invoke-ModuleBuild` builds the modules; see below.

## Invoke-ModuleBuild

The engine writes no console output; its caller reports the result. It takes explicit module names, a `profiles.yml` key, or both, and
needs at least one of the two. The version is the resolved `MAJOR.MINOR.PATCH`: the engine never resolves `auto`. The build goes to
`<Destination>/Catzc/<Version>/`, records the named bundle (an `exporter.yml` bundles key) in `build.json`, and takes the `Catzc.psd1`
metadata (Guid, Author, CompanyName, Description, Tags, ProjectUri, LicenseUri). A dry run still runs every check, since all checks run
before anything is written. It returns BuildRoot, Version, Modules, TypesHash, ContentHash (`$null` under a dry run), FileCount, Dirty and
DryRun.

```powershell
Invoke-ModuleBuild -ModuleProfile full -Version 6.6.666 -VendorPolicy runtime -Destination (Join-Path (Get-OutputRoot) 'automation/built/full') -Bundle full -PackageMetadata $metadata
```

Two checks come before any write. The presence check
([ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically))
runs against the plan, so a missing asset fails before any write. The types surface a bundle carries must be the committed contract: a build
checks it and never writes it
([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](../../../drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)).
