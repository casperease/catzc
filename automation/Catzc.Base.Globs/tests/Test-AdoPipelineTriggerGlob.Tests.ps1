# Test-AdoPipelineTriggerGlob (drift detection): the pipeline's actual trigger vs the globset's projection,
# compared as sets (ADO path filters are order-independent). Match / Drift / Missing.
Describe 'Test-AdoPipelineTriggerGlob' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot { 'X:/repo' } -ModuleName Catzc.Base.Globs
    }

    It 'reports Drift when the pipeline include differs from the projection' {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{ 'gadget' = @{ description = 'g'; layer = 'deployable-unit'; pipeline = 'cd-gadget'; include = @('lib/**') } }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Test-Path { $true } -ModuleName Catzc.Base.Globs
        Mock Get-PipelineTrigger {
            [pscustomobject]@{ TriggerInclude = @('lib/**', 'oops/**'); TriggerExclude = @(); PrInclude = @('lib/**', 'oops/**'); PrExclude = @() }
        } -ModuleName Catzc.Base.Globs

        $status = Test-AdoPipelineTriggerGlob -Name gadget
        $status.Status | Should -Be 'Drift'
        $status.Detail | Should -Match 'trigger.paths.include'
    }

    It 'reports Match when the trigger equals the projection (order-independent include/exclude)' {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{ 'gadget' = @{ description = 'g'; layer = 'deployable-unit'; pipeline = 'cd-gadget'; include = @('lib/**'); exclude = @('lib/gen/**') } }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Test-Path { $true } -ModuleName Catzc.Base.Globs
        Mock Get-PipelineTrigger {
            [pscustomobject]@{ TriggerInclude = @('lib/**'); TriggerExclude = @('lib/gen/**'); PrInclude = @('lib/**'); PrExclude = @('lib/gen/**') }
        } -ModuleName Catzc.Base.Globs

        (Test-AdoPipelineTriggerGlob -Name gadget).Status | Should -Be 'Match'
    }

    It 'reports Missing when the bound pipeline file does not exist' {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{ 'gadget' = @{ description = 'g'; layer = 'deployable-unit'; pipeline = 'cd-gadget'; include = @('lib/**') } }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Test-Path { $false } -ModuleName Catzc.Base.Globs

        (Test-AdoPipelineTriggerGlob -Name gadget).Status | Should -Be 'Missing'
    }
}
