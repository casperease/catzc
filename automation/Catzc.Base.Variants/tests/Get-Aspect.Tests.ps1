<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Variants/tests/Get-Aspect.Tests.ps1
    folder: tests
    name: get-aspect-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-Aspect' -Tag 'L0', 'logic' {

    It 'defaults to the automation convention (live closed, tests catch-all) when unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{}) }
        $aspects = @(Get-Aspect -Track automation)
        $aspects[0] | Should -BeOfType [Catzc.Base.Variants.VariantAspect]
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Contain 'private/**'
        $aspects[-1].Patterns | Should -Be @('**')          # tests is the non-live catch-all, declared last
    }

    It 'defaults infrastructure to live-as-catch-all (a deployment ships everything but tests/)' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{}) }
        $aspects = @(Get-Aspect -Track infrastructure)
        $aspects.Name | Should -Be @('tests', 'live')
        $aspects[-1].Patterns | Should -Be @('**')          # live is the catch-all for a deployment
    }

    It 'returns a configured track convention in declared order' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } {
            [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ aspects = [ordered]@{ automation = @([ordered]@{ live = @('src/**') }, [ordered]@{ tests = @('**') }) } })
        }
        $aspects = @(Get-Aspect -Track automation)
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Be @('src/**')
    }

    It 'falls back to the automation convention for an unknown track' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{}) }
        (Get-Aspect -Track nonesuch).Name | Should -Be @('live', 'tests')
    }
}
