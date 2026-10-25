# pwsh/.internal/Catzc.Internal.Bootstrap.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:4

Above `function Clear-CompiledType {`, written with `#`.

```text
.SYNOPSIS
    Deletes the compiled C# type assembly so the next import rebuilds it from source.
.DESCRIPTION
    Unlike Clear-ModuleTypeCache it wipes every build before import in any context, skipping only locked DLLs.
    [comment:4](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment4)
.PARAMETER ModulesRoot
    Path to the modules folder (the parent of .compiled/).
```

## comment:5

Above `function New-DynamicManifest {`, written with `#`.

```text
.SYNOPSIS
    Writes a module's generated <Module>.psd1 and returns its path.
.DESCRIPTION
    A caller whose module is not one function per file passes both lists explicitly, and the folder is not enumerated.
    [comment:5](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment5)
.PARAMETER ModulePath
    The module folder; the manifest is <ModulePath>/<leaf>.psd1.
.PARAMETER ExportPrivates
    Export every function ('*'), so tests can reach privates.
.PARAMETER ReadOnly
    Never write: assert the manifest is already present and return its path.
.PARAMETER NestedModule
    Explicit NestedModules, relative to ModulePath with forward slashes, in load order. Requires -FunctionToExport.
.PARAMETER FunctionToExport
    Explicit FunctionsToExport names. Requires -NestedModule.
```

## comment:6

Above `[switch]$ReadOnly,`, written with `#`.

```text
Read-only load (a bundle): never generate or write the manifest — it must already be present
(Build-Modules pre-generates every module's manifest), so a read-only install store is never written to.
```

## comment:7

Above `$privateRelative = [string[]] @(foreach ($f in $privateFiles) {`, written with `#`.

```text
The shared loader (the manifest's one NestedModule) dot-sources each listed .ps1 into the module's session
state, in list order. Private functions group first, then public; each group is ordinal-sorted and its paths
use forward slashes, so the emitted manifest is byte-identical on every platform and every build of the same
commit.
```

## comment:8

Above `$content = Get-DynamicManifestContent -NestedModule $script:moduleFilesLoader...`, written with `#`.

```text
Canonical, formatter-stable text — no hand-padded alignment
([ADR-REPO-FORMAT-TOOLSFORMAT](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-toolsformat)); the L2 tests guard the
invariant.
```

## comment:9

Above `$script:moduleFilesLoader = '../.internal/assets/Import-ModuleFiles.ps1'`, written with `#`.

```text
The shared loader every derived manifest names as its one NestedModule, relative to the module folder: a module
folder sits directly under the modules root, beside .internal.
```

## comment:10

Above `[CmdletBinding()]` (occurrence 4), written with `#`.

```text
.SYNOPSIS
    Writes rendered manifest text to its .psd1 only when it differs, and returns the path.
.DESCRIPTION
    An unchanged module yields identical bytes and no write, so parallel workers never race on the manifest files.
    [comment:10](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment10)
```

## comment:11

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Renders a module manifest hashtable as canonical .psd1 text.
.DESCRIPTION
    Canonical by construction: the alignment column derives from the longest key and the text is formatter-stable.
    [comment:11](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment11)
```

## comment:12

Above `$fields = [ordered]@{`, written with `#`.

```text
Ordered fields with their value literals. The '=' column width is derived from the longest key, so a new
field re-aligns automatically and no alignment is maintained by hand
([ADR-REPO-FORMAT-TOOLSFORMAT](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-toolsformat)).
```

## comment:13

Above `function Import-CSharpTypes {`, written with `#`.

```text
.SYNOPSIS
    Compiles and loads EVERY module's native C# types (types/*.cs) into ONE hash-keyed assembly.
.DESCRIPTION
    One assembly lets a type in one module reference a type in another; the module graph is policed by tests.
    [comment:13](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment13)
.PARAMETER ModulesRoot
    The modules folder. Its non-dot subfolders are the modules; the assembly is written to its .compiled/.
.PARAMETER DiagnoseLoadTime
    Emit a single combined compile/cache-load timing line (surfaced by importer.ps1 -DiagnoseLoadTime).
.PARAMETER PrebuiltOnly
    A bundle: the prebuilt DLL and manifest must exist, and the run mode for the types-load policy is build.
.PARAMETER HostKind
    console or headless, the host axis of the types-load policy. Only the interactive importer passes console.
```

## comment:14

Above `[switch]$PrebuiltOnly,`, written with `#`.

```text
Prebuilt-only load (a bundle): load the shipped combined-types assembly, and throw if it is absent —
never invoke Roslyn and never write. A bundle ships the DLL, so a read-only install never compiles.
```

## comment:15

Above `Import-InternalModule Types`, written with `#`.

```text
The enumeration, deterministic ordering, per-file EOL-insensitive digest, combined hash, and per-file
snapshot all come from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared module)
that the janitor (Clear-ModuleTypeCache) also calls — so the committed Catzc.Types.<hash>.dll key can never
drift between loader and janitor. The importer loads Catzc.Internal.Types before this pre-pass; the
Import-InternalModule call is a no-op guard that keeps this callable if the module was unloaded.
```

## comment:16

Above `$arr = [object[]]@(foreach ($file in $hashResult.Files) {`, written with `#`.

```text
Validate each source and derive its FQN (<module>.<filename>). These two poka-yokes are the loader's job,
deliberately NOT in the shared enumerator (the janitor must never throw on a source that is wrong): a
dotted filename (the old fully-qualified style) is rejected, and a file whose declared file-scoped namespace
does not match its module folder (or is missing/block-scoped) is rejected — the same invariant
Test-Formatting enforces, checked here at load; Format-Types repairs all of them. The source list is already
ordinally sorted.
```

## comment:17

Above `if (-not (Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly...`, written with `#`.

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

Above `if (Test-IsRunningInPipeline) {`, written with `#`.

```text
A loaded assembly cannot be swapped in the AppDomain. In a pipeline a stale-types load is a HARD
failure (CI must never run on old types). Inside a VS Code terminal nothing throws: the import cannot
restart that host, so the session keeps the loaded assembly whatever drifted and one line names the
loaded hash and the source hash. On any other devbox, a type the AppDomain lacks (added, or not
loaded cross-root) is a hard failure — the code that uses it is certain to fail later, far from
here. A changed or removed type degrades gracefully — keep the already-loaded types this session,
warn (orange), and return WITHOUT recording the new hash, so the warning repeats on every re-import
until you restart. Every devbox session, a person's included, takes this path
([ADR-BCL-TYPES-ONEDRIFTMEASURE](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-onedriftmeasure)): one
yellow line naming the changed types by simple name, and the import goes on.
```

## comment:19

Above `$didCompile = $false`, written with `#`.

```text
Ensure the committed, hash-keyed DLL exists on disk — recompile if missing (deleted, git-cleaned, or a
source never built). -OutputAssembly writes the file WITHOUT loading, so this restores the artifact even
when the types are already in the AppDomain (idempotent, self-healing re-import).
```

## comment:20

Above `$built = Build-CombinedTypeAssembly -ModulesRoot $ModulesRoot...`, written with `#`.

```text
The ONE compile path (Build-CombinedTypeAssembly in Catzc.Internal.Types, shared with a build): it
compiles the sources, once validated, to a temp file and moves it into place, so a concurrent import
never sees a half-written DLL. It re-derives the hash from disk, so a source edited mid-import is a
throw, never a DLL whose name keys a set of sources other than the ones validated above.
```

## comment:21

Above `foreach ($old in [System.IO.Directory]::EnumerateFiles($compiledDir,...`, written with `#`.

```text
Prune superseded-hash builds — the .compiled dir's old Catzc.Types.*.dll. Best-effort: a DLL still
locked (the live build on Windows, or a concurrent process) is skipped, never fails the import.
```

## comment:22

Above `$relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll))...`, written with `#`.

```text
Announce the real build (a freshly created, committable artifact) — always, not only under
-DiagnoseLoadTime. .internal (bootstrap) code only ever runs from the importer, so output goes
through Write-ImporterMessage like the rest of bootstrap (Write-Message may not be loaded yet).
```

## comment:23

Above `$deferred = $false`, written with `#`.

```text
Load the assembly if not already in the AppDomain (a reimport keeps the live copy). Verify EVERY type.
Loading a binary into the session is a state change, so it is announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)) on the
importer's verbose record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)), naming
the DLL; a reimport that keeps the live copy loads
nothing and says nothing. The load goes through a per-user shadow copy (Import-TypesAssembly), never the
.compiled file itself, so no session ever locks a build inside the repository; the message names the
committed DLL, the artifact a reader recognizes.
```

## comment:24

Above `foreach ($result in @(Initialize-Types)) {`, written with `#`.

```text
Publish [PSTypeAlias("Name")] accelerators from the freshly loaded types, so `[Name]` resolves to the
decorated type (e.g. [Catzc.Module.Depm]::Puml). This is registration only — Add-Type above stays the
sole compiler; the editor-facing MSBuild pathway is Invoke-BuildForVsCode. The alias literal lives in
the decorated types/*.cs, so a workspace search for it lands on the source. Idempotent
(Remove-then-Add) so a re-import never throws on a duplicate key; the Catzc.-namespaced names mean this
only ever reclaims our own accelerator, never another module's.
```

## comment:25

Above `function Assert-UniqueModuleFunctionName {`, written with `#`.

```text
.SYNOPSIS
    Fails the import when an exported function name collides — across catzc modules, or with a shipped
    (vendored/built-in) command that is already imported.
.DESCRIPTION
    PowerShell silently lets the last imported command shadow the rest, so this turns a clash into a loud failure.
    [comment:26](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment26)
.PARAMETER ModuleDirs
    The discovered module directories (dot-prefixed infrastructure already excluded).
.PARAMETER ExportPrivates
    When set, private/ functions are exported too, so they join the uniqueness check.
```

## comment:26

Above `$shipped = @{}`, written with `#`.

```text
2) A module function shadowing an already-imported SHIPPED command (vendored module or built-in).
   Vendor modules and built-ins import before our modules, so a name clash means our -Scope Global import
   would silently shadow them. Scope the check to shipped commands by module path — under .vendor/ or
   $PSHOME — so a user's unrelated session module never blocks the import, and our own modules (current
   or stale on a devbox re-import) are naturally excluded (their base is neither).
```

## comment:27

Above `$isShipped = ($base -like "$PSHOME*") -or ($base -match '[\\/]\.vendor[\\/]')...`, written with `#`.

```text
Shipped = a command that loads BEFORE our catzc modules and would be silently shadowed by our
-Scope Global import: built-ins ($PSHOME), vendored third-party (.vendor), and the .internal shared
modules (loaded by the importer before this check). The .internal modules sit directly in the folder,
so their ModuleBase ENDS at .internal (no trailing separator) — match that too.
```

## comment:28

Above `function Get-ForeignCatzcModule {`, written with `#`.

```text
.SYNOPSIS
    Returns every loaded catzc module that does not come from the given code root.
.DESCRIPTION
    The package module also belongs when its ModuleBase is the root's parent, since its code root is pwsh/.
    [comment:29](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment29)
.PARAMETER ModulesRoot
    The active code root (CatzcModulesRoot).
.PARAMETER IncludeInternal
    Include the Catzc.Internal.* loader modules (they belong to a root through its .internal folder).
```

## comment:29

Above `function Import-AllModules {`, written with `#`.

```text
.SYNOPSIS
    Imports all module directories under a given root path.
.DESCRIPTION
    Running importer modules are never touched mid-load; the exclusivity assert reports any that are foreign.
    [comment:30](/docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md#comment30)
.PARAMETER ModulesRoot
    Path to the directory containing module folders.
```

## comment:30

Above `[switch]$DiagnoseLoadTime,` (occurrence 2), written with `#`.

```text
Emit a per-module load-time breakdown: manifest generation, a raw-read probe (cold file I/O), and
Import-Module (parse). Surfaced by importer.ps1 -DiagnoseLoadTime so an author can see WHICH
module(s) are slow and whether the cost is file I/O (raw-read column) or parse (import column);
manifest enumeration is native .NET and consistently ~1-7ms. Off = no overhead.
```

## comment:31

Above `[switch]$Bundle,`, written with `#`.

```text
Read-only bundle load: manifests must be pre-generated (never written), and the combined-types DLL
must be shipped (never compiled). Passed by Invoke-Importer -Bundle; off for the mono repo.
```

## comment:32

Above `$moduleDirs = [System.IO.DirectoryInfo]::new($ModulesRoot).GetDirectories() |`, written with `#`.

```text
One level, inline: this module loads before the walker exists
([ADR-PWSH-ENUM-EARLYLOADINGCODE](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-earlyloadingcode)).
```

## comment:33

Above `Assert-UniqueModuleFunctionName -ModuleDirs $moduleDirs...`, written with `#`.

```text
Fail fast on duplicate exported function names BEFORE any module or C# type loads — a collision would
otherwise be silent (the module imported last shadows the others).
```

## comment:34

Above `$stale = @(Get-Module |`, written with `#`.

```text
Remove previously loaded catzc modules (handles deleted/renamed modules). Exclude Bootstrap, the
vendored third-party modules (.vendor), and the .internal shared modules — the last are loaded by the
importer before this runs and must SURVIVE into the session (Import-CSharpTypes and post-import cover
functions call them); they live under the modules root, so without this they match the stale sweep.
```

## comment:35

Above `$rootInternal =...`, written with `#`.

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

Above `Import-CSharpTypes -ModulesRoot $ModulesRoot...`, written with `#`.

```text
Native C# types (every module's types/*.cs) compile/load ONCE, before any module's functions, into a
single combined assembly — so a function (or a module's load-time code) can reference any type, and a
type in one module can reference a type in another. Module import order below is therefore irrelevant.
```

## comment:37

Above `$readMs = 0`, written with `#`.

```text
Diagnostic probe: read every .ps1 this module imports, raw, BEFORE Import-Module. This pays
the cold per-file *open* cost — the part an antivirus real-time scan or a network share
intercepts — so the Import-Module that follows reads from warm OS cache and its time is ≈ pure
parse/compile. Splitting them is the point: raw-read = I/O cost, import = parse cost. Only the
set Import-Module will load (root + private .ps1, no tests), so the warming is representative.
```

## comment:38

Above `. $importedModule { Set-StrictMode -Version Latest }`, written with `#`.

```text
A session-level Set-StrictMode does not reach module code, so strict mode is set in each module's own
script scope, which every function in the module inherits
([ADR-PWSH-ERROR](/docs/drs/automation/pwsh/error-handling.md)).
```

## comment:39

Above `$summary = "Loaded $($imported.Count) modules from '$ModulesRoot'"`, written with `#`.

```text
Loading and unloading modules changes the session, so it is announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)) on the
importer's
verbose record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)): one
line names
the load, plus any module that left the session for good — evicted from another root, or gone from the tree.
A re-import's remove-then-reload of the same modules is not a departure and is not listed.
```
