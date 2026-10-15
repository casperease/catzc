<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Get-CurrentAzSubscription.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the Azure CLI's currently active subscription.
.DESCRIPTION
    The call is silenced because it is a data read, and it throws when no context is active.
    [comment:1](/docs/references/automation/catzc-azure-cli/Get-CurrentAzSubscription.ps1.md#comment1)
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
