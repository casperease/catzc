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

        $lineNumber = 0
        foreach ($line in [System.IO.File]::ReadLines($fullPath)) {
            $lineNumber++
            foreach ($match in $pattern.Matches($line)) {
                [ordered]@{
                    file = $file
                    line = $lineNumber
                    guid = $match.Value.ToLowerInvariant()
                }
            }
        }
    }
    @($ret)
}
