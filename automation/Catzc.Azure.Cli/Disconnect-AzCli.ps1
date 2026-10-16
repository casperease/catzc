<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1
    name: disconnect-az-cli
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
