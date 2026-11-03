function Get-ReusableBuild {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $StoreBuildRoot,

        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [string] $Stamp
    )

    # A build.json that parses, holds every field the engine reads and records this stamp, else $null.
    $readRecord = {
        param([string] $Root, [string] $Expected)
        $recordFile = [System.IO.Path]::Combine($Root, 'build.json')
        if (-not [System.IO.File]::Exists($recordFile)) {
            return $null
        }
        try {
            $parsed = [System.IO.File]::ReadAllText($recordFile) | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Verbose "No build reused: $recordFile does not parse ($($_.Exception.Message))"
            return $null
        }
        foreach ($field in 'sourceStamp', 'contentHash', 'fileCount', 'typesHash', 'modules') {
            if (-not $parsed.ContainsKey($field)) {
                return $null
            }
        }
        if ("$($parsed['sourceStamp'])" -cne $Expected) {
            return $null
        }
        $parsed
    }

    $record = & $readRecord $StoreBuildRoot $Stamp
    if ($null -eq $record) {
        return $null
    }

    # A destination that already holds this build is returned untouched: parallel callers sharing it never rewrite a good build under each other.
    $held = & $readRecord $BuildRoot $Stamp
    if ($null -ne $held -and (Get-ContentHash -Path $BuildRoot -Exclude 'build.json') -ceq "$($held['contentHash'])") {
        return $held
    }

    # The copy lands in a staging sibling, is verified there, then swaps in with one move, so a reader never sees a half-filled build root.
    $root = $BuildRoot.TrimEnd('\', '/')
    $destination = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($root))
    $id = [guid]::NewGuid().ToString('N')
    $stagingRoot = [System.IO.Path]::Combine($destination, ".staging-$id")
    $staging = [System.IO.Path]::Combine($stagingRoot, 'Catzc', [System.IO.Path]::GetFileName($root))
    [System.IO.Directory]::CreateDirectory($staging) | Out-Null
    # A named whole-tree walk: the copy must hold every file, so nothing is pruned and no depth drops one.
    foreach ($file in (Get-ChildPath $StoreBuildRoot -File -Depth 64 -Exclude @() -PruneVendor $false)) {
        $target = [System.IO.Path]::Combine($staging, [System.IO.Path]::GetRelativePath($StoreBuildRoot, $file))
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
        [System.IO.File]::Copy($file, $target, $true)
    }

    $actual = Get-ContentHash -Path $staging -Exclude 'build.json'
    if ($actual -cne "$($record['contentHash'])") {
        Write-Verbose "No build reused: the copy hashes to $actual but build.json records $($record['contentHash'])"
        [System.IO.Directory]::Delete($stagingRoot, $true)
        return $null
    }

    $old = $null
    try {
        if ([System.IO.Directory]::Exists($root)) {
            $old = [System.IO.Path]::Combine($destination, ".old-$id")
            [System.IO.Directory]::Move($root, $old)
        }
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($root)) | Out-Null
        [System.IO.Directory]::Move($staging, $root)
    }
    catch [System.IO.IOException], [System.UnauthorizedAccessException] {
        # A reader holds the build root, or another caller filled it first; nothing is reused and the engine builds.
        Write-Verbose "No build reused: the build root $root could not be swapped ($($_.Exception.Message))"
        if ($null -ne $old -and -not [System.IO.Directory]::Exists($root) -and [System.IO.Directory]::Exists($old)) {
            [System.IO.Directory]::Move($old, $root)
            $old = $null
        }
        if ([System.IO.Directory]::Exists($stagingRoot)) {
            [System.IO.Directory]::Delete($stagingRoot, $true)
        }
        return $null
    }

    foreach ($leftover in $old, $stagingRoot) {
        if ($leftover -and [System.IO.Directory]::Exists($leftover)) {
            try {
                [System.IO.Directory]::Delete($leftover, $true)
            }
            catch [System.IO.IOException], [System.UnauthorizedAccessException] {
                Write-Verbose "Left $leftover for the next caller ($($_.Exception.Message))"
            }
        }
    }
    $record
}
