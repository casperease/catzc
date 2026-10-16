<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
    folder: tests
    name: get-bicep-resource-group-name-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{4,19}
---
#>

Describe 'Get-BicepResourceGroupName' -Tag 'L0', 'logic' {
    BeforeAll {
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

    It 'derives env-region-org-short-rg for a base slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample -Environment alpha } |
            Should -Be 'alpha-weu-tst-smpl-rg'
    }

    It 'includes the slot for a special slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample-indexed -Environment alpha -Slot 001 } |
            Should -Be 'alpha-001-weu-tst-sidx-rg'
    }

    It 'includes the customer (readable key) for a per-customer RG' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample-customer -Environment alpha -Customer acme } |
            Should -Be 'alpha-weu-tst-scus-acme-rg'
    }
}
