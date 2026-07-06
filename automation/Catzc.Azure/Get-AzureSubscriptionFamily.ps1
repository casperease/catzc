<#
.SYNOPSIS
    Returns the family a subscription belongs to — the configuration-folder name of its group.
.DESCRIPTION
    A subscription's family is DERIVED, in fixed precedence (see docs/adr/azure/data-model.md):
      1. its customer's canonical key, when the subscription carries a `customer` (the raw token may be
         the key or the 2-char shortcode — normalized via Get-AzureCustomer);
      2. else its explicit `family:` key;
      3. else its own name (a single ungrouped subscription is its own one-member family).
    This is the single derivation, shared by every family consumer (Get-AzureFamilies, discovery) so the
    grouping cannot drift. Reads azure.yml (and customer.yml only when a customer must be normalized).
.PARAMETER Subscription
    Subscription name — a key in azure.yml's `subscriptions`.
.EXAMPLE
    Get-AzureSubscriptionFamily apex_nonprod    # -> apex   (derived from the customer)
.EXAMPLE
    Get-AzureSubscriptionFamily shared_nonprod  # -> shared (the explicit family: key)
#>
function Get-AzureSubscriptionFamily {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $azure = Get-Config -Config azure
    $found = $azure.subscriptions[$Subscription]
    Assert-True ($null -ne $found) -ErrorText "Unknown subscription '$Subscription' in azure.yml"

    $customerToken = Get-AzureSubscriptionCustomer $found
    if (-not [string]::IsNullOrEmpty($customerToken)) {
        return (Get-AzureCustomer $customerToken).key
    }
    if ($found.Contains('family')) {
        return "$($found.family)"
    }
    $Subscription
}
