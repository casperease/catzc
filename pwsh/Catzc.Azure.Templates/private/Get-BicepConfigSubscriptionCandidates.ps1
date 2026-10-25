<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md"
  warning: "Generated Header"
---
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
        if ($token -ceq $Customer -or (Get-AzureCustomer $token).key -ceq $Customer) {
            $ret.Add($subscriptionName)
        }
    }
    , $ret.ToArray()
}
