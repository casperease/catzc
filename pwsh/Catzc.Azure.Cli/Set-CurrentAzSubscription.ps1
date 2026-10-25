<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Set-CurrentAzSubscription.ps1.md"
  header: "generated"
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
