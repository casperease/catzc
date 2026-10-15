---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Builder.psm1.md
    kind: comment-page
    body_sha: b9f267c69aad
    adrs:
      - ADR-AUTO-ASSETDEP#4
      - ADR-AUTO-BUNDLE#5
      - ADR-PWSH-MANIFEST#5
---

# automation/.internal/Catzc.Internal.Builder.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Set-StrictMode -Version Latest`.

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

Above `$script:testToolVendorModules = @('Pester', 'PSScriptAnalyzer')`.

```text
Vendored modules that serve only the quality gates — the two the importer loads lazily. vendor_policy 'runtime'
leaves them out; every other vendored module is a runtime dependency and always ships.
```

## comment:3

Above `$script:runtimeInternalFiles = @(`.

```text
The runtime loader a build carries under .internal/: Import-Catzc.ps1 boots Invoke-Importer -Bundle, which loads
Bootstrap, Types and Vendor and applies the error view. Builder and the tests never ship.
```

## comment:4

Above `$script:fullPolicyInternalFiles = @(`.

```text
What a test-capable build (vendor_policy 'full') adds: the analyzer settings, which travel with the analyzer like
.scriptanalyzer/, and the TestKit the test files load (Import-InternalModule TestKit) — the build run executes them.
```

## comment:5

Above `$script:mergedFileSuffix = '.functions.ps1'`.

```text
The merged function file of a built module is <Module>.functions.ps1, never <Module>.ps1: a nested script
module is named for its file, so <Module>.ps1 would load a second module named <Module> under the manifest's,
and Get-Module <Module>, Mock -ModuleName and InModuleScope would each see two modules of that name.
```

## comment:6

Above `$script:shippedSideFolders = @('assets', 'configs', 'types')`.

```text
A module's side folders that ship verbatim; everything else in the module folder (private/, tests/, README.md,
the source-mode manifest) does not.
```

## comment:7

Section `.DESCRIPTION` of the comment-based help.

```text
Ignored files (bin/, obj/, local scratch) never reach a bundle. An untracked file that is not ignored is new
work on a devbox, so it ships, and it makes the tree dirty; a pipeline refuses a dirty tree, so a released
bundle is always exactly its commit's tracked files. The mark drives the one normalisation rule
([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)): a file whose index
form is LF-only is written LF-only, which undoes whatever line-ending conversion the checkout applied;
every other file (CRLF-stored, mixed, binary, no line ending, untracked) is a byte copy. On a clean tree the
build therefore ships exactly the bytes git stores, on any OS and under any core.autocrlf.
```

## comment:8

Section `.DESCRIPTION` of the comment-based help.

```text
Content decides, not file metadata: git diff compares each file as git would store it with HEAD, so a
checkout whose line endings differ from another checkout's is still the same commit. (git status goes by
stat data first and calls such a file modified until the index is refreshed.) --no-optional-locks keeps
both calls read-only. A tree with no commit to compare against counts as dirty.
```

## comment:9

Section `.DESCRIPTION` of the comment-based help.

```text
The declared closure (dependencies.yml) leaves a module it does not list unconstrained, so a partial
build can miss a module the code really needs; this proves the closure from the code itself
([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)):

  commands  every call a selected module makes to a catzc function (Get-FunctionDependency) targets a
            selected module
  configs   every Get-Config whose config name is a literal (-Config <name>, or the first positional
            argument) reads a config that a selected module owns (<Module>/configs/<name>.yml); a
            read scoped by owner (-ListOwners, -Module) reads only the owners present, so it is exempt

A config name that no module owns is left to Get-Config itself, which fails the same way in source mode.
```

## comment:10

Above `$isOwnerScoped = @($elements | Where-Object {`.

```text
-ListOwners / -Module read a config that many modules may ship, owner by owner: only the owners
present are read, so an owner missing from the build is not a gap.
```

## comment:11

Section `.DESCRIPTION` of the comment-based help.

```text
Order is private/*.ps1 ordinal, then the root *.ps1 ordinal — the order the source manifest's NestedModules
uses, so load semantics are identical. Files git ignores are never merged. Each file is taken verbatim (CR
stripped, trailing newlines trimmed) behind one '# source: automation/<Module>/<path>' marker line.
Returns the canonical text, the public (exported) function names, and every precondition violation of
every file.
```

## comment:12

Above `foreach ($violation in @(Get-FunctionFileViolation -Path $entry.Path...`.

```text
The one function-file check (Catzc.Base.Overlay), shared with the consumer overlay, which loads a function
file into a built module the same way the merge does.
```

## comment:13

Section `.PARAMETER IncludeUntracked` of the comment-based help.

```text
Copy untracked files too. Only the types/ folders take it: their sources must equal the type set the DLL's
name (typesHash) proves, and that set is every types/*.cs on disk, tracked or not. A pipeline builds a
clean tree, where the two are the same.
```

## comment:14

Section `.DESCRIPTION` of the comment-based help.

```text
Pure with respect to the build destination: reads the source modules and infrastructure, writes nothing.
Returns the plan entries (build-relative Path, Kind Text/Copy/Manifest/Types, Content or Source), the
type-source hash, the union of the public functions, and the collected violations — merge preconditions
([ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), missing modules, missing
infrastructure.
```

## comment:15

Above `$typeHash = $null`.

```text
The combined-types assembly is always the FULL type set, whatever modules are selected, so a build loads the
same types as source mode. The committed <source>/.compiled/Catzc.Types.<hash>.dll is reused by copy — its
name is the hash proof — and compiled into the build only when it is missing. A selected module's sources
ship in its own types/ folder (copied above); every other module's ship verbatim under
.compiled/types/<Module>/<File>.cs, a dot folder the importer never takes for a module. Together the two hold
the full set the hash covers; build.json lists every source by its build-relative path, in hash order.
```

## comment:16

Above `$dllPath = ".compiled/Catzc.Types.$typeHash.dll"`.

```text
The DLL is proven by its name, the hash of the type sources, not by git: a devbox that changed a
types/*.cs holds the matching DLL before it is committed. It is binary, so a byte copy.
```

## comment:17

Section `.DESCRIPTION` of the comment-based help.

```text
Rendered here rather than by New-ModuleManifest, whose output carries a generation date and so differs on
every build; the same commit must yield the same bytes
([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)). Values are single-quoted
with
embedded quotes doubled. Blank ProjectUri/LicenseUri are left out.
```

## comment:18

Section `.DESCRIPTION` of the comment-based help.

```text
A byte copy, except under -Normalize, which turns every CRLF into LF first: the bytes git stores for a
file it holds LF-only (Get-BuildSourceIndex), whatever line endings the checkout wrote. The Latin-1
round trip maps each byte to one char and back, so nothing but the CR bytes changes.
```

## comment:19

Section `.DESCRIPTION` of the comment-based help.

```text
What makes a rebuild converge instead of accumulate: a removed module, a dropped vendor module, a stale
types DLL of an earlier hash. A file that cannot be deleted (a DLL loaded by another process) fails the
build with its path, rather than leaving a second types DLL beside the current one.
```

## comment:20

Above `$hadBootstrap = [bool] (Get-Module Catzc.Internal.Bootstrap)`.

```text
The manifests come from the bootstrap's canonical emitter (New-DynamicManifest -NestedModule
-FunctionToExport). The bootstrap leaves the session after an import, so it is loaded for the build and
removed again when this call loaded it.
```

## comment:21

Above `if (@($Entries | Where-Object { $_.Kind -eq 'Types' }).Count -gt 0) {`.

```text
Fallback when the committed DLL is missing: the one compile path (Build-CombinedTypeAssembly) over the full
type set. An existing DLL of the same hash is kept, so a rebuild of the same sources compiles nothing.
```

## comment:22

Section `.DESCRIPTION` of the comment-based help.

```text
The engine behind Build-Modules (Catzc.Base.Exporter;
[ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). Resolves
the module set (-Module and/or -ModuleProfile, closure-expanded over dependencies.yml), then converges
<Destination>/Catzc/<Version>/ to:

  Catzc.psd1, Catzc.psm1, Import-Catzc.ps1   the package manifest, its RootModule, the initializer
  build.json                                 provenance: bundle, version, hashes, type sources, commit, dirty,
                                             modules
  .internal/                                 the runtime loader (Loader, Importer, Types, Vendor, Bootstrap)
  .compiled/Catzc.Types.<hash>.dll           the full type set (the committed DLL, copied)
  .compiled/types/<Module>/<File>.cs         type sources of the modules not selected
  .vendor/                                   vendored modules per -VendorPolicy, verbatim
  <Module>/<Module>.psd1                     per module: generated manifest (NestedModules = the merged file)
  <Module>/<Module>.functions.ps1            per module: merged function files
  <Module>/{configs,assets,types}/           shipped side folders, verbatim — never tests/

A build ships the files git tracks under the source root, plus the untracked files git does not ignore
(new work on a devbox), never an ignored one, and writes each as git stores it: a file git holds LF-only
is written LF-only whatever the checkout's line endings, every other file is a byte copy
(Get-BuildSourceIndex). The same commit therefore yields the same bytes on any OS. A source tree that
differs from its commit — an untracked file included — is recorded as dirty in build.json; a pipeline
refuses to build one, so a released bundle is exactly its commit.

Every check runs before anything is written, and each collects every violation before it throws: the
merge preconditions of every source file
([ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), the closure check —
every catzc call and literal config read of the selected modules lands in a selected module
(Get-BuildClosureViolation) — and the presence
check — every internal asset dependency of the selected modules (Get-InternalAssetDependency) is present in the planned output
([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)). Writes are
converging: text through Write-FileIfChanged, copies only on a byte
difference, and files the plan omits removed — so a rebuild of an unchanged commit writes nothing.

The types assembly is always the full type set: the committed <source>/.compiled/Catzc.Types.<hash>.dll
is copied (compiled into the build only when missing). Selected modules' sources ship in <Module>/types/,
every other module's under .compiled/types/<Module>/<File>.cs. Because the DLL is a byte copy, the content
hash (Get-CatzcContentHash) covers every file except build.json, the DLL included. The engine writes no
console output; its caller reports the result.
```

## comment:23

Section `.PARAMETER VendorPolicy` of the comment-based help.

```text
runtime ships the runtime vendored modules only; full also ships Pester, PSScriptAnalyzer and the analyzer
rules and settings, which the build run needs.
```

## comment:24

Section `.PARAMETER DryRun` of the comment-based help.

```text
Return the plan and write nothing
([ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)).
```

## comment:25

Above `$plannedPaths =...`.

```text
The presence check
([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)), checked
against the plan so a missing asset fails before any write.
```
