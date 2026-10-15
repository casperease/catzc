<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-Config.Integrity.Tests.ps1
    kind: pester-test
---
#>

# Integrity tests for the SHIPPED config assets + real templates.
# [comment:1](/docs/references/automation/catzc-azure-templates/tests/Get-Config.Integrity.Tests.ps1.md#comment1)
Describe 'Shipped asset integrity' -Tag 'L0', 'integrity' {

    It 'the shipped azure.yml loads and passes its AzureConfig type' {
        # Get-Config constructs the type on load, so a bad file throws here.
        { Get-Config -Config azure } | Should -Not -Throw
    }

    It 'the shipped network.yml loads and passes its NetworkConfig type' {
        { Get-Config -Config network } | Should -Not -Throw
    }

    It 'every shipped template references only defined environments and customers' {
        $azure = Get-Config -Config azure
        $envs = @($azure.environments.Keys)

        # One Should over the violating set — a Should per template slot pays Pester's per-assertion cost times the...
        # [comment:2](/docs/references/automation/catzc-azure-templates/tests/Get-Config.Integrity.Tests.ps1.md#comment2)
        $violations = foreach ($t in (Get-BicepTemplates)) {
            foreach ($slot in $t.slots) {
                if ($slot.environment -notin $envs) {
                    "template '$($t.name)' config '$($slot.name)': environment '$($slot.environment)' is not defined in azure.yml"
                }
                if (-not [string]::IsNullOrEmpty($slot.customer)) {
                    # slot.customer is the raw token from the subscription (a key or shortcode); it must resolve to a...
                    # [comment:3](/docs/references/automation/catzc-azure-templates/tests/Get-Config.Integrity.Tests.ps1.md#comment3)
                    try {
                        $null = Get-AzureCustomer $slot.customer
                    }
                    catch {
                        "template '$($t.name)' config '$($slot.name)': customer '$($slot.customer)' is not defined in customer.yml ($_)"
                    }
                }
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }
}
