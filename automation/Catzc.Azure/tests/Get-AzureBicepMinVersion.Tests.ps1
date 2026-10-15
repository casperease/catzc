<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
---
#>

Describe 'Get-AzureBicepMinVersion' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is identical...
    # [comment:1](/docs/references/automation/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md#comment1)
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
