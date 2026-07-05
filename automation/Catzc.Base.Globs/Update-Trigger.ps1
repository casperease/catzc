<#
.SYNOPSIS
    Regenerates the committed trigger files from the globsets' durable SHAs (ADR-GLOBS:5, ADR-GLOBS:6).
.DESCRIPTION
    For every globset (or the named ones), recomputes the durable SHA and writes .triggers/<name>.sha256 —
    exactly one line, the 64-hex-lowercase digest plus a trailing LF, no BOM — only when the content
    actually changes (idempotent). Trigger files whose globset no longer exists are removed (one living
    version — no dead trigger files), regardless of -Name. Run this after changing any file a globset
    matches, and commit the trigger file together with the change; the trigger-freshness gate fails a
    commit that forgets.
.PARAMETER Name
    The globset(s) to regenerate. Omit for every globset. Orphan removal always considers the full registry.
.PARAMETER PassThru
    Return the per-file report objects (Name, Status Written|Unchanged|Removed, Hash, Path).
.EXAMPLE
    Update-Trigger
.EXAMPLE
    Update-Trigger -Name automation -PassThru
#>
function Update-Trigger {
    [CmdletBinding()]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $triggersDir = [System.IO.Path]::Combine($root, '.triggers')
    if (-not [System.IO.Directory]::Exists($triggersDir)) {
        [void][System.IO.Directory]::CreateDirectory($triggersDir)
    }

    $config = Get-Config -Config globs
    $sets = if ($PSBoundParameters.ContainsKey('Name')) {
        Get-GlobSet -Name $Name
    }
    else {
        Get-GlobSet
    }

    $report = [System.Collections.Generic.List[object]]::new()
    $noBomUtf8 = [System.Text.UTF8Encoding]::new($false)

    foreach ($set in $sets) {
        $hash = Get-GlobSetHash -Name $set.Name
        $path = [System.IO.Path]::Combine($root, $set.TriggerPath)
        $content = "$hash`n"
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
            Write-Message "Trigger '$($set.Name)': $($hash.Substring(0, 8)) -> $($set.TriggerPath)"
        }
        $report.Add([pscustomobject]@{ Name = $set.Name; Status = $status; Hash = $hash; Path = $set.TriggerPath })
    }

    # Orphans: a trigger file with no globset is dead state — remove it (README and friends are untouched).
    foreach ($file in [System.IO.Directory]::EnumerateFiles($triggersDir, '*.sha256')) {
        $orphanName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        if (-not $config.Contains($orphanName)) {
            [System.IO.File]::Delete($file)
            Write-Message "Trigger '$orphanName': removed (no such globset)"
            $report.Add([pscustomobject]@{ Name = $orphanName; Status = 'Removed'; Hash = $null; Path = ".triggers/$orphanName.sha256" })
        }
    }

    if ($PassThru) {
        $report
    }
}
