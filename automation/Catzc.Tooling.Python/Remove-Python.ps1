<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Remove-Python.ps1
    kind: public-function
    module: Catzc.Tooling.Python
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Removes a manually installed Python and cleans up system PATH.
.DESCRIPTION
    Only for Pythons absent from Apps and Features and winget; a tooling-managed one is refused, use Uninstall-Python.
.PARAMETER InstallDir
    Path to the Python installation folder. Auto-detected from PATH if omitted.
.PARAMETER Force
    Actually perform the removal. Without this, shows what would be removed.
.EXAMPLE
    Remove-Python
.EXAMPLE
    Remove-Python -Force
.EXAMPLE
    Remove-Python -InstallDir 'C:\Python312' -Force
#>
function Remove-Python {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    Assert-IsAdministrator

    $config = Get-ToolConfig -Tool 'python'

    # Gate: if managed by our tooling system, refuse and redirect
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Python is managed by the tooling system. Use Uninstall-Python instead.'
    }

    # Auto-detect install directory
    if (-not $InstallDir) {
        $command = Get-Command $config.command -ErrorAction SilentlyContinue
        if ($command) {
            $InstallDir = Split-Path $command.Source
        }
        else {
            $InstallDir = 'C:\Program Files\Python311'
        }
    }

    $resolvedDir = [System.IO.Path]::GetFullPath($InstallDir)

    if (-not [System.IO.Directory]::Exists($resolvedDir)) {
        Write-Message "Directory not found: $resolvedDir — nothing to remove"
        return
    }

    if (-not $Force) {
        Write-Message "Would remove: $resolvedDir"
        Write-Message 'Run with -Force to execute'
        return
    }

    Write-Message "Removing: $resolvedDir"
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -ExtraPathDirs 'Scripts'
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
