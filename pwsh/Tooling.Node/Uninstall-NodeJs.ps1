<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-node/Uninstall-NodeJs.ps1.md"
  header: "generated"
---
#>

function Uninstall-NodeJs {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    # With -Remove a failure is a foreign install the escalation still removes, so it is logged; alone it propagates.
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
