<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{4,19}
---
#>

Describe 'Get-AzureBicepMinVersion' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate from the shipped azure.yml: resolve identity from the test config fixture.
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the configured bicep_min_version from azure.yml as a [version]' {
        $result = Get-AzureBicepMinVersion
        $result | Should -BeOfType ([version])
        $result | Should -Be ([version]'0.30.0')
    }
}
