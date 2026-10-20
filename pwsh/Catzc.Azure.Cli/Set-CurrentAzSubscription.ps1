<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Set-CurrentAzSubscription.ps1
    name: set-current-az-subscription
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Set-CurrentAzSubscription.ps1.md](docs/references/pwsh/catzc-azure-cli/Set-CurrentAzSubscription.ps1.md)"
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
