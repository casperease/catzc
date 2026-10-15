<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the per-subscription identity environment (nsub/psub) of a named subscription.
.DESCRIPTION
    Lets a standard template find the once-per-subscription foundation, and its Key Vault, in its own subscription.
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
    [comment:1](/docs/references/automation/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md#comment1)
.PARAMETER Subscription
    Subscription name — a key in azure.yml's `subscriptions`.
.EXAMPLE
    Get-AzureSubscriptionEnvironment shared_nonprod   # -> nsub
.EXAMPLE
    Get-AzureSubscriptionEnvironment apex_prod         # -> psub
#>
function Get-AzureSubscriptionEnvironment {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $azure = Get-Config -Config azure
    $subscriptionRecord = $azure.subscriptions[$Subscription]
    $perSubscriptionEnvironments = @(@($subscriptionRecord.environments) | Where-Object {
            $environmentEntry = $azure.environments[$_]
            $null -ne $environmentEntry -and $environmentEntry.Contains('per_subscription') -and $environmentEntry['per_subscription']
        })

    Assert-True ($perSubscriptionEnvironments.Count -ge 1) -ErrorText "Subscription '$Subscription' has no per-subscription environment (nsub/psub)."
    $perSubscriptionEnvironments[0]
}
