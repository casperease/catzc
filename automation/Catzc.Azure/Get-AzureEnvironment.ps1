<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureEnvironment.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
    adrs:
      - ADR-AZ-DATAMOD#4
---
#>

<#
.SYNOPSIS
    Returns the resolved environment object: identity + the named subscription that serves it.
.DESCRIPTION
    The subscription is an explicit input, asserted to serve the environment; its customer renders into resource names.
.PARAMETER Environment
    Environment name. Must be a key in azure.yml's `environments` map.
.PARAMETER Subscription
    Subscription name — a key in azure.yml's `subscriptions`. Must serve the environment.
.EXAMPLE
    $env = Get-AzureEnvironment dev -Subscription shared_nonprod
    $env.region
    $env.subscription.id
.EXAMPLE
    $env = Get-AzureEnvironment dev -Subscription apex_nonprod   # .subscription.customer is apex
#>
function Get-AzureEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $azure = Get-Config -Config azure
    $environmentEntry = $azure.environments[$Environment]

    $subscriptionEnvironments = @($azure.subscriptions[$Subscription].environments)
    Assert-True ($Environment -in $subscriptionEnvironments) -ErrorText "Subscription '$Subscription' does not serve environment '$Environment' (serves: $($subscriptionEnvironments -join ', '))"

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    [Catzc.Azure.AzureEnvironment]::new($Environment, $environmentEntry.shortcode, $environmentEntry.region, $environmentEntry.region_code, $subscriptionDescriptor)
}
