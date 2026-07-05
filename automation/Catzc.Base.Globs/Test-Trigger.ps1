<#
.SYNOPSIS
    Compares every trigger file against its globset's recomputed durable SHA — the freshness query.
.DESCRIPTION
    The non-throwing query behind the trigger-freshness gate (ADR-GLOBS:6): recomputes each globset's
    durable SHA and reports one status object per globset — Fresh (file matches), Stale (file differs), or
    Missing (no file) — plus one Orphaned entry per .triggers/*.sha256 with no globset. A commit is clean
    exactly when every status is Fresh; anything else means "run Update-Trigger and commit the result".
.PARAMETER Name
    The globset(s) to check. Omit for every globset. Orphan detection always runs against the full registry,
    regardless of -Name.
.EXAMPLE
    Test-Trigger
.EXAMPLE
    (Test-Trigger | Where-Object Status -NE 'Fresh').Count -eq 0
#>
function Test-Trigger {
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
        $path = [System.IO.Path]::Combine($root, $set.TriggerPath)
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
            Path     = $set.TriggerPath
        }
    }

    $triggersDir = [System.IO.Path]::Combine($root, '.triggers')
    if ([System.IO.Directory]::Exists($triggersDir)) {
        foreach ($file in [System.IO.Directory]::EnumerateFiles($triggersDir, '*.sha256')) {
            $orphanName = [System.IO.Path]::GetFileNameWithoutExtension($file)
            if (-not $config.Contains($orphanName)) {
                [pscustomobject]@{
                    Name     = $orphanName
                    Status   = 'Orphaned'
                    Expected = $null
                    Actual   = [System.IO.File]::ReadAllText($file).Trim()
                    Path     = ".triggers/$orphanName.sha256"
                }
            }
        }
    }
}
