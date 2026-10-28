# .SYNOPSIS
#     The single implementation of the combined C# type-source hash — enumerate, order, and hash every module's
#     types/*.cs the way the committed pwsh/.compiled/Catzc.Types.<hash>.dll is keyed.
# .DESCRIPTION
#     Loader and janitor must agree on this hash byte for byte, or the janitor plans the live build for deletion.
function Get-CombinedTypeHash {
    # .SYNOPSIS
    #     Returns the combined 8-char hash of every module's C# type sources, with the per-file snapshot and the
    #     source list, in order, that the loader compiles.
    # .PARAMETER ModulesRoot
    #     The modules folder. Its non-dot subfolders are the modules whose types/*.cs are hashed.
    # .PARAMETER Module
    #     Omitted, every non-dot module is hashed; a named module without a types folder contributes nothing.
    # .OUTPUTS
    #     [pscustomobject] with:
    #       CombinedHash  the 8-char lowercase hex hash (the Catzc.Types.<hash>.dll key), or $null when no module
    #                     ships a C# type source.
    #       Snapshot      an ordered map of "<module>/<bare type>" -> per-file EOL-insensitive digest.
    #       Files         the source list, sorted ordinally ([pscustomobject] Module/Base/Key/Path), that the
    #                     caller validates and compiles.
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ModulesRoot,

        [string[]] $Module,

        # A machine-local memo of each file's hash keyed by length and last write: a file that shows the same pair is
        # not read again, and
        # the memo is rewritten when any file was. Omitted, every file is hashed, which is what the builder, the janitor
        # and the gates ask.
        [string] $StampPath,

        # The modules track's namespace, for a copy of the root whose folder names no track; omitted, read from the root.
        [AllowEmptyString()]
        [string] $ModuleNamespace
    )

    # Assigned directly, never through an if-expression: an empty HashSet emitted from a statement enumerates to
    # $null, which would silently widen an empty selection to every module.
    $selected = $null
    if ($PSBoundParameters.ContainsKey('Module')) {
        $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module),
            [System.StringComparer]::OrdinalIgnoreCase)
    }

    if (-not $PSBoundParameters.ContainsKey('ModuleNamespace')) {
        $ModuleNamespace = Get-ModuleNamespace -ModulesRoot $ModulesRoot
    }
    # The key names a source by its module's full name, so a source tree (short folders) and a bundle (full-name folders) hash the same.
    # Enumerate every non-dot module's types/*.cs. Key = "<module>/<bare type>"; Path = the source file. No
    # namespace / dotted-name validation here (the loader's job). [System.IO] over Get-ChildItem for the
    # ~20ms/call provider overhead the raw enumeration avoids
    # ([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
    $files = [System.Collections.Generic.List[object]]::new()
    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($ModulesRoot)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.') -or ($null -ne $selected -and -not $selected.Contains((Resolve-ModuleName -Folder $moduleName -Namespace $ModuleNamespace)))) {
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
                    Key    = "$(Resolve-ModuleName -Folder $moduleName -Namespace $ModuleNamespace)/$base"
                    Path   = $sourcePath
                })
        }
    }

    # A build ships the full type set but only the selected modules' folders; the other modules' sources sit
    # under .compiled/types/<module>/ so the importer never mistakes them for module folders. Keyed the same way,
    # so the hash equals the one over the full type set. A source tree has no .compiled/types, so this adds
    # nothing there.
    $compiledTypesDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled', 'types')
    if ($null -eq $selected -and [System.IO.Directory]::Exists($compiledTypesDir)) {
        foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($compiledTypesDir)) {
            $moduleName = [System.IO.Path]::GetFileName($moduleDir)
            foreach ($sourcePath in [System.IO.Directory]::EnumerateFiles($moduleDir, '*.cs')) {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
                $files.Add([pscustomobject]@{
                        Module = $moduleName
                        Base   = $base
                        Key    = "$(Resolve-ModuleName -Folder $moduleName -Namespace $ModuleNamespace)/$base"
                        Path   = $sourcePath
                    })
            }
        }
    }

    if ($files.Count -eq 0) {
        return [pscustomobject]@{ CombinedHash = $null; Snapshot = [ordered]@{}; Files = @() }
    }

    # Deterministic, culture-independent order: sort by <module>/<bare type> ORDINALLY (Sort-Object is
    # culture-aware — cross-platform record — so use an ordinal comparer over the keys).
    $sortedFiles = [object[]]$files.ToArray()
    [System.Array]::Sort($sortedFiles, [System.Comparison[object]] { param($a,
                $b) [System.StringComparer]::Ordinal.Compare($a.Key, $b.Key) })

    $languagesFolder = Resolve-ModuleName -FullName 'Catzc.Base.Languages' -Namespace $ModuleNamespace
    $carriers = [System.IO.Path]::Combine($ModulesRoot, $languagesFolder, 'configs', 'file-carriers.yml')
    # A build ships the carriers beside its type sources, so a reduced build without the Languages module hashes the same bodies.
    if (-not [System.IO.File]::Exists($carriers)) {
        $carriers = [System.IO.Path]::Combine($ModulesRoot, '.compiled', 'types', 'file-carriers.yml')
    }
    $block = $null
    if ([System.IO.File]::Exists($carriers)) {
        $declared = (ConvertFrom-Yaml ([System.IO.File]::ReadAllText($carriers)))['carriers']['bcl']
        $block = [string[]] @($declared['block'])
    }
    # The form this run hashes: the body when the bcl carrier is known, else the whole file; a memo of the other form is no memo.
    $form = $null -ne $block ? 'body' : 'whole'
    $stamped = @{}
    if ($StampPath -and [System.IO.File]::Exists($StampPath)) {
        try {
            $document = [System.IO.File]::ReadAllText($StampPath) | ConvertFrom-Json -AsHashtable
            if ($document -is [hashtable] -and $document['form'] -ceq $form -and $document['files'] -is [hashtable]) {
                $stamped = $document['files']
            }
        }
        catch {
            Write-Verbose "Ignoring the unreadable types stamp '$StampPath': $($_.Exception.Message)"
        }
    }

    # Per-file EOL-INSENSITIVE digest: hash the source bytes with every CR (0x0D) stripped, so a CRLF vs LF
    # working tree (git core.autocrlf, an editor's format-on-save) yields the same digest and never re-keys the
    # committed DLL on a pure line-ending flip. The combined hash folds in each file's <module>|<bare type>|digest.
    # One SHA instance is reused for the per-file digests and the final combined hash. First 8 hex, lowercase.
    # The CR strip round-trips through Latin1 — a byte-exact 1:1 byte<->char mapping — so it runs as one native
    # String.Replace instead of a per-byte pipeline (~1.2s per cold import). This runs before the combined
    # assembly loads, so Catzc.Base.Globs.DurableHash (the native equivalent) is not callable here.
    $latin1 = [System.Text.Encoding]::Latin1
    # The hash is the body's: a head-only change (the file-meta imprint) keeps it, so the dll is not rebuilt for a
    # comment. The head's form is
    # the bcl carrier's in file-carriers.yml; a modules root without the Languages module hashes whole files.
    $snapshot = [ordered]@{}
    $memo = [ordered]@{}
    $rehashed = 0
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $stringBuilder = [System.Text.StringBuilder]::new()
        foreach ($file in $sortedFiles) {
            $info = [System.IO.FileInfo]::new($file.Path)
            $known = $stamped[$file.Key]
            if ($known -is [hashtable] -and $known['length'] -eq $info.Length -and
                $known['ticks'] -eq $info.LastWriteTimeUtc.Ticks -and $known['hash'] -is [string]) {
                $fileHash = $known['hash']
            }
            else {
                $normalized = $latin1.GetString([System.IO.File]::ReadAllBytes($file.Path)).Replace("`r", '')
                if ($block) {
                    $normalized = Get-TypeSourceBody -Text $normalized -Block $block
                }
                $normalizedBytes = $latin1.GetBytes($normalized)
                $fileHash = [System.BitConverter]::ToString($sha.ComputeHash($normalizedBytes)) -replace '-', ''
                $rehashed++
            }
            $snapshot[$file.Key] = $fileHash
            $memo[$file.Key] = [ordered]@{ length = $info.Length; ticks = $info.LastWriteTimeUtc.Ticks; hash = $fileHash }
            [void]$stringBuilder.Append($file.Key).Append('|').Append($fileHash).Append("`n")
        }
        $bytes = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($stringBuilder.ToString()))
    }
    finally {
        $sha.Dispose()
    }
    $combinedHash = ([System.BitConverter]::ToString($bytes) -replace '-', '').Substring(0, 8).ToLowerInvariant()

    if ($StampPath -and ($rehashed -gt 0 -or $stamped.Count -ne $memo.Count)) {
        $folder = [System.IO.Path]::GetDirectoryName($StampPath)
        if ($folder) {
            [System.IO.Directory]::CreateDirectory($folder) | Out-Null
        }
        $json = [ordered]@{ form = $form; combined = $combinedHash; files = $memo } | ConvertTo-Json -Depth 4 -Compress
        $temporary = "$StampPath.$([guid]::NewGuid().ToString('N')).tmp"
        [System.IO.File]::WriteAllText($temporary, $json)
        # The stamp is a cache that parallel imports share: a replace that loses to another process's read or replace
        # leaves the next import to rehash.
        try {
            [System.IO.File]::Move($temporary, $StampPath, $true)
        }
        catch [System.UnauthorizedAccessException], [System.IO.IOException] {
            Write-Verbose "Skipped the types stamp write; another process holds '$StampPath': $($_.Exception.Message)"
            [System.IO.File]::Delete($temporary)
        }
    }

    [pscustomobject]@{
        CombinedHash = $combinedHash
        Snapshot     = $snapshot
        Files        = $sortedFiles
        Rehashed     = $rehashed
    }
}
