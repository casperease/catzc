<#
.SYNOPSIS
    Writes a globset's gitignored companion file — the expanded, human-readable resolution beside its
    marker (ADR-GLOBS:11).
.DESCRIPTION
    Renders `.sha-markers/<name>.files.yml`: a UTC timestamp, the two list-identity SHAs, the scan filter
    (mirrored from the marker so the companion is self-contained), the FULL `included` list (git-bound files
    in the package, one line per file), and OPTIONALLY the `filtered` list (non-git files the includes touch
    — what is on disk but NOT in the package). The companion is gitignored, managed, and NOT gated: its
    filtered half is a non-reproducible fact of the local tree.

    Two disciplines:
      - Filtered is capped at 500 entries. Beyond that the list is cut off gracefully, `filtered_truncated:
        true` is emitted, and a red message names the file — the full set is too big to be useful inline.
      - Idempotent under the timestamp: the on-disk companion is compared with its `generated_at:` line
        removed, so an unchanged resolution is not rewritten every import (the importer-budget contract).
.PARAMETER GlobSet
    The globset the companion belongs to (for the name and the scan filter).
.PARAMETER Resolution
    The result of Get-GlobSetResolution (Included, Filtered, ScopedSha, FilteredSha).
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

    $filteredCap = 500
    $root = Get-RepositoryRoot
    $companionPath = [System.IO.Path]::Combine($root, '.sha-markers', "$($GlobSet.Name).files.yml")

    $filtered = @($Resolution.Filtered)
    $truncated = $filtered.Count -gt $filteredCap
    $filteredShown = if ($truncated) { $filtered[0..($filteredCap - 1)] } else { $filtered }

    # Body WITHOUT the timestamp line — the change-compare basis.
    $stringBuilder = [System.Text.StringBuilder]::new()
    [void]$stringBuilder.Append("scoped_sha256: $($Resolution.ScopedSha)`n")
    [void]$stringBuilder.Append("filtered_sha256: $($Resolution.FilteredSha)`n")
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

    if ($filteredShown.Count -gt 0) {
        [void]$stringBuilder.Append("filtered:`n")
        foreach ($path in $filteredShown) {
            [void]$stringBuilder.Append("- $path`n")
        }
        if ($truncated) {
            [void]$stringBuilder.Append("filtered_truncated: true`n")
        }
    }
    $bodyNoStamp = $stringBuilder.ToString()

    # Timestamp-ignoring compare: strip the existing generated_at line and compare the rest.
    $existingBody = $null
    if ([System.IO.File]::Exists($companionPath)) {
        $existingLines = [System.IO.File]::ReadAllLines($companionPath)
        $kept = foreach ($line in $existingLines) {
            if (-not $line.StartsWith('generated_at:')) { $line }
        }
        $existingBody = ($kept -join "`n") + "`n"
    }

    if ($existingBody -ceq $bodyNoStamp) {
        return
    }

    $timestamp = [System.DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ', [System.Globalization.CultureInfo]::InvariantCulture)
    $content = "generated_at: $timestamp`n" + $bodyNoStamp
    $noBomUtf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($companionPath, $content, $noBomUtf8)

    if ($truncated) {
        Write-Message "Companion '$($GlobSet.Name).files.yml': filtered list cut off at $filteredCap of $($filtered.Count) non-git files (too big to hold inline)" -ForegroundColor Red
    }
}
