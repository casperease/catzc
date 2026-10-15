<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1
    kind: public-function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

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

    # A non-zero exit from az account show means not logged in, an expected state, so it must not throw.
    # [comment:1](/docs/references/automation/catzc-azure-cli/Disconnect-AzCli.ps1.md#comment1)
    $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0 -or -not $result.Output) {
        Write-Message 'Not logged in — nothing to do'
        return
    }

    Invoke-Executable 'az logout'
    Write-Message 'Logged out of Azure CLI'
}
