# catzc:
#   path: automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
#   module: Catzc.Azure.Cli
#   visibility: public

<#
.SYNOPSIS
    Resolves the az session's active subscription to its declared azure.yml identity.
.DESCRIPTION
    A session on a subscription azure.yml does not declare is an error, never a fallback: config defines correct.
    [ADR-AZ-SESSION](/docs/adr/azure/az-session-verification.md)
    [comment:1](/docs/references/automation/catzc-azure-cli/Get-AzCliSessionSubscription.ps1.md#comment1)
.OUTPUTS
    An ordered dictionary: @{ name; id; customer; tenant } — `name` is the azure.yml subscription key,
    `customer` the canonical customer key ('' for a non-customer subscription), `tenant` the resolved
    tenant object.
.EXAMPLE
    (Get-AzCliSessionSubscription).name      # -> apex_nonprod  (whatever the session is set to)
.EXAMPLE
    (Get-AzCliSessionSubscription).customer  # -> apex  ('' for a non-customer subscription)
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

    [ordered]@{
        name     = $subscription.name
        id       = $subscription.id
        customer = $subscription.customer
        tenant   = $subscription.tenant
    }
}
