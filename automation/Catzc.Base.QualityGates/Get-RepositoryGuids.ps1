<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Get-RepositoryGuids.ps1
    name: get-repository-guids
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
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
