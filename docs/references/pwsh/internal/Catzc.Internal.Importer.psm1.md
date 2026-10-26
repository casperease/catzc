# pwsh/.internal/Catzc.Internal.Importer.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.Importer — the importer overlay.

The whole load sequence lives here, in Invoke-Importer, whose parameter block is the importer's public
switch surface. The root importer.ps1 is a thin, GENERATED shim (New-Importer) that carries the same param
block and delegates here — one living copy of the load logic (see
[PDR-ONELIVE](/docs/drs/principles/one-living-version.md)), which a bundle's entry runs too, in its -Bundle mode
([ADR-AUTO-BUNDLE-ONELIVINGIMPORTER](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-onelivingimporter)).
It sets the two roots, RepositoryRoot and CatzcModulesRoot, equal in the mono repo
([ADR-AUTO-BUNDLE-TWOROOTS](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-tworoots)), and establishes the
catzc session every entry loads into
([ADR-AUTO-BUNDLE-BUNDLEISSESSION](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-bundleissession)).
Like the transient bootstrap, this module is import-time orchestration, not shared library code: the shim
removes it after Invoke-Importer returns.
```

## comment:2

Above `$script:modulesFolder = 'pwsh'`, written with `#`.

```text
The one bootstrap constant: the folder under the repository root that holds the modules. It is read before any registry
loads, so it cannot come from one; everything after the import reads it back through Get-CatzcModulesRoot, and
New-Importer writes the shim's loader line from that resolver (ADR-AUTO-LAYERS).
```

## comment:3

Above `function Invoke-Importer {`, written with `#`.

```text
.SYNOPSIS
    Runs the toolset's whole load sequence — the single living copy of the importer body.
.DESCRIPTION
    The parameter block is asserted to match importer.ps1, which New-Importer generates from it.
.PARAMETER ExportPrivates
    Export private (private/) functions too, so tests can reach them.
.PARAMETER AllowWarnings
    Set $global:WarningPreference to Continue instead of Stop (warnings do not fail the load).
.PARAMETER DiagnoseLoadTime
    Emit per-stage load timings and an end-of-load summary.
.PARAMETER ClearCompiledTypes
    Delete every compiled C# type DLL before importing so types rebuild from source.
.PARAMETER SkipJanitors
    Skip the post-import janitors and the PSModulePath check — a lean load for a copied subset.
.PARAMETER CleanClone
    The clean keeps and reports any untracked file that is not the automation's to delete.
.PARAMETER Bundle
    Only the bundle bootstrap passes it, so an inherited CatzcModulesRoot never diverts a mono repo or fixture load.
.EXAMPLE
    Invoke-Importer -DiagnoseLoadTime
```

## comment:4

Above `[switch] $ClearCompiledTypes,`, written with `#`.

```text
Delete every compiled C# type DLL before importing, so each type is rebuilt from source rather than
loaded from its committed/cached assembly. Use it to build from source (e.g. verify a clean rebuild).
```

## comment:5

Above `[switch] $SkipJanitors,`, written with `#`.

```text
Skip the post-import janitors (Clear-ModuleTypeCache, Build-Readme, Build-TerminologyDictionary,
Build-RootConfig) and the PSModulePath check — a lean/optimized load for a copied subset
(Test-InIsolation). Type loading still fast-paths on the committed .compiled DLL; only the tail
maintenance is skipped.
```

## comment:6

Above `[switch] $CleanClone,`, written with `#`.

```text
Opt IN to a whitelisted deep clean as the janitor run's first step (Reset-GitCleanFxd): delete
only the auto-controlled generated artifacts, keep and report everything else, and let the
regenerating janitors below rematerialise the tree.
```

## comment:7

Above `[switch] $Bundle,`, written with `#`.

```text
Load as an installed bundle, not the mono repo. Honour the pre-set $env:CatzcModulesRoot (the bundle's
own pwsh/, set by its Catzc.psm1) instead of deriving it from RepositoryRoot, and force
-SkipJanitors (a bundle is a read-only install with no git work tree). Only the bundle bootstrap passes
this; the mono shim never does, so an inherited CatzcModulesRoot can never divert a mono/fixture load.
```

## comment:8

Above `if ($PSVersionTable.PSVersion -lt [version]'7.4') {`, written with `#`.

```text
Hard floor: the toolset requires PowerShell 7.4+. Among other things the vendor functions
(Catzc.Base.Vendor) use the bundled Microsoft.PowerShell.PSResourceGet, first shipped in 7.4.
```

## comment:9

Above `$stack = Get-PSCallStack`, written with `#`.

```text
Detect a direct console session vs a load from within a script. The overlay runs one call below the
generated importer.ps1 shim, so the stack is [0] Invoke-Importer, [1] importer.ps1, [2] the shim's caller.
An empty ScriptName at [2] means importer.ps1 was dot-sourced with no calling script (a console session).
This reproduces the shim's own `-not $MyInvocation.ScriptName` from inside the module.
```

## comment:10

Above `$showStateChanges = $VerbosePreference -ne 'SilentlyContinue'`, written with `#`.

```text
-Verbose shows the importer's own state-change record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)). The
dot-sourced shim binds it in the caller's scope, so for the import the session-wide preference is quieted,
restored in the finally below: otherwise every Import-Module would list each function it dot-sources and exports.
```

## comment:11

Above `$outputEncodingChanged = Set-RedirectedOutputEncoding`, written with `#`.

```text
A redirected session writes UTF-8, the encoding the process relays stream, so a captured log is one
encoding; announced with the preferences below.
```

## comment:12

Above `$repoRoot = $env:RepositoryRoot`, written with `#`.

```text
Repository root — the WORKING root (out/, repo-relative paths, git), set on $env by the shim
(importer.ps1 sets $env:RepositoryRoot = $PSScriptRoot). Read it here; working-root readers anchor on it.
```

## comment:13

Above `if ($Bundle -and $env:CatzcModulesRoot) {`, written with `#`.

```text
Catzc code anchor — the pwsh/ tree that holds the loaded modules; config, type and vendor discovery
follow THIS, not RepositoryRoot (see Get-CatzcModulesRoot). In the mono repo it equals <repoRoot>/pwsh
and nothing pre-sets it, so it is derived here (a no-op split). An installed bundle's Catzc.psm1 pre-sets it
to the bundle's own pwsh/, so the importer honours that — this is what makes catzc relocatable.
```

## comment:14

Above `Import-InternalModule Bootstrap -Force`, written with `#`.

```text
The .internal shared-code loader is already imported by the shim (it provides Import-InternalModule).
Load the rest of the shared modules on demand. Bootstrap does the import-time discovery/loading and is
removed at the end; the loader, Types and Vendor stay in the session (NOT removed), so post-import Catzc
cover functions can Import-InternalModule the same shared code and delegate to it. -Force honors the
re-import invalidation boundary (cache ADR), so a devbox re-import picks up edits to a shared module.
```

## comment:15

Above `Write-ImporterMessage ("Session:...`, written with `#`.

```text
Every lasting change to the caller's session is announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)):
the preferences and the
error view, then the two roots and the internal modules that stay loaded — RepositoryRoot set by the
importer.ps1 shim and the modules by Import-InternalModule, which both delegate their announcement here.
This is where Write-ImporterMessage (Catzc.Internal.Loader) first announces. Like every announcement
of the importer's own load, they go on its verbose record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)).
```

## comment:16

Above `if ($isConsoleSession) {` (occurrence 2), written with `#`.

```text
Load vendored dependencies first
Console session: load timer, split into the module import and the session initializer/finalizer around it.
In scripts, authors add `trap { Write-Exception $_; break }` after the importer.
```

## comment:17

Above `if ($ClearCompiledTypes) {`, written with `#`.

```text
Discover and import all modules from the catzc code anchor computed above ($modulesRoot).
Optionally wipe compiled type DLLs first so the import below rebuilds them from source.
```

## comment:18

Above `Assert-CatzcRunModeExclusive -ModulesRoot $modulesRoot`, written with `#`.

```text
The two run modes never coexist ([DDR-RUNMODE-NEVERCOEXIST](/docs/drs/design/run-modes.md#rule-ddr-runmode-nevercoexist)):
Import-AllModules evicted the other mode, and this
proves it before any janitor touches the tree from a mixed session.
```

## comment:19

Above `if (-not $SkipJanitors -and -not $deferJanitors) {`, written with `#`.

```text
The post-import janitors, in their fixed order (Invoke-ImporterJanitors). An isolated copy and a bundle
(-SkipJanitors) skip the whole chain.
```

## comment:20

Above `if (-not $SkipJanitors -and $IsWindows) {`, written with `#`.

```text
Warn if PSModulePath contains a network share. The permanent fix is a one-time
script that writes a local PSModulePath to the user-scope powershell.config.json.
See: pwsh/Catzc.Base.Environment/assets/README.md
```

## comment:21

Above `Write-Verbose 'Removing Catzc.Internal.Bootstrap module'`, written with `#`.

```text
Remove the bootstrap so its import-time functions do not linger;
the other .internal modules (loader, Types, Vendor) stay loaded.
```

## comment:22

Above `$initializerSeconds = [math]::Round($initializerEnd.TotalSeconds, 1)`, written with `#`.

```text
The three parts sum to the total: the initializer is everything before the vendor import starts, the
module import runs from there to the last module loaded, the finalizer is the rest (assert, overlay, janitors, cleanup).
```

## comment:23

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Applies a consumer's overlay at the end of a bundle load, or stops the load when the bundle cannot.
.DESCRIPTION
    A bundle without the overlay module cannot apply overrides, so the load stops instead of ignoring them.
.PARAMETER RepositoryRoot
    The working root of the load.
```

## comment:24

Above `[CmdletBinding()]` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Throws unless every loaded catzc module comes from the active code root.
.DESCRIPTION
    Every loaded Catzc module must sit under the active CatzcModulesRoot, the predicate the eviction sweep uses.
.PARAMETER ModulesRoot
    The active code root.
```

## comment:25

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawConsoleWrite...`, written with `#`.

```text
.SYNOPSIS
    Makes a redirected session write UTF-8, so a captured log has one encoding.
.DESCRIPTION
    A redirected host writes the OEM codepage while relays stream UTF-8, which mangled box drawing in logs.
```

## comment:26

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Runs the post-import type-cache janitor (Clear-ModuleTypeCache) without ever failing the load.
.DESCRIPTION
    A superseded build it cannot delete is one red line, never a failed load.
.PARAMETER ShowReport
    Show the janitor's end-state report.
```

## comment:27

Above `[CmdletBinding()]` (occurrence 7), written with `#`.

```text
.SYNOPSIS
    Publishes every agent hook, each folder under .claude/hooks that has a csproj, whose C# source changed, without ever failing the load.
.DESCRIPTION
    A checkout without the hooks' code or dotnet is told, never stopped: Install-Dotnet needs this import.
```

## comment:28

Above `[CmdletBinding()]` (occurrence 10), written with `#`.

```text
.SYNOPSIS
    Writes one -DiagnoseLoadTime stage line: the milliseconds since the previous stage, then restarts the clock.
.DESCRIPTION
    A call before the clock exists starts it instead of throwing on the unset variable.
.PARAMETER Step
    The stage just finished.
```

## comment:29

Above `[CmdletBinding()]` (occurrence 11), written with `#`.

```text
.SYNOPSIS
    Writes the -DiagnoseLoadTime summary: file-read and parse totals, and the three slowest load stages.
.DESCRIPTION
    It writes through the transient bootstrap, so it must run while that is still loaded.
```

## comment:30

Above `$scanMs = [int](($global:__CatzcLoadTimings | Measure-Object ReadMs -Sum).Sum)`, written with `#`.

```text
raw-read is a pure [IO.File]::ReadAllText of every .ps1 BEFORE Import-Module, so it isolates the cold
file-READ I/O (disk / network share / antivirus-on-read) from the parse. It is warm-cached after the
first access — small here does NOT mean "no AV": an AV that scans on script *parse* (AMSI) is not a
read, so that cost lands in parse/compile below, not here. Don't read this as "antivirus time".
```

## comment:31

Above `$top = $global:__CatzcLoadTimings | Sort-Object Ms -Descending |...`, written with `#`.

```text
The native C# type compile/load (every module's types/*.cs via Import-CSharpTypes) appears as one
'types (combined)' row below; a 'compile+load' row is a cold cache (Roslyn), a 'cache load' row reused
the committed pwsh/.compiled DLL.
```

## comment:32

Above `$hostKind = if ($isConsoleSession -and (Test-IsInteractiveHost) -and -not...`, written with `#`.

```text
An interactive dot-source is the only console host; a script, a test worker, a -File or -Command process and a
pipeline load the types and run the janitors at import.
```

## comment:33

Above `$mixArgs = @{}`, written with `#`.

```text
The mix is resolved once the modules are loaded and kept as the session record; the modules outside it are
removed.
```

## comment:34

Above `$show = $showStateChanges`, written with `#`.

```text
A console import stays types-free: the mix needs the types, so it is resolved once the first prompt has
shown, before the janitors.
```

## comment:35

Above `Enable-DeferredJanitors -ShowStateChanges:$showStateChanges`, written with `#`.

```text
A console import stays types-free: the janitors call catzc commands, so they run once the first prompt has
shown.
```

## comment:36

Above `& $writeMessage "Loaded in $totalSeconds seconds (session initializer...`, written with `#`.

```text
Run through its command info: a lookup by name is a first use and would load the pending types for a
status line.
```

## comment:37

Above `function Write-InsideVsCodeNotice {`, written with `#`.

```text
The one line a janitor prints instead of working inside VS Code: what it left undone and the command to run from a
terminal outside the editor.
```

## comment:38

Above `function Invoke-EditorExtensionJanitor {`, written with `#`.

```text
Installs the repository's own editor extensions whose installed copy is missing or stale, so loading the repo is the
whole setup.
```
