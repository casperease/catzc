<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Remove-Java.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
---
#>

<#
.SYNOPSIS
    Removes a manually installed Java JDK and cleans up system PATH.
.DESCRIPTION
    For JDKs that winget, brew and apt do not manage; a managed Java goes through Uninstall-Java instead.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Remove-Java.ps1.md#comment1)
.PARAMETER InstallDir
    Path to the JDK installation folder. Auto-detected from PATH if omitted.
.PARAMETER Force
    Actually perform the removal. Without this, shows what would be removed.
.EXAMPLE
    Remove-Java
.EXAMPLE
    Remove-Java -Force
.EXAMPLE
    Remove-Java -InstallDir 'C:\Program Files\Java\jdk-17' -Force
#>
function Remove-Java {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'java'

    # Removal never touches a managed install: only Uninstall-Java deletes what the tooling owns.
    # [ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)
    # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Remove-Java.ps1.md#comment2)
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Java is managed by the tooling system. Use Uninstall-Java instead.'
    }

    # Elevation is scoped to the placing mechanism, so unlike the Windows folder delete there is no admin assert here.
    # [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Remove-Java.ps1.md#comment3)
    if ($IsLinux -or $IsMacOS) {
        if (-not $Force) {
            Write-Message 'Would evict an off-config Java (native package / uv-Python pip / stray binary). Run with -Force to execute.'
            return
        }
        $removed = if ($IsLinux) {
            Remove-LinuxToolInstall -Config $config
        }
        else {
            Remove-MacToolInstall -Config $config
        }
        if (-not $removed) {
            Write-Message 'No off-config Java found — nothing to remove.'
        }
        return
    }

    # Windows: delete the JDK install directory, clean the machine PATH and JAVA_HOME — needs Administrator.
    Assert-IsAdministrator

    if (-not $InstallDir) {
        $command = Get-Command $config.command -ErrorAction SilentlyContinue
        if ($command) {
            # java.exe is typically in bin/ under the JDK root
            $InstallDir = Split-Path (Split-Path $command.Source)
        }
        else {
            $InstallDir = Join-Path ([Environment]::GetFolderPath('ProgramFiles')) 'Java'
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
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -ExtraPathDirs 'bin' -EnvironmentVariables 'JAVA_HOME'
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
