<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md"
  header: "generated"
---
#>

function Uninstall-AzCli {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    try {
        Uninstall-UvVenvTool -Tool 'az_cli'
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-AzCli."
    }

    if ($Remove) {
        Remove-AzCli -Force:$Force
    }
}
