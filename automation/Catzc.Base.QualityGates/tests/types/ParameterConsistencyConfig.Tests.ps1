<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/ParameterConsistencyConfig.Tests.ps1
    kind: test
---
#>

Describe 'ParameterConsistencyConfig' -Tag 'L0' {
    Context 'integrity (shipped parameter-consistency.yml)' -Tag 'integrity' {
        It 'loads, and gives every exempt name a reason' {
            $config = Get-Config -Config parameter-consistency
            $config | Should -BeOfType [Catzc.Base.QualityGates.ParameterConsistencyConfig]
            @($config.exempt.Values | Where-Object { [string]::IsNullOrWhiteSpace($_) }) | Should -HaveCount 0
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'reads the exempt names with their reasons, matching a name case-insensitively' {
            $config = [Catzc.Base.QualityGates.ParameterConsistencyConfig]::new([ordered]@{ exempt = [ordered]@{ Kind = 'widget kinds differ' } })
            $config.exempt['Kind'] | Should -Be 'widget kinds differ'
            $config.IsExempt('kind') | Should -BeTrue
            $config.IsExempt('Count') | Should -BeFalse
        }

        It 'exempts nothing for an empty file' {
            [Catzc.Base.QualityGates.ParameterConsistencyConfig]::new([ordered]@{}).exempt.Count | Should -Be 0
        }

        It 'throws on an unknown key, a dashed name, an empty reason, and an exempt that is not a map' {
            $err = { [Catzc.Base.QualityGates.ParameterConsistencyConfig]::new([ordered]@{ widget = 1; exempt = [ordered]@{ '-Kind' = 'x'; Count = ' ' } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'widget'*"
            $err.Exception.Message | Should -BeLike "*invalid parameter name '-Kind'*"
            $err.Exception.Message | Should -BeLike '*exempt.Count needs the reason*'
            { [Catzc.Base.QualityGates.ParameterConsistencyConfig]::new([ordered]@{ exempt = @('Kind') }) } | Should -Throw '*exempt must be a map*'
        }
    }
}
