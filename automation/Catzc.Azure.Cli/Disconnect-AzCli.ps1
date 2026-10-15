<#
.SYNOPSIS
    Logs out of Azure CLI.
.DESCRIPTION
    Skips if not currently logged in.
.EXAMPLE
    Disconnect-AzCli
#>
function Disconnect-AzCli {
    [CmdletBinding()]
    param()

    Assert-Tool 'az_cli'

    # Idempotent: skip if not logged in -NoAssert: non-zero exit means "not logged in" — an expected state, not an error
    # [comment:1](/docs/references/automation/catzc-azure-cli/Disconnect-AzCli.ps1.md#comment1)
    $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0 -or -not $result.Output) {
        Write-Message 'Not logged in — nothing to do'
        return
    }

    Invoke-Executable 'az logout'
    Write-Message 'Logged out of Azure CLI'
}
