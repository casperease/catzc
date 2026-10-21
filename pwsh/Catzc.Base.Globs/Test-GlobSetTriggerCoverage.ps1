<#
---
catzc:
  immutable:
    with_body_sha: "79270ea4a3b4"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
    docs: "[Test-GlobSetTriggerCoverage.ps1.md](docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-FLOW-CD-GLOBS-NATIVEPATHFILTER
---
#>

function Test-GlobSetTriggerCoverage {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $boundSets = @(Get-GlobSet | Where-Object Pipeline | ForEach-Object Name)
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $boundSets) {
        $includes = @(foreach ($pattern in (Get-GlobSetTrigger -Name $name).AdoInclude) {
                [Catzc.Base.Globs.GlobPattern]::new($pattern)
            })
        foreach ($member in (Get-GlobSetFile -Name $name)) {
            $covered = $false
            foreach ($include in $includes) {
                if ($include.Matches($member)) {
                    $covered = $true
                    break
                }
            }
            if (-not $covered) {
                $issues.Add("${name}: member $member matches no ADO include pattern — the include-only trigger would miss it")
            }
        }
    }

    Write-QualityGateReport -Subject 'glob-set-trigger-coverage' -Title 'Test-GlobSetTriggerCoverage' -Issues $issues `
        -Facts ([ordered]@{ GlobSets = $boundSets.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
