<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
    kind: test
---
#>

# Test-AdoPipelineTriggerGlob is a quality gate
# ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35), drift detection): each pipeline's
# actual trigger vs its globset's projection, compared as sets (ADO path filters are order-independent). A drifted
# or missing pipeline is one issue; the report goes to $TestDrive.
Describe 'Test-AdoPipelineTriggerGlob' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot { 'X:/repo' } -ModuleName Catzc.Base.Globs
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'gadget' = @{ description = 'g'; layer = 'deployable-unit'; pipeline = 'cd-gadget'; include = @('lib/**'); exclude = @('lib/gen/**') }
                    'widget' = @{ description = 'w'; layer = 'deployable-unit'; pipeline = 'cd-widget'; include = @('src/**') }
                }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Test-Path { $true } -ModuleName Catzc.Base.Globs
    }

    It 'passes when every trigger equals its projection (order-independent include/exclude)' -Tag 'ADR-AUTO-TEST#35' {
        Mock Get-PipelineTrigger -ParameterFilter { $Path -like '*cd-gadget.yaml' } {
            [pscustomobject]@{ TriggerInclude = @('lib/**'); TriggerExclude = @('lib/gen/**'); PrInclude = @('lib/**'); PrExclude = @('lib/gen/**') }
        } -ModuleName Catzc.Base.Globs
        Mock Get-PipelineTrigger -ParameterFilter { $Path -like '*cd-widget.yaml' } {
            [pscustomobject]@{ TriggerInclude = @('src/**'); TriggerExclude = @(); PrInclude = @('src/**'); PrExclude = @() }
        } -ModuleName Catzc.Base.Globs

        { Test-AdoPipelineTriggerGlob -OutputFolder (Join-Path $TestDrive 'ado') } | Should -Not -Throw
    }

    It 'throws once listing every drifted and missing pipeline' -Tag 'ADR-AUTO-TEST#35' {
        Mock Test-Path -ParameterFilter { $LiteralPath -like '*cd-widget.yaml' } { $false } -ModuleName Catzc.Base.Globs
        Mock Get-PipelineTrigger {
            [pscustomobject]@{ TriggerInclude = @('lib/**', 'oops/**'); TriggerExclude = @('lib/gen/**'); PrInclude = @('lib/**'); PrExclude = @('lib/gen/**') }
        } -ModuleName Catzc.Base.Globs

        $thrown = { Test-AdoPipelineTriggerGlob -OutputFolder (Join-Path $TestDrive 'ado') } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-AdoPipelineTriggerGlob failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -Match 'gadget: pipelines/cd-gadget\.yaml trigger drifted .* on trigger\.paths\.include'
        $thrown.Exception.Message | Should -Match 'widget: pipeline file not found: pipelines/cd-widget\.yaml'
    }

    It 'names every drifted filter of a pipeline under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        Mock Get-PipelineTrigger {
            [pscustomobject]@{ TriggerInclude = @('lib/**'); TriggerExclude = @(); PrInclude = @('other/**'); PrExclude = @('lib/gen/**') }
        } -ModuleName Catzc.Base.Globs

        $result = Test-AdoPipelineTriggerGlob -Name gadget -PassThru -OutputFolder (Join-Path $TestDrive 'ado')
        $result.Subject | Should -Be 'ado-pipeline-trigger-glob'
        $result.Pipelines | Should -Be 1
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike '*on trigger.paths.exclude, pr.paths.include'
    }
}
