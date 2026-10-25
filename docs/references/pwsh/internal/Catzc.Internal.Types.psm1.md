# pwsh/.internal/Catzc.Internal.Types.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[OutputType([string])]`, written with `#`.

```text
.SYNOPSIS
    The per-user folder that holds the shadow copies of the combined types assembly.
.DESCRIPTION
    Shared by every session and clone: a copy is named by its source hash, so equal names mean equal types.
.OUTPUTS
    [string] The folder path (not created here).
.EXAMPLE
    Get-TypesShadowRoot
```

## comment:2

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`, written with `#`.

```text
.SYNOPSIS
    Loads a combined types assembly from a per-user shadow copy, never from the file it is given.
.DESCRIPTION
    Windows locks a loaded DLL, so loading in place would pin a superseded build; every load uses a shadow copy.
.PARAMETER Path
    The assembly to load (normally pwsh/.compiled/Catzc.Types.<hash>.dll, or a bundle's prebuilt copy).
.PARAMETER ShadowRoot
    The shadow folder. Defaults to Get-TypesShadowRoot; tests pass a throwaway folder.
.PARAMETER PruneAfter
    The age bound keeps a copy another process just wrote but not yet loaded from being pruned under it.
.PARAMETER ShadowCopy
    $false loads the given file in place, for a system that does not lock a loaded file.
.OUTPUTS
    [string] The path of the loaded assembly: the shadow copy, or the given file when ShadowCopy is $false.
.EXAMPLE
    Import-TypesAssembly -Path (Join-Path $modulesRoot '.compiled/Catzc.Types.762c40fe.dll')
```

## comment:3

Above `[CmdletBinding()]`, written with `#`.

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

## comment:4

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

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

## comment:5

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...`, written with `#`.

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

## comment:6

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...` (occurrence 2), written with `#`.

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

## comment:7

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',...` (occurrence 3), written with `#`.

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
