<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
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
    Quality gate: checks each ADO pipeline's trigger path filters against its globset's projection — the
    trigger-drift quality gate.
.DESCRIPTION
    Filters compare as sets, since ADO path filters are order-independent; a missing pipeline file is an issue too.
    [comment:1](/docs/references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md#comment1)
.PARAMETER Name
    The globset(s) to check — a declared, pipeline-bound name. Omit for every pipeline-bound globset.
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-ado-pipeline-trigger-glob).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Pipelines } instead of throwing.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-AdoPipelineTriggerGlob
.EXAMPLE
    (Test-AdoPipelineTriggerGlob -Name gadget -PassThru).Issues
#>
function Test-AdoPipelineTriggerGlob {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $sets = if ($PSBoundParameters.ContainsKey('Name')) {
        Get-GlobSet -Name $Name
    }
    else {
        @(Get-GlobSet) | Where-Object { $_.Pipeline }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $checked = 0
    foreach ($set in $sets) {
        if (-not $set.Pipeline) {
            continue
        }
        $checked++

        $expected = Get-GlobSetTrigger -GlobSet $set
        $relative = "pipelines/$($set.Pipeline).yaml"
        $path = [System.IO.Path]::Combine($root, 'pipelines', "$($set.Pipeline).yaml")

        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $issues.Add("$($set.Name): pipeline file not found: $relative")
            continue
        }

        $actual = Get-PipelineTrigger -Path $path -Vendor Ado
        $drift = [System.Collections.Generic.List[string]]::new()
        if (-not (Test-GlobListEqual -Reference $expected.AdoInclude -Difference $actual.TriggerInclude)) {
            $drift.Add('trigger.paths.include')
        }
        if (-not (Test-GlobListEqual -Reference $expected.AdoExclude -Difference $actual.TriggerExclude)) {
            $drift.Add('trigger.paths.exclude')
        }
        if (-not (Test-GlobListEqual -Reference $expected.AdoInclude -Difference $actual.PrInclude)) {
            $drift.Add('pr.paths.include')
        }
        if (-not (Test-GlobListEqual -Reference $expected.AdoExclude -Difference $actual.PrExclude)) {
            $drift.Add('pr.paths.exclude')
        }
        if ($drift.Count -gt 0) {
            $issues.Add("$($set.Name): $relative trigger drifted from the globset projection on $($drift -join ', ')")
        }
    }

    Write-QualityGateReport -Subject ado-pipeline-trigger-glob -Title Test-AdoPipelineTriggerGlob -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Pipelines = $checked }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
