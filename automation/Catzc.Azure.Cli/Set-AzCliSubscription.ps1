<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Set-AzCliSubscription.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-cli/Set-AzCliSubscription.ps1.md
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
