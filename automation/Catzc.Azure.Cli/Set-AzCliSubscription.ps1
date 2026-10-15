<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Set-AzCliSubscription.ps1
    kind: automation-function
    module: Catzc.Azure.Cli
    visibility: public
  config:
    synopsis: Sets the active Azure CLI subscription.
    description: Skips if the requested subscription is already active.
    parameters:
      Subscription: Subscription name or ID.
    examples:
      - Set-AzCliSubscription 'my-subscription'
      - Set-AzCliSubscription '50a0ed00-de00-50b0-0000-000000000000'
---
#>

function Set-AzCliSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Subscription
    )

    Assert-Tool 'az_cli'

    # Idempotent: skip if already on the requested subscription -NoAssert: non-zero exit means "not logged in" —...
    # [comment:2](/docs/references/automation/catzc-azure-cli/Set-AzCliSubscription.ps1.md#comment2)
    $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
    if ($result.ExitCode -eq 0 -and $result.Output) {
        $account = $result.Output | ConvertFrom-Json
        if ($account.id -eq $Subscription -or $account.name -eq $Subscription) {
            Write-Message "Already on subscription '$Subscription'"
            return
        }
    }

    Write-Verbose "Switching to subscription '$Subscription'"
    Invoke-Executable "az account set --subscription $Subscription"
    Write-Message "Active subscription: $Subscription"
}
