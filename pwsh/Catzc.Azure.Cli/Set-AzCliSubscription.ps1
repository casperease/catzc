<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Set-AzCliSubscription.ps1
    name: set-az-cli-subscription
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
    docs: "[Set-AzCliSubscription.ps1.md](docs/references/pwsh/catzc-azure-cli/Set-AzCliSubscription.ps1.md)"
---
#>

function Set-AzCliSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Subscription
    )

    Assert-Tool 'az_cli'

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
