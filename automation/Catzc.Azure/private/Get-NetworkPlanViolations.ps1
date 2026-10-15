<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/private/Get-NetworkPlanViolations.ps1
    kind: private-function
    module: Catzc.Azure
    visibility: private
    adrs:
      - ADR-AZ-NETWORK#2
      - ADR-AZ-NETWORK#4
      - ADR-AZ-NETWORK#5
---
#>

<#
.SYNOPSIS
    Returns every way a network plan is out of sync with the azure config's environments and subscriptions.
.DESCRIPTION
    Per-subscription environments (nsub, psub) are exempt because they carry no vnet, so they need no network entry.
.PARAMETER Network
    The network plan (Get-Config -Config network).
.PARAMETER Azure
    The azure config (Get-Config -Config azure).
.OUTPUTS
    [string] One message per violation; nothing when the two are in sync.
.EXAMPLE
    Get-NetworkPlanViolations -Network (Get-Config -Config network) -Azure (Get-Config -Config azure)
#>
function Get-NetworkPlanViolations {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.NetworkConfig] $Network,

        [Parameter(Mandatory)]
        [Catzc.Azure.AzureConfig] $Azure
    )

    $azureNames = @($Azure.environments.Keys) -join ', '
    foreach ($name in $Network.environments.Keys) {
        if (-not $Azure.environments.ContainsKey($name)) {
            "network environment '$name' is not a defined azure.yml environment (valid: $azureNames)"
        }
    }
    foreach ($environment in $Azure.environments.Values) {
        if (-not $environment.per_subscription -and -not $Network.environments.ContainsKey($environment.name)) {
            "azure.yml environment '$($environment.name)' has no network entry in network.yml"
        }
    }

    $subscriptionNames = @($Azure.subscriptions.Keys) -join ', '
    foreach ($name in $Network.subscriptions.Keys) {
        if (-not $Azure.subscriptions.ContainsKey($name)) {
            "network subscription '$name' is not a defined azure.yml subscription (valid: $subscriptionNames)"
        }
    }
    $hub = [Catzc.Azure.NetworkSubscription]::Hub
    $spoke = [Catzc.Azure.NetworkSubscription]::Spoke
    foreach ($subscription in $Azure.subscriptions.Values) {
        $name = $subscription.name
        $expected = $hub
        $because = 'serves no customer'
        if ($subscription.customer) {
            $expected = $spoke
            $because = "serves customer '$($subscription.customer)'"
        }
        if (-not $Network.subscriptions.ContainsKey($name)) {
            "azure.yml subscription '$name' has no network entry in network.yml (it $because, so it needs a $expected)"
            continue
        }
        $entry = $Network.subscriptions[$name]
        if ($entry.kind -cne $expected) {
            "network subscription '$name' is a $($entry.kind), but its azure.yml subscription $because, so it needs a $expected"
            continue
        }
        if ($expected -cne $spoke) {
            continue
        }

        $served = @($subscription.environments | Where-Object {
                $Azure.environments.ContainsKey($_) -and -not $Azure.environments[$_].per_subscription
            })
        foreach ($environmentName in $served) {
            if (-not $entry.subnets.ContainsKey($environmentName)) {
                "network spoke '$name' has no workload subnet for environment '$environmentName', which its subscription serves"
            }
        }
        $privateEndpoints = [Catzc.Azure.NetworkSubscription]::PrivateEndpointsSubnet
        foreach ($subnet in $entry.subnets.Keys) {
            if ($subnet -cne $privateEndpoints -and $subnet -cnotin $served) {
                "network spoke '$name' has workload subnet '$subnet', which names no standard environment its" +
                " subscription serves (serves: $($served -join ', '))"
            }
        }
    }
}
