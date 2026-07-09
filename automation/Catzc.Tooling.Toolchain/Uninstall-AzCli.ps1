<#
.SYNOPSIS
    Uninstalls the Azure CLI.
.DESCRIPTION
    Removes az's dedicated uv venv via Uninstall-UvVenvTool — the managed uninstall (idempotent, skips if not
    installed). For an Azure CLI installed OUTSIDE the tooling system (a lingering machine-scope MSI, an apt
    'azure-cli', a pip install), escalate with -Remove -Force: the managed uninstall runs best-effort and then
    falls through to Remove-AzCli, which destructively evicts whatever the configured manager did not own
    (docs/adr/automation/tool-removal-lifecycle.md, ADR-AUTO-REMOVE:5).
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-AzCli to evict an off-config install the managed path
    cannot touch. Pair with -Force to actually remove; -Remove alone reports the plan (ADR-AUTO-REMOVE:4).
.PARAMETER Force
    Confirm the destructive Remove-AzCli step of the escalation. Ignored without -Remove.
.EXAMPLE
    Uninstall-AzCli
.EXAMPLE
    Uninstall-AzCli -Remove -Force
#>
function Uninstall-AzCli {
    [CmdletBinding()]
    param(
        [switch] $Remove,
        [switch] $Force
    )

    # Managed uninstall best-effort. With -Remove a failure (a foreign install the manager cannot touch — the
    # exact case -Remove exists for) is logged and the escalation proceeds to Remove-AzCli; without -Remove it
    # propagates as a normal uninstall failure. Catching only under -Remove is the escalation's single stated
    # purpose, not general catch-and-continue (ADR-AUTO-ERROR:6, ADR-AUTO-REMOVE:5).
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
