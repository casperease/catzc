<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
---
#>

<#
.SYNOPSIS
    Quality gate: every member of a pipeline-bound globset matches one of its ADO trigger include patterns.
.DESCRIPTION
    An include-only ADO trigger must be a superset of exact membership, so it can over-trigger but never miss a deploy.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-glob-set-trigger-coverage/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; GlobSets }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-GlobSetTriggerCoverage
#>
function Test-GlobSetTriggerCoverage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
