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
    catch [System.IO.IOException] {
        # Another build filled this stamp between the check and the move; its copy stands and this one goes.
        Write-Verbose "The store stamp folder $stampFolder was filled by another build ($($_.Exception.Message))."
        if ([System.IO.Directory]::Exists($stagingFolder)) {
            [System.IO.Directory]::Delete($stagingFolder, $true)
        }
        return
    }

    # Other stamps and stale staging folders of this bundle go best-effort: a reader mid-copy blocks a delete on Windows, and the next writer retries.
    $stampName = [System.IO.Path]::GetFileName($stampFolder)
    foreach ($entry in [System.IO.Directory]::GetDirectories($bundleFolder)) {
        $name = [System.IO.Path]::GetFileName($entry)
        $stale = if ($name -match '^[0-9a-f]{12}$') {
            $name -cne $stampName
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
