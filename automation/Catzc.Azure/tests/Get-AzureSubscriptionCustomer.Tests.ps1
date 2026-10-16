<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/tests/Get-AzureSubscriptionCustomer.Tests.ps1
    folder: tests
    name: get-azure-subscription-customer-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
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
