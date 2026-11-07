function Save-BuildToStore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [string] $StoreBuildRoot
    )

    # The store build root is <bundle folder>/<stamp key>/Catzc/<Version>; a stamp folder is complete or absent and is never changed in place.
    $storeRoot = $StoreBuildRoot.TrimEnd('\', '/')
    $stampFolder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($storeRoot))
    $bundleFolder = [System.IO.Path]::GetDirectoryName($stampFolder)
    if ([System.IO.Directory]::Exists($stampFolder)) {
        return
    }

    # The copy lands in a staging sibling first, then the stamp folder moves in whole, so a reader never sees a half-filled store.
    $stagingFolder = [System.IO.Path]::Combine($bundleFolder, ".staging-$([guid]::NewGuid().ToString('N'))")
    $staging = [System.IO.Path]::Combine($stagingFolder, 'Catzc', [System.IO.Path]::GetFileName($storeRoot))
    [System.IO.Directory]::CreateDirectory($staging) | Out-Null
    foreach ($file in (Get-ChildPath $BuildRoot -File -Depth 64 -Exclude @() -PruneVendor $false)) {
        $target = [System.IO.Path]::Combine($staging, [System.IO.Path]::GetRelativePath($BuildRoot, $file))
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
        [System.IO.File]::Copy($file, $target, $true)
    }
    try {
        [System.IO.Directory]::Move($stagingFolder, $stampFolder)
    }
    catch [System.IO.IOException], [System.UnauthorizedAccessException] {
        $moveError = $_.Exception.Message
        if ([System.IO.Directory]::Exists($stagingFolder)) {
            [System.IO.Directory]::Delete($stagingFolder, $true)
        }
        # Only a complete stamp folder of another build excuses the failed move; any other failure leaves the store empty and says so (ADR-AUTO-FAILFAST, ADR-PWSH-ERROR).
        if ([System.IO.File]::Exists([System.IO.Path]::Combine($storeRoot, 'build.json'))) {
            Write-Verbose "The store stamp folder $stampFolder was filled by another build ($moveError)."
            return
        }
        throw "Save-BuildToStore: the build could not be moved into the store stamp folder '$stampFolder' and no other build holds it ($moveError)."
    }

    # A selection is the bundle, the version and the ordinal-sorted module names of a build.json; $null when the record is missing, unreadable or lacks one.
    $readSelection = {
        param([string] $Folder)
        $recordFile = [System.IO.Path]::Combine($Folder, 'build.json')
        if (-not [System.IO.File]::Exists($recordFile)) {
            return $null
        }
        try {
            $parsed = [System.IO.File]::ReadAllText($recordFile) | ConvertFrom-Json -AsHashtable
        }
        catch {
            return $null
        }
        if ($parsed -isnot [System.Collections.IDictionary]) {
            return $null
        }
        foreach ($field in 'bundle', 'version', 'modules') {
            if (-not $parsed.Contains($field) -or $null -eq $parsed[$field]) {
                return $null
            }
        }
        $names = [string[]] @(foreach ($row in @($parsed['modules'])) {
                if ($row -is [System.Collections.IDictionary]) {
                    if (-not $row.Contains('name')) {
                        return $null
                    }
                    "$($row['name'])"
                }
                else {
                    "$row"
                }
            })
        [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
        "$($parsed['bundle'])|$($parsed['version'])|$($names -join ',')"
    }
    $selection = & $readSelection $BuildRoot

    # Other stamps of this selection and stale staging folders of this bundle go best-effort: a reader mid-copy blocks a delete on Windows, and the next writer retries.
    $stampName = [System.IO.Path]::GetFileName($stampFolder)
    foreach ($entry in [System.IO.Directory]::GetDirectories($bundleFolder)) {
        $name = [System.IO.Path]::GetFileName($entry)
        $stale = if ($name -match '^[0-9a-f]{12}$') {
            $candidate = if ($null -ne $selection -and $name -cne $stampName) {
                & $readSelection ([System.IO.Path]::Combine($entry, 'Catzc', [System.IO.Path]::GetFileName($storeRoot)))
            }
            $null -ne $candidate -and $candidate -ceq $selection
        }
        elseif ($name -like '.staging-*') {
            # A staging folder under ten minutes old belongs to a copy still running.
            [System.IO.Directory]::GetLastWriteTimeUtc($entry) -lt [datetime]::UtcNow.AddMinutes(-10)
        }
        else {
            $false
        }
        if ($stale) {
            try {
                [System.IO.Directory]::Delete($entry, $true)
            }
            catch [System.IO.IOException], [System.UnauthorizedAccessException] {
                Write-Verbose "Left $entry for the next writer ($($_.Exception.Message))"
            }
        }
    }
}
