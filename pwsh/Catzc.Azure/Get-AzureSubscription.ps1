<#
---
catzc:
  immutable:
    with_body_sha: "50fdd662aed3"
  edges:
    test: pwsh/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
    docs: "[Get-AzureSubscription.ps1.md](docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md)"
    cites:
      - ADR-AZ-CUSTOMER
      - ADR-AZ-DATAMOD-CUSTOMERAXIS
---
#>

function Get-AzureSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $azure = Get-Config -Config azure
    $found = $azure.subscriptions[$Subscription]
    Assert-True ($null -ne $found) -ErrorText "Unknown subscription '$Subscription' in azure.yml"
    Assert-True ($azure.tenants.ContainsKey($found.tenant)) -ErrorText "Subscription '$Subscription' references unknown tenant '$($found.tenant)'"

    $tenant = [Catzc.Azure.Tenant]::new($found.tenant, $azure.tenants[$found.tenant].id)
    $customerToken = Get-AzureSubscriptionCustomer $found
    $customer = if ([string]::IsNullOrEmpty($customerToken)) {
        ''
    }
    else {
        (Get-AzureCustomer $customerToken).key
    }
    [Catzc.Azure.AzureSubscription]::new($Subscription, $found.id, $customer, $tenant)
}
