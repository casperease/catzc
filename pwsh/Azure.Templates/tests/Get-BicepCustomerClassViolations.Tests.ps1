Describe 'Get-BicepCustomerClassViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        # Runs the private function in the module scope; a config's customer is its subfolder name, empty for a root config.
        $script:check = {
            param($customer)
            & (Get-Module Catzc.Azure.Templates) {
                param($c)
                $where = if ($c) {
                    "configuration/$c/x.yml"
                }
                else {
                    'configuration/x.yml'
                }
                Get-BicepCustomerClassViolations -Customer $c -Location $where
            } $customer
        }
    }

    It 'flags a customer folder when customer deployments are disabled, advising the variant, not an options key' {
        Mock Test-HaveCustomers -ModuleName Catzc.Azure.Templates { $false }
        $violation = & $script:check 'widget'
        $violation | Should -BeLike '*customer deployments are disabled*have_customers*'
        $violation | Should -Not -BeLike '*options.yml*'
    }

    It 'allows a configuration-root config when customer deployments are disabled' {
        Mock Test-HaveCustomers -ModuleName Catzc.Azure.Templates { $false }
        & $script:check '' | Should -BeNullOrEmpty
    }

    It 'allows a customer config when the customer is enabled' {
        Mock Test-HaveCustomers -ModuleName Catzc.Azure.Templates { $true }
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $true }
        & $script:check 'widget' | Should -BeNullOrEmpty
    }

    It 'allows a configuration-root config when customer deployments are enabled' {
        Mock Test-HaveCustomers -ModuleName Catzc.Azure.Templates { $true }
        & $script:check '' | Should -BeNullOrEmpty
    }

    It 'flags a customer config whose customer is not enabled' {
        Mock Test-HaveCustomers -ModuleName Catzc.Azure.Templates { $true }
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $false }
        & $script:check 'widget' | Should -BeLike '*not enabled by have_customers*'
    }
}
