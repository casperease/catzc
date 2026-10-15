<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
    kind: automation-function
    module: Catzc.Azure
    visibility: public
    adrs:
      - ADR-AZ-DATAMOD
  config:
    synopsis: Returns the per-subscription identity environment (nsub/psub) of a named subscription.
    description: |-
      Each subscription carries exactly one per-subscription env (nsub or psub — see
      [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)), the identity env that environment_kind:subscription
      templates deploy
      once-per-subscription. This returns it for a named subscription, so an environment_kind:standard
      template can locate the once-per-subscription foundation (and its Key Vault) that lives in the same
      subscription.
    parameters:
      Subscription: Subscription name — a key in azure.yml's `subscriptions`.
    examples:
      - 'Get-AzureSubscriptionEnvironment shared_nonprod   # -> nsub'
      - 'Get-AzureSubscriptionEnvironment apex_prod         # -> psub'
---
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
