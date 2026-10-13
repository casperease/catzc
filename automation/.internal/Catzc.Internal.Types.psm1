Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

<#
.SYNOPSIS
    The single implementation of the combined C# type-source hash — enumerate, order, and hash every module's
    types/*.cs the way the committed automation/.compiled/Catzc.Types.<hash>.dll is keyed.
.DESCRIPTION
    Both the loader (Import-CSharpTypes, in the bootstrap) and the janitor (Clear-ModuleTypeCache, a Catzc module)
    must agree byte-for-byte on this hash, or the janitor plans the live build for deletion. The algorithm lives
    here once, called from both layers via Import-InternalModule (see one-living-version). The one compile path
    for the combined assembly (Build-CombinedTypeAssembly) lives here too, shared by the loader and a build, and so
    does the one load path (Import-TypesAssembly — a per-user shadow copy, so no session ever locks .compiled),
    shared by the loader and the analyzer rule that needs the types.

    The hash is EOL-insensitive (every CR byte stripped before the per-file digest), so a CRLF vs LF working tree
    keys the same DLL on every machine, and it folds in each file's <module>|<bare type> so a move between modules
    or a rename re-keys even on byte-identical content. Deterministic, culture-independent ordering. This does NOT
    validate namespaces or reject dotted filenames — that is the loader's concern; the janitor must never throw on
    a bad source.
#>

function Get-CombinedTypeHash {
    <#
    .SYNOPSIS
        Returns the combined 8-char hash of every module's C# type sources, with the per-file snapshot and the
        ordered source list the loader compiles.
    .PARAMETER AutomationRoot
        The automation directory. Its non-dot subfolders are the modules whose types/*.cs are hashed.
    .PARAMETER Module
        Restricts the hash to these module folders (a build of a module subset). Omitted, every non-dot module
        folder is hashed, plus a build's .compiled/types/<module>/*.cs (the unselected modules' sources). A named
        module without a types/ folder simply contributes nothing.
    .OUTPUTS
        [pscustomobject] with:
          CombinedHash  the 8-char lowercase hex hash (the Catzc.Types.<hash>.dll key), or $null when no module
                        ships a C# type source.
          Snapshot      an ordered map of "<module>/<bare type>" -> per-file EOL-insensitive digest.
          Files         the ordinally-sorted source list ([pscustomobject] Module/Base/Key/Path) the caller
                        validates and compiles.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $AutomationRoot,

        [string[]] $Module
    )

    # Assigned directly, never through an if-expression: an empty HashSet emitted from a statement enumerates to
    # $null, which would silently widen an empty selection to every module.
    $selected = $null
    if ($PSBoundParameters.ContainsKey('Module')) {
        $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::OrdinalIgnoreCase)
    }

    # Enumerate every non-dot module's types/*.cs. Key = "<module>/<bare type>"; Path = the source file. No
    # namespace / dotted-name validation here (the loader's job). [System.IO] over Get-ChildItem for the
    # ~20ms/call provider overhead the raw enumeration avoids
    # ([ADR-AUTO-TEST#18](/docs/adr/automation/test-automation.md#rule-adr-auto-test18)).
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

    # A build ships the full type set but only the selected modules' folders; the other modules' sources sit
    # under .compiled/types/<module>/ so the importer never mistakes them for module folders. Keyed the same way,
    # so the hash equals the full source hash. A source tree has no .compiled/types, so this adds nothing there.
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

    # Deterministic, culture-independent order: sort by <module>/<bare type> ORDINALLY (Sort-Object is
    # culture-aware — cross-platform ADR — so use an ordinal comparer over the keys).
    $sortedFiles = [object[]]$files.ToArray()
    [System.Array]::Sort($sortedFiles, [System.Comparison[object]] { param($a, $b) [System.StringComparer]::Ordinal.Compare($a.Key, $b.Key) })

    # Per-file EOL-INSENSITIVE digest: hash the source bytes with every CR (0x0D) stripped, so a CRLF vs LF
    # working tree (git core.autocrlf, an editor's format-on-save) yields the same digest and never re-keys the
    # committed DLL on a pure line-ending flip. The combined hash folds in each file's <module>|<bare type>|digest.
    # One SHA instance is reused for the per-file digests and the final combined hash. First 8 hex, lowercase.
    # The CR strip round-trips through Latin1 — a byte-exact 1:1 byte<->char mapping — so it runs as one native
    # String.Replace instead of a per-byte pipeline (~1.2s per cold import). This runs before the combined
    # assembly loads, so Catzc.Base.Globs.DurableHash (the native equivalent) is not callable here.
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

function Build-CombinedTypeAssembly {
    <#
    .SYNOPSIS
        Compiles the selected modules' C# type sources into one hash-named assembly on disk, without loading it.
    .DESCRIPTION
        The one compile path for the combined types assembly: the loader (Import-CSharpTypes) calls it to restore
        automation/.compiled/Catzc.Types.<hash>.dll, and a build calls it to produce the assembly of the modules it
        ships. The hash comes from Get-CombinedTypeHash over the same module selection, so the file name always
        keys the exact sources compiled.

        Add-Type -OutputAssembly writes the DLL and does NOT load it, so this works in a session that already holds
        the types. Each .cs is a separate compilation unit (Add-Type -Path), so each file's file-scoped namespace
        is legal while every type still lands in one assembly. The compile goes to a per-process temp file that is
        then moved into place, so a concurrent writer never sees a half-written DLL; a lost race (same hash, same
        sources) just discards the temp. An existing DLL of the same hash is kept as is (Compiled = $false).

        Source validation (bare filenames, the module's file-scoped namespace) is the loader's concern, not this
        function's — a caller that compiles unvalidated sources gets the compiler's own errors.
    .PARAMETER AutomationRoot
        The automation directory whose non-dot module folders hold the types/*.cs sources.
    .PARAMETER Module
        Restricts the compile (and its hash) to these module folders. Omitted, every module's types compile.
    .PARAMETER OutputDirectory
        The directory the Catzc.Types.<hash>.dll is written to; created when missing.
    .OUTPUTS
        [pscustomobject] with Hash (the 8-char combined hash), Path (the DLL), Files (the ordered source list from
        Get-CombinedTypeHash), Snapshot (the per-file digests), and Compiled (whether this call ran the compiler).
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
    $compiled = $false
    if (-not [System.IO.File]::Exists($dll)) {
        [System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null
        $tmp = "$dll.$PID.tmp"
        Add-Type -Path @($hashResult.Files.Path) -OutputAssembly $tmp -OutputType Library
        try {
            [System.IO.File]::Move($tmp, $dll)
        }
        catch {
            if ([System.IO.File]::Exists($tmp)) {
                [System.IO.File]::Delete($tmp)
            }
        }
        $compiled = $true
    }

    [pscustomobject]@{
        Hash     = $hashResult.CombinedHash
        Path     = $dll
        Files    = $hashResult.Files
        Snapshot = $hashResult.Snapshot
        Compiled = $compiled
    }
}

function Get-TypesShadowRoot {
    <#
    .SYNOPSIS
        The per-user folder that holds the shadow copies of the combined types assembly.
    .DESCRIPTION
        %LOCALAPPDATA%\catzc\types on Windows, ~/.local/share/catzc/types on Unix — the same per-user catzc root
        the tool venvs use. Shared by every session, clone, and installed version of the user: a copy is named
        for the hash of the sources it was compiled from, so equal names mean equivalent types.
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
        A loaded assembly is locked on Windows for the life of the process, so loading
        automation/.compiled/Catzc.Types.<hash>.dll in place would let any long-lived session — a console, the
        editor's analyzer host, a test worker — pin a superseded build inside the repository. Every load goes
        through here instead: the DLL is copied into the shadow root (Get-TypesShadowRoot) under its own name,
        and the copy is loaded. The source file is only ever read, so .compiled can always be pruned.

        A copy is named for its source hash, so it never changes once written: an existing copy is reused, and a
        new one is written to a per-process temp file and moved into place (a concurrent writer that wins the
        race leaves an equivalent copy, and the temp is discarded). A copy rather than a load from bytes, because
        a byte-loaded assembly has no Location, and code that compiles against the types references it by path.

        Each load refreshes its copy's write time; other copies untouched for -PruneAfter (a day by default) are
        pruned, best-effort (a locked or vanished copy is skipped). The age bound keeps a copy that another process
        has just written but not yet loaded from being pruned under it.
    .PARAMETER Path
        The assembly to load (normally automation/.compiled/Catzc.Types.<hash>.dll, or a bundle's prebuilt copy).
    .PARAMETER ShadowRoot
        The shadow folder. Defaults to Get-TypesShadowRoot; tests pass a throwaway folder.
    .PARAMETER PruneAfter
        How long another copy may go untouched before it is pruned. Defaults to one day: long enough that no
        in-flight load loses its copy, short enough that superseded builds do not pile up.
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

Export-ModuleMember -Function Get-CombinedTypeHash, Build-CombinedTypeAssembly, Get-TypesShadowRoot, Import-TypesAssembly
