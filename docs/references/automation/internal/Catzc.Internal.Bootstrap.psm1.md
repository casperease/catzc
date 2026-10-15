# automation/.internal/Catzc.Internal.Bootstrap.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The importer and its .internal bootstrap run before the module system (and Write-Message) are available,
so this is their writer chokepoint: the bootstrap's counterpart of Write-InformationColored, and like it the
one place besides it that may call Write-Information
([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)). It
prepends '[Importer.ps1] ' so
importer output reads consistently with the rest of the toolset's '[Caller] ...' messages, carries the
colour as embedded ANSI, and is silent during a Pester run ($global:__PesterRunning), exactly as the Writers
chokepoint is. .internal code only ever runs from the importer. An empty message writes a blank line.

A -StateChange line is one of the importer's own load announcements, which go to the verbose stream instead
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)): shown
when the import runs with -Verbose (Set-ImporterVerbosity), silent otherwise.
```

## comment:2

Above `$script:importerVerbose = $false`.

```text
Whether Write-ImporterMessage -StateChange lines are shown. Module state, so it lives exactly as long as the
bootstrap: a fresh import starts it at $false and the importer's teardown removes it with the module.
```

## comment:3

Section `.DESCRIPTION` of the comment-based help.

```text
-Verbose on the importer sets $VerbosePreference only in Invoke-Importer's own scope; the bootstrap and vendor
module functions that announce the load do not inherit it. Invoke-Importer hands the setting over here once,
and Write-ImporterMessage reads it for every -StateChange line.
```

## comment:4

Section `.DESCRIPTION` of the comment-based help.

```text
Removes every <ModulesRoot>/.compiled/*.dll (the single combined types assembly). Run by the importer's
-ClearCompiledTypes switch BEFORE modules load, so Import-CSharpTypes finds no cached DLL and compiles all
modules' types fresh from source — "build from source", not "trust the committed/cached DLL".

Distinct from Catzc.Base.TypesSystem's Clear-ModuleTypeCache: that is a post-import janitor that KEEPS the
current build and skips in CI; this wipes every build (current included) pre-import and runs in any
context. Best-effort: a DLL still locked (a loaded build on Windows, a concurrent process) is
skipped — never stalls.
```

## comment:5

Section `.DESCRIPTION` of the comment-based help.

```text
By default the manifest is derived from the module folder: private/*.ps1 then root *.ps1 (each group
ordinal-sorted, forward-slashed) become the file list in PrivateData.CatzcFiles, its one NestedModule is the shared
loader .internal/assets/Import-ModuleFiles.ps1 (which parses each listed file in memory and dot-sources it into the
module's session state — far cheaper than one nested script file per function), and the root *.ps1 basenames
become FunctionsToExport. A caller
whose module is not one-function-per-file on disk — a built module whose functions are merged into one
<Module>.ps1 — passes both lists explicitly with -NestedModule and -FunctionToExport instead; the folder is
then not enumerated. Either way the text comes from the one canonical emitter (Get-DynamicManifestContent)
and is written only on drift.
```

## comment:6

Above `[switch]$ReadOnly,`.

```text
Read-only load (a bundle): never generate or write the manifest — it must already be present
(Build-Modules pre-generates every module's manifest), so a read-only install store is never written to.
```

## comment:7

Above `$privateRelative = [string[]] @(foreach ($f in $privateFiles) {`.

```text
The shared loader (the manifest's one NestedModule) dot-sources each listed .ps1 into the module's session
state, in list order. Private functions group first, then public; each group is ordinal-sorted and its paths
use forward slashes, so the emitted manifest is byte-identical on every platform and every build of the same
commit.
```

## comment:8

Above `$content = Get-DynamicManifestContent -NestedModule $script:moduleFilesLoader...`.

```text
Canonical, formatter-stable text — no hand-padded alignment
([ADR-REPO-FORMAT#1](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format1)); the L2 tests guard the
invariant.
```

## comment:9

Above `$script:moduleFilesLoader = '../.internal/assets/Import-ModuleFiles.ps1'`.

```text
The shared loader every derived manifest names as its one NestedModule, relative to the module folder: a module
folder sits directly under the modules root, beside .internal.
```

## comment:10

Section `.DESCRIPTION` of the comment-based help.

```text
The janitors' write-on-drift pattern: the manifest is a pure derivation, so an unchanged module yields
identical bytes and the write is skipped. Beyond saving ~40 writes per import, this is what lets
Test-Automation's parallel workers dot-source the importer concurrently — the parent's own import
regenerated every manifest just before spawning, so the workers all compare-equal and none writes, and
there is no cross-process race on the .psd1 files. UTF-8 without BOM.
```

## comment:11

Section `.DESCRIPTION` of the comment-based help.

```text
The manifest is generated on every import, so it is canonical by construction: the '=' column is computed
from the longest key rather than hand-padded
([ADR-REPO-FORMAT#1](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format1)), the text uses LF
endings with a trailing newline,
and it is formatter-stable — running Invoke-Formatter over it is a no-op (guarded by the L2 tests). Callers
pass ordinal-sorted, forward-slashed inputs, so the bytes are identical on every platform and every build
of a commit. -ModuleFile, when given, renders as PrivateData = @{ CatzcFiles = @(...) }: the files the shared
loader (Import-ModuleFiles.ps1) dot-sources, in that order.
```

## comment:12

Above `$fields = [ordered]@{`.

```text
Ordered fields with their value literals. The '=' column width is derived from the longest key, so a new
field re-aligns automatically and no alignment is maintained by hand
([ADR-REPO-FORMAT#1](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format1)).
```

## comment:13

Section `.DESCRIPTION` of the comment-based help.

```text
Autoloads all modules' types/ folders as a SINGLE assembly (automation/.compiled/Catzc.Types.<hash>.dll),
so a type in one module can reference a type in another — a shared base class, a layered record graph.
Each .cs file is named for the BARE type it must produce and declares the file-scoped namespace of its
module ("namespace <module>;"), maintained by Format-Types and checked by Test-Formatting. The loader compiles the
sources AS AUTHORED (Add-Type -Path, one compilation unit per file, so each file's file-scoped namespace is
legal) and derives the expected type as <module>.<filename>: types/CliRunner.cs in module Catzc.Base.Execution
-> type Catzc.Base.Execution.CliRunner. The loader requires each source's declared namespace to match its
module folder (the same invariant Test-Formatting enforces) and identifies the type from the filename.

Because everything is ONE assembly, there are NO cross-ASSEMBLY references — only cross-NAMESPACE
references inside it, which the compiler and CLR resolve unconditionally. The combined assembly is a leaf
in the assembly-reference graph (nothing references it by assembly identity; PowerShell resolves
[Namespace.Type] by FQN), so the Roslyn-assigned random assembly name is irrelevant and Add-Type stays the
compiler. The module dependency graph is NOT enforced by the compiler here — it is policed by
Get-CSharpTypeDependency / Test-ModuleDependency in the L1 integrity tests.

The assembly is committed as automation/.compiled/Catzc.Types.<combinedHash8>.dll (deterministic per the
combined source hash, like .vendor) so a fresh checkout and CI load it without invoking Roslyn. The
combined hash folds in each file's MODULE and bare type name (not just content), so moving a .cs between
modules (new namespace) or renaming it (new type) re-keys the assembly even when the content is identical.
States:

  1. A type already in the AppDomain (types survive module reimport) -> compare the combined source hash to
     what was recorded for this root; a change throws in a pipeline and warns on a devbox (restart
     required), otherwise it is a no-op.
  2. Loaded on behalf of a DIFFERENT root (the other run mode) -> compare the per-file digests of every type
     this root needs to the root that recorded them. All equal reuses the loaded types and records this
     root; a changed digest or a needed type missing from the AppDomain takes the contract of state 1,
     naming both roots.
  3. Not loaded -> load the cached DLL if its hash matches, else compile all sources to the hash-named DLL
     (Build-CombinedTypeAssembly — Roslyn, once per combined hash) and load it. Then verify EVERY expected
     type resolved, else throw.

Runs once from Bootstrap (not a Catzc module) as a pre-pass before any module's functions import.
```

## comment:14

Above `[switch]$PrebuiltOnly`.

```text
Prebuilt-only load (a bundle): load the shipped combined-types assembly, and throw if it is absent —
never invoke Roslyn and never write. A bundle ships the DLL, so a read-only install never compiles.
```

## comment:15

Above `Import-InternalModule Types`.

```text
The enumeration, deterministic ordering, per-file EOL-insensitive digest, combined hash, and per-file
snapshot all come from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared module)
that the janitor (Clear-ModuleTypeCache) also calls — so the committed Catzc.Types.<hash>.dll key can never
drift between loader and janitor. The importer loads Catzc.Internal.Types before this pre-pass; the
Import-InternalModule call is a no-op guard that keeps this callable if the module was unloaded.
```

## comment:16

Above `$arr = [object[]]@(foreach ($file in $hashResult.Files) {`.

```text
Validate each source and derive its FQN (<module>.<filename>). These two poka-yokes are the loader's job,
deliberately NOT in the shared enumerator (the janitor must never throw on a source that is wrong): a
dotted filename (the old fully-qualified style) is rejected, and a file whose declared file-scoped namespace
does not match its module folder (or is missing/block-scoped) is rejected — the same invariant
Test-Formatting enforces, checked here at load; Format-Types repairs all of them. The source list is already
ordinally sorted.
```

## comment:17

Above `if (-not (Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly...`.

```text
A loaded assembly cannot be reloaded. Whether the types in this process are current for THIS ModulesRoot is
measured in one place, Get-LoadedTypeDrift (Catzc.Internal.Types), which the public
Test-LoadedTypesCurrent / Assert-LoadedTypesCurrent pair and the importer's restart read too. The session
record is keyed by ModulesRoot, so loading a different tree (e.g. a test-fixture root) records its own
hash/snapshot and never poisons the real tree's guard; a root with no record of its own is compared per file
against the root that loaded the types (cross-root). The message names which files drifted and both hashes or
roots, so the cause is diagnosable from the error text alone (a pure CRLF/LF flip never drifts — the digests
strip CR).
```

## comment:18

Above `if ((Test-IsRunningInPipeline) -or $typeState.MissingTypes.Count) {`.

```text
A loaded assembly cannot be swapped in the AppDomain. In a pipeline a stale-types load is a HARD
failure (CI must never run on old types). On a devbox, a type the AppDomain lacks (added, or not
loaded cross-root) is a hard failure too — the code that uses it is certain to fail later, far from
here. A changed or removed type degrades gracefully — keep the already-loaded types this session,
warn (orange), and return WITHOUT recording the new hash, so the warning repeats on every re-import
until you restart. Every devbox session, a person's included, takes this path
([ADR-AUTO-TYPES#15](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types15)): one
yellow line naming the changed types by simple name, and the import goes on.
```

## comment:19

Above `$didCompile = $false`.

```text
Ensure the committed, hash-keyed DLL exists on disk — recompile if missing (deleted, git-cleaned, or a
source never built). -OutputAssembly writes the file WITHOUT loading, so this restores the artifact even
when the types are already in the AppDomain (idempotent, self-healing re-import).
```

## comment:20

Above `$built = Build-CombinedTypeAssembly -AutomationRoot $ModulesRoot...`.

```text
The ONE compile path (Build-CombinedTypeAssembly in Catzc.Internal.Types, shared with a build): it
compiles the sources, once validated, to a temp file and moves it into place, so a concurrent import
never sees a half-written DLL. It re-derives the hash from disk, so a source edited mid-import is a
throw, never a DLL whose name keys a set of sources other than the ones validated above.
```

## comment:21

Above `foreach ($old in [System.IO.Directory]::EnumerateFiles($compiledDir,...`.

```text
Prune superseded-hash builds — the .compiled dir's old Catzc.Types.*.dll. Best-effort: a DLL still
locked (the live build on Windows, or a concurrent process) is skipped, never fails the import.
```

## comment:22

Above `$relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll))...`.

```text
Announce the real build (a freshly created, committable artifact) — always, not only under
-DiagnoseLoadTime. .internal (bootstrap) code only ever runs from the importer, so output goes
through Write-ImporterMessage like the rest of bootstrap (Write-Message may not be loaded yet).
```

## comment:23

Above `if (-not $loaded) {`.

```text
Load the assembly if not already in the AppDomain (a reimport keeps the live copy). Verify EVERY type.
Loading a binary into the session is a state change, so it is announced
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)) on the
importer's verbose record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)), naming
the DLL; a reimport that keeps the live copy loads
nothing and says nothing. The load goes through a per-user shadow copy (Import-TypesAssembly), never the
.compiled file itself, so no session ever locks a build inside the repository; the message names the
committed DLL, the artifact a reader recognizes.
```

## comment:24

Above `$aliasAttrType =...`.

```text
Publish [PSTypeAlias("Name")] accelerators from the freshly loaded types, so `[Name]` resolves to the
decorated type (e.g. [Catzc.Module.Depm]::Puml). This is registration only — Add-Type above stays the
sole compiler; the editor-facing MSBuild pathway is Invoke-BuildForVSCode. The alias literal lives in
the decorated types/*.cs, so a workspace search for it lands on the source. Idempotent
(Remove-then-Add) so a re-import never throws on a duplicate key; the Catzc.-namespaced names mean this
only ever reclaims our own accelerator, never another module's.
```

## comment:25

Above `$displayAttrType =...`.

```text
Publish [ConsoleDisplay(...)] identity properties as each type's DefaultDisplayPropertySet, so typing
`$x` at the prompt shows those columns instead of every property. The same attribute narrows the type's
ToString (ConsoleText). Formatting honours ETS type data, where interpolation does not, so this half is
registered here and the text half is the C# override. -Force makes a re-registration idempotent.
```

## comment:26

Section `.DESCRIPTION` of the comment-based help.

```text
PowerShell does NOT error on a command-name clash — the command imported last silently shadows the rest.
This pre-pass turns that silent collision into a fast, loud failure before any module (or C# type) loads.
It catches two cases and collects all of them into one error:

1. Two automation modules exporting the same name — a caller of Get-Foo would get whichever module sorted
   last.
2. An automation function whose name would shadow an already-imported shipped command. Vendored modules and
   built-ins load before our modules, so a clash means our -Scope Global import silently overrides them.
   The check is scoped to shipped commands by module path (under .vendor/ or $PSHOME), so a user's
   unrelated session module never blocks the import and our own modules are naturally excluded.

The checked set mirrors New-DynamicManifest's exports: module-root *.ps1 are always exported; private/*.ps1
join the set only under -ExportPrivates (which exports '*'). Without the flag, two modules each owning a
private of the same name is legal (privates are module-scoped, not exported) and is not a collision.
```

## comment:27

Above `$shipped = @{}`.

```text
2) An automation function shadowing an already-imported SHIPPED command (vendored module or built-in).
   Vendor modules and built-ins import before our modules, so a name clash means our -Scope Global import
   would silently shadow them. Scope the check to shipped commands by module path — under .vendor/ or
   $PSHOME — so a user's unrelated session module never blocks the import, and our own modules (current
   or stale on a devbox re-import) are naturally excluded (their base is neither).
```

## comment:28

Above `$isShipped = ($base -like "$PSHOME*") -or ($base -match '[\\/]\.vendor[\\/]')...`.

```text
Shipped = a command that loads BEFORE our automation modules and would be silently shadowed by our
-Scope Global import: built-ins ($PSHOME), vendored third-party (.vendor), and the .internal shared
modules (loaded by the importer before this check). The .internal modules sit directly in the folder,
so their ModuleBase ENDS at .internal (no trailing separator) — match that too.
```

## comment:29

Section `.DESCRIPTION` of the comment-based help.

```text
A catzc module is one named 'Catzc' (the package module) or 'Catzc.*'. It belongs to a root when its
ModuleBase is that root or lies under it; the package module also belongs when its ModuleBase is the
root's parent (a package whose code root is its automation/ subfolder). Paths compare as normalized full
paths, case-insensitively, as Get-CatzcRunMode does. Vendored third-party modules never carry a catzc name,
so the name filter alone keeps them out — Import-VendorModules owns their reload. The single predicate
behind both the run-mode eviction (Import-AllModules) and the exclusivity assert (Invoke-Importer's tail).
```

## comment:30

Section `.DESCRIPTION` of the comment-based help.

```text
Before anything loads it evicts the other run mode
([ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)): every catzc module loaded from a
different root is removed, and a Catzc.Internal.* module from a different root is re-imported from this
root's .internal (Import-InternalModule -Force semantics, anchored at this root). The running importer
modules (Importer, Bootstrap) are never touched mid-load; the shims import them from the active root by
construction, and Invoke-Importer's exclusivity assert reports any that are not.
```

## comment:31

Above `[switch]$DiagnoseLoadTime,`.

```text
Emit a per-module load-time breakdown: manifest generation, a raw-read probe (cold file I/O), and
Import-Module (parse). Surfaced by importer.ps1 -DiagnoseLoadTime so an author can see WHICH
module(s) are slow and whether the cost is file I/O (raw-read column) or parse (import column);
manifest enumeration is native .NET and consistently ~1-7ms. Off = no overhead.
```

## comment:32

Above `[switch]$Bundle`.

```text
Read-only bundle load: manifests must be pre-generated (never written), and the combined-types DLL
must be shipped (never compiled). Passed by Invoke-Importer -Bundle; off for the mono repo.
```

## comment:33

Above `Assert-UniqueModuleFunctionName -ModuleDirs $moduleDirs...`.

```text
Fail fast on duplicate exported function names BEFORE any module or C# type loads — a collision would
otherwise be silent (the module imported last shadows the others).
```

## comment:34

Above `$stale = @(Get-Module |`.

```text
Remove previously loaded automation modules (handles deleted/renamed modules). Exclude Bootstrap, the
vendored third-party modules (.vendor), and the .internal shared modules — the last are loaded by the
importer before this runs and must SURVIVE into the session (Import-CSharpTypes and post-import cover
functions call them); they live under the automation root, so without this they match the stale sweep.
```

## comment:35

Above `$rootInternal =...`.

```text
Evict the other run mode: a catzc module loaded from a different root (a build when loading the source
tree, or the reverse) is removed, taking its script scope — and every $script: cache — with it. Removal is
by module INSTANCE (-ModuleInfo), never by name: Import-Module -Force of a same-named module from another
path loads a second instance beside the first, so the shim's own imports of this root's Loader, Importer,
Bootstrap, Types and Vendor leave the other root's instances in the module table, and removing just those
keeps this root's commands intact. A Catzc.Internal.* module this root has not loaded yet (an on-demand
one, e.g. TestKit) is re-imported from THIS root's .internal by path (Import-InternalModule -Force
semantics, anchored here — the loader itself may be the foreign one). The running importer modules are
never removed unless this root's instance is the one running. Removal tolerates a module already gone
with its parent; Invoke-Importer's exclusivity assert (after the load) proves nothing foreign survived.
```

## comment:36

Above `Import-CSharpTypes -ModulesRoot $ModulesRoot...`.

```text
Native C# types (every module's types/*.cs) compile/load ONCE, before any module's functions, into a
single combined assembly — so a function (or a module's load-time code) can reference any type, and a
type in one module can reference a type in another. Module import order below is therefore irrelevant.
```

## comment:37

Above `$readMs = 0`.

```text
Diagnostic probe: read every .ps1 this module imports, raw, BEFORE Import-Module. This pays
the cold per-file *open* cost — the part an antivirus real-time scan or a network share
intercepts — so the Import-Module that follows reads from warm OS cache and its time is ≈ pure
parse/compile. Splitting them is the point: raw-read = I/O cost, import = parse cost. Only the
set Import-Module will load (root + private .ps1, no tests), so the warming is representative.
```

## comment:38

Above `. $importedModule { Set-StrictMode -Version Latest }`.

```text
A session-level Set-StrictMode does not reach module code, so strict mode is set in each module's own
script scope, which every function in the module inherits
([ADR-PWSH-ERROR](/docs/adr/pwsh/error-handling.md)).
```

## comment:39

Above `$summary = "Loaded $($imported.Count) modules from '$ModulesRoot'"`.

```text
Loading and unloading modules changes the session, so it is announced
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)) on the
importer's
verbose record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)): one
line names
the load, plus any module that left the session for good — evicted from another root, or gone from the tree.
A re-import's remove-then-reload of the same modules is not a departure and is not listed.
```
