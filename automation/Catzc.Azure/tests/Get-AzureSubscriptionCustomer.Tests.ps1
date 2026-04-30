Describe 'Get-AzureSubscriptionCustomer' -Tag 'L0', 'logic' {
    It 'returns the customer field for a customer subscription' {
        $subscription = [ordered]@{ name = 's'; customer = 'apex'; environments = @('dev') }
        & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $subscription | Should -Be 'apex'
    }

    It 'returns empty when the customer field is absent' {
        $subscription = [ordered]@{ name = 's'; environments = @('dev') }
        & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $subscription | Should -BeNullOrEmpty
    }
}
