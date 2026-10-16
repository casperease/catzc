<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md
      source: automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1
    adrs:
      - ADR-AUTO-TEST#{4,19}
---
#>

Describe 'Get-BicepTemplate' -Tag 'L0', 'logic' {
    BeforeAll {
        # Discover from the test fixtures, never the shipped infrastructure/templates.
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the sample template by name' {
        $t = Get-BicepTemplate sample
        $t.name | Should -Be 'sample'
        $t.main | Should -BeLike '*main.bicep'
    }

    It 'rejects an unknown template name via ValidateScript' {
        { Get-BicepTemplate nonexistent } | Should -Throw
    }
}
