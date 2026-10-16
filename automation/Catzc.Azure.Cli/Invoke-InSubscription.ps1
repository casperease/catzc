<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Invoke-InSubscription.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
  config:
    synopsis: Runs a script block against a target subscription, restoring the original context afterwards.
    description: |-
      Captures the active subscription (Get-CurrentAzSubscription), switches to the target
      (Set-CurrentAzSubscription), invokes the script block, and restores the original subscription in a
      finally so it is restored even if the block throws. The block's output streams through unchanged.

      If the session is already on the target (matched by Id or Name) the switch is skipped entirely and the
      block runs without touching — or restoring — context.

      Restore semantics: a failure to restore is only downgraded to a warning when the block itself threw,
      so the block's real error isn't masked by a cleanup failure. If the block succeeded and only the
      restore failed, that restore error is thrown (fail-early — it's the only failure in flight).
    parameters:
      SubscriptionId: The subscription GUID (or display name) to run the block against.
      ScriptBlock: The work to run while the target subscription is active.
    examples:
      - |-
        Invoke-InSubscription -SubscriptionId $prod -ScriptBlock {
            Get-FirewallIpgsYaml -SubscriptionId $prod -ResourceGroupName rg-firewall
        }
      - '$rules = Invoke-InSubscription $prod { Get-FirewallCsv -SubscriptionId $prod -StorageAccountName sa -ContainerName c }'
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
