# pwsh/.internal/Catzc.Internal.Bootstrap.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

The import-time engine. It does the heavy lifting the [Importer overlay](catzc-internal-importer.md) delegates to: discovering the modules
on disk, generating each module's manifest, compiling and loading every module's native C# types into one assembly, and guarding against
function-name collisions — all before any `pwsh/*` module's functions exist. It is **transient**: loaded early and removed at the tail of
`Invoke-Importer`, so its import-time functions do not linger in the session. The console writer the whole importer routes output through,
`Write-ImporterMessage`, lives in the resident loader, so a line printed after the import still reaches it.

## What it does

Bootstrap is the part of the load sequence that turns a folder of `.ps1` files into imported modules with working C# types:

- **Module discovery and import** — `Import-AllModules` enumerates the non-dot module directories under the automation root, runs the
  name-collision guard, removes any stale previously-loaded modules (leaving the vendored and `.internal` modules alone), compiles and loads
  the combined C# type assembly once, then for each module generates its manifest and imports it. Import order is irrelevant because the
  types are already loaded, so a function in any module can reference a type in any other.
- **Manifest generation** — `New-DynamicManifest` scans a module folder for `.ps1` files (root files are public, `private/` files are
  private, `.Tests.ps1` excluded), and writes a canonical `<Module>.psd1` that lists them in `PrivateData.CatzcFiles` and names the shared
  loader `assets/Import-ModuleFiles.ps1` as its one `NestedModules` entry: the loader parses each file in memory and dot-sources it into the
  module, so they share one session state and keep their source file and line. It scans for `.ps1` only — a `.psm1` inside a module folder
  is silently ignored — which is one of the mechanical enforcements of [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md).
  `Get-DynamicManifestContent` renders the manifest text: the `=` column is computed from the longest key rather than hand-padded, endings
  are LF, and the output is formatter-stable — running the formatter over it is a no-op — so the bytes are identical on every platform and
  every build of a commit ([ADR-REPO-FORMAT-TOOLSFORMAT](../../../drs/repository/uniform-formatting.md)).
- **C# type compile and load** — `Import-CSharpTypes` compiles every module's `types/*.cs` into one hash-keyed assembly,
  `pwsh/.compiled/Catzc.Types.<hash>.dll`, so a type in one module can reference a type in another. It keys the assembly off the combined
  source hash from [Catzc.Internal.Types](catzc-internal-types.md) (the same hash the cache janitor uses, so the two can never drift),
  enforces the loader's poka-yokes (a dotted filename or a namespace that does not match the module folder is rejected — the same invariant
  the `Test-Formatting` gate checks through `Format-Types`), loads the committed DLL when its hash matches or compiles fresh through Roslyn
  once per hash, verifies every expected type resolved, and publishes each type's `[PSTypeAlias]` accelerator. On a devbox it degrades
  gracefully when a live type changed or was removed (warn and keep the loaded copy), and fails fast when a type was added since load; in CI
  a stale-types load is a hard failure. The full contract is the [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md)
  ADR and the [BCL type-system reference](../../BCL/types-system.md).
- **Collision guard** — `Assert-UniqueModuleFunctionName` turns PowerShell's silent last-writer-wins command shadowing into a loud, fast
  failure before anything loads. It catches two cases and reports all of them at once: two catzc modules exporting the same name, and an
  automation function whose name would shadow an already-imported shipped command (a vendored module, a built-in, or an `.internal` module).
- **Pre-import cache wipe** — `Clear-CompiledType` deletes every `pwsh/.compiled/*.dll` before modules load, so the `-ClearCompiledTypes`
  switch forces a rebuild from source. It is best-effort (a locked DLL is skipped) and distinct from the post-import `Clear-ModuleTypeCache`
  janitor, which keeps the current build and self-skips in CI.

## Functions

The exported surface the importer calls:

- `Import-AllModules` — discover, guard, and import every `pwsh/*` module, compiling the combined C# type assembly first.
- `Clear-CompiledType` — delete the compiled type DLLs before import so the types rebuild from source (`-ClearCompiledTypes`).

The module-internal engine `Import-AllModules` drives (not exported):

- `New-DynamicManifest` — generate a module's canonical `<Module>.psd1` from its `.ps1` files.
- `Get-DynamicManifestContent` — render the manifest hashtable as canonical, formatter-stable `.psd1` text.
- `Import-CSharpTypes` — compile and load every module's `types/*.cs` into the one hash-keyed `Catzc.Types.<hash>.dll`.
- `Assert-UniqueModuleFunctionName` — fail the import on a duplicate or shadowing exported function name.

## Related

- ADR: [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — `New-DynamicManifest` scanning only `.ps1` is the enforcement;
  Bootstrap is itself a sanctioned `.psm1`.
- ADR: [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md) and [caching](../../../drs/automation/caching.md) — the one
  combined assembly, its committed prebuild, and the hash key `Import-CSharpTypes` loads by.
- ADR: [uniform-formatting](../../../drs/repository/uniform-formatting.md) — the canonical, hand-alignment-free manifest text.
- Reference: [Catzc.Internal.Types](catzc-internal-types.md) — the shared hash; the [BCL type-system reference](../../BCL/types-system.md);
  [Catzc.Base.ModuleSystem](../catzc-base-module-system.md) — the post-import dependency-graph check over the same modules; the
  [internal area overview](index.md).

## comment:1

Above `function Clear-CompiledType {`, written with `#`.

```text
.SYNOPSIS
    Deletes the compiled C# type assembly so the next import rebuilds it from source.
.DESCRIPTION
    Unlike Clear-ModuleTypeCache it wipes every build before import in any context, skipping only locked DLLs.
.PARAMETER ModulesRoot
    Path to the modules folder (the parent of .compiled/).
```

## comment:2

Above `function New-DynamicManifest {`, written with `#`.

```text
.SYNOPSIS
    Writes a module's generated <Module>.psd1 and returns its path.
.DESCRIPTION
    A caller whose module is not one function per file passes both lists explicitly, and the folder is not enumerated.
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

## comment:3

Above `[switch]$ReadOnly,`, written with `#`.

```text
Read-only load (a bundle): never generate or write the manifest — it must already be present
(Build-Modules pre-generates every module's manifest), so a read-only install store is never written to.
```

## comment:4

Above `$privateRelative = [string[]] @(foreach ($f in $privateFiles) {`, written with `#`.

```text
The shared loader (the manifest's one NestedModule) dot-sources each listed .ps1 into the module's session
state, in list order. Private functions group first, then public; each group is ordinal-sorted and its paths
use forward slashes, so the emitted manifest is byte-identical on every platform and every build of the same
commit.
```

## comment:5

Above `$content = Get-DynamicManifestContent -NestedModule $script:moduleFilesLoader...`, written with `#`.

```text
Canonical, formatter-stable text — no hand-padded alignment
([ADR-REPO-FORMAT-TOOLSFORMAT](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-toolsformat)); the L2 tests guard the
invariant.
```

## comment:6

Above `$script:moduleFilesLoader = '../.internal/assets/Import-ModuleFiles.ps1'`, written with `#`.

```text
The shared loader every derived manifest names as its one NestedModule, relative to the module folder: a module
folder sits directly under the modules root, beside .internal.
```

## comment:7

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Writes rendered manifest text to its .psd1 only when it differs, and returns the path.
.DESCRIPTION
    An unchanged module yields identical bytes and no write, so parallel workers never race on the manifest files.
```

## comment:8

Above `[CmdletBinding()]` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Renders a module manifest hashtable as canonical .psd1 text.
.DESCRIPTION
    Canonical by construction: the alignment column derives from the longest key and the text is formatter-stable.
```

## comment:9

Above `$fields = [ordered]@{`, written with `#`.

```text
Ordered fields with their value literals. The '=' column width is derived from the longest key, so a new
field re-aligns automatically and no alignment is maintained by hand
([ADR-REPO-FORMAT-TOOLSFORMAT](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-toolsformat)).
```

## comment:10

Above `function Assert-UniqueModuleFunctionName {`, written with `#`.

```text
.SYNOPSIS
    Fails the import when an exported function name collides — across catzc modules, or with a shipped
    (vendored/built-in) command that is already imported.
.DESCRIPTION
    PowerShell silently lets the last imported command shadow the rest, so this turns a clash into a loud failure.
.PARAMETER ModuleDirs
    The discovered module directories (dot-prefixed infrastructure already excluded).
.PARAMETER ExportPrivates
    When set, private/ functions are exported too, so they join the uniqueness check.
```

## comment:11

Above `$shipped = @{}`, written with `#`.

```text
2) A module function shadowing an already-imported SHIPPED command (vendored module or built-in).
   Vendor modules and built-ins import before our modules, so a name clash means our -Scope Global import
   would silently shadow them. Scope the check to shipped commands by module path — under .vendor/ or
   $PSHOME — so a user's unrelated session module never blocks the import, and our own modules (current
   or stale on a devbox re-import) are naturally excluded (their base is neither).
```

## comment:12

Above `$isShipped = ($base -like "$PSHOME*") -or ($base -match '[\\/]\.vendor[\\/]')...`, written with `#`.

```text
Shipped = a command that loads BEFORE our catzc modules and would be silently shadowed by our
-Scope Global import: built-ins ($PSHOME), vendored third-party (.vendor), and the .internal shared
modules (loaded by the importer before this check). The .internal modules sit directly in the folder,
so their ModuleBase ENDS at .internal (no trailing separator) — match that too.
```

## comment:13

Above `function Get-ForeignCatzcModule {`, written with `#`.

```text
.SYNOPSIS
    Returns every loaded catzc module that does not come from the given code root.
.DESCRIPTION
    The package module also belongs when its ModuleBase is the root's parent, since its code root is pwsh/.
.PARAMETER ModulesRoot
    The active code root (CatzcModulesRoot).
.PARAMETER IncludeInternal
    Include the Catzc.Internal.* loader modules (they belong to a root through its .internal folder).
```

## comment:14

Above `if ($script:privateFunctionFolder -and $script:privateFunctionFolder.Root...`, written with `#`.

```text
The pre-types reader of the powershell layout's private-function row; once types load, LanguagesConfig.FolderOf reads the same row
(ADR-REPO-FOLDERS-NAMESARESETTINGS).
```
