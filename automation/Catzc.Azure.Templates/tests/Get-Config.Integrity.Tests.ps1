# Integrity tests for the SHIPPED config assets + real templates. Unlike the logic unit tests, these
# deliberately bind to the real configs/azure.yml, configs/network.yml, and infrastructure/templates/ —
# they are the contract that "what ships is internally consistent". They do NOT mock the
# Resolve-ConfigEntry (config discovery) / Get-BicepTemplatesRoot seams. Nothing else depends on them.
Describe 'Shipped asset integrity' -Tag 'L0', 'integrity' {

    It 'the shipped azure.yml loads and passes Assert-AzureConfig' {
        # Get-Config runs the validator on load, so a bad file throws here.
        { Get-Config -Config azure } | Should -Not -Throw
    }

    It 'the shipped network.yml loads and passes Assert-NetworkConfig' {
        { Get-Config -Config network } | Should -Not -Throw
    }

    It 'every shipped template references only defined environments and customers' {
        $azure = Get-Config -Config azure
        $envs = @($azure.environments.Keys)

        # One Should over the violating set — a Should per template slot pays Pester's per-assertion
        # cost times the whole discovered template tree.
        $violations = foreach ($t in (Get-BicepTemplates)) {
            foreach ($slot in $t.slots) {
                if ($slot.environment -notin $envs) {
                    "template '$($t.name)' config '$($slot.name)': environment '$($slot.environment)' is not defined in azure.yml"
                }
                if (-not [string]::IsNullOrEmpty($slot.customer)) {
                    # slot.customer is the raw token from the subscription (a key or shortcode); it must
                    # resolve to a defined customer in customer.yml (Get-AzureCustomer throws otherwise).
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
