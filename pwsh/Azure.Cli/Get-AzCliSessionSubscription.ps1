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
    # The session must sit in the tenant azure.yml declares for the subscription: a session signed in elsewhere is the wrong estate.
    if ("$($current.TenantId)" -ne "$($subscription.tenant.id)") {
        throw "The az session's tenant $($current.TenantId) is not tenant '$($subscription.tenant.name)' ($($subscription.tenant.id)), which azure.yml declares for subscription '$($subscription.name)' — sign in to that tenant (az login --tenant $($subscription.tenant.id))"
    }

    [ordered]@{
        name     = $subscription.name
        id       = $subscription.id
        customer = $subscription.customer
        tenant   = $subscription.tenant
    }
}
