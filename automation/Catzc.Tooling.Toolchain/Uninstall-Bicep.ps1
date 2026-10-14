<#
.SYNOPSIS
    Uninstalls the Bicep CLI that Install-Bicep installed.
.DESCRIPTION
    Windows and macOS delegate to Uninstall-Tool with the tools.yml `bicep` entry (winget, brew). On Linux it removes the
    binary Install-Bicep placed in ~/.local/bin; a Bicep CLI elsewhere is not this module's to remove.
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
