<#
.SYNOPSIS
    Compares every sha-marker file and .globset companion against its globset — the freshness query.
.DESCRIPTION
    The non-throwing query behind the marker-freshness gate (ADR-GLOBS:6, ADR-GLOBS:9): recomputes each
    globset's durable SHA and canonical definition representation — the declared registry AND the derived
    module sets (ADR-PROTGLOB:7) — and reports one status object per file — Fresh (file matches), Stale
    (file differs), or Missing (no file) — a marker row and a companion row per globset, plus one Orphaned
    entry per .sha-markers/*.sha256 or *.globset with no globset in either name space. A commit is clean
    exactly when every status is Fresh; anything else means "run Update-ShaMarker and commit the result".
.PARAMETER Name
    The globset(s) to check — a declared name or a derived one (module folder, internal module, kebab, or
    reserved infra name). Omit for every globset. Orphan detection always runs against both full name
    spaces, regardless of -Name.
.EXAMPLE
    Test-ShaMarker
.EXAMPLE
    (Test-ShaMarker | Where-Object Status -NE 'Fresh').Count -eq 0
#>
function Test-ShaMarker {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ArgumentCompleter({ @((Get-Config -Config globs).Names) + @((Get-ModuleGlobSet).Name) })]
        [string[]] $Name
    )

    $root = Get-RepositoryRoot
    $config = Get-Config -Config globs
    $derived = @(Get-ModuleGlobSet)
    $sets = if ($PSBoundParameters.ContainsKey('Name')) {
        foreach ($setName in $Name) {
            if ($config.Contains($setName)) {
                $config.Get($setName)
            }
            else {
                Get-ModuleGlobSet -Name $setName
            }
        }
    }
    else {
        @(Get-GlobSet) + $derived
    }

    $validNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($declaredName in $config.Names) {
        [void]$validNames.Add($declaredName)
    }
    foreach ($derivedSet in $derived) {
        [void]$validNames.Add($derivedSet.Name)
    }

    foreach ($set in $sets) {
        $expected = Get-GlobSetHash -GlobSet $set
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

        # The definition companion (ADR-GLOBS:9): compared against the set's canonical representation.
        $companionPath = [System.IO.Path]::Combine($root, $set.GlobSetPath)
        $companionExpected = $set.Representation
        $companionActual = $null
        $companionStatus = 'Missing'
        if ([System.IO.File]::Exists($companionPath)) {
            $companionActual = [System.IO.File]::ReadAllText($companionPath)
            $companionStatus = if ($companionActual -ceq $companionExpected) {
                'Fresh'
            }
            else {
                'Stale'
            }
        }
        [pscustomobject]@{
            Name     = $set.Name
            Status   = $companionStatus
            Expected = $companionExpected
            Actual   = $companionActual
            Path     = $set.GlobSetPath
        }
    }

    $markersDir = [System.IO.Path]::Combine($root, '.sha-markers')
    if ([System.IO.Directory]::Exists($markersDir)) {
        foreach ($extension in '*.sha256', '*.globset') {
            foreach ($file in [System.IO.Directory]::EnumerateFiles($markersDir, $extension)) {
                $orphanName = [System.IO.Path]::GetFileNameWithoutExtension($file)
                if (-not $validNames.Contains($orphanName)) {
                    [pscustomobject]@{
                        Name     = $orphanName
                        Status   = 'Orphaned'
                        Expected = $null
                        Actual   = [System.IO.File]::ReadAllText($file).Trim()
                        Path     = ".sha-markers/$([System.IO.Path]::GetFileName($file))"
                    }
                }
            }
        }
    }
}
