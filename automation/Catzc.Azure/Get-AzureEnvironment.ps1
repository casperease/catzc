<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureEnvironment.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
    adrs:
      - ADR-AZ-DATAMOD#4
  config:
    synopsis: 'Returns the resolved environment object: identity + the named subscription that serves it.'
    description: |-
      Reads configs/azure.yml via Get-Config and composes an ordered dictionary with the
      environment's identity fields (name, shortcode, region, region_code) and the serving subscription
      (via Get-AzureSubscription). The subscription is named directly — the deploy path resolves it from
      the az session and passes it in — so it is an explicit input here. Asserts the subscription actually
      serves the environment. The embedded subscription's optional `customer` is what renders into resource
      names. See [ADR-AZ-DATAMOD#4](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod4).
    parameters:
      Environment: Environment name. Must be a key in azure.yml's `environments` map.
      Subscription: Subscription name — a key in azure.yml's `subscriptions`. Must serve the environment.
    examples:
      - |-
        $env = Get-AzureEnvironment dev -Subscription shared_nonprod
        $env.region
        $env.subscription.id
      - '$env = Get-AzureEnvironment dev -Subscription apex_nonprod   # .subscription.customer is apex'
---
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
