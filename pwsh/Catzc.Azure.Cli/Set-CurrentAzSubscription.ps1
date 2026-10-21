<#
---
catzc:
  immutable:
    with_body_sha: f7a408d33bed
  edges:
    docs: "[Set-CurrentAzSubscription.ps1.md](../../docs/references/pwsh/catzc-azure-cli/Set-CurrentAzSubscription.ps1.md)"
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
