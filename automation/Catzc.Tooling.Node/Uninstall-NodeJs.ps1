<#
.SYNOPSIS
    Uninstalls Node.js via the platform package manager.
.DESCRIPTION
    Removes Node.js (and its bundled npm) through the configured manager — the managed uninstall. Idempotent —
    skips if not installed. For a Node.js installed OUTSIDE the tooling system (a stray binary, a foreign
    package), escalate with -Remove -Force: the managed uninstall runs best-effort and then falls through to
    Remove-NodeJs, which destructively evicts whatever the configured manager did not own
    (docs/adr/automation/tool-removal-lifecycle.md, ADR-REMOVE:5).
.PARAMETER Version
    Node.js version to uninstall. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-NodeJs to evict an off-config install the managed path
    cannot touch. Pair with -Force to actually remove; -Remove alone reports the plan (ADR-REMOVE:4).
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

    # Managed uninstall best-effort; with -Remove a failure (a foreign install) is logged and the escalation
    # proceeds, without -Remove it propagates (ADR-ERROR:6, ADR-REMOVE:5).
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
