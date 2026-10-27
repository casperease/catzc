function Get-LoadedTypeDrift {
    # .SYNOPSIS
    #     Compares the C# types loaded in this process with the type sources of a code root, and says whether they are
    #     current.
    # .DESCRIPTION
    #     A loaded assembly cannot be swapped in a running process, so a source edited after loading stays stale.
    # .PARAMETER ModulesRoot
    #     The code root (a pwsh/ folder) whose type sources to compare.
    # .PARAMETER HashResult
    #     The Get-CombinedTypeHash result for the root, when the caller has it already; computed otherwise.
    # .OUTPUTS
    #     [pscustomobject] { RootKey; Loaded; Current; LoadedHash; SourceHash; Drift; MissingTypes; Summary }. Summary
    #     is one sentence naming the hashes or roots, or $null when the types are current.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = 'Reads $global:__CatzcTypes, the per-root session record of loaded types the loader keeps (ADR-PWSH-TYPES-STALETYPESGUARD)')]
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
        # Cross-root: the types are in the process, but loaded on behalf of a different root. Compare per-file
        # digests against the root that recorded each one; a type no recorded root claims is taken as it is.
        $otherRoots = [System.Collections.Generic.List[string]]::new()
        $recordEntries = @(if ($records) {
                @($records.GetEnumerator())
            }
            else {
                @()
            })
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
