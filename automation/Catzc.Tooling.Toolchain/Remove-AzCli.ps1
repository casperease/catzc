<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/Remove-AzCli.ps1
    name: remove-az-cli
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md
    test: automation/Catzc.Tooling.Toolchain/tests/Remove-AzCli.Tests.ps1
    cites:
      - ADR-AUTO-REMOVE
---
#>

function Remove-AzCli {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'az_cli'

    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Azure CLI is managed by the tooling system. Use Uninstall-AzCli instead.'
    }

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
