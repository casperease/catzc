<#
.SYNOPSIS
    Resolves the az session's active subscription to its declared azure.yml identity (name + family).
.DESCRIPTION
    The reverse lookup that makes the session the deploy-target selector: reads the active subscription
    (Get-CurrentAzSubscription — in a pipeline, exactly what the service connection logged into), finds
    the azure.yml subscription with that GUID, and returns the declared identity with its family
    (Get-AzureSubscriptionFamily). Read-only — it never logs in or switches context (verify is not
    connect, docs/adr/azure/az-session-verification.md); config defines correct, so a session pointed at
    a subscription azure.yml does not declare is an error, not a fallback.
.OUTPUTS
    An ordered dictionary: @{ name; id; family; customer; tenant } — `name` is the azure.yml subscription
    key, `customer` the canonical customer key ('' for a non-customer subscription), `tenant` the
    resolved tenant object.
.EXAMPLE
    (Get-AzCliSessionSubscription).name      # -> apex_nonprod  (whatever the session is set to)
.EXAMPLE
    (Get-AzCliSessionSubscription).family    # -> apex
#>
function Get-AzCliSessionSubscription {
    [CmdletBinding()]
    param()

    $current = Get-CurrentAzSubscription
    $azure = Get-Config -Config azure

    $declared = @($azure.subscriptions.Keys | Where-Object { "$($azure.subscriptions[$_].id)" -eq "$($current.Id)" })
    if ($declared.Count -eq 0) {
        throw "The az session's subscription '$($current.Name)' ($($current.Id)) is not declared in azure.yml — the session must target a declared subscription (run 'az account set', or declare it). Declared: $(@($azure.subscriptions.Keys | Sort-Object) -join ', ')"
    }
    if ($declared.Count -gt 1) {
        throw "The az session's subscription id $($current.Id) is declared more than once in azure.yml ($(@($declared | Sort-Object) -join ', ')) — subscription ids must be unique"
    }

    $subscription = Get-AzureSubscription $declared[0]
    $family = Get-AzureSubscriptionFamily $declared[0]

    [ordered]@{
        name     = $subscription.name
        id       = $subscription.id
        family   = $family
        customer = $subscription.customer
        tenant   = $subscription.tenant
    }
}
