<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-node/Uninstall-NodeJs.ps1.md"
  warning: "Generated Header"
---
#>

function Uninstall-NodeJs {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    try {
        Uninstall-Tool -Tool 'node_js' -Version $Version
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-NodeJs."
    }

    if ($Remove) {
        Remove-NodeJs -Force:$Force
    }
}
