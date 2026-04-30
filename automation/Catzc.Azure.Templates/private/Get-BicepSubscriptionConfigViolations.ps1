<#
.SYNOPSIS
    Returns the subscription-folder violations for a single config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two never
    drift. Parallels Get-BicepConfigClassViolations. See docs/adr/azure/data-model.md#rule-adr-datamod8.
.DESCRIPTION
    A config lives at `configuration/<subscription>/<env>[-<slot>].yml`; the folder names the
    subscription the config deploys to. This checks that link (returns a possibly-empty array of
    human-readable violations; the caller prepends the template identifier):
      - the folder is a DEFINED subscription in azure.yml;
      - the config's environment is one the subscription actually serves.
    Empty result means the config conforms.
.PARAMETER Subscription
    The subscription-folder name (the directory directly under configuration/).
.PARAMETER Environment
    The config's resolved environment name.
.PARAMETER AzureConfig
    The loaded azure config (Get-Config -Config azure) — used to read subscriptions.
.PARAMETER Location
    A human-readable label for the config (e.g. 'configuration/core_lower/dev.yml') used in messages.
#>
function Get-BicepSubscriptionConfigViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)] [string] $Subscription,
        [Parameter(Mandatory)] [string] $Environment,
        [Parameter(Mandatory)] $AzureConfig,
        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()
    $subscriptions = $AzureConfig.subscriptions

    if (-not $subscriptions.Contains($Subscription)) {
        $violations += "$Location is under configuration/$Subscription/ but '$Subscription' is not a defined subscription in azure.yml (valid: $(@($subscriptions.Keys | Sort-Object) -join ', '))"
        # Without a valid subscription there is nothing more to check against.
        return $violations
    }

    $subscriptionEnvironments = @($subscriptions[$Subscription].environments)
    if ($Environment -notin $subscriptionEnvironments) {
        $violations += "$Location uses environment '$Environment', but subscription '$Subscription' does not serve it (serves: $($subscriptionEnvironments -join ', '))"
    }

    $violations
}
