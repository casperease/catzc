<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{8,17,19,26,37}
      - ADR-AZ-DATAMOD#9
      - ADR-PWSH-PESTER#2
---
#>

BeforeDiscovery {
    $script:templateNames = @(Get-BicepTemplateNames)
}

Describe 'Shipped template parameter model' -Tag 'L2', 'integrity', 'greedy', 'ADR-AZ-DATAMOD#9', 'ADR-AUTO-TEST#37' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates

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
