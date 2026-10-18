<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
    name: get-az-cli-subscription-access-state
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
    test: automation/Catzc.Azure.Cli/tests/Get-AzCliSubscriptionAccessState.Tests.ps1
    cites:
      - ADR-AZ-CLI#1
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
