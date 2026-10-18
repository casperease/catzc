<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
    name: test-ado-pipeline-trigger-glob
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
---
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
