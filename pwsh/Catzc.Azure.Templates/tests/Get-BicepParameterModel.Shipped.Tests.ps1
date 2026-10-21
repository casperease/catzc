<#
---
catzc:
  immutable:
    with_body_sha: "412e6a85730f"
  edges:
    docs: "[Get-BicepParameterModel.Shipped.Tests.ps1.md](docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-TAGBYOUTERMOSTRING
      - ADR-AUTO-TEST-GENERICTEMPLATETESTS
      - ADR-AUTO-TEST-SETUPONCE
      - ADR-AUTO-TEST-ONESCHEDULINGPOOL
      - ADR-AUTO-TEST-TESTSUITE
      - ADR-AZ-DATAMOD-PARAMETERCONTRACT
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
---
#>

BeforeDiscovery {
    $script:templateNames = @(Get-BicepTemplateNames)
}

Describe 'Shipped template parameter model' -Tag 'L2', 'integrity', 'greedy', 'ADR-AZ-DATAMOD-PARAMETERCONTRACT', 'ADR-AUTO-TEST-TESTSUITE' {
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
