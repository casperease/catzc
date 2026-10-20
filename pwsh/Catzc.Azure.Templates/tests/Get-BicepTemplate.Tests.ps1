<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
    folder: tests
    name: get-bicep-template-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-BicepTemplate.Tests.ps1.md](docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SAFESEAMSWAPS
      - ADR-AUTO-TEST-SETUPONCE
---
#>

Describe 'Get-BicepTemplate' -Tag 'L0', 'logic' {
    BeforeAll {
        # Discover from the test fixtures, never the shipped infrastructure/templates.
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModulesRoot) 'Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModulesRoot) "Catzc.Azure.Templates/tests/assets/config/$Config.yml"
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
