<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
    name: get-azure-subscription-environment
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
    docs: "[Get-AzureSubscriptionEnvironment.ps1.md](docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD
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
