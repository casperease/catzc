function Set-AbandonedTestRun {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Rewrites run records under out/ only — the gitignored output folder — as an automatic step of starting a run; nothing user-owned changes.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $OutputFolder
    )

    if (-not [System.IO.Directory]::Exists($OutputFolder)) {
        return
    }

    foreach ($runDirectory in [System.IO.Directory]::EnumerateDirectories($OutputFolder)) {
        $manifestPath = [System.IO.Path]::Combine($runDirectory, 'run.json')
        if (-not [System.IO.File]::Exists($manifestPath)) {
            continue
        }
        try {
            $manifest = [System.IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Verbose "Skipped unreadable run manifest: $manifestPath — $($_.Exception.Message)"
            continue
        }
        if ($manifest -isnot [System.Collections.IDictionary] -or $manifest['status'] -ne 'running') {
            continue
        }

        $ownerPid = $manifest['ownerPid']
        $ownerStart = $manifest['ownerStart']
        if ($null -ne $ownerPid -and $null -ne $ownerStart -and
            [Catzc.Base.QualityGates.WorkerParentWatch]::IsAlive([int]$ownerPid, [long]$ownerStart)) {
            continue
        }

        # A date goes back as the UTC string it was read from, not as a local DateTime.
        $abandoned = [ordered]@{}
        foreach ($key in $manifest.Keys) {
            $value = $manifest[$key]
            if ($value -is [datetime] -or $value -is [System.DateTimeOffset]) {
                $value = ([System.DateTimeOffset] $value).ToUniversalTime().ToString('o')
            }
            $abandoned[$key] = $value
        }
        $abandoned['status'] = 'abandoned'
        $abandoned['abandonedAt'] = [DateTimeOffset]::UtcNow.ToString('o')
        Write-TestRunManifest -RunDirectory $runDirectory -Manifest $abandoned | Out-Null

        $owner = if ($null -ne $ownerPid) {
            "its owner (PID $ownerPid) is gone"
        }
        else {
            'it names no owner'
        }
        Write-Message "Marked run $([System.IO.Path]::GetFileName($runDirectory)) abandoned — $owner"
        $runDirectory
    }
}
