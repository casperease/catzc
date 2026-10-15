<#
.SYNOPSIS
    Sets the active Azure CLI subscription.
.DESCRIPTION
    Skips if the requested subscription is already active.
.PARAMETER Subscription
    Subscription name or ID.
.EXAMPLE
    Set-AzCliSubscription 'my-subscription'
.EXAMPLE
    Set-AzCliSubscription '50a0ed00-de00-50b0-0000-000000000000'
#>
function Set-AzCliSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Subscription
    )

    Assert-Tool 'az_cli'

    # A non-zero exit from az account show means not logged in, so it must not throw but fall through to the set.
    # [comment:1](/docs/references/automation/catzc-azure-cli/Set-AzCliSubscription.ps1.md#comment1)
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
