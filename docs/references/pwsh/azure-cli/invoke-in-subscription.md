# pwsh/Azure.Cli/Invoke-InSubscription.ps1

The command that runs a script block against a target subscription and restores the original subscription context afterwards.

## help

### synopsis

Runs a script block against a target subscription, restoring the original context afterwards.

### description

Captures the active subscription (Get-CurrentAzSubscription), switches to the target (Set-CurrentAzSubscription), invokes the script block,
and restores the original subscription in a finally so it is restored even if the block throws. The block's output streams through
unchanged.

If the session is already on the target (matched by Id or Name) the switch is skipped entirely and the block runs without touching — or
restoring — context.

Restore semantics: a failure to restore is only downgraded to a warning when the block itself threw, so the block's real error isn't masked
by a cleanup failure. If the block succeeded and only the restore failed, that restore error is thrown (fail-early — it's the only failure
in flight).

### parameter `SubscriptionId`

The subscription GUID (or display name) to run the block against.

### parameter `ScriptBlock`

The work to run while the target subscription is active.

### example 1

```powershell
Invoke-InSubscription -SubscriptionId $prod -ScriptBlock {
    Get-FirewallIpgsYaml -SubscriptionId $prod -ResourceGroupName rg-firewall
}
```

### example 2

```powershell
$rules = Invoke-InSubscription $prod { Get-FirewallCsv -SubscriptionId $prod -StorageAccountName sa -ContainerName c }
```
