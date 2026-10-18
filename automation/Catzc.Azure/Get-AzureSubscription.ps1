<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/Get-AzureSubscription.ps1
    name: get-azure-subscription
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md
    test: automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
    cites:
      - ADR-AZ-CUSTOMER
      - ADR-AZ-DATAMOD#4
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
