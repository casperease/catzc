<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{8,26}
      - ADR-PWSH-PESTER#2
---
#>

Describe 'Build-Bicep (walking skeleton — real az)' -Tag 'L2', 'logic', 'greedy' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
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

    AfterEach {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'real az bicep build compiles a multi-slot template to main.json (sample-customer)' {
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-customer'
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-customer | Out-Null
        Join-Path $script:outputRoot 'main.json' | Should -Exist
    }

    It 'a subscription-scoped template compiles end-to-end (targetScope = subscription) (sample-subscription)' {
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-subscription'
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-subscription -Environments alpha | Out-Null
        # The subscription-scope compile is the concern; main.json proves it compiled. Parameter rendering is L0.
        Join-Path $script:outputRoot 'main.json' | Should -Exist
    }

    It 'real az inlines a local reusable module into main.json (sample-with-module)' {
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-with-module'
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-with-module -Environments alpha | Out-Null
        $mainJson = Join-Path $script:outputRoot 'main.json'
        $mainJson | Should -Exist
        # Only the real compiler resolves + inlines the reusable module's storage resource into the template.
        (Get-Content $mainJson -Raw) | Should -Match 'Microsoft.Storage/storageAccounts'
    }
}
