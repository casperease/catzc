<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1
    name: uninstall-az-cli
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Uninstall-AzCli.Tests.ps1
    docs: "[Uninstall-AzCli.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md)"
    cites:
      - ADR-AUTO-ONEJOB-CALLERHANDLESERRORS
      - ADR-AUTO-REMOVE-DOUBLYGUARDED
      - ADR-AUTO-REMOVE-ONECALLESCALATION
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
