<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Invoke-InSubscription.ps1.md"
  header: "generated"
---
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
