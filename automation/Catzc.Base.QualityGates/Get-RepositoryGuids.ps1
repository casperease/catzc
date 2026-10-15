# catzc:
#   path: automation/Catzc.Base.QualityGates/Get-RepositoryGuids.ps1
#   module: Catzc.Base.QualityGates
#   visibility: public

<#
.SYNOPSIS
    Scans every tracked text file for GUID literals and returns one record per occurrence.
.DESCRIPTION
    Only hyphenated GUIDs match, never bare 32-hex, which would false-positive on hashes.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md#comment1)
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

        # One scan over the whole text is about 3x faster than per-line matching, whose managed transitions dominate.
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md#comment2)
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
