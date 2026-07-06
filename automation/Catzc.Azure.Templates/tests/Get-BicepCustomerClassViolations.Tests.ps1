Describe 'Get-BicepCustomerClassViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        # Invoke the private function in the module's scope. The config's customer is its configuration
        # subfolder name ('' = a configuration-root, shared-platform config).
        $script:check = {
            param($customer, $customerDeployment)
            & (Get-Module Catzc.Azure.Templates) {
                param($c, $cd)
                $where = if ($c) {
                    "configuration/$c/x.yml"
                }
                else {
                    'configuration/x.yml'
                }
                Get-BicepCustomerClassViolations -Customer $c -CustomerDeployment $cd -Location $where
            } $customer $customerDeployment
        }
    }

    It 'flags a customer config under a non-customer template' {
        & $script:check 'acme' $false | Should -Not -BeNullOrEmpty
    }

    It 'allows a configuration-root config under a non-customer template' {
        & $script:check '' $false | Should -BeNullOrEmpty
    }

    It 'allows a customer config under a customer template when the customer is enabled' {
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $true }
        & $script:check 'acme' $true | Should -BeNullOrEmpty
    }

    It 'allows a configuration-root config under a customer template' {
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $true }
        & $script:check '' $true | Should -BeNullOrEmpty
    }

    It 'flags a customer config whose customer is not enabled' {
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $false }
        & $script:check 'acme' $true | Should -Not -BeNullOrEmpty
    }
}
