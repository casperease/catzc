<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/tests/Get-AzureSubscriptionCustomer.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Azure
    relatives:
      source: automation/Catzc.Azure/Get-AzureSubscriptionCustomer.ps1
---
#>

Describe 'Get-AzureSubscriptionCustomer' -Tag 'L0', 'logic' {
    It 'returns the customer field for a customer subscription' {
        $subscription = [ordered]@{ name = 's'; customer = 'acme'; environments = @('alpha') }
        & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $subscription | Should -Be 'acme'
    }

    It 'returns empty when the customer field is absent' {
        $subscription = [ordered]@{ name = 's'; environments = @('alpha') }
        & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $subscription | Should -BeNullOrEmpty
    }
}
