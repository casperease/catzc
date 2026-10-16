<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#4
---
#>

Describe 'SourceConventionsConfig' -Tag 'L0' {
    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'gives every check its defaults when the file is empty' -Tag 'ADR-AUTO-DEFAULT#6' {
            $config = [Catzc.Base.QualityGates.SourceConventionsConfig]::new([ordered]@{})
            $config.engine_set.IsReport | Should -BeFalse
            $config.neutral_codes.IsReport | Should -BeFalse
            $config.engine_set.name_phrases.Count | Should -Be 0
        }

        It 'maps each check it is given' -Tag 'ADR-PRIN-CONFIG#4' {
            $config = [Catzc.Base.QualityGates.SourceConventionsConfig]::new([ordered]@{
                    engine_set    = [ordered]@{ mode = 'report'; name_phrases = @('{name} and {name}') }
                    neutral_codes = [ordered]@{ exempt = [ordered]@{ 'src/**' = 'widget fixtures' } }
                })
            $config.engine_set.IsReport | Should -BeTrue
            $config.engine_set.name_phrases | Should -Be @('{name} and {name}')
            $config.neutral_codes.IsExempt('src/widget.ps1') | Should -BeTrue
        }

        It 'rejects an unknown key and a check that is not a map' -Tag 'ADR-PRIN-CONFIG#4' {
            { [Catzc.Base.QualityGates.SourceConventionsConfig]::new([ordered]@{ gadget = 1 }) } | Should -Throw "*unknown key 'gadget'*"
            { [Catzc.Base.QualityGates.SourceConventionsConfig]::new([ordered]@{ neutral_codes = 'report' }) } | Should -Throw '*must be a map*'
        }
    }

    Context 'integrity (shipped source-conventions.yml)' -Tag 'L1', 'integrity' {
        It 'loads the shipped source-conventions.yml as a SourceConventionsConfig' -Tag 'ADR-AUTO-DEFAULT#6' {
            Get-Config -Config source-conventions | Should -BeOfType ([Catzc.Base.QualityGates.SourceConventionsConfig])
        }
    }
}
