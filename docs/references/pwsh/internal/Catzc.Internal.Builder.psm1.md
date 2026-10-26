# pwsh/.internal/Catzc.Internal.Builder.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest`, written with `#`.

```text
Catzc.Internal.Builder — the build-mode engine (Invoke-ModuleBuild).

Builds the selected modules into one installable, versioned Catzc package
([ADR-AUTO-BUNDLE](/docs/drs/automation/platform-bundle.md),
[DDR-RUNMODE](/docs/drs/design/run-modes.md)): every module stays its own PowerShell module of the same name, its
function files
merged into one <Module>.functions.ps1 behind a generated manifest, beside the runtime loader (.internal), the vendored
dependencies (.vendor), the full combined-types DLL and its sources (.compiled) and the package entry points. It
is a .internal multi-function module (the one-function-per-file convention does not apply), loaded on demand
(Import-InternalModule Builder) by Build-Modules after a normal source-mode import, so it calls catzc public
functions (Get-ModuleProfile, Write-FileIfChanged, Get-InternalAssetDependency, Get-CatzcContentHash, ...). It
reads the per-function source tree, so it never ships in a build itself.
```

## comment:2

Above `$script:testToolVendorModules = @('Pester', 'PSScriptAnalyzer')`, written with `#`.

```text
Vendored modules that serve only the quality gates — the two the importer loads lazily. vendor_policy 'runtime'
leaves them out; every other vendored module is a runtime dependency and always ships.
```

## comment:3

Above `$script:mergedFileSuffix = '.functions.ps1'`, written with `#`.

```text
The merged function file of a built module is <Module>.functions.ps1, never <Module>.ps1: a nested script
module is named for its file, so <Module>.ps1 would load a second module named <Module> under the manifest's,
and Get-Module <Module>, Mock -ModuleName and InModuleScope would each see two modules of that name.
```

## comment:4

Above `[CmdletBinding()]`, written with `#`.

```text
.SYNOPSIS
    Returns the closure-expanded, ordinally sorted module set of a build: the union of a profile and explicit
    module names, each expanded through Get-ModuleProfile (dependencies.yml).
```

## comment:5

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Lists the plan entries that copy a source folder's tracked files to a build-relative folder.
.PARAMETER SourceDirectory
    The folder whose files are copied (recursively).
.PARAMETER TargetPath
    The build-relative, forward-slashed folder the files land in.
.PARAMETER SourceRoot
    The source root the index paths are relative to.
.PARAMETER Index
    The files that may ship and their line-ending form (Get-BuildSourceIndex); an ignored file is skipped.
.PARAMETER ExcludeDirectory
    Folder names (at any depth) whose contents are skipped — e.g. tests.
.PARAMETER IncludeUntracked
    Only the types folders take it: their sources must equal the type set that the DLL name proves.
```

## comment:6

Above `foreach ($file in Get-ChildPath $sourceFull -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the build
copies every shippable file, so nothing is pruned here.
```

## comment:7

Above `[CmdletBinding()]` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Copies a file, only when the target is missing or differs. Returns whether it wrote.
.DESCRIPTION
    Normalize yields the bytes git stores for an LF-only file, whatever line endings the checkout wrote.
```

## comment:8

Above `[CmdletBinding()]` (occurrence 4), written with `#`.

```text
.SYNOPSIS
    Returns the commit the build was made from, or $null when git cannot answer (no work tree, no git).
```

## comment:9

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Builds the selected modules into one installable, versioned Catzc package — build mode's code root.
.DESCRIPTION
    The engine writes no console output; its caller reports the result.
.PARAMETER Module
    Explicit module names. Combined with -ModuleProfile; at least one of the two is required.
.PARAMETER ModuleProfile
    A profiles.yml key.
.PARAMETER Version
    The resolved MAJOR.MINOR.PATCH version (the engine never resolves 'auto').
.PARAMETER VendorPolicy
    Full also ships the analyzer rules and settings, because the build run executes the tests.
.PARAMETER Destination
    The parent folder; the build goes to <Destination>/Catzc/<Version>/.
.PARAMETER Bundle
    The named bundle this build is (an exporter.yml bundles key), recorded in build.json.
.PARAMETER PackageMetadata
    Catzc.psd1 metadata: Guid, Author, CompanyName, Description, Tags, ProjectUri, LicenseUri.
.PARAMETER DryRun
    A dry run still runs every check, since all checks run before anything is written.
.OUTPUTS
    [pscustomobject] BuildRoot, Version, Modules, TypesHash, ContentHash ($null under -DryRun), FileCount,
    Dirty, DryRun.
.EXAMPLE
    Invoke-ModuleBuild -ModuleProfile full -Version 6.6.666 -VendorPolicy runtime -Destination (Join-Path (Get-OutputRoot) 'automation/built/full') -Bundle full -PackageMetadata $metadata
```

## comment:10

Above `$plannedPaths =...`, written with `#`.

```text
The presence check
([ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically)), checked
against the plan so a missing asset fails before any write.
```

## comment:11

Above `$typesDll = [System.IO.Path]::Combine((Get-TypesShadowRoot),...`, written with `#`.

```text
The types surface a bundle carries must be the committed contract; a build checks it and never writes it
([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](/docs/drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)).
```
