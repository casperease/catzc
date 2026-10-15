<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Remove-AzCli.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs:
      - ADR-AUTO-REMOVE
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#4
      - ADR-AUTO-REMOVE#5
      - ADR-AUTO-REMOVE#6
---
#>

<#
.SYNOPSIS
    Destructively evicts an off-config Azure CLI so the managed (uv-venv) build can win.
.DESCRIPTION
    Without -Force the plan is only reported and nothing changes; it is usually reached through Uninstall-AzCli -Remove.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md#comment1)
.PARAMETER InstallDir
    Path to the Azure CLI installation folder. Auto-detected from PATH if omitted.
.PARAMETER Force
    Actually perform the removal. Without this, shows what would be removed.
.EXAMPLE
    Remove-AzCli
.EXAMPLE
    Remove-AzCli -Force
.EXAMPLE
    Remove-AzCli -InstallDir 'C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2' -Force
#>
function Remove-AzCli {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'az_cli'

    # Removal never touches a managed install: only Uninstall-AzCli deletes what the tooling owns.
    # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md#comment2)
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Azure CLI is managed by the tooling system. Use Uninstall-AzCli instead.'
    }

    # Elevation is scoped to the placing mechanism, so unlike the Windows folder delete there is no admin assert here.
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md#comment3)
    if ($IsLinux -or $IsMacOS) {
        if (-not $Force) {
            Write-Message 'Would evict an off-config Azure CLI (native package / uv-Python pip / stray binary). Run with -Force to execute.'
            return
        }
        $removed = if ($IsLinux) {
            Remove-LinuxToolInstall -Config $config
        }
        else {
            Remove-MacToolInstall -Config $config
        }
        if (-not $removed) {
            Write-Message 'No off-config Azure CLI found — nothing to remove.'
        }
        return
    }

    # Windows: delete the MSI install directory and clean the machine PATH — needs Administrator.
    Assert-IsAdministrator

    # Auto-detect install directory
    if (-not $InstallDir) {
        $command = Get-Command $config.command -ErrorAction SilentlyContinue
        if ($command) {
            $binDir = Split-Path $command.Source
            # az.cmd lives in the wbin/ subdirectory of the MSI install
            $InstallDir = if ((Split-Path $binDir -Leaf) -eq 'wbin') {
                Split-Path $binDir
            }
            else {
                $binDir
            }
        }
        else {
            $InstallDir = 'C:\Program Files\Microsoft SDKs\Azure\CLI2'
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
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -ExtraPathDirs 'wbin'
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
