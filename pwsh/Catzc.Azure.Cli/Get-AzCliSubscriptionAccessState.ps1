<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md"
  header: "generated"
---
#>

function Get-AzCliSubscriptionAccessState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    Assert-IsGuid $SubscriptionId

    $probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId -o none" -PassThru -NoAssert -Silent
    if ($probe.ExitCode -eq 0) {
        return [Catzc.Azure.Cli.SubscriptionAccessState]::new($true, $true, $SubscriptionId, $null)
    }

    $session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent

    [Catzc.Azure.Cli.SubscriptionAccessState]::new(($session.ExitCode -eq 0), $false, $SubscriptionId, ($probe.Errors | Select-Object -First 1))
}
