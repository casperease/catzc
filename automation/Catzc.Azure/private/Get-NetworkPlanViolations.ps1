<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/private/Get-NetworkPlanViolations.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure
    visibility: private
    adrs:
      - ADR-AZ-NETWORK#{2,4,5}
  config:
    synopsis: Returns every way a network plan is out of sync with the azure config's environments and subscriptions.
    description: |-
      The cross-asset join of [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2) and
      [ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5), over two already-typed configs.

      Environments: every network environment is a defined azure.yml environment (no ghost plan), and every STANDARD
      azure.yml environment has a network entry. Per-subscription environments (nsub/psub) are exempt — they carry no
      vnet ([ADR-AZ-NETWORK#4](/docs/adr/azure/azure-network-model.md#rule-adr-az-network4)).

      Subscriptions: every network subscription is a defined azure.yml subscription (no ghost network), and every
      azure.yml subscription has one of the right kind — a hub when it has no customer, a spoke when it has one. A spoke
      has exactly one workload subnet per standard environment its subscription serves, named for that environment.
    parameters:
      Network: The network plan (Get-Config -Config network).
      Azure: The azure config (Get-Config -Config azure).
    outputs: '[string] One message per violation; nothing when the two are in sync.'
    examples:
      - Get-NetworkPlanViolations -Network (Get-Config -Config network) -Azure (Get-Config -Config azure)
---
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
