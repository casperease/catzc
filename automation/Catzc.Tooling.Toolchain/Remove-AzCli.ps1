<#
.SYNOPSIS
    Destructively evicts an off-config Azure CLI so the managed (uv-venv) build can win.
.DESCRIPTION
    Removes an Azure CLI installed OUTSIDE the tooling system — the destructive `Remove-` verb of the tool lifecycle.
    [ADR-AUTO-REMOVE](/docs/adr/automation/tool-removal-lifecycle.md),
    [ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3),
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6),
    [ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4),
    [ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)
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

    # Gate: managed by our tooling system → refuse, redirect to Uninstall-AzCli.
    # [ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)
    # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md#comment2)
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Azure CLI is managed by the tooling system. Use Uninstall-AzCli instead.'
    }

    # Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip /...
    # [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
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
