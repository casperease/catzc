<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Types.psm1
    kind: other
---
#>

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

<#
.SYNOPSIS
    The single implementation of the combined C# type-source hash — enumerate, order, and hash every module's
    types/*.cs the way the committed automation/.compiled/Catzc.Types.<hash>.dll is keyed.
.DESCRIPTION
    Loader and janitor must agree on this hash byte for byte, or the janitor plans the live build for deletion.
    [comment:1](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment1)
#>

function Get-CombinedTypeHash {
    <#
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
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $AutomationRoot,

        [string[]] $Module
    )

    # An empty HashSet out of an if-expression enumerates to null, which would widen an empty selection to all modules.
    # [comment:3](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment3)
    $selected = $null
    if ($PSBoundParameters.ContainsKey('Module')) {
        $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::OrdinalIgnoreCase)
    }

    # Raw System.IO instead of Get-ChildItem avoids about 20 ms of provider overhead per call.
    # [comment:4](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment4)
    $files = [System.Collections.Generic.List[object]]::new()
    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($AutomationRoot)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.') -or ($null -ne $selected -and -not $selected.Contains($moduleName))) {
            continue
        }
        $typesDir = [System.IO.Path]::Combine($moduleDir, 'types')
        if (-not [System.IO.Directory]::Exists($typesDir)) {
            continue
        }
        foreach ($sourcePath in [System.IO.Directory]::EnumerateFiles($typesDir, '*.cs')) {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
            $files.Add([pscustomobject]@{
                    Module = $moduleName
                    Base   = $base
                    Key    = "$moduleName/$base"
                    Path   = $sourcePath
                })
        }
    }

    # A build keeps unselected modules' sources under .compiled, keyed alike, so the hash equals the full-set hash.
    # [comment:5](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment5)
    $compiledTypesDir = [System.IO.Path]::Combine($AutomationRoot, '.compiled', 'types')
    if ($null -eq $selected -and [System.IO.Directory]::Exists($compiledTypesDir)) {
        foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($compiledTypesDir)) {
            $moduleName = [System.IO.Path]::GetFileName($moduleDir)
            foreach ($sourcePath in [System.IO.Directory]::EnumerateFiles($moduleDir, '*.cs')) {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
                $files.Add([pscustomobject]@{
                        Module = $moduleName
                        Base   = $base
                        Key    = "$moduleName/$base"
                        Path   = $sourcePath
                    })
            }
        }
    }

    if ($files.Count -eq 0) {
        return [pscustomobject]@{ CombinedHash = $null; Snapshot = [ordered]@{}; Files = @() }
    }

    # Ordinal comparer, because Sort-Object is culture-aware and the hash must be identical on every machine.
    # [comment:6](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment6)
    $sortedFiles = [object[]]$files.ToArray()
    [System.Array]::Sort($sortedFiles, [System.Comparison[object]] { param($a, $b) [System.StringComparer]::Ordinal.Compare($a.Key, $b.Key) })

    # CR bytes are stripped first, so a CRLF versus LF checkout never re-keys the committed DLL on a line-ending flip.
    # [comment:7](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment7)
    $latin1 = [System.Text.Encoding]::Latin1
    $snapshot = [ordered]@{}
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $stringBuilder = [System.Text.StringBuilder]::new()
        foreach ($file in $sortedFiles) {
            $normalizedBytes = $latin1.GetBytes($latin1.GetString([System.IO.File]::ReadAllBytes($file.Path)).Replace("`r", ''))
            $fileHash = [System.BitConverter]::ToString($sha.ComputeHash($normalizedBytes)) -replace '-', ''
            $snapshot[$file.Key] = $fileHash
            [void]$stringBuilder.Append($file.Key).Append('|').Append($fileHash).Append("`n")
        }
        $bytes = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($stringBuilder.ToString()))
    }
    finally {
        $sha.Dispose()
    }
    $combinedHash = ([System.BitConverter]::ToString($bytes) -replace '-', '').Substring(0, 8).ToLowerInvariant()

    [pscustomobject]@{
        CombinedHash = $combinedHash
        Snapshot     = $snapshot
        Files        = $sortedFiles
    }
}

function Get-LoadedTypeDrift {
    <#
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
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Reads $global:__CatzcTypes, the per-root session record of loaded types the loader keeps (ADR-AUTO-TYPES#12)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ModulesRoot,

        [pscustomobject] $HashResult
    )

    if (-not $HashResult) {
        $HashResult = Get-CombinedTypeHash $ModulesRoot
    }
    $rootKey = [System.IO.Path]::GetFullPath($ModulesRoot)
    $snapshot = $HashResult.Snapshot
    $records = Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly -ErrorAction Ignore
    $prior = if ($records) {
        $records[$rootKey]
    }
    else {
        $null
    }

    $typeNames = @(foreach ($file in $HashResult.Files) {
            "$($file.Module).$($file.Base)"
        })
    $loaded = $false
    foreach ($typeName in $typeNames) {
        if (([System.Management.Automation.PSTypeName]$typeName).Type) {
            $loaded = $true
            break
        }
    }

    $drift = [System.Collections.Generic.List[string]]::new()
    $summary = $null
    if ($loaded -and $prior -and $prior.Hash -ne $HashResult.CombinedHash) {
        foreach ($key in $snapshot.Keys) {
            if (-not $prior.Snapshot.Contains($key)) {
                $drift.Add("added $key")
            }
            elseif ($prior.Snapshot[$key] -ne $snapshot[$key]) {
                $drift.Add("changed $key")
            }
        }
        foreach ($key in $prior.Snapshot.Keys) {
            if (-not $snapshot.Contains($key)) {
                $drift.Add("removed $key")
            }
        }
        $summary = "C# types changed since they were loaded ($($prior.Hash) -> $($HashResult.CombinedHash))."
    }
    elseif ($loaded -and -not $prior) {
        # A type no recorded root claims is taken as it is; the rest are compared with the root that recorded them.
        # [comment:9](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment9)
        $otherRoots = [System.Collections.Generic.List[string]]::new()
        $recordEntries = if ($records) {
            @($records.GetEnumerator())
        }
        else {
            @()
        }
        foreach ($key in $snapshot.Keys) {
            foreach ($entry in $recordEntries) {
                if ($entry.Key -ne $rootKey -and $entry.Value.Snapshot.Contains($key)) {
                    if ($entry.Value.Snapshot[$key] -ne $snapshot[$key]) {
                        $drift.Add("changed $key")
                    }
                    if (-not $otherRoots.Contains($entry.Key)) {
                        $otherRoots.Add($entry.Key)
                    }
                    break
                }
            }
        }
        foreach ($file in $HashResult.Files) {
            if (-not ([System.Management.Automation.PSTypeName]"$($file.Module).$($file.Base)").Type) {
                $drift.Add("not loaded $($file.Key)")
            }
        }
        if ($drift.Count) {
            $loadedFrom = if ($otherRoots.Count) {
                "'" + ($otherRoots -join "', '") + "'"
            }
            else {
                'another root'
            }
            $summary = "C# types already loaded from $loadedFrom differ from the sources under '$rootKey'."
        }
    }

    $loadedHash = if ($prior) {
        $prior.Hash
    }
    else {
        $null
    }
    [pscustomobject]@{
        RootKey      = $rootKey
        Loaded       = $loaded
        Current      = $null -eq $summary
        LoadedHash   = $loadedHash
        SourceHash   = $HashResult.CombinedHash
        Drift        = [string[]] $drift.ToArray()
        MissingTypes = [string[]] @($drift | Where-Object { $_.StartsWith('added ') -or $_.StartsWith('not loaded ') })
        Summary      = $summary
    }
}

function Build-CombinedTypeAssembly {
    <#
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
        [pscustomobject] with Hash (the 8-char combined hash), Path (the DLL), Files (the source list, in order,
        from Get-CombinedTypeHash), Snapshot (the per-file digests), and Compiled (whether this call ran the compiler).
        $null when the selection ships no C# type source.
    .EXAMPLE
        Build-CombinedTypeAssembly -AutomationRoot $root -Module 'Catzc.Base.Objects' -OutputDirectory "$build/.compiled"
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $AutomationRoot,

        [string[]] $Module,

        [Parameter(Mandatory)]
        [string] $OutputDirectory
    )

    $hashArguments = @{ AutomationRoot = $AutomationRoot }
    if ($PSBoundParameters.ContainsKey('Module')) {
        $hashArguments.Module = $Module
    }
    $hashResult = Get-CombinedTypeHash @hashArguments
    if ($hashResult.Files.Count -eq 0) {
        return $null
    }

    $dll = [System.IO.Path]::Combine($OutputDirectory, ('Catzc.Types.{0}.dll' -f $hashResult.CombinedHash))
    if ([System.IO.File]::Exists($dll)) {
        return [pscustomobject]@{
            Hash     = $hashResult.CombinedHash
            Path     = $dll
            Files    = $hashResult.Files
            Snapshot = $hashResult.Snapshot
            Compiled = $false
        }
    }

    # Freeze the sources, then hash and compile the copy, so the DLL's name keys exactly the bytes compiled.
    $frozenRoot = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "catzc-types-$PID-$([guid]::NewGuid().ToString('N'))")
    try {
        foreach ($file in $hashResult.Files) {
            $frozenTypes = [System.IO.Path]::Combine($frozenRoot, $file.Module, 'types')
            [System.IO.Directory]::CreateDirectory($frozenTypes) | Out-Null
            try {
                [System.IO.File]::Copy($file.Path, [System.IO.Path]::Combine($frozenTypes, "$($file.Base).cs"))
            }
            catch [System.IO.FileNotFoundException], [System.IO.DirectoryNotFoundException] {
                throw "C# type source '$($file.Path)' was removed while the types were being built. Re-run the build."
            }
        }
        $frozenArguments = @{ AutomationRoot = $frozenRoot }
        if ($PSBoundParameters.ContainsKey('Module')) {
            $frozenArguments.Module = $Module
        }
        $frozen = Get-CombinedTypeHash @frozenArguments
        $dll = [System.IO.Path]::Combine($OutputDirectory, ('Catzc.Types.{0}.dll' -f $frozen.CombinedHash))
        $compiled = $false
        if (-not [System.IO.File]::Exists($dll)) {
            [System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null
            $tmp = "$dll.$PID.tmp"
            try {
                try {
                    Add-Type -Path @($frozen.Files.Path) -OutputAssembly $tmp -OutputType Library -ErrorAction Stop
                }
                catch {
                    # The compiler names the frozen copies; name the sources the reader edits instead.
                    $message = $_.Exception.Message
                    foreach ($file in $hashResult.Files) {
                        $message = $message.Replace([System.IO.Path]::Combine($frozenRoot, $file.Module, 'types', "$($file.Base).cs"), $file.Path)
                    }
                    throw $message
                }
                try {
                    [System.IO.File]::Move($tmp, $dll)
                }
                catch {
                    if (-not [System.IO.File]::Exists($dll)) {
                        throw
                    }
                }
            }
            finally {
                if ([System.IO.File]::Exists($tmp)) {
                    [System.IO.File]::Delete($tmp)
                }
            }
            $compiled = $true
        }
    }
    finally {
        if ([System.IO.Directory]::Exists($frozenRoot)) {
            [System.IO.Directory]::Delete($frozenRoot, $true)
        }
    }

    [pscustomobject]@{
        Hash     = $frozen.CombinedHash
        Path     = $dll
        Files    = $hashResult.Files
        Snapshot = $frozen.Snapshot
        Compiled = $compiled
    }
}

function Get-TypesShadowRoot {
    <#
    .SYNOPSIS
        The per-user folder that holds the shadow copies of the combined types assembly.
    .DESCRIPTION
        Shared by every session and clone: a copy is named by its source hash, so equal names mean equal types.
        [comment:11](/docs/references/automation/internal/Catzc.Internal.Types.psm1.md#comment11)
    .OUTPUTS
        [string] The folder path (not created here).
    .EXAMPLE
        Get-TypesShadowRoot
    #>
    [OutputType([string])]
    param()

    if ($IsWindows) {
        Join-Path $env:LOCALAPPDATA 'catzc\types'
    }
    else {
        Join-Path $HOME '.local/share/catzc/types'
    }
}

function Import-TypesAssembly {
    <#
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
    .OUTPUTS
        [string] The path of the loaded shadow copy.
    .EXAMPLE
        Import-TypesAssembly -Path (Join-Path $modulesRoot '.compiled/Catzc.Types.762c40fe.dll')
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes only the per-user shadow cache, an internal load-time detail of the importer; the load itself is announced by the caller (Import-CSharpTypes).')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The binary load is announced by the caller: Import-CSharpTypes writes "Loaded types <dll>" through Write-ImporterMessage -StateChange; the analyzer rule SpellOutIdentifiers runs inside the analyzer engine, where only diagnostic records may be emitted.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [string] $ShadowRoot = (Get-TypesShadowRoot),

        [TimeSpan] $PruneAfter = [TimeSpan]::FromDays(1)
    )

    if (-not [System.IO.File]::Exists($Path)) {
        throw "Cannot load the types assembly: '$Path' does not exist."
    }

    [System.IO.Directory]::CreateDirectory($ShadowRoot) | Out-Null
    $shadow = [System.IO.Path]::Combine($ShadowRoot, [System.IO.Path]::GetFileName($Path))
    if (-not [System.IO.File]::Exists($shadow)) {
        $tmp = "$shadow.$PID.tmp"
        try {
            [System.IO.File]::Copy($Path, $tmp, $true)
            [System.IO.File]::Move($tmp, $shadow)
        }
        catch {
            # A concurrent load that won the race left an equivalent copy; anything else is a real failure.
            if (-not [System.IO.File]::Exists($shadow)) {
                throw
            }
        }
        finally {
            if ([System.IO.File]::Exists($tmp)) {
                [System.IO.File]::Delete($tmp)
            }
        }
    }

    # Mark this copy as in use (best-effort: a copy another process has loaded may refuse the attribute write).
    try {
        [System.IO.File]::SetLastWriteTimeUtc($shadow, [DateTime]::UtcNow)
    }
    catch {
        Write-Verbose "Could not refresh the shadow copy's write time: $shadow"
    }

    $staleBefore = [DateTime]::UtcNow - $PruneAfter
    foreach ($other in [System.IO.Directory]::EnumerateFiles($ShadowRoot, 'Catzc.Types.*.dll')) {
        if ($other -eq $shadow -or [System.IO.File]::GetLastWriteTimeUtc($other) -ge $staleBefore) {
            continue
        }
        try {
            [System.IO.File]::Delete($other)
        }
        catch {
            Write-Verbose "Skipped a shadow copy still in use: $other"
        }
    }

    Add-Type -Path $shadow
    $shadow
}

function Test-TypesAssemblyContent {
    <#
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
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [object[]] $Expected
    )

    if (-not [System.IO.File]::Exists($Path)) {
        throw "Cannot verify the types assembly: '$Path' does not exist."
    }

    $declared = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $stream = [System.IO.MemoryStream]::new([System.IO.File]::ReadAllBytes($Path))
    $peReader = [System.Reflection.PortableExecutable.PEReader]::new($stream)
    try {
        $reader = [System.Reflection.Metadata.PEReaderExtensions]::GetMetadataReader($peReader)
        foreach ($handle in $reader.TypeDefinitions) {
            $definition = $reader.GetTypeDefinition($handle)
            $visibility = $definition.Attributes -band [System.Reflection.TypeAttributes]::VisibilityMask
            if ($visibility -eq [System.Reflection.TypeAttributes]::Public) {
                [void] $declared.Add($reader.GetString($definition.Namespace) + '.' + $reader.GetString($definition.Name))
            }
        }
    }
    finally {
        $peReader.Dispose()
        $stream.Dispose()
    }

    foreach ($source in $Expected) {
        if (-not $declared.Contains("$($source.Module).$($source.Base)")) {
            throw "Compiled C# types but '$($source.Module).$($source.Base)' was not produced. $($source.Module)/types/$($source.Base).cs must declare a public class named '$($source.Base)' (the module namespace '$($source.Module)' is added automatically)."
        }
    }
}

# The default row and the allowed values live here, not on a C# type: the policy is read while the types assembly is still unloaded.
$script:TypesLoadDefault = [ordered]@{ Load = 'lazy'; Trigger = 'lookup-hook'; EagerTypes = @(); ShadowCopy = $true }
$script:TypesLoadHosts = 'console', 'headless'
$script:TypesLoadSystems = 'windows', 'unix'
$script:TypesLoadRunModes = 'source', 'build'
$script:TypesLoadLoads = 'lazy', 'eager'
$script:TypesLoadTriggers = 'lookup-hook', 'none'
$script:TypesLoadKeys = 'load', 'trigger', 'shadowCopy', 'eagerTypes'

function Get-TypesLoadPolicy {
    <#
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
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Engine = 'pwsh',

        [ValidateSet('console', 'headless')]
        [string] $HostKind = $(if (Test-IsRunningInPipeline) { 'headless' } else { 'console' }),

        [ValidateSet('windows', 'unix')]
        [string] $Os = $(if ($IsWindows) { 'windows' } else { 'unix' }),

        [ValidateSet('source', 'build')]
        [string] $RunMode = 'source',

        [ValidateSet('lazy', 'eager')]
        [string] $Load,

        [ValidateSet('lookup-hook', 'none')]
        [string] $Trigger,

        [bool] $ShadowCopy,

        [string[]] $EagerType,

        [string] $ConfigPath = [System.IO.Path]::Combine($PSScriptRoot, 'assets', 'types-load.yml')
    )

    if ($Engine -ne 'pwsh') {
        return [pscustomobject]@{ Cell = $null; Engine = $Engine; Load = 'never'; Trigger = 'none'; EagerTypes = @(); ShadowCopy = $false }
    }

    if (-not [System.IO.File]::Exists($ConfigPath)) {
        throw "The types-load config '$ConfigPath' does not exist."
    }
    $config = ConvertFrom-Yaml ([System.IO.File]::ReadAllText($ConfigPath))
    if ($null -eq $config -or -not $config.ContainsKey('cells')) {
        throw "The types-load config '$ConfigPath' has no 'cells' map."
    }

    $valid = foreach ($h in $script:TypesLoadHosts) { foreach ($o in $script:TypesLoadSystems) { foreach ($r in $script:TypesLoadRunModes) { "$h.$o.$r" } } }
    foreach ($key in $config['cells'].Keys) {
        if ($key -cnotin $valid) {
            throw "The types-load config has a row '$key' that is no mode. The modes are: $($valid -join ', ')."
        }
        foreach ($setting in $config['cells'][$key].Keys) {
            if ($setting -cnotin $script:TypesLoadKeys) {
                throw "The types-load row '$key' has an unknown setting '$setting'. The settings are: $($script:TypesLoadKeys -join ', ')."
            }
        }
    }

    $cell = "$HostKind.$Os.$RunMode"
    $row = if ($config['cells'].ContainsKey($cell)) { $config['cells'][$cell] } else { @{} }
    $policy = [ordered]@{ Cell = $cell; Engine = $Engine }
    foreach ($name in 'Load', 'Trigger', 'ShadowCopy') {
        $fromConfig = $name.Substring(0, 1).ToLowerInvariant() + $name.Substring(1)
        $policy[$name] = if ($PSBoundParameters.ContainsKey($name)) { $PSBoundParameters[$name] }
        elseif ($row.ContainsKey($fromConfig)) { $row[$fromConfig] }
        else { $script:TypesLoadDefault[$name] }
    }
    $policy['EagerTypes'] = @(
        if ($PSBoundParameters.ContainsKey('EagerType')) { $EagerType }
        elseif ($row.ContainsKey('eagerTypes')) { $row['eagerTypes'] }
        else { $script:TypesLoadDefault['EagerTypes'] }
    )

    if ($policy.Load -cnotin $script:TypesLoadLoads) {
        throw "Row '$cell' has load '$($policy.Load)'; the values are: $($script:TypesLoadLoads -join ', ')."
    }
    if ($policy.Trigger -cnotin $script:TypesLoadTriggers) {
        throw "Row '$cell' has trigger '$($policy.Trigger)'; the values are: $($script:TypesLoadTriggers -join ', ')."
    }
    if ($policy.ShadowCopy -isnot [bool]) {
        throw "Row '$cell' has shadowCopy '$($policy.ShadowCopy)'; it is true or false."
    }
    if ($policy.Trigger -eq 'none' -and $policy.Load -ne 'eager') {
        throw "Row '$cell' has trigger 'none' with load '$($policy.Load)'; nothing would ever load the types. 'none' needs load eager."
    }
    [pscustomobject]$policy
}

Export-ModuleMember -Function Get-CombinedTypeHash, Get-LoadedTypeDrift, Build-CombinedTypeAssembly, Get-TypesShadowRoot, Import-TypesAssembly, Test-TypesAssemblyContent, Get-TypesLoadPolicy
