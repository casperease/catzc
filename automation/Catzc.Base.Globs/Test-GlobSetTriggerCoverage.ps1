<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
    kind: gate-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
  config:
    synopsis: 'Quality gate: every member of a pipeline-bound globset matches one of its ADO trigger include patterns.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
      native-trigger projection of the real tree
      ([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)). Its safety property: every
      member of a pipeline-bound set matches at least one ADO include pattern (Get-GlobSetTrigger), so an ADO
      include-only trigger is always a SUPERSET of exact membership and can never under-trigger (miss a deploy); the
      in-pipeline Test-GlobSetAffected check supplies exactness on top. Each uncovered member is an issue. (GitHub is exact
      by construction: its ordered '!'-negation paths are the scan program itself.)

      Whether a pipeline file declares the projected trigger is a separate quality gate (Test-AdoPipelineTriggerGlob).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-glob-set-trigger-coverage/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; GlobSets }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-GlobSetTriggerCoverage
---
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
