<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-cli/Disconnect-AzCli.ps1.md
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

    $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0 -or -not $result.Output) {
        Write-Message 'Not logged in — nothing to do'
        return
    }

    Invoke-Executable 'az logout'
    Write-Message 'Logged out of Azure CLI'
}
