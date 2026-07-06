<#
.SYNOPSIS
    Returns the repo-relative tracked files the managed-GUID scan reads — the scan's file universe.
.DESCRIPTION
    Tracked files (git ls-files — the same matching universe as the globsets, ADR-GLOBS:4), minus what the
    scan must not read: vendored third-party code (automation/.vendor/), the committed compiled assembly
    (automation/.compiled/), known binary extensions, and the registry file itself — configs/guids.yml is
    the definition of the managed set, not a reference to it, and excluding it is what keeps the liveness
    check honest. The one place this scan shells to git; a logic test mocks this seam (returning absolute
    fixture paths, which Resolve-RepoPath passes through unchanged).
#>
function Get-GuidScanFiles {
    [CmdletBinding()]
    param()

    $result = Invoke-Executable 'git -c core.quotepath=off ls-files' -PassThru -Silent
    $tracked = $result.Output -split "`r?`n" | Where-Object { $_ -ne '' }

    $binaryExtensions = @('.dll', '.exe', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.gz', '.zip', '.pdf', '.woff', '.woff2', '.ttf')
    $registryFile = 'automation/Catzc.Base.QualityGates/configs/guids.yml'

    foreach ($file in $tracked) {
        if ($file.StartsWith('automation/.vendor/')) {
            continue
        }
        if ($file.StartsWith('automation/.compiled/')) {
            continue
        }
        if ($file -eq $registryFile) {
            continue
        }
        $extension = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
        if ($extension -in $binaryExtensions) {
            continue
        }
        $file
    }
}
