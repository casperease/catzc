<#
.SYNOPSIS
    Returns the Azure CLI's currently active subscription.
.DESCRIPTION
    Thin wrapper over `az account show` (via Invoke-AzCli) returning the active subscription as an object
    (Id, Name, TenantId, State, IsDefault). This is a data read, so the underlying call is silenced.
    Throws with remediation when there is no active context (e.g. not logged in).

    Pairs with Set-CurrentAzSubscription for a save / switch / restore idiom:
        $original = Get-CurrentAzSubscription
        try     { Set-CurrentAzSubscription -SubscriptionId $target; do-stuff}
        finally { Set-CurrentAzSubscription -SubscriptionId $original.Id }
.EXAMPLE
    Get-CurrentAzSubscription
.EXAMPLE
    (Get-CurrentAzSubscription).Id
#>
function Get-CurrentAzSubscription {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    try {
        # Data read — silenced; -PassThru to capture the JSON for parsing.
        $cli = Invoke-AzCli 'account show -o json' -PassThru -Silent
    }
    catch {
        throw "No active Azure CLI subscription context. Run 'az login' (and optionally 'az account set') first. Underlying: $_"
    }

    $account = $cli.Output | ConvertFrom-Json

    [Catzc.Azure.Cli.SubscriptionContext]::new($account.id, $account.name, $account.tenantId, $account.state, $account.isDefault)
}
