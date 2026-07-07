<#
.SYNOPSIS
    Removes a manually installed Node.js and cleans up system PATH.
.DESCRIPTION
    Deletes the Node.js installation folder and removes it from the
    system-level PATH. Requires Administrator. Auto-detects the install
    directory from Get-Command if not specified.

    This is for Node.js installations that do not appear in Apps & Features
    or winget. If Node.js is managed by winget, use Uninstall-NodeJs instead.
.PARAMETER InstallDir
    Path to the Node.js installation folder. Auto-detected from PATH if omitted.
.PARAMETER Force
    Actually perform the removal. Without this, shows what would be removed.
.EXAMPLE
    Remove-NodeJs
.EXAMPLE
    Remove-NodeJs -Force
.EXAMPLE
    Remove-NodeJs -InstallDir 'D:\tools\nodejs' -Force
#>
function Remove-NodeJs {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'node_js'

    # Gate: managed by our tooling system → refuse, redirect to Uninstall-NodeJs (ADR-REMOVE:3).
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Node.js is managed by the tooling system. Use Uninstall-NodeJs instead.'
    }

    # Linux: evict an off-config install by the mechanism that placed it (apt / uv-Python pip / stray binary);
    # elevation is scoped to the mechanism (ADR-REMOVE:6). macOS eviction is a stub (ADR-REMOVE:7).
    if ($IsLinux) {
        if (-not $Force) {
            Write-Message 'Would evict an off-config Node.js (apt package / uv-Python pip / stray binary). Run with -Force to execute.'
            return
        }
        if (-not (Remove-LinuxToolInstall -Config $config)) {
            Write-Message 'No off-config Node.js found — nothing to remove.'
        }
        return
    }
    if ($IsMacOS) {
        Remove-MacToolInstall -Config $config | Out-Null
        return
    }

    # Windows: delete the install directory and clean the machine PATH — needs Administrator.
    Assert-IsAdministrator

    # Auto-detect install directory
    if (-not $InstallDir) {
        $command = Get-Command $config.command -ErrorAction SilentlyContinue
        if ($command) {
            $InstallDir = Split-Path $command.Source
        }
        else {
            $InstallDir = 'C:\Program Files\nodejs'
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
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
