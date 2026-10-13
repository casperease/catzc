<#
.SYNOPSIS
    Returns every way a network plan is out of sync with the azure config's environments.
.DESCRIPTION
    The cross-asset join of [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2), over two
    already-typed configs: every network environment is a defined azure.yml environment (no ghost plan), and every
    STANDARD azure.yml environment has a network entry. Per-subscription environments (nsub/psub) are exempt — they
    carry no vnet ([ADR-AZ-NETWORK#4](/docs/adr/azure/azure-network-model.md#rule-adr-az-network4)).
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
}
