<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
    adrs:
      - ADR-AZ-DATAMOD
  config:
    synopsis: Returns the subscriptions a config coordinate (customer?, environment) can resolve to.
    description: |-
      The single implementation of the configuration-tree resolution rule
      ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): a config at the configuration/ ROOT (empty -Customer) is
      served by
      the NON-customer subscriptions serving its environment; a config under configuration/<customer>/ is
      served by that customer's subscriptions serving it (the subscription's raw customer token — key or
      shortcode — is normalized against the folder's customer key). A conforming azure.yml yields exactly
      one candidate; callers assert that (Get-BicepSubscriptionConfigViolations for the violation text,
      discovery for the resolved name) so the rule cannot drift between them.
    parameters:
      Customer: The configuration subfolder name (a customer key), or '' for a configuration-root config.
      Environment: The config's resolved environment name.
      AzureConfig: The loaded azure config (Get-Config -Config azure).
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
