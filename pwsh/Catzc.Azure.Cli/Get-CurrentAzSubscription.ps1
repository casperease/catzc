<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Get-CurrentAzSubscription.ps1
    name: get-current-az-subscription
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Get-CurrentAzSubscription.ps1.md](docs/references/pwsh/catzc-azure-cli/Get-CurrentAzSubscription.ps1.md)"
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

    [Catzc.Azure.Cli.SubscriptionContext]::new($account.id, $account.name, $account.tenantId, $account.state, $account.isDefault)
}
