<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Uninstall-Bicep.ps1
    name: uninstall-bicep
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
    docs: "[Uninstall-Bicep.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Bicep.ps1.md)"
---
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
