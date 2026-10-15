<#
.SYNOPSIS
    Uninstalls Node.js via the platform package manager.
.DESCRIPTION
    Removes Node.js (and its bundled npm) through the configured manager — the managed uninstall.
    [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
    [comment:1](/docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md#comment1)
.PARAMETER Version
    Node.js version to uninstall. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-NodeJs to evict an off-config install the managed path cannot touch.
    [ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)
    [comment:2](/docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md#comment2)
.PARAMETER Force
    Confirm the destructive Remove-NodeJs step of the escalation. Ignored without -Remove.
.EXAMPLE
    Uninstall-NodeJs
.EXAMPLE
    Uninstall-NodeJs -Remove -Force
#>
function Uninstall-NodeJs {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    # Managed uninstall best-effort; with -Remove a failure (a foreign install) is logged and the escalation...
    # [ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
    # [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
    # [comment:3](/docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md#comment3)
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
