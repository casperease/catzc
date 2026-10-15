<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#4
      - ADR-AUTO-REMOVE#5
---
#>

<#
.SYNOPSIS
    Uninstalls the Azure CLI.
.DESCRIPTION
    A foreign install, such as a machine MSI, an apt package or a pip install, needs -Remove -Force to be evicted.
.PARAMETER Remove
    Alone it only reports the plan; pair it with -Force so Remove-AzCli actually evicts the off-config install.
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

    # A failure is swallowed only under -Remove, where a foreign install the manager cannot touch is expected.
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
