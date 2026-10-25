# pwsh/.internal/Catzc.Internal.Bootstrap.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

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
