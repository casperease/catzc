<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Set-CurrentAzSubscription.ps1
    name: set-current-az-subscription
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
---
#>

function Set-CurrentAzSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$SubscriptionId
    )

    try {
        # Action / mutation — stays loud.
        Invoke-AzCli "account set --subscription $SubscriptionId"
    }
    catch {
        throw "Failed to set the active subscription to '$SubscriptionId'. Verify the ID and that your identity has access. Underlying: $_"
    }
}
