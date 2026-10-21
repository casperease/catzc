<#
---
catzc:
  immutable:
    with_body_sha: "63c6600907cd"
  edges:
    docs: "[Get-BicepTemplateSlots.Tests.ps1.md](../../../docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md)"
    code: pwsh/Catzc.Azure.Templates/Get-BicepTemplateSlots.ps1
    cites:
      - ADR-AUTO-TEST-SAFESEAMSWAPS
      - ADR-AUTO-TEST-SETUPONCE
---
#>

Describe 'Get-BicepTemplateSlots' -Tag 'L0', 'logic' {
    BeforeAll {
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

    It 'returns the non-empty slot discriminators for a template' {
        $slots = Get-BicepTemplateSlots 'sample-indexed'
        $slots | Should -Contain '001'
        $slots | Should -Contain '002'
        foreach ($s in $slots) {
            $s | Should -BeOfType [string]
        }
    }

    It 'returns an empty array for a template with only base slots' {
        # `sample` ships alpha.yml / beta.yml (base slots, empty discriminator) -> nothing to offer.
        @(Get-BicepTemplateSlots 'sample') | Should -BeNullOrEmpty
    }

    It 'filters to a single environment when -Environment is given' {
        @(Get-BicepTemplateSlots 'sample-indexed' -Environment 'alpha') | Sort-Object |
            Should -Be @('001', '002')
        @(Get-BicepTemplateSlots 'sample-indexed' -Environment 'beta') | Should -BeNullOrEmpty
    }

    It 'filters slots by customer (omitted = configuration-root slots only)' {
        @(Get-BicepTemplateSlots 'sample-customer') | Should -BeNullOrEmpty
        @(Get-BicepTemplateSlots 'sample-customer' -Customer 'acme') | Should -Be @('001')
    }

    It 'returns an empty array (never throws) for an unknown template' {
        @(Get-BicepTemplateSlots 'does-not-exist') | Should -BeNullOrEmpty
    }

    It 'returns an empty array (never throws) when -Template is omitted' {
        @(Get-BicepTemplateSlots) | Should -BeNullOrEmpty
        @(Get-BicepTemplateSlots '') | Should -BeNullOrEmpty
    }
}

Describe 'Slot ArgumentCompleter wiring' -Tag 'L0', 'logic' {
    BeforeAll {
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

    $commands = @(
        'Deploy-Bicep'
        'Get-BicepResourceName'
        'Get-BicepDeploymentName'
        'Get-BicepDeploymentContext'
        'Get-BicepTemplateConfiguration'
        'Set-BicepTrackingTagSet'
    )

    It '<_> has an ArgumentCompleter on -Slot that returns the template slots' -ForEach $commands {
        $attr = (Get-Command $_).Parameters['Slot'].Attributes |
            Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] }
        $attr | Should -Not -BeNullOrEmpty

        # Invoke the completer the way PowerShell would: (cmd, param, word, ast, fakeBoundParameters).
        $results = & $attr.ScriptBlock $null 'Slot' '' $null @{ Template = 'sample-indexed' }
        @($results) | Should -Contain '001'
        @($results) | Should -Contain '002'
    }

    It 'degrades quietly when no -Template is bound yet' {
        $attr = (Get-Command 'Deploy-Bicep').Parameters['Slot'].Attributes |
            Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] }
        $results = & $attr.ScriptBlock $null 'Slot' '' $null @{}
        @($results) | Should -BeNullOrEmpty
    }
}
