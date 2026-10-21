<#
---
catzc:
  immutable:
    with_body_sha: "20ee2acf973b"
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1
    docs: "[Get-AzCliSessionSubscription.ps1.md](../../docs/references/pwsh/catzc-azure-cli/Get-AzCliSessionSubscription.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-CUSTOMERAXIS
      - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - ADR-AZ-SESSION
---
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
