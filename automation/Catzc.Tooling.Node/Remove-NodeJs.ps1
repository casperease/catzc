<#
.SYNOPSIS
    Removes a manually installed Node.js and cleans up system PATH.
.DESCRIPTION
    Meant for installs absent from Apps and Features or winget; a winget-managed Node.js belongs to Uninstall-NodeJs.
    [comment:1](/docs/references/automation/catzc-tooling-node/Remove-NodeJs.ps1.md#comment1)
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

    # A managed install is refused, not removed, so the tooling system never loses track of what it installed.
    # [ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)
    # [comment:2](/docs/references/automation/catzc-tooling-node/Remove-NodeJs.ps1.md#comment2)
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Node.js is managed by the tooling system. Use Uninstall-NodeJs instead.'
    }

    # Elevation is scoped to the mechanism that placed the install, so this branch needs no admin assert.
    # [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    # [comment:3](/docs/references/automation/catzc-tooling-node/Remove-NodeJs.ps1.md#comment3)
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
