<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Set-AzCliSubscription.ps1.md"
  header: "generated"
---
#>

function Set-AzCliSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Subscription
    )

    Assert-Tool 'az_cli'

    # Idempotent: already on the subscription is a no-op, and a failed show falls through to the set.
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
