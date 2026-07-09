<#
.SYNOPSIS
    Returns the resolved environment object: identity + the named subscription that serves it.
.DESCRIPTION
    Reads configs/azure.yml via Get-Config and composes an ordered dictionary with the
    environment's identity fields (name, shortcode, region, region_code) and the serving subscription
    (via Get-AzureSubscription). The subscription is named directly — the deploy path resolves it from
    the az session and passes it in — so it is an explicit input here. Asserts the subscription actually
    serves the environment. The embedded subscription's optional `customer` is what renders into resource
    names. See docs/adr/azure/azure-data-model.md#rule-adr-az-datamod4.
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
