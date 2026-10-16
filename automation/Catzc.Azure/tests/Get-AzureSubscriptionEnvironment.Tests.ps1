<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
    folder: tests
    name: get-azure-subscription-environment-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{4,19}
---
#>

Describe 'Get-AzureSubscriptionEnvironment' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'resolves the nonprod identity env (nsub) for a nonprod subscription' {
        Get-AzureSubscriptionEnvironment core_lower | Should -Be 'nsub'
        Get-AzureSubscriptionEnvironment acme_lower | Should -Be 'nsub'
    }

    It 'resolves the prod identity env (psub) for a prod subscription' {
        Get-AzureSubscriptionEnvironment core_upper | Should -Be 'psub'
        Get-AzureSubscriptionEnvironment acme_upper | Should -Be 'psub'
    }

    It 'resolves the identity env of a single-subscription that serves all standard envs' {
        # cross_shared serves all standard envs + psub as its one identity env.
        Get-AzureSubscriptionEnvironment cross_shared | Should -Be 'psub'
    }

    It 'rejects an unknown subscription via ValidateScript' {
        { Get-AzureSubscriptionEnvironment nonexistent } | Should -Throw
    }
}
