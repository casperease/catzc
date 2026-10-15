# catzc:
#   path: automation/Catzc.Azure/Get-AzureSubscription.ps1
#   module: Catzc.Azure
#   visibility: public

<#
.SYNOPSIS
    Returns the resolved Azure subscription identity (id + tenant [+ customer]) for a named subscription.
.DESCRIPTION
    Lookup is by name alone: no environment, group or customer join happens here, so callers build on it.
    [ADR-AZ-DATAMOD#4](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod4),
    [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)
    [comment:1](/docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md#comment1)
.PARAMETER Subscription
    Subscription name — a key in azure.yml's `subscriptions`.
.EXAMPLE
    $sub = Get-AzureSubscription shared_nonprod
    $sub.id
    $sub.tenant.id
.EXAMPLE
    (Get-AzureSubscription apex_nonprod).customer   # -> apex
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
    # Normalized to the canonical key, so the resolved object is identical whichever form the config used.
    # [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)
    # [comment:2](/docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md#comment2)
    $customerToken = Get-AzureSubscriptionCustomer $found
    $customer = if ([string]::IsNullOrEmpty($customerToken)) {
        ''
    }
    else {
        (Get-AzureCustomer $customerToken).key
    }
    [Catzc.Azure.AzureSubscription]::new($Subscription, $found.id, $customer, $tenant)
}
