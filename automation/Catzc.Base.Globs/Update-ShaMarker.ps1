<#
.SYNOPSIS
    Regenerates the committed sha-marker files from the globsets' definitions and durable SHAs
    (ADR-GLOBS:5, ADR-GLOBS:6, ADR-GLOBS:9).
.DESCRIPTION
    For every globset — the declared registry AND the derived module sets (ADR-PROTGLOB:7) — or the named
    ones, recomputes the durable SHA and writes .sha-markers/<name>.yml — the set's canonical definition
    representation plus its sha256 line, LF-terminated, no BOM — only when the content actually changes
    (idempotent). The one file carries both signals: its body changes exactly when the set's configuration
    changes, its sha256 line whenever member content changes. Marker files whose globset no longer exists
    in either name space are removed (one living version — no dead marker files), regardless of -Name. Run
    this after changing any file a globset matches, and commit the marker file together with the change;
    the marker-freshness gate fails a commit that forgets.
.PARAMETER Name
    The globset(s) to regenerate — a declared name or a derived one (module folder, internal module, kebab,
    or reserved infra name). Omit for every globset. Orphan removal always considers both full name spaces.
.PARAMETER PassThru
    Return the per-file report objects (Name, Status Written|Unchanged|Removed, Hash, Path).
.EXAMPLE
    Update-ShaMarker
.EXAMPLE
    Update-ShaMarker -Name automation, Catzc.Base.Globs -PassThru
#>
function Update-ShaMarker {
    [CmdletBinding()]
    param(
        [ArgumentCompleter({ @((Get-Config -Config globs).Names) + @((Get-ModuleGlobSet).Name) })]
        [string[]] $Name,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $markersDir = [System.IO.Path]::Combine($root, '.sha-markers')
    if (-not [System.IO.Directory]::Exists($markersDir)) {
        [void][System.IO.Directory]::CreateDirectory($markersDir)
    }

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

    $report = [System.Collections.Generic.List[object]]::new()
    $noBomUtf8 = [System.Text.UTF8Encoding]::new($false)

    foreach ($set in $sets) {
        $hash = Get-GlobSetHash -GlobSet $set
        $path = [System.IO.Path]::Combine($root, $set.MarkerPath)
        $content = $set.MarkerContent($hash)
        $current = if ([System.IO.File]::Exists($path)) {
            [System.IO.File]::ReadAllText($path)
        }
        else {
            $null
        }

        if ($current -ceq $content) {
            $status = 'Unchanged'
        }
        else {
            [System.IO.File]::WriteAllText($path, $content, $noBomUtf8)
            $status = 'Written'
            Write-Message "Marker '$($set.Name)': $($hash.Substring(0, 8)) -> $($set.MarkerPath)"
        }
        $report.Add([pscustomobject]@{ Name = $set.Name; Status = $status; Hash = $hash; Path = $set.MarkerPath })
    }

    # Orphans: a marker file with no globset — declared or derived — is dead state; remove it (README and
    # friends are untouched).
    foreach ($file in [System.IO.Directory]::EnumerateFiles($markersDir, '*.yml')) {
        $orphanName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        if (-not $validNames.Contains($orphanName)) {
            [System.IO.File]::Delete($file)
            Write-Message "Marker '$orphanName': removed (no such globset)"
            $report.Add([pscustomobject]@{ Name = $orphanName; Status = 'Removed'; Hash = $null; Path = ".sha-markers/$orphanName.yml" })
        }
    }

    if ($PassThru) {
        $report
    }
}
