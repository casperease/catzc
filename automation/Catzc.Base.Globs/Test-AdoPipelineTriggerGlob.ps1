<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
  config:
    synopsis: |-
      Quality gate: checks each ADO pipeline's trigger path filters against its globset's projection — the
      trigger-drift quality gate.
    description: |-
      Answers "do the ADO pipelines have the proper glob trigger setup?": for every pipeline-bound globset, it
      recomputes the vendor-native trigger the set projects to (Get-GlobSetTrigger) and compares it against what
      the bound pipeline file actually declares (Get-PipelineTrigger). Both the `trigger:` and the `pr:` path
      filters must match, on include AND exclude, compared as sets (ADO path filters are order-independent). The
      pipeline is resolved from the globset's `pipeline:` binding: pipelines/<pipeline>.yaml.

      Each drifted pipeline is one issue naming the filters that differ, and a missing pipeline file is one issue;
      the fix for either is "regenerate the pipeline trigger from globs.yml". The gate ends with
      Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
      the report lands in out/test-ado-pipeline-trigger-glob/, and the gate throws once listing every issue (or
      returns the result with -PassThru).
    parameters:
      Name: The globset(s) to check — a declared, pipeline-bound name. Omit for every pipeline-bound globset.
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-ado-pipeline-trigger-glob).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; Pipelines } instead of throwing.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-AdoPipelineTriggerGlob
      - (Test-AdoPipelineTriggerGlob -Name gadget -PassThru).Issues
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
