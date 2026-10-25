<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Disconnect-AzCli.ps1.md"
  header: "generated"
---
#>

function Disconnect-AzCli {
    [CmdletBinding()]
    param()

    Assert-Tool 'az_cli'

    # Idempotent: a failed show means nobody is logged in, an expected state with nothing to undo.
    $result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0 -or -not $result.Output) {
        Write-Message 'Not logged in — nothing to do'
        return
    }

    Invoke-Executable 'az logout'
    Write-Message 'Logged out of Azure CLI'
}
