---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Builder.psm1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "12ea9b16727f"
    adrs:
      - ADR-AUTO-ASSETDEP#4
      - ADR-PWSH-ENUM#3
---

# automation/.internal/Catzc.Internal.Builder.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest`, written with `#`.

```text
Catzc.Internal.Builder — the build-mode engine (Invoke-ModuleBuild).

Builds the selected modules into one installable, versioned Catzc package
([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md),
[ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): every module stays its own PowerShell module of the same name, its
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

Above `$script:runtimeInternalFiles = @(`, written with `#`.

```text
The runtime loader a build carries under .internal/: Import-Catzc.ps1 boots Invoke-Importer -Bundle, which loads
Bootstrap, Types and Vendor and applies the error view. Builder and the tests never ship.
```

## comment:4

Above `$script:fullPolicyInternalFiles = @(`, written with `#`.

```text
What a test-capable build (vendor_policy 'full') adds: the analyzer settings, which travel with the analyzer like
.scriptanalyzer/, and the TestKit the test files load (Import-InternalModule TestKit) — the build run executes them.
```

## comment:5

Above `$script:mergedFileSuffix = '.functions.ps1'`, written with `#`.

```text
The merged function file of a built module is <Module>.functions.ps1, never <Module>.ps1: a nested script
module is named for its file, so <Module>.ps1 would load a second module named <Module> under the manifest's,
and Get-Module <Module>, Mock -ModuleName and InModuleScope would each see two modules of that name.
```

## comment:6

Above `$script:shippedSideFolders = @('assets', 'configs', 'types')`, written with `#`.

```text
A module's side folders that ship verbatim; everything else in the module folder (private/, tests/, README.md,
the source-mode manifest) does not.
```

## comment:7

Above `[CmdletBinding()]`, written with `#`.

```text
.SYNOPSIS
    Returns the files a build may ship — the tracked files and the untracked files git does not ignore — each
    marked with whether git stores it with LF-only line endings.
.DESCRIPTION
    An untracked file that is not ignored ships and dirties the tree, which a pipeline refuses.
    [comment:7](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment7)
.OUTPUTS
    [System.Collections.Generic.Dictionary[string, bool]] source-root-relative, forward-slashed path -> LF-only.
```

## comment:8

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Returns whether the source root differs from its commit: a modified, staged, deleted or untracked file.
.DESCRIPTION
    Content decides, not stat data: a checkout with other line endings is still the same commit.
    [comment:8](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment8)
```

## comment:9

Above `[CmdletBinding()]` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Returns whether a source file ships LF-normalised: it is tracked and git stores it with LF-only endings.
```

## comment:10

Above `[CmdletBinding()]` (occurrence 4), written with `#`.

```text
.SYNOPSIS
    Returns whether a source file may ship in a build: tracked by git, or untracked and not ignored.
```

## comment:11

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Returns the closure-expanded, ordinally sorted module set of a build: the union of a profile and explicit
    module names, each expanded through Get-ModuleProfile (dependencies.yml).
```

## comment:12

Above `[CmdletBinding()]` (occurrence 6), written with `#`.

```text
.SYNOPSIS
    Returns every call and config read of the selected modules that lands outside the selection.
.DESCRIPTION
    Proves the closure from the code, because dependencies.yml leaves an unlisted module unconstrained.
    [comment:9](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment9)
```

## comment:13

Above `$isOwnerScoped = @($elements | Where-Object {`, written with `#`.

```text
-ListOwners / -Module read a config that many modules may ship, owner by owner: only the owners
present are read, so an owner missing from the build is not a gap.
```

## comment:14

Above `[CmdletBinding()]` (occurrence 7), written with `#`.

```text
.SYNOPSIS
    Merges one source module's function files into the text of its built <Module>.functions.ps1.
.DESCRIPTION
    Same order as the source manifest's NestedModules, so load semantics match source mode.
    [comment:11](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment11)
```

## comment:15

Above `foreach ($violation in @(Get-FunctionFileViolation -Path $entry.Path...`, written with `#`.

```text
The one function-file check (Catzc.Base.Overlay), shared with the consumer overlay, which loads a function
file into a built module the same way the merge does.
```

## comment:16

Above `[CmdletBinding()]` (occurrence 8), written with `#`.

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
    [comment:13](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment13)
```

## comment:17

Above `foreach ($file in Get-ChildPath $sourceFull -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the build
copies every shippable file, so nothing is pruned here.
```

## comment:18

Above `[CmdletBinding()]` (occurrence 9), written with `#`.

```text
.SYNOPSIS
    Computes every file a build writes, from the source tree alone, and collects every reason it cannot.
.DESCRIPTION
    Reads sources and writes nothing, so the plan can be checked or returned before any write.
    [comment:14](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment14)
```

## comment:19

Above `$typeHash = $null`, written with `#`.

```text
The combined-types assembly is always the FULL type set, whatever modules are selected, so a build loads the
same types as source mode. The committed <source>/.compiled/Catzc.Types.<hash>.dll is reused by copy — its
name is the hash proof — and compiled into the build only when it is missing. A selected module's sources
ship in its own types/ folder (copied above); every other module's ship verbatim under
.compiled/types/<Module>/<File>.cs, a dot folder the importer never takes for a module. Together the two hold
the full set the hash covers; build.json lists every source by its build-relative path, in hash order.
```

## comment:20

Above `$dllPath = ".compiled/Catzc.Types.$typeHash.dll"`, written with `#`.

```text
The DLL is proven by its name, the hash of the type sources, not by git: a devbox that changed a
types/*.cs holds the matching DLL before it is committed. It is binary, so a byte copy.
```

## comment:21

Above `[CmdletBinding()]` (occurrence 10), written with `#`.

```text
.SYNOPSIS
    Renders the package manifest Catzc.psd1 as canonical, deterministic text.
.DESCRIPTION
    Not New-ModuleManifest, whose generation date would make the same commit yield different bytes.
    [comment:17](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment17)
```

## comment:22

Above `[CmdletBinding()]` (occurrence 11), written with `#`.

```text
.SYNOPSIS
    Copies a file, only when the target is missing or differs. Returns whether it wrote.
.DESCRIPTION
    Normalize yields the bytes git stores for an LF-only file, whatever line endings the checkout wrote.
    [comment:18](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment18)
```

## comment:23

Above `[CmdletBinding()]` (occurrence 12), written with `#`.

```text
.SYNOPSIS
    Deletes every file under the build root that the plan does not name, then every emptied folder.
.DESCRIPTION
    A file that cannot be deleted fails the build with its path, rather than leave a second types DLL.
    [comment:19](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment19)
```

## comment:24

Above `foreach ($file in @(Get-ChildPath $BuildRoot -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a stale
file anywhere under the build root must go, so nothing is pruned.
```

## comment:25

Above `[CmdletBinding()]` (occurrence 13), written with `#`.

```text
.SYNOPSIS
    Returns the commit the build was made from, or $null when git cannot answer (no work tree, no git).
```

## comment:26

Above `[CmdletBinding()]` (occurrence 14), written with `#`.

```text
.SYNOPSIS
    Converges the build root to a plan: writes what differs, compiles the types, prunes what the plan omits.
.OUTPUTS
    [pscustomobject] Built — the combined-types build result, or $null when the selection ships no type.
```

## comment:27

Above `$hadBootstrap = [bool] (Get-Module Catzc.Internal.Bootstrap)`, written with `#`.

```text
The manifests come from the bootstrap's canonical emitter (New-DynamicManifest -NestedModule
-FunctionToExport). The bootstrap leaves the session after an import, so it is loaded for the build and
removed again when this call loaded it.
```

## comment:28

Above `if (@($Entries | Where-Object { $_.Kind -eq 'Types' }).Count -gt 0) {`, written with `#`.

```text
Fallback when the committed DLL is missing: the one compile path (Build-CombinedTypeAssembly) over the full
type set. An existing DLL of the same hash is kept, so a rebuild of the same sources compiles nothing.
```

## comment:29

Above `[CmdletBinding()]` (occurrence 15), written with `#`.

```text
.SYNOPSIS
    Builds the selected modules into one installable, versioned Catzc package — build mode's code root.
.DESCRIPTION
    The engine writes no console output; its caller reports the result.
    [comment:22](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment22)
.PARAMETER Module
    Explicit module names. Combined with -ModuleProfile; at least one of the two is required.
.PARAMETER ModuleProfile
    A profiles.yml key.
.PARAMETER Version
    The resolved MAJOR.MINOR.PATCH version (the engine never resolves 'auto').
.PARAMETER VendorPolicy
    Full also ships the analyzer rules and settings, because the build run executes the tests.
    [comment:23](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment23)
.PARAMETER Destination
    The parent folder; the build goes to <Destination>/Catzc/<Version>/.
.PARAMETER Bundle
    The named bundle this build is (an exporter.yml bundles key), recorded in build.json.
.PARAMETER PackageMetadata
    Catzc.psd1 metadata: Guid, Author, CompanyName, Description, Tags, ProjectUri, LicenseUri.
.PARAMETER DryRun
    A dry run still runs every check, since all checks run before anything is written.
    [comment:24](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment24)
.OUTPUTS
    [pscustomobject] BuildRoot, Version, Modules, TypesHash, ContentHash ($null under -DryRun), FileCount,
    Dirty, DryRun.
.EXAMPLE
    Invoke-ModuleBuild -ModuleProfile full -Version 6.6.666 -VendorPolicy runtime -Destination (Join-Path (Get-OutputRoot) 'automation/built/full') -Bundle full -PackageMetadata $metadata
```

## comment:30

Above `$plannedPaths =...`, written with `#`.

```text
The presence check
([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)), checked
against the plan so a missing asset fails before any write.
```
