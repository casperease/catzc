<#
.SYNOPSIS
    Uninstalls the Azure CLI.
.DESCRIPTION
    Removes az's dedicated uv venv via Uninstall-UvVenvTool — the managed uninstall (idempotent, skips if not...
    [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md#comment1)
.PARAMETER Remove
    After the managed uninstall, escalate to Remove-AzCli to evict an off-config install the managed path cannot touch.
    [ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)
    [comment:2](/docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md#comment2)
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

    # Managed uninstall best-effort.
    # [ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
    # [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md#comment3)
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
