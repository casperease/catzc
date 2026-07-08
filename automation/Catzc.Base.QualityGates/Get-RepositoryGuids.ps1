<#
.SYNOPSIS
    Scans every tracked text file for GUID literals and returns one record per occurrence.
.DESCRIPTION
    The repository-wide managed-GUID scanner. It reads the tracked-file universe (Get-GuidScanFiles) and
    matches the canonical hyphenated GUID form only — deliberately never bare 32-hex, which would
    false-positive on hashes (the durable SHAs are 64 hex and unhyphenated, so they never match). Paths
    come back repo-relative (communication form); guids come back lowercase. The managed-guid integrity
    gate asserts every returned guid against the registry (configs/guids.yml), and every registry entry
    against these results.
.OUTPUTS
    One ordered dictionary per occurrence: @{ file; line; guid }.
.EXAMPLE
    Get-RepositoryGuids | Where-Object { -not (Test-ManagedGuid $_.guid) }
    Lists every unregistered GUID occurrence in the repository.
#>
function Get-RepositoryGuids {
    [CmdletBinding()]
    param()

    $files = @(Get-GuidScanFiles)
    $pattern = [regex]::new(
        '\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b',
        [System.Text.RegularExpressions.RegexOptions]::Compiled)

    $ret = foreach ($file in $files) {
        $fullPath = Resolve-RepoPath $file
        # A tracked file may be missing on disk (an unstaged deletion) — nothing to scan.
        if (-not [System.IO.File]::Exists($fullPath)) {
            continue
        }

        # Read the whole file and match once, rather than regex-per-line: a single scan over the text is
        # ~3x faster than N per-line Matches calls (the per-line managed/native transitions dominated).
        # Line numbers are recovered from each match's offset — matches arrive in ascending index order, so
        # one forward cursor counts the newlines between consecutive matches, touching each char at most once.
        $text = [System.IO.File]::ReadAllText($fullPath)
        $lineNumber = 1
        $scanPos = 0
        foreach ($match in $pattern.Matches($text)) {
            while ($scanPos -lt $match.Index) {
                if ($text[$scanPos] -eq "`n") {
                    $lineNumber++
                }
                $scanPos++
            }
            [ordered]@{
                file = $file
                line = $lineNumber
                guid = $match.Value.ToLowerInvariant()
            }
        }
    }
    @($ret)
}
