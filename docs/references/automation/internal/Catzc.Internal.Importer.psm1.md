# automation/.internal/Catzc.Internal.Importer.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`.

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

Section `.DESCRIPTION` of the comment-based help.

```text
Called by the generated importer.ps1 shim, which carries the same public switch block and sets
$env:RepositoryRoot first. Loads the .internal shared modules, the vendored dependencies, and every
automation module, then runs the post-import janitors and removes the transient bootstrap. Its parameter
block is asserted to match importer.ps1 (New-Importer generates the shim from it).
```

## comment:3

Section `.PARAMETER CleanClone` of the comment-based help.

```text
Opt IN to a whitelisted deep clean as the janitor run's first step: Reset-GitCleanFxd deletes only
the auto-controlled generated artifacts a `git clean -fxd` would remove (managed root configs,
module manifests, generated READMEs, cspell dictionaries, out/, IDE bin/obj) and keeps — reported — any
untracked file that is not the automation's to delete. The regenerating janitors that follow
rematerialise what it removed, so one -CleanClone import leaves a pristine, fully-generated clone
(the module manifests reappear on the next import, exactly as on a fresh clone). Ignored under
-SkipJanitors.
```

## comment:4

Section `.PARAMETER Bundle` of the comment-based help.

```text
Load as an installed bundle rather than the mono repo: honour the pre-set $env:CatzcModulesRoot (the
bundle's own automation/, set by its Catzc.psm1) instead of deriving it from RepositoryRoot, and force
-SkipJanitors. Only the bundle bootstrap passes it; the mono shim never does.
```

## comment:5

Above `[switch] $ClearCompiledTypes,`.

```text
Delete every compiled C# type DLL before importing, so each type is rebuilt from source rather than
loaded from its committed/cached assembly. Use it to build from source (e.g. verify a clean rebuild).
```

## comment:6

Above `[switch] $SkipJanitors,`.

```text
Skip the post-import janitors (Clear-ModuleTypeCache, Build-Readme, Build-TerminologyDictionary,
Build-RootConfig) and the PSModulePath check — a lean/optimized load for a copied subset
(Test-InIsolation). Type loading still fast-paths on the committed .compiled DLL; only the tail
maintenance is skipped.
```

## comment:7

Above `[switch] $CleanClone,`.

```text
Opt IN to a whitelisted deep clean as the janitor run's first step (Reset-GitCleanFxd): delete
only the auto-controlled generated artifacts, keep and report everything else, and let the
regenerating janitors below rematerialise the tree.
```

## comment:8

Above `[switch] $Bundle`.

```text
Load as an installed bundle, not the mono repo. Honour the pre-set $env:CatzcModulesRoot (the bundle's
own automation/, set by its Catzc.psm1) instead of deriving it from RepositoryRoot, and force
-SkipJanitors (a bundle is a read-only install with no git work tree). Only the bundle bootstrap passes
this; the mono shim never does, so an inherited CatzcModulesRoot can never divert a mono/fixture load.
```

## comment:9

Above `if ($PSVersionTable.PSVersion -lt [version]'7.4') {`.

```text
Hard floor: the toolset requires PowerShell 7.4+. Among other things the vendor functions
(Catzc.Base.Vendor) use the bundled Microsoft.PowerShell.PSResourceGet, first shipped in 7.4.
```

## comment:10

Above `$stack = Get-PSCallStack`.

```text
Detect a direct console session vs a load from within a script. The overlay runs one call below the
generated importer.ps1 shim, so the stack is [0] Invoke-Importer, [1] importer.ps1, [2] the shim's caller.
An empty ScriptName at [2] means importer.ps1 was dot-sourced with no calling script (a console session).
This reproduces the shim's own `-not $MyInvocation.ScriptName` from inside the module.
```

## comment:11

Above `$importSw = [Diagnostics.Stopwatch]::new()`.

```text
Times only the module import (vendor + automation modules), so the console load line can split it from
the session initializer/finalizer around it (session setup and internal modules before, janitors after).
```

## comment:12

Above `$showStateChanges = $VerbosePreference -ne 'SilentlyContinue'`.

```text
-Verbose shows the importer's own state-change record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)). The
dot-sourced shim binds it in the caller's scope, so for the import the session-wide preference is quieted,
restored in the finally below: otherwise every Import-Module would list each function it dot-sources and exports.
```

## comment:13

Above `$outputEncodingChanged = Set-RedirectedOutputEncoding`.

```text
A redirected session writes UTF-8, the encoding the process relays stream, so a captured log is one
encoding; announced with the preferences below.
```

## comment:14

Above `$repoRoot = $env:RepositoryRoot`.

```text
Repository root — the WORKING root (out/, repo-relative paths, git), set on $env by the shim
(importer.ps1 sets $env:RepositoryRoot = $PSScriptRoot). Read it here; working-root readers anchor on it.
```

## comment:15

Above `if ($Bundle -and $env:CatzcModulesRoot) {`.

```text
Catzc code anchor — the automation/ tree that holds the loaded modules; config, type and vendor discovery
follow THIS, not RepositoryRoot (see Get-CatzcModulesRoot). In the mono repo it equals <repoRoot>/automation
and nothing pre-sets it, so it is derived here (a no-op split). An installed bundle's Catzc.psm1 pre-sets it
to the bundle's own automation/, so the importer honours that — this is what makes catzc relocatable.
```

## comment:16

Above `Import-InternalModule Bootstrap -Force`.

```text
The .internal shared-code loader is already imported by the shim (it provides Import-InternalModule).
Load the rest of the shared modules on demand. Bootstrap does the import-time discovery/loading and is
removed at the end; the loader, Types and Vendor stay in the session (NOT removed), so post-import Catzc
cover functions can Import-InternalModule the same shared code and delegate to it. -Force honors the
re-import invalidation boundary (cache ADR), so a devbox re-import picks up edits to a shared module.
```

## comment:17

Above `Write-ImporterMessage ("Session:...`.

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

## comment:18

Above `if ($ClearCompiledTypes) {`.

```text
Discover and import all modules from the catzc code anchor computed above ($modulesRoot).
Optionally wipe compiled type DLLs first so the import below rebuilds them from source.
```

## comment:19

Above `Assert-CatzcRunModeExclusive -ModulesRoot $modulesRoot`.

```text
The two run modes never coexist ([ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)):
Import-AllModules evicted the other mode, and this
proves it before any janitor touches the tree from a mixed session.
```

## comment:20

Above `if (-not $SkipJanitors) {`.

```text
The post-import janitors, in their fixed order (Invoke-ImporterJanitors). An isolated copy and a bundle
(-SkipJanitors) skip the whole chain.
```

## comment:21

Above `if (-not $SkipJanitors -and $IsWindows) {`.

```text
Warn if PSModulePath contains a network share. The permanent fix is a one-time
script that writes a local PSModulePath to the user-scope powershell.config.json.
See: automation/Catzc.Base.Environment/assets/README.md
```

## comment:22

Above `Write-Verbose 'Removing Catzc.Internal.Bootstrap module'`.

```text
Remove the bootstrap, kept until here for Write-ImporterMessage, so its import-time functions do not linger;
the other .internal modules (loader, Types, Vendor) stay loaded.
```

## comment:23

Above `if ($isConsoleSession) {`.

```text
Console session: load timer, split into the module import and the session initializer/finalizer around it.
In scripts, authors add `trap { Write-Exception $_; break }` after the importer.
```

## comment:24

Section `.DESCRIPTION` of the comment-based help.

```text
Run at the importer tail in both run modes
([ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)). Every loaded module named 'Catzc' or
'Catzc.*' — the Catzc.Internal.* loader modules included, vendored third-party modules excluded by name —
must have its ModuleBase under the active CatzcModulesRoot (Get-ForeignCatzcModule, the same predicate the
eviction sweep uses). A violation names every offending module with its ModuleBase, the active root, and
the other root(s) the offenders came from. Internal to the importer overlay: it needs the transient
bootstrap, which is still loaded at this point.
```

## comment:25

Section `.DESCRIPTION` of the comment-based help.

```text
A consumer changes a built bundle only through the overlay in its working root
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). Its function overrides apply once every
bundled module has loaded and been proven exclusive, after the whole overlay is checked (Import-CatzcOverlay,
Catzc.Base.Overlay). A bundle that does not carry the overlay module cannot apply them, so the load stops
rather than run with the consumer's overlay silently ignored. Without an overlay this does nothing.
```

## comment:26

Section `.DESCRIPTION` of the comment-based help.

```text
When the session's standard output goes to a file or a pipe, the host encodes everything it writes with
[Console]::OutputEncoding — the OEM codepage on Windows — while the process relays (CliRunner, PesterRunner)
stream UTF-8, so one captured log mixed two encodings and the box drawing came out mangled. An interactive
console writes Unicode directly and is left as it is. Returns $true when it changed the encoding, so the
caller announces it on the importer's load record
([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)
names this as the one console property the toolset assigns).
```

## comment:27

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the $global:__CatzcLoadTimings collector Invoke-Importer creates under -DiagnoseLoadTime and the Bootstrap
loaders append to. Internal to the importer overlay: it writes through the transient bootstrap's
Write-ImporterMessage, which is still loaded at this point.
```

## comment:28

Section `.DESCRIPTION` of the comment-based help.

```text
-Silent unless -ShowReport (the importer passes its -Verbose); CI self-skips inside Clear-ModuleTypeCache. A
superseded build it cannot delete (held outside catzc) becomes one red line, never a failed load. Holders are
stopped in a person's session only — never an agent's, never CI's (Get-SessionActor,
[ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)). A no-op when
Clear-ModuleTypeCache is absent (the bootstrap sandbox).
```

## comment:29

Section `.DESCRIPTION` of the comment-based help.

```text
Build-BashTimeoutHook is a no-op while the published hook matches its source
([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). The hook is
agent tooling, so a pipeline skips it; a checkout without the hook's code (a bundle) or without dotnet yet is
told, never stopped — Install-Dotnet itself needs this import to succeed. A failed publish is one red line.
A no-op when Build-BashTimeoutHook is absent (the bootstrap sandbox).
```

## comment:30

Section `.DESCRIPTION` of the comment-based help.

```text
The tail maintenance of a mono-repo import: the opt-in deep clean first (-CleanClone), then the type-cache
janitor, the generated ADR, glossary, contract, README, .gitkeep, dictionary and root-config files, the session
PATH, the agent hook, and last the commit of the generated files the importer maintains. Every janitor is a
fast no-op on a clean tree and guarded by presence, so the bootstrap sandbox runs the subset it has. The
caller skips the whole chain under -SkipJanitors (an isolated copy, a bundle).
```

## comment:31

Above `if ($CleanClone -and (Get-Command Reset-GitCleanFxd -ErrorAction Ignore)) {`.

```text
Opt-in deep clean (-CleanClone): the whitelisted git clean -fxd (Reset-GitCleanFxd) deletes only the
auto-controlled generated artifacts and keeps — reported — any untracked file that is not the
automation's to delete. Deliberately the FIRST janitor, so the regenerating janitors below
rematerialise what it removed in the same run. Guarded: absent in the bootstrap sandbox.
```

## comment:32

Above `if (Get-Command Build-AdrIndex -ErrorAction Ignore) {`.

```text
Keep the generated ADR pages current (Catzc.Base.Docs): [index](/docs/adr/index.md) from adrs.yml and
[glossary](/docs/adr/glossary.md) from the glossary sources — committed so GitHub has them, rebuilt BEFORE
Build-Readme (the docs/adr README is generated from the index). See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:33

Above `if (Get-Command Build-ContractReference -ErrorAction Ignore) {`.

```text
Keep the generated contract pages current (Catzc.Base.Contracts): docs/references/contracts/<unit>.md from the
contract assets' header comments — committed so GitHub has them. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:34

Above `if (Get-Command Build-Readme -ErrorAction Ignore) {`.

```text
Keep the generated README copy-ins current (Catzc.Base.Docs). Fast no-op when nothing changed — Build-Readme
rewrites a README only when its composed content differs (compared EOL-insensitively), so a clean tree costs
only a few small file reads. Guarded: absent in the bootstrap sandbox, like Clear-ModuleTypeCache.
```

## comment:35

Above `if (Get-Command Build-GitKeep -ErrorAction Ignore) {`.

```text
Keep the managed .gitkeep files current (Catzc.Base.Docs). Every .gitkeep is a committed copy of the
one shared template, pointing at its folder's generated README — reproduced here so a template change
propagates, and a fast no-op on a clean tree. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:36

Above `if (Get-Command Build-TerminologyDictionary -ErrorAction Ignore) {`.

```text
Keep the generated cspell dictionaries current (Catzc.Base.QualityGates). They are derived from
configs/terminology.yml — gitignored, not committed — so the registry is the single source of truth and
cspell still resolves them at fixed paths. Fast no-op when nothing changed (writes only on drift).
```

## comment:37

Above `if (Get-Command Build-RootConfig -ErrorAction Ignore) {`.

```text
Keep the managed root config files current (Catzc.Base.RootConfig). Every opted-in root file is
reproduced from its single in-repo source of truth — an authored source copied out with a generated-file
header (e.g. the root PSScriptAnalyzerSettings.psd1 from .internal/assets), or a generator's rendered
output (e.g. New-Importer for importer.ps1). Rewrites only on drift, so a clean tree is a fast no-op.
Guarded: absent in the bootstrap sandbox. See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```

## comment:38

Above `if (Get-Command Sync-SessionTools -ErrorAction Ignore) {`.

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

## comment:39

Above `if ((Get-Command Sync-GeneratedFile -ErrorAction Ignore) -and...`.

```text
Commit the generated files the importer maintains (automation/.compiled/) — who is running decides
([ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)): a person's session
commits, an agent's announces what changed and leaves the commit to the person, a test-run snapshot never
commits, and a pipeline is not even asked, so CI imports stay silent. Deliberately the LAST janitor, so
tracked files the janitors above touch (the .compiled DLL swap) are in their final state.
Guarded: absent in the bootstrap sandbox.
```

## comment:40

Section `.DESCRIPTION` of the comment-based help.

```text
Internal to the importer overlay, called only under -DiagnoseLoadTime, which starts $script:diagSw. The slot
is probed strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)), so a
call before the clock exists starts it instead of throwing on the unset variable.
```

## comment:41

Above `$scanMs = [int](($global:__CatzcLoadTimings | Measure-Object ReadMs -Sum).Sum)`.

```text
raw-read is a pure [IO.File]::ReadAllText of every .ps1 BEFORE Import-Module, so it isolates the cold
file-READ I/O (disk / network share / antivirus-on-read) from the parse. It is warm-cached after the
first access — small here does NOT mean "no AV": an AV that scans on script *parse* (AMSI) is not a
read, so that cost lands in parse/compile below, not here. Don't read this as "antivirus time".
```

## comment:42

Above `$top = $global:__CatzcLoadTimings | Sort-Object Ms -Descending |...`.

```text
The native C# type compile/load (every module's types/*.cs via Import-CSharpTypes) appears as one
'types (combined)' row below; a 'compile+load' row is a cold cache (Roslyn), a 'cache load' row reused
the committed automation/.compiled DLL.
```
