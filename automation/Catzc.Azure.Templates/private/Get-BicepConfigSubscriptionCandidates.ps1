<#
.SYNOPSIS
    Returns the subscriptions a config coordinate (customer?, environment) can resolve to.
.DESCRIPTION
    The single implementation of the configuration-tree resolution rule
    (docs/adr/azure/azure-data-model.md): a config at the configuration/ ROOT (empty -Customer) is served by
    the NON-customer subscriptions serving its environment; a config under configuration/<customer>/ is
    served by that customer's subscriptions serving it (the subscription's raw customer token — key or
    shortcode — is normalized against the folder's customer key). A conforming azure.yml yields exactly
    one candidate; callers assert that (Get-BicepSubscriptionConfigViolations for the violation text,
    discovery for the resolved name) so the rule cannot drift between them.
.PARAMETER Customer
    The configuration subfolder name (a customer key), or '' for a configuration-root config.
.PARAMETER Environment
    The config's resolved environment name.
.PARAMETER AzureConfig
    The loaded azure config (Get-Config -Config azure).
#>
function Get-BicepConfigSubscriptionCandidates {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyString()]
        [string] $Customer,

        [Parameter(Mandatory)] [string] $Environment,
        [Parameter(Mandatory)] $AzureConfig
    )

    $ret = [System.Collections.Generic.List[string]]::new()
    foreach ($subscriptionName in @($AzureConfig.subscriptions.Keys)) {
        $subscription = $AzureConfig.subscriptions[$subscriptionName]
        if ($Environment -notin @($subscription.environments)) {
            continue
        }
        $token = Get-AzureSubscriptionCustomer $subscription
        if ([string]::IsNullOrEmpty($Customer)) {
            # Root config: only non-customer subscriptions are candidates.
            if ([string]::IsNullOrEmpty($token)) {
                $ret.Add($subscriptionName)
            }
            continue
        }
        if ([string]::IsNullOrEmpty($token)) {
            continue
        }
        # Customer config: match the raw token first (the common, by-key binding), and only resolve a
        # non-matching token through the catalogue (the by-shortcode binding) — keeps the read lazy.
        if ($token -ceq $Customer -or (Get-AzureCustomer $token).key -ceq $Customer) {
            $ret.Add($subscriptionName)
        }
    }
    , $ret.ToArray()
}
