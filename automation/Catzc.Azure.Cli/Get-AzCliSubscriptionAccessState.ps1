<#
.SYNOPSIS
    Returns whether the current az CLI login can actually reach a given subscription.
.DESCRIPTION
    The access counterpart to Get-AzCliConnectionState.
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1)
    [comment:1](/docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the current login must be able to reach.
.EXAMPLE
    (Get-AzCliSubscriptionAccessState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).accessible
#>
function Get-AzCliSubscriptionAccessState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    Assert-IsGuid $SubscriptionId

    # A REAL, read-only ARM call scoped to the subscription.
    # [comment:2](/docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md#comment2)
    $probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId -o none" -PassThru -NoAssert -Silent
    if ($probe.ExitCode -eq 0) {
        return [Catzc.Azure.Cli.SubscriptionAccessState]::new($true, $true, $SubscriptionId, $null)
    }

    # The probe failed.
    # [comment:3](/docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md#comment3)
    $session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent

    [Catzc.Azure.Cli.SubscriptionAccessState]::new(($session.ExitCode -eq 0), $false, $SubscriptionId, ($probe.Errors | Select-Object -First 1))
}
