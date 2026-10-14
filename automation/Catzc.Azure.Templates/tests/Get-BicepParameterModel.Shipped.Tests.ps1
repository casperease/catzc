# L2 integrity for the SHIPPED bicep templates' parameter contract
# ([ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)): every template is built with the
# real `az bicep build`, and every parameters file it renders must satisfy the parameter model of its compiled main.json
# — types, @allowed values, bounds, required parameters, no undeclared parameter, and a Key Vault reference (never a
# literal) for a secure parameter. Get-BicepParameterViolations does the checking; its rules are proven on fixtures at
# L0 (Get-BicepParameterViolations.Tests.ps1). This file adds what only the real compiler can: the contract the shipped
# templates actually declare.
#
# Generic over the template set ([ADR-AUTO-TEST#17](/docs/adr/automation/test-automation.md#rule-adr-auto-test17)): the
# templates are discovered with Get-BicepTemplateNames, one test each, and no test names a template or asserts a
# production value. It runs in the `infrastructure` globset's test suite
# ([ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)) —
# `Test-Automation -Suite infrastructure` — with the rest of the module's tests.
#
# Each test self-skips when `az` is absent ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
# The build output goes to this file's $TestDrive through the Get-BicepTemplatesOutputRoot seam
# ([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)), so it never shares
# out/template/<name> with another test file or a developer's build. greedy, not serial: it drives real
# `az bicep build` child processes but shares no mutable state
# ([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
BeforeDiscovery {
    $script:templateNames = @(Get-BicepTemplateNames)
}

Describe 'Shipped template parameter model' -Tag 'L2', 'integrity', 'greedy', 'ADR-AZ-DATAMOD#9', 'ADR-AUTO-TEST#37' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
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
