function Get-TestDiscoveryCache {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $cache = @{}
    if (-not [System.IO.File]::Exists($Path)) {
        return $cache
    }
    try {
        $parsed = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json -AsHashtable
    }
    catch {
        Write-Message "Ignoring an unreadable test discovery cache at '$Path': $($_.Exception.Message)"
        return $cache
    }
    if ($parsed -isnot [System.Collections.IDictionary]) {
        return $cache
    }
    foreach ($key in @($parsed.Keys)) {
        $entry = $parsed[$key]
        if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('blocks') -and $entry.Contains('tests')) {
            $cache[[string]$key] = $entry
        }
    }
    $cache
}
