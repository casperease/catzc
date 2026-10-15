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
    # [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
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
        [ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7),
        [ADR-AUTO-TYPES#12](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types12)
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

Export-ModuleMember -Function Get-CombinedTypeHash, Get-LoadedTypeDrift, Build-CombinedTypeAssembly, Get-TypesShadowRoot, Import-TypesAssembly
