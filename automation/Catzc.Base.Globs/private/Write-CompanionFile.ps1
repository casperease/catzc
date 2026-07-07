<#
.SYNOPSIS
    Writes a globset's expanded member list to the transient out/ folder — the human-readable companion to
    its lean marker (ADR-GLOBS:11).
.DESCRIPTION
    Renders `<out>/sha-markers/<name>.files.yml` (out root = Get-OutputRoot — out/ on a devbox, the build
    staging dir in CI): a UTC timestamp, the list-identity SHA, the file count, the scan filter (mirrored from
    the marker so the companion is self-contained), and the FULL `included` list (the git-bound files in the
    package, one line per file). It lives in out/ — transient, gitignored, never committed and never gated —
    so the committed marker stays lean and deterministic (just the count + SHAs) while the full list is one
    `Get-OutputRoot` away when you want to read it. There is no "filtered" half: the marker is bound to the
    committed file names only, and a non-git local fact has no place beside it.
.PARAMETER GlobSet
    The globset the companion belongs to (for the name and the scan filter).
.PARAMETER Resolution
    The result of Get-GlobSetResolution (Included, Count, ScopedSha).
.EXAMPLE
    Write-CompanionFile -GlobSet $set -Resolution (Get-GlobSetResolution -GlobSet $set)
#>
function Write-CompanionFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Globs.GlobSet] $GlobSet,

        [Parameter(Mandatory)]
        [pscustomobject] $Resolution
    )

    $companionDir = [System.IO.Path]::Combine((Get-OutputRoot), 'sha-markers')
    if (-not [System.IO.Directory]::Exists($companionDir)) {
        [void][System.IO.Directory]::CreateDirectory($companionDir)
    }
    $companionPath = [System.IO.Path]::Combine($companionDir, "$($GlobSet.Name).files.yml")

    $timestamp = [System.DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ', [System.Globalization.CultureInfo]::InvariantCulture)
    $stringBuilder = [System.Text.StringBuilder]::new()
    [void]$stringBuilder.Append("generated_at: $timestamp`n")
    [void]$stringBuilder.Append("scoped_sha256: $($Resolution.ScopedSha)`n")
    [void]$stringBuilder.Append("files: $($Resolution.Count)`n")
    [void]$stringBuilder.Append($GlobSet.ScanRepresentation)

    $included = @($Resolution.Included)
    if ($included.Count -eq 0) {
        [void]$stringBuilder.Append("included: []`n")
    }
    else {
        [void]$stringBuilder.Append("included:`n")
        foreach ($path in $included) {
            [void]$stringBuilder.Append("- $path`n")
        }
    }

    $noBomUtf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($companionPath, $stringBuilder.ToString(), $noBomUtf8)
}
