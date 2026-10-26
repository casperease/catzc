<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Get-CurrentAzSubscription.ps1.md"
  header: "generated"
---
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

    [Catzc.Azure.Cli.SubscriptionContext]::new($account.id, $account.name, $account.tenantId, $account.state,
        $account.isDefault)
}
