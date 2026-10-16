<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Get-RepositoryGuids.ps1
    name: get-repository-guids
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
  config:
    synopsis: Scans every tracked text file for GUID literals and returns one record per occurrence.
    description: |-
      The repository-wide managed-GUID scanner. It reads the tracked-file universe (Get-GuidScanFiles) and
      matches the canonical hyphenated GUID form only — deliberately never bare 32-hex, which would
      false-positive on hashes (the durable SHAs are 64 hex and unhyphenated, so they never match). Paths
      come back repo-relative (communication form); guids come back lowercase. The managed-guid quality
      gate (Test-ManagedGuids) asserts every returned guid against the registry (configs/guids.yml), and every
      registry entry against these results.
    outputs: 'One ordered dictionary per occurrence: @{ file; line; guid }.'
    examples:
      - |-
        Get-RepositoryGuids | Where-Object { -not (Test-ManagedGuid $_.guid) }
        Lists every unregistered GUID occurrence in the repository.
---
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
