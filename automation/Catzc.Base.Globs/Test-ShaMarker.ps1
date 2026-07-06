<#
.SYNOPSIS
    Compares every sha-marker file against its globset's recomputed durable SHA — the freshness query.
.DESCRIPTION
    The non-throwing query behind the marker-freshness gate (ADR-GLOBS:6): recomputes each globset's
    durable SHA and reports one status object per globset — Fresh (file matches), Stale (file differs), or
    Missing (no file) — plus one Orphaned entry per .sha-markers/*.sha256 with no globset. A commit is
    clean exactly when every status is Fresh; anything else means "run Update-ShaMarker and commit the
    result".
.PARAMETER Name
    The globset(s) to check. Omit for every globset. Orphan detection always runs against the full registry,
    regardless of -Name.
.EXAMPLE
    Test-ShaMarker
.EXAMPLE
    (Test-ShaMarker | Where-Object Status -NE 'Fresh').Count -eq 0
#>
function Test-ShaMarker {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name
    )

    $root = Get-RepositoryRoot
    $config = Get-Config -Config globs
    $sets = if ($PSBoundParameters.ContainsKey('Name')) {
        Get-GlobSet -Name $Name
    }
    else {
        Get-GlobSet
    }

    foreach ($set in $sets) {
        $expected = Get-GlobSetHash -Name $set.Name
        $path = [System.IO.Path]::Combine($root, $set.MarkerPath)
        $actual = $null
        $status = 'Missing'
        if ([System.IO.File]::Exists($path)) {
            $actual = [System.IO.File]::ReadAllText($path).Trim()
            $status = if ($actual -ceq $expected) {
                'Fresh'
            }
            else {
                'Stale'
            }
        }
        [pscustomobject]@{
            Name     = $set.Name
            Status   = $status
            Expected = $expected
            Actual   = $actual
            Path     = $set.MarkerPath
        }
    }

    $markersDir = [System.IO.Path]::Combine($root, '.sha-markers')
    if ([System.IO.Directory]::Exists($markersDir)) {
        foreach ($file in [System.IO.Directory]::EnumerateFiles($markersDir, '*.sha256')) {
            $orphanName = [System.IO.Path]::GetFileNameWithoutExtension($file)
            if (-not $config.Contains($orphanName)) {
                [pscustomobject]@{
                    Name     = $orphanName
                    Status   = 'Orphaned'
                    Expected = $null
                    Actual   = [System.IO.File]::ReadAllText($file).Trim()
                    Path     = ".sha-markers/$orphanName.sha256"
                }
            }
        }
    }
}
