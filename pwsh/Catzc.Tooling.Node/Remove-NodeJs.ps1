<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-node/Remove-NodeJs.ps1.md"
  header: "generated"
---
#>

function Remove-NodeJs {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'node_js'

    # A managed install is refused: it leaves through its uninstall, never by eviction.
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Node.js is managed by the tooling system. Use Uninstall-NodeJs instead.'
    }

    # An off-config install leaves by the mechanism that placed it, so elevation is that mechanism's, never asserted here.
    if ($IsLinux -or $IsMacOS) {
        if (-not $Force) {
            Write-Message 'Would evict an off-config Node.js (native package / uv-Python pip / stray binary). Run with -Force to execute.'
            return
        }
        $removed = if ($IsLinux) {
            Remove-LinuxToolInstall -Config $config
        }
        else {
            Remove-MacToolInstall -Config $config
        }
        if (-not $removed) {
            Write-Message 'No off-config Node.js found — nothing to remove.'
        }
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
