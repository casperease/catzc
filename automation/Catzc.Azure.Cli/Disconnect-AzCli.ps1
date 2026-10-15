<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1
    kind: automation-function
    module: Catzc.Azure.Cli
    visibility: public
  config:
    synopsis: Logs out of Azure CLI.
    description: Skips if not currently logged in.
    examples:
      - Disconnect-AzCli
---
#>

function Disconnect-AzCli {
    [CmdletBinding()]
    param()

    Assert-Tool 'az_cli'

    # Idempotent: skip if not logged in -NoAssert: non-zero exit means "not logged in" — an expected state, not an error
    # [comment:2](/docs/references/automation/catzc-azure-cli/Disconnect-AzCli.ps1.md#comment2)
    $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0 -or -not $result.Output) {
        Write-Message 'Not logged in — nothing to do'
        return
    }

    Invoke-Executable 'az logout'
    Write-Message 'Logged out of Azure CLI'
}
