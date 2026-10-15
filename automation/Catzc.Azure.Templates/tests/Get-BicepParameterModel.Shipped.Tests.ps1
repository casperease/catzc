<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#17
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#37
      - ADR-AUTO-TEST#8
      - ADR-AZ-DATAMOD#9
      - ADR-PWSH-PESTER#2
---
#>

# L2 integrity for the SHIPPED bicep templates' parameter contract: every template is built with the real `az bicep...
# [comment:1](/docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md#comment1)
BeforeDiscovery {
    $script:templateNames = @(Get-BicepTemplateNames)
}

Describe 'Shipped template parameter model' -Tag 'L2', 'integrity', 'greedy', 'ADR-AZ-DATAMOD#9', 'ADR-AUTO-TEST#37' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates

        # The Bicep CLI is verified once here for the whole template set, not once per Build-Bicep call: each probe...
        # [comment:2](/docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md#comment2)
        if (Get-Command az -ErrorAction Ignore) {
            Assert-AzCliBicep
            Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Templates
        }
    }

    It 'every rendered parameters file of template <_> satisfies its compiled parameter model' -ForEach $script:templateNames {
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        Build-Bicep $_ | Out-Null
        $violations = @(InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $_ } {
                param($Template)
                Get-BicepParameterViolations $Template
            })
        $violations | Should -BeNullOrEmpty -Because "the rendered parameters files must satisfy main.json:`n$($violations -join "`n")"
    }
}
