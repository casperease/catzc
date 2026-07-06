<#
.SYNOPSIS
    Returns the resolved Azure subscription identity (id + tenant [+ customer]) for a named subscription.
.DESCRIPTION
    Reads configs/azure.yml via Get-Config and looks up the subscription by name (a key in
    `subscriptions`) — the by-name identity lookup the resolved configuration coordinates and the session
    reverse lookup (Get-AzCliSessionSubscription) build on; there is no (environment, group, customer)
    join here. The matching tenant is looked up by name and embedded. A
    subscription MAY carry a `customer`, named by its key OR its 2-char shortcode (a customer in
    customer.yml); it is resolved to the canonical key and included (and renders into the resource names of
    anything deployed there). See docs/adr/azure/data-model.md#rule-adr-datamod4 and customer-model.md.
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
    Assert-True ($azure.tenants.Contains($found.tenant)) -ErrorText "Subscription '$Subscription' references unknown tenant '$($found.tenant)'"

    $tenant = [Catzc.Azure.Tenant]::new($found.tenant, $azure.tenants[$found.tenant].id)
    # The subscription's `customer` field may name a customer by its key OR its 2-char shortcode; normalize
    # to the canonical key so the resolved object is the same whichever form the config used. Empty when the
    # subscription is not a customer subscription. See docs/adr/azure/customer-model.md.
    $customerToken = Get-AzureSubscriptionCustomer $found
    $customer = if ([string]::IsNullOrEmpty($customerToken)) {
        ''
    }
    else {
        (Get-AzureCustomer $customerToken).key
    }
    [Catzc.Azure.AzureSubscription]::new($Subscription, $found.id, $customer, $tenant)
}
