<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Bicep.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Uninstalls the Bicep CLI that Install-Bicep installed.
.DESCRIPTION
    On Linux only the binary Install-Bicep placed in ~/.local/bin is removed; a Bicep CLI elsewhere is left alone.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Bicep.ps1.md#comment1)
.PARAMETER Version
    The version to uninstall (Windows and macOS). Default: whichever is installed.
.EXAMPLE
    Uninstall-Bicep
#>
function Uninstall-Bicep {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    if (-not $IsLinux) {
        Uninstall-Tool -Tool 'bicep' -Version $Version
        return
    }

    Assert-NotNullOrWhitespace $env:HOME -ErrorText 'Uninstall-Bicep needs $env:HOME to locate the user bin (~/.local/bin).'
    $binary = Join-Path $env:HOME '.local/bin/bicep'
    if (Test-Path -LiteralPath $binary) {
        Remove-Item -LiteralPath $binary -Force
        Write-Message "Removed the Bicep CLI at '$binary'"
    }
    else {
        Write-Message "No Bicep CLI at '$binary' — nothing to remove"
    }
}
