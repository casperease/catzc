<#
.SYNOPSIS
    Compares every sha-marker file against its globset's recomputed content — the freshness query.
.DESCRIPTION
    The non-throwing query behind the marker-freshness gate (ADR-GLOBS:6, ADR-GLOBS:9): recomputes each
    globset's marker content — the canonical definition representation plus the durable SHA — for the
    declared registry AND the derived module sets (ADR-PROTGLOB:7), and reports one status object per
    globset — Fresh (file matches), Stale (file differs, in its definition body or its sha256 line), or
    Missing (no file) — plus one Orphaned entry per .sha-markers/*.yml with no globset in either name
    space. A commit is clean exactly when every status is Fresh; anything else means "run Update-ShaMarker
    and commit the result".
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
        # The gate checks only the committed marker (scan + scoped_sha256 + sha256) — never the gitignored
        # companion — so it needs the tracked members only, no untracked-tree scan.
        $members = Get-GlobSetMember -GlobSet $set
        $scopedSha = [Catzc.Base.Globs.DurableHash]::HashPathList([string[]] $members)
        $hash = Get-GlobSetHash -GlobSet $set
        $expected = $set.MarkerContent($scopedSha, $hash)
        $path = [System.IO.Path]::Combine($root, $set.MarkerPath)
        $actual = $null
        $status = 'Missing'
        if ([System.IO.File]::Exists($path)) {
            $actual = [System.IO.File]::ReadAllText($path)
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
        foreach ($file in [System.IO.Directory]::EnumerateFiles($markersDir, '*.yml')) {
            # Companions '<name>.files.yml' are gitignored, ungated artifacts — not markers; never orphan-check
            # them (they are removed with their marker by Update-ShaMarker).
            if ($file.EndsWith('.files.yml')) {
                continue
            }
            $orphanName = [System.IO.Path]::GetFileNameWithoutExtension($file)
            if (-not $validNames.Contains($orphanName)) {
                [pscustomobject]@{
                    Name     = $orphanName
                    Status   = 'Orphaned'
                    Expected = $null
                    Actual   = [System.IO.File]::ReadAllText($file)
                    Path     = ".sha-markers/$orphanName.yml"
                }
            }
        }
    }
}
