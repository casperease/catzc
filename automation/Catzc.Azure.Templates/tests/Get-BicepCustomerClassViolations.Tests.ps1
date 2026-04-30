Describe 'Get-BicepCustomerClassViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture azure with one customer subscription (acme) and one non-customer subscription.
        $script:azure = [ordered]@{
            subscriptions = [ordered]@{
                acme_sub  = [ordered]@{ customer = 'acme' }
                plain_sub = [ordered]@{}
            }
        }
        # Invoke the private function in the module's scope with the fixture azure config.
        $script:check = {
            param($subscription, $customerDeployment)
            & (Get-Module Catzc.Azure.Templates) {
                param($s, $cd, $a)
                Get-BicepCustomerClassViolations -Subscription $s -CustomerDeployment $cd -AzureConfig $a -Location "configuration/$s/x.yml"
            } $subscription $customerDeployment $script:azure
        }
    }

    It 'flags a customer subscription under a non-customer template' {
        & $script:check 'acme_sub' $false | Should -Not -BeNullOrEmpty
    }

    It 'allows a non-customer subscription under a non-customer template' {
        & $script:check 'plain_sub' $false | Should -BeNullOrEmpty
    }

    It 'allows a customer subscription under a customer template when the customer is enabled' {
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $true }
        & $script:check 'acme_sub' $true | Should -BeNullOrEmpty
    }

    It 'allows a non-customer subscription under a customer template' {
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $true }
        & $script:check 'plain_sub' $true | Should -BeNullOrEmpty
    }

    It 'flags a customer subscription whose customer is not enabled' {
        Mock Test-HaveCustomer -ModuleName Catzc.Azure.Templates { $false }
        Mock Get-AzureCustomer -ModuleName Catzc.Azure.Templates { [ordered]@{ key = 'acme'; shortcode = 'ac'; details = '' } }
        & $script:check 'acme_sub' $true | Should -Not -BeNullOrEmpty
    }
}
