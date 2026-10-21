<#
---
catzc:
  immutable:
    with_body_sha: "21fc89d72a90"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
    docs: "[Get-RepositoryGuids.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md)"
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
