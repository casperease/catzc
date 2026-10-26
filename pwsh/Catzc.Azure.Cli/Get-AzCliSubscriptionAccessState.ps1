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

    # A real read-only call scoped by --subscription, so it proves access whether or not the subscription is active.
    $probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId -o none" -PassThru -NoAssert -Silent
    if ($probe.ExitCode -eq 0) {
        return [Catzc.Azure.Cli.SubscriptionAccessState]::new($true, $true, $SubscriptionId, $null)
    }

    # Read only on the failure path, so the error can name the right fix: log in, or ask for access.
    $session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent

    [Catzc.Azure.Cli.SubscriptionAccessState]::new(($session.ExitCode -eq 0), $false, $SubscriptionId,
        ($probe.Errors | Select-Object -First 1))
}
