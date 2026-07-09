<#
.SYNOPSIS
    The single implementation of the combined C# type-source hash — enumerate, order, and hash every module's
    types/*.cs the way the committed automation/.compiled/Catzc.Types.<hash>.dll is keyed.
.DESCRIPTION
    Both the loader (Import-CSharpTypes, in the bootstrap) and the janitor (Clear-ModuleTypeCache, a Catzc module)
    must agree byte-for-byte on this hash, or the janitor plans the live build for deletion. That algorithm used
    to be copied into both (and mirrored again in tests) with a standing "keep all of them identical" note; it
    now lives here once, called from both layers via Import-InternalModule (see one-living-version).

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
        [string] $AutomationRoot
    )

    # Enumerate every non-dot module's types/*.cs. Key = "<module>/<bare type>"; Path = the source file. No
    # namespace / dotted-name validation here (the loader's job). [System.IO] over Get-ChildItem for the
    # ~20ms/call provider overhead the raw enumeration avoids (ADR-AUTO-TEST:18).
    $files = [System.Collections.Generic.List[object]]::new()
    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($AutomationRoot)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.')) {
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
    $snapshot = [ordered]@{}
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $stringBuilder = [System.Text.StringBuilder]::new()
        foreach ($file in $sortedFiles) {
            $normalizedBytes = [byte[]]([System.IO.File]::ReadAllBytes($file.Path) | Where-Object { $_ -ne 13 })
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

Export-ModuleMember -Function Get-CombinedTypeHash
