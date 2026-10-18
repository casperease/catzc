<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1
    name: uninstall-az-cli
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md
    test: automation/Catzc.Tooling.Toolchain/tests/Uninstall-AzCli.Tests.ps1
    cites:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#{4,5}
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
