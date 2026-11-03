function Get-FileDigest {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $digests = [object[]]::new($Path.Count)
    $hashFile = {
        param([string] $RelativePath)
        [Catzc.Base.Globs.DurableHash]::HashFile([System.IO.Path]::Combine($RepositoryRoot, $RelativePath))
    }
    $hashAll = {
        for ($position = 0; $position -lt $Path.Count; $position++) {
            $digests[$position] = & $hashFile $Path[$position]
        }
        , $digests
    }
    if ($Path.Count -eq 0) {
        return , $digests
    }

    $git = 'git --no-optional-locks -c core.quotepath=off'
    $listing = Invoke-Executable "$git ls-files -s" -WorkingDirectory $RepositoryRoot -PassThru -Silent -NoAssert
    $modified = Invoke-Executable "$git ls-files -m" -WorkingDirectory $RepositoryRoot -PassThru -Silent -NoAssert
    if ($listing.ExitCode -ne 0 -or $modified.ExitCode -ne 0) {
        return & $hashAll
    }

    # An object id vouches for a file only at stage 0, for a regular file, and while the work tree still matches the index.
    $ordinal = [System.StringComparer]::Ordinal
    $trusted = [System.Collections.Generic.Dictionary[string, string]]::new($ordinal)
    $indexKeys = [System.Collections.Generic.HashSet[string]]::new($ordinal)
    foreach ($line in ([string] $listing.Output).Split("`n")) {
        $tab = $line.IndexOf("`t")
        if ($tab -lt 0) {
            continue
        }
        $fields = $line.Substring(0, $tab).Split(' ')
        $entryPath = $line.Substring($tab + 1).TrimEnd("`r")
        if ($fields[2] -ne '0' -or $fields[0] -in '120000', '160000') {
            $trusted.Remove($entryPath) | Out-Null
            continue
        }
        $trusted[$entryPath] = $fields[1]
        [void] $indexKeys.Add("$entryPath|$($fields[1])")
    }
    foreach ($line in ([string] $modified.Output).Split("`n")) {
        $changedPath = $line.TrimEnd("`r")
        if ($changedPath) {
            $trusted.Remove($changedPath) | Out-Null
        }
    }

    $cachePath = Join-Path (Get-OutputRoot) 'cache/file-digests.json'
    $cache = [System.Collections.Generic.Dictionary[string, string]]::new($ordinal)
    if ([System.IO.File]::Exists($cachePath)) {
        try {
            $stored = [System.Text.Json.JsonSerializer]::Deserialize[System.Collections.Generic.Dictionary[string, string]](
                [System.IO.File]::ReadAllText($cachePath))
            if ($null -ne $stored) {
                $cache = [System.Collections.Generic.Dictionary[string, string]]::new($stored, $ordinal)
            }
        }
        catch [System.Text.Json.JsonException] {
            $cache.Clear()
        }
    }

    $changed = $false
    for ($position = 0; $position -lt $Path.Count; $position++) {
        $objectId = $null
        $key = $null
        if ($trusted.TryGetValue($Path[$position], [ref] $objectId)) {
            $key = "$($Path[$position])|$objectId"
        }
        $digest = $null
        if ($key -and $cache.TryGetValue($key, [ref] $digest)) {
            $digests[$position] = $digest
            continue
        }
        $digest = & $hashFile $Path[$position]
        $digests[$position] = $digest
        if ($key -and $null -ne $digest) {
            $cache[$key] = $digest
            $changed = $true
        }
    }

    foreach ($key in @($cache.Keys)) {
        if (-not $indexKeys.Contains($key)) {
            [void] $cache.Remove($key)
            $changed = $true
        }
    }
    if ($changed) {
        $temporary = "$cachePath.$PID.tmp"
        [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($cachePath))
        $json = [System.Text.Json.JsonSerializer]::Serialize[System.Collections.Generic.Dictionary[string, string]](
            $cache, [System.Text.Json.JsonSerializerOptions] $null)
        [System.IO.File]::WriteAllText($temporary, $json)
        [System.IO.File]::Move($temporary, $cachePath, $true)
    }
    , $digests
}
