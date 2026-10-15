---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Types.psm1.md
    kind: comment-page
    body_sha: "65ea94e7734c"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/.internal/Catzc.Internal.Types.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Get-CombinedTypeHash {`, written with `#`.

```text
.SYNOPSIS
    The single implementation of the combined C# type-source hash — enumerate, order, and hash every module's
    types/*.cs the way the committed automation/.compiled/Catzc.Types.<hash>.dll is keyed.
.DESCRIPTION
    Loader and janitor must agree on this hash byte for byte, or the janitor plans the live build for deletion.
    [comment:1](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment1)
```

## comment:2

Above `[CmdletBinding()]`, written with `#`.

```text
.SYNOPSIS
    Returns the combined 8-char hash of every module's C# type sources, with the per-file snapshot and the
    source list, in order, that the loader compiles.
.PARAMETER AutomationRoot
    The automation directory. Its non-dot subfolders are the modules whose types/*.cs are hashed.
.PARAMETER Module
    Omitted, every non-dot module is hashed; a named module without a types folder contributes nothing.
    [comment:2](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment2)
.OUTPUTS
    [pscustomobject] with:
      CombinedHash  the 8-char lowercase hex hash (the Catzc.Types.<hash>.dll key), or $null when no module
                    ships a C# type source.
      Snapshot      an ordered map of "<module>/<bare type>" -> per-file EOL-insensitive digest.
      Files         the source list, sorted ordinally ([pscustomobject] Module/Base/Key/Path), that the
                    caller validates and compiles.
```

## comment:3

Above `$selected = $null`, written with `#`.

```text
Assigned directly, never through an if-expression: an empty HashSet emitted from a statement enumerates to
$null, which would silently widen an empty selection to every module.
```

## comment:4

Above `$files = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
Enumerate every non-dot module's types/*.cs. Key = "<module>/<bare type>"; Path = the source file. No
namespace / dotted-name validation here (the loader's job). [System.IO] over Get-ChildItem for the
~20ms/call provider overhead the raw enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:5

Above `$compiledTypesDir = [System.IO.Path]::Combine($AutomationRoot, '.compiled',...`, written with `#`.

```text
A build ships the full type set but only the selected modules' folders; the other modules' sources sit
under .compiled/types/<module>/ so the importer never mistakes them for module folders. Keyed the same way,
so the hash equals the one over the full type set. A source tree has no .compiled/types, so this adds
nothing there.
```

## comment:6

Above `$sortedFiles = [object[]]$files.ToArray()`, written with `#`.

```text
Deterministic, culture-independent order: sort by <module>/<bare type> ORDINALLY (Sort-Object is
culture-aware — cross-platform ADR — so use an ordinal comparer over the keys).
```

## comment:7

Above `$latin1 = [System.Text.Encoding]::Latin1`, written with `#`.

```text
Per-file EOL-INSENSITIVE digest: hash the source bytes with every CR (0x0D) stripped, so a CRLF vs LF
working tree (git core.autocrlf, an editor's format-on-save) yields the same digest and never re-keys the
committed DLL on a pure line-ending flip. The combined hash folds in each file's <module>|<bare type>|digest.
One SHA instance is reused for the per-file digests and the final combined hash. First 8 hex, lowercase.
The CR strip round-trips through Latin1 — a byte-exact 1:1 byte<->char mapping — so it runs as one native
String.Replace instead of a per-byte pipeline (~1.2s per cold import). This runs before the combined
assembly loads, so Catzc.Base.Globs.DurableHash (the native equivalent) is not callable here.
```

## comment:8

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...`, written with `#`.

```text
.SYNOPSIS
    Compares the C# types loaded in this process with the type sources of a code root, and says whether they are
    current.
.DESCRIPTION
    A loaded assembly cannot be swapped in a running process, so a source edited after loading stays stale.
    [comment:8](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment8)
.PARAMETER ModulesRoot
    The code root (an automation/ folder) whose type sources to compare.
.PARAMETER HashResult
    The Get-CombinedTypeHash result for the root, when the caller has it already; computed otherwise.
.OUTPUTS
    [pscustomobject] { RootKey; Loaded; Current; LoadedHash; SourceHash; Drift; MissingTypes; Summary }. Summary
    is one sentence naming the hashes or roots, or $null when the types are current.
```

## comment:9

Above `$otherRoots = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Cross-root: the types are in the process, but loaded on behalf of a different root. Compare per-file
digests against the root that recorded each one; a type no recorded root claims is taken as it is.
```

## comment:10

Above `[CmdletBinding()]` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Compiles the selected modules' C# type sources into one hash-named assembly on disk, without loading it.
.DESCRIPTION
    Compiles a frozen copy of the sources, so a save mid-compile cannot make the DLL name differ from its bytes.
    [comment:10](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment10)
.PARAMETER AutomationRoot
    The automation directory whose non-dot module folders hold the types/*.cs sources.
.PARAMETER Module
    Restricts the compile (and its hash) to these module folders. Omitted, every module's types compile.
.PARAMETER OutputDirectory
    The directory the Catzc.Types.<hash>.dll is written to; created when missing.
.OUTPUTS
    [pscustomobject] with Hash (the 8-char combined hash), Path (the DLL), Manifest (the Catzc.Types.<hash>.json beside
    it, written when missing), Files (the source list, in order,
    from Get-CombinedTypeHash), Snapshot (the per-file digests), and Compiled (whether this call ran the compiler).
    $null when the selection ships no C# type source.
.EXAMPLE
    Build-CombinedTypeAssembly -AutomationRoot $root -Module 'Catzc.Base.Objects' -OutputDirectory "$build/.compiled"
```

## comment:11

Above `[OutputType([string])]`, written with `#`.

```text
.SYNOPSIS
    The per-user folder that holds the shadow copies of the combined types assembly.
.DESCRIPTION
    Shared by every session and clone: a copy is named by its source hash, so equal names mean equal types.
    [comment:11](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment11)
.OUTPUTS
    [string] The folder path (not created here).
.EXAMPLE
    Get-TypesShadowRoot
```

## comment:12

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`, written with `#`.

```text
.SYNOPSIS
    Loads a combined types assembly from a per-user shadow copy, never from the file it is given.
.DESCRIPTION
    Windows locks a loaded DLL, so loading in place would pin a superseded build; every load uses a shadow copy.
    [comment:12](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment12)
.PARAMETER Path
    The assembly to load (normally automation/.compiled/Catzc.Types.<hash>.dll, or a bundle's prebuilt copy).
.PARAMETER ShadowRoot
    The shadow folder. Defaults to Get-TypesShadowRoot; tests pass a throwaway folder.
.PARAMETER PruneAfter
    The age bound keeps a copy another process just wrote but not yet loaded from being pruned under it.
    [comment:13](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment13)
.PARAMETER ShadowCopy
    $false loads the given file in place, for a system that does not lock a loaded file.
.OUTPUTS
    [string] The path of the loaded assembly: the shadow copy, or the given file when ShadowCopy is $false.
.EXAMPLE
    Import-TypesAssembly -Path (Join-Path $modulesRoot '.compiled/Catzc.Types.762c40fe.dll')
```

## comment:13

Above `[CmdletBinding()]` (occurrence 4), written with `#`.

```text
.SYNOPSIS
    Checks that a combined types assembly declares every expected public type, reading its metadata only.
.DESCRIPTION
    The file is read into memory and parsed with System.Reflection.Metadata, so the assembly is never loaded into the
    process and the file is never locked. A missing type throws; a complete assembly returns nothing.
.PARAMETER Path
    The assembly file to read.
.PARAMETER Expected
    The sources whose types the assembly must hold: objects with Module (the namespace) and Base (the type name), as
    Get-CombinedTypeHash returns in Files.
.EXAMPLE
    Test-TypesAssemblyContent -Path $dll -Expected $hashResult.Files
```

## comment:14

Above `[CmdletBinding()]` (occurrence 5), written with `#`.

```text
.SYNOPSIS
    Lists the public types of a combined types assembly with the facts the importer registers for them, reading metadata only.
.DESCRIPTION
    For each public top-level type: its full name, the PSTypeAlias names it declares, and the ConsoleDisplay properties that
    apply to it (its own, else the nearest base type's in the same assembly, as the attribute is inherited). The file is read
    into memory and parsed with System.Reflection.Metadata, so the assembly is never loaded and the file never locked.
.PARAMETER Path
    The assembly file to read.
.OUTPUTS
    [pscustomobject] with Types: the types sorted ordinally by Name, each with Name, Aliases and Display (string arrays).
.EXAMPLE
    (Get-TypesAssemblyManifest -Path $dll).Types
```

## comment:15

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Writes the manifest Catzc.Types.<hash>.json beside a combined types assembly, unless it is there already.
.DESCRIPTION
    The manifest is generated from the assembly's own metadata, never edited, and named by the same hash as the assembly, so
    the two always describe the same build. It is written to a temporary file and moved into place.
.PARAMETER Path
    The assembly (Catzc.Types.<hash>.dll) to describe.
.OUTPUTS
    [string] The manifest path.
.EXAMPLE
    Write-TypesAssemblyManifest -Path $dll
```

## comment:16

Above `[CmdletBinding()]` (occurrence 7), written with `#`.

```text
.SYNOPSIS
    Says whether, when, and how the combined types assembly is loaded in one mode.
.DESCRIPTION
    A setting resolves in the one fixed order: the caller's explicit value, else the mode's row in types-load.yml, else the default row.
    Only pwsh can load a C# assembly, so any other engine answers Load 'never' without reading the table.
.PARAMETER Engine
    The execution engine's name. Anything but pwsh answers Load 'never'.
.PARAMETER HostKind
    console or headless. Defaults to headless inside a pipeline, else console.
.PARAMETER Os
    windows or unix. Defaults to the running system.
.PARAMETER RunMode
    source or build (Get-CatzcRunMode is not loaded yet when the importer asks, so the caller passes it). Defaults to source.
.PARAMETER Load
    An explicit load, outranking the config.
.PARAMETER Trigger
    An explicit trigger, outranking the config.
.PARAMETER ShadowCopy
    An explicit shadow-copy choice, outranking the config.
.PARAMETER EagerType
    Explicit type names to load at import, outranking the config.
.PARAMETER ConfigPath
    The types-load.yml to read. Defaults to the one beside this module in assets/.
.OUTPUTS
    [pscustomobject] Cell, Engine, Load, Trigger, EagerTypes, ShadowCopy.
.EXAMPLE
    Get-TypesLoadPolicy -HostKind headless -Os unix -RunMode build
```

## comment:17

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Records a verified types assembly as pending: known, not loaded. Initialize-Types loads it.
.DESCRIPTION
    The record is session-global, so it survives a re-import of this module; it is keyed by code root, like the drift record.
.PARAMETER RootKey
    The full path of the code root the assembly belongs to.
.PARAMETER Path
    The assembly to load later. Its manifest sits beside it.
.PARAMETER ShadowCopy
    Whether the later load goes through the per-user shadow copy.
.EXAMPLE
    Register-DeferredTypes -RootKey $root -Path $dll -ShadowCopy $true
```

## comment:18

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...` (occurrence 3), written with `#`.

```text
.SYNOPSIS
    Loads every pending types assembly and registers its accelerators and default display properties from the manifest. Idempotent.
.DESCRIPTION
    The first use of a catzc command calls it through the lookup hook, so a session that never uses a type never loads one.
    The hook is removed first: nothing below may re-enter it.
.OUTPUTS
    [pscustomobject] One per assembly loaded by this call: Path, Loaded, Aliases, Displayed. Nothing when none was pending.
.EXAMPLE
    Initialize-Types
```

## comment:19

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...` (occurrence 4), written with `#`.

```text
.SYNOPSIS
    Makes the first lookup of one of the named commands load the pending types, before the command binds its parameters.
.DESCRIPTION
    A guard inside a function is too late: a typed parameter or an OutputType resolves its type before the body runs. The hook
    runs before binding and is filtered by name, so only a catzc command pays for it. With nothing pending it clears the hook.
.PARAMETER CommandName
    The commands whose first lookup loads the types.
.EXAMPLE
    Enable-DeferredTypesLoad -CommandName (Get-Command -Module Widget).Name
```
