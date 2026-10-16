---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Importer.psm1.md
    folder: docs/references/automation/internal
    name: catzc-internal-importer-psm1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a64cb3b45c41
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-DSGN-RUNMODE#5
      - ADR-PWSH-ANNOUNCE#{6,9}
---

# automation/.internal/Catzc.Internal.Importer.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.Importer — the importer overlay.

The whole load sequence lives here, in Invoke-Importer, whose parameter block is the importer's public
switch surface. The root importer.ps1 is a thin, GENERATED shim (New-Importer) that carries the same param
block and delegates here — one living copy of the load logic (see
[ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)).
Like the transient bootstrap, this module is import-time orchestration, not shared library code: the shim
removes it after Invoke-Importer returns.
```

## comment:2

Above `function Invoke-Importer {`, written with `#`.

```text
.SYNOPSIS
    Runs the toolset's whole load sequence — the single living copy of the importer body.
.DESCRIPTION
    The parameter block is asserted to match importer.ps1, which New-Importer generates from it.
    [comment:2](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment2)
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
    [comment:3](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment3)
.PARAMETER Bundle
    Only the bundle bootstrap passes it, so an inherited CatzcModulesRoot never diverts a mono repo or fixture load.
    [comment:4](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment4)
.EXAMPLE
    Invoke-Importer -DiagnoseLoadTime
```

## comment:3

Above `[switch] $ClearCompiledTypes,`, written with `#`.

```text
Delete every compiled C# type DLL before importing, so each type is rebuilt from source rather than
loaded from its committed/cached assembly. Use it to build from source (e.g. verify a clean rebuild).
```

## comment:4

Above `[switch] $SkipJanitors,`, written with `#`.

```text
Skip the post-import janitors (Clear-ModuleTypeCache, Build-Readme, Build-TerminologyDictionary,
Build-RootConfig) and the PSModulePath check — a lean/optimized load for a copied subset
(Test-InIsolation). Type loading still fast-paths on the committed .compiled DLL; only the tail
maintenance is skipped.
```

## comment:5

Above `[switch] $CleanClone,`, written with `#`.

```text
Opt IN to a whitelisted deep clean as the janitor run's first step (Reset-GitCleanFxd): delete
only the auto-controlled generated artifacts, keep and report everything else, and let the
regenerating janitors below rematerialise the tree.
```

## comment:6

Above `[switch] $Bundle`, written with `#`.

```text
Load as an installed bundle, not the mono repo. Honour the pre-set $env:CatzcModulesRoot (the bundle's
own automation/, set by its Catzc.psm1) instead of deriving it from RepositoryRoot, and force
-SkipJanitors (a bundle is a read-only install with no git work tree). Only the bundle bootstrap passes
this; the mono shim never does, so an inherited CatzcModulesRoot can never divert a mono/fixture load.
```

## comment:7

Above `if ($PSVersionTable.PSVersion -lt [version]'7.4') {`, written with `#`.

```text
Hard floor: the toolset requires PowerShell 7.4+. Among other things the vendor functions
(Catzc.Base.Vendor) use the bundled Microsoft.PowerShell.PSResourceGet, first shipped in 7.4.
```

## comment:8

Above `$stack = Get-PSCallStack`, written with `#`.

```text
Detect a direct console session vs a load from within a script. The overlay runs one call below the
generated importer.ps1 shim, so the stack is [0] Invoke-Importer, [1] importer.ps1, [2] the shim's caller.
An empty ScriptName at [2] means importer.ps1 was dot-sourced with no calling script (a console session).
This reproduces the shim's own `-not $MyInvocation.ScriptName` from inside the module.
```

## comment:9

Above `$importSw = [Diagnostics.Stopwatch]::new()`, written with `#`.

```text
Times only the module import (vendor + automation modules), so the console load line can split it from
the session initializer/finalizer around it (session setup and internal modules before, janitors after).
```

## comment:10

Above `$showStateChanges = $VerbosePreference -ne 'SilentlyContinue'`, written with `#`.

```text
-Verbose shows the importer's own state-change record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)). The
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
Catzc code anchor — the automation/ tree that holds the loaded modules; config, type and vendor discovery
follow THIS, not RepositoryRoot (see Get-CatzcModulesRoot). In the mono repo it equals <repoRoot>/automation
and nothing pre-sets it, so it is derived here (a no-op split). An installed bundle's Catzc.psm1 pre-sets it
to the bundle's own automation/, so the importer honours that — this is what makes catzc relocatable.
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
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)):
the preferences and the
error view, then the two roots and the internal modules that stay loaded — RepositoryRoot set by the
importer.ps1 shim and the modules by Import-InternalModule, which both delegate their announcement here.
This is the first point Write-ImporterMessage (Catzc.Internal.Bootstrap) is loaded. Like every announcement
of the importer's own load, they go on its verbose record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)).
```

## comment:16

Above `if ($ClearCompiledTypes) {`, written with `#`.

```text
Discover and import all modules from the catzc code anchor computed above ($modulesRoot).
Optionally wipe compiled type DLLs first so the import below rebuilds them from source.
```

## comment:17

Above `Assert-CatzcRunModeExclusive -ModulesRoot $modulesRoot`, written with `#`.

```text
The two run modes never coexist ([ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)):
Import-AllModules evicted the other mode, and this
proves it before any janitor touches the tree from a mixed session.
```

## comment:18

Above `if (-not $SkipJanitors) {`, written with `#`.

```text
The post-import janitors, in their fixed order (Invoke-ImporterJanitors). An isolated copy and a bundle
(-SkipJanitors) skip the whole chain.
```

## comment:19

Above `if (-not $SkipJanitors -and $IsWindows) {`, written with `#`.

```text
Warn if PSModulePath contains a network share. The permanent fix is a one-time
script that writes a local PSModulePath to the user-scope powershell.config.json.
See: automation/Catzc.Base.Environment/assets/README.md
```

## comment:20

Above `Write-Verbose 'Removing Catzc.Internal.Bootstrap module'`, written with `#`.

```text
Remove the bootstrap, kept until here for Write-ImporterMessage, so its import-time functions do not linger;
the other .internal modules (loader, Types, Vendor) stay loaded.
```

## comment:21

Above `if ($isConsoleSession) {` (occurrence 2), written with `#`.

```text
Console session: load timer, split into the module import and the session initializer/finalizer around it.
In scripts, authors add `trap { Write-Exception $_; break }` after the importer.
```

## comment:22

Above `function Invoke-ConsumerOverlay {`, written with `#`.

```text
.SYNOPSIS
    Throws unless every loaded catzc module comes from the active code root.
.DESCRIPTION
    Every loaded Catzc module must sit under the active CatzcModulesRoot, the predicate the eviction sweep uses.
    [comment:24](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment24)
.PARAMETER ModulesRoot
    The active code root.
```

## comment:23

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Applies a consumer's overlay at the end of a bundle load, or stops the load when the bundle cannot.
.DESCRIPTION
    A bundle without the overlay module cannot apply overrides, so the load stops instead of ignoring them.
    [comment:25](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment25)
.PARAMETER RepositoryRoot
    The working root of the load.
```

## comment:24

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawConsoleWrite...`, written with `#`.

```text
.SYNOPSIS
    Makes a redirected session write UTF-8, so a captured log has one encoding.
.DESCRIPTION
    A redirected host writes the OEM codepage while relays stream UTF-8, which mangled box drawing in logs.
    [comment:26](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment26)
```

## comment:25

Above `function Invoke-TypeCacheJanitor {`, written with `#`.

```text
.SYNOPSIS
    Writes the -DiagnoseLoadTime summary: file-read and parse totals, and the three slowest load stages.
.DESCRIPTION
    It writes through the transient bootstrap, so it must run while that is still loaded.
    [comment:27](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment27)
```

## comment:26

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Runs the post-import type-cache janitor (Clear-ModuleTypeCache) without ever failing the load.
.DESCRIPTION
    A superseded build it cannot delete is one red line, never a failed load.
    [comment:28](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment28)
.PARAMETER ShowReport
    Show the janitor's end-state report.
```

## comment:27

Above `[CmdletBinding()]` (occurrence 6), written with `#`.

```text
.SYNOPSIS
    Publishes the agent Bash time-safeguard hook when its C# source changed, without ever failing the load.
.DESCRIPTION
    A checkout without the hook's code or dotnet is told, never stopped: Install-Dotnet needs this import.
    [comment:29](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment29)
```

## comment:28

Above `[CmdletBinding()]` (occurrence 7), written with `#`.

```text
.SYNOPSIS
    Runs the post-import janitors in their fixed order, from the opt-in deep clean to the commit of what changed.
.DESCRIPTION
    Every janitor is a fast no-op on a clean tree and guarded by presence, so the bootstrap sandbox runs a subset.
    [comment:30](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment30)
.PARAMETER CleanClone
    Run the whitelisted deep clean (Reset-GitCleanFxd) first, so the janitors below rematerialise what it removed.
.PARAMETER ShowStateChanges
    Show the type-cache janitor's end-state report (the importer passes its -Verbose).
```

## comment:29

Above `if ($CleanClone -and (Get-Command Reset-GitCleanFxd -ErrorAction Ignore)) {`, written with `#`.

```text
Opt-in deep clean (-CleanClone): the whitelisted git clean -fxd (Reset-GitCleanFxd) deletes only the
auto-controlled generated artifacts and keeps — reported — any untracked file that is not the
automation's to delete. Deliberately the FIRST janitor, so the regenerating janitors below
rematerialise what it removed in the same run. Guarded: absent in the bootstrap sandbox.
```

## comment:30

Above `if (Get-Command Build-AdrIndex -ErrorAction Ignore) {`, written with `#`.

```text
Keep the generated ADR pages current (Catzc.Base.Docs): [index](/docs/adr/index.md) from adrs.yml and
[glossary](/docs/adr/glossary.md) from the glossary sources — committed so GitHub has them, rebuilt BEFORE
Build-Readme (the docs/adr README is generated from the index). See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:31

Above `if (Get-Command Build-ContractReference -ErrorAction Ignore) {`, written with `#`.

```text
Keep the generated contract pages current (Catzc.Base.Contracts): docs/references/contracts/<unit>.md from the
contract assets' header comments — committed so GitHub has them. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:32

Above `if (Get-Command Build-Readme -ErrorAction Ignore) {`, written with `#`.

```text
Keep the generated README copy-ins current (Catzc.Base.Docs). Fast no-op when nothing changed — Build-Readme
rewrites a README only when its composed content differs (compared EOL-insensitively), so a clean tree costs
only a few small file reads. Guarded: absent in the bootstrap sandbox, like Clear-ModuleTypeCache.
```

## comment:33

Above `if (Get-Command Build-GitKeep -ErrorAction Ignore) {`, written with `#`.

```text
Keep the managed .gitkeep files current (Catzc.Base.Docs). Every .gitkeep is a committed copy of the
one shared template, pointing at its folder's generated README — reproduced here so a template change
propagates, and a fast no-op on a clean tree. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:34

Above `if (Get-Command Build-TerminologyDictionary -ErrorAction Ignore) {`, written with `#`.

```text
Keep the generated cspell dictionaries current (Catzc.Base.QualityGates). They are derived from
configs/terminology.yml — gitignored, not committed — so the registry is the single source of truth and
cspell still resolves them at fixed paths. Fast no-op when nothing changed (writes only on drift).
```

## comment:35

Above `if (Get-Command Build-RootConfig -ErrorAction Ignore) {`, written with `#`.

```text
Keep the managed root config files current (Catzc.Base.RootConfig). Every opted-in root file is
reproduced from its single in-repo source of truth — an authored source copied out with a generated-file
header (e.g. the root PSScriptAnalyzerSettings.psd1 from .internal/assets), or a generator's rendered
output (e.g. New-Importer for importer.ps1). Rewrites only on drift, so a clean tree is a fast no-op.
Guarded: absent in the bootstrap sandbox. See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```

## comment:36

Above `if (Get-Command Sync-SessionTools -ErrorAction Ignore) {`, written with `#`.

```text
Reconcile the session PATH to whatever tools are actually present — including tools installed outside the
installer layer (e.g. nvm-managed node) — and report any running from a non-owned location on one line.
Session-only, self-skips in CI. The importer is dot-sourced, so its PATH nudges land in the caller's live
session. The janitor announces each nudge like any function, but at every shell open the same nudges are part
of the load record ([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)):
the importer's -Verbose decides whether they are shown, so a plain import prints only the Loaded line. The
quieting is the session-wide information preference, restored in the finally
([ADR-PWSH-ANNOUNCE#9](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce9)): a common parameter
would reach only the janitor's own scope, not the writer chokepoint in Catzc.Base.Writers. Guarded: absent in
the bootstrap sandbox (Catzc.Tooling.Core).
```

## comment:37

Above `[CmdletBinding()]` (occurrence 8), written with `#`.

```text
.SYNOPSIS
    Writes one -DiagnoseLoadTime stage line: the milliseconds since the previous stage, then restarts the clock.
.DESCRIPTION
    A call before the clock exists starts it instead of throwing on the unset variable.
    [comment:40](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment40)
.PARAMETER Step
    The stage just finished.
```

## comment:38

Above `$scanMs = [int](($global:__CatzcLoadTimings | Measure-Object ReadMs -Sum).Sum)`, written with `#`.

```text
raw-read is a pure [IO.File]::ReadAllText of every .ps1 BEFORE Import-Module, so it isolates the cold
file-READ I/O (disk / network share / antivirus-on-read) from the parse. It is warm-cached after the
first access — small here does NOT mean "no AV": an AV that scans on script *parse* (AMSI) is not a
read, so that cost lands in parse/compile below, not here. Don't read this as "antivirus time".
```

## comment:39

Above `$top = $global:__CatzcLoadTimings | Sort-Object Ms -Descending |...`, written with `#`.

```text
The native C# type compile/load (every module's types/*.cs via Import-CSharpTypes) appears as one
'types (combined)' row below; a 'compile+load' row is a cold cache (Roslyn), a 'cache load' row reused
the committed automation/.compiled DLL.
```
