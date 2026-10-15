<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Invoke-InSubscription.ps1
    kind: public-function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs a script block against a target subscription, restoring the original context afterwards.
.DESCRIPTION
    A failed restore only warns when the block threw, so a cleanup failure never masks the block's real error.
.PARAMETER SubscriptionId
    The subscription GUID (or display name) to run the block against.
.PARAMETER ScriptBlock
    The work to run while the target subscription is active.
.EXAMPLE
    Invoke-InSubscription -SubscriptionId $prod -ScriptBlock {
        Get-FirewallIpgsYaml -SubscriptionId $prod -ResourceGroupName rg-firewall
    }
.EXAMPLE
    $rules = Invoke-InSubscription $prod { Get-FirewallCsv -SubscriptionId $prod -StorageAccountName sa -ContainerName c }
#>
function Invoke-InSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$SubscriptionId,

        [Parameter(Mandatory, Position = 1)]
        [scriptblock]$ScriptBlock
    )

    $original = Get-CurrentAzSubscription

    # Already on the target (by id or name) — run without switching or restoring.
    if ($SubscriptionId -in @($original.Id, $original.Name)) {
        & $ScriptBlock
        return
    }

    Set-CurrentAzSubscription -SubscriptionId $SubscriptionId

    $blockFailed = $false
    try {
        & $ScriptBlock
    }
    catch {
        $blockFailed = $true
        throw
    }
    finally {
        try {
            Set-CurrentAzSubscription -SubscriptionId $original.Id
        }
        catch {
            if ($blockFailed) {
                # Don't let a restore failure bury the block's actual error.
                Write-Message "WARNING: failed to restore subscription to $($original.Id): $_"
            }
            else {
                throw
            }
        }
    }
}
