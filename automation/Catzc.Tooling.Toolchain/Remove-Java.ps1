<#
.SYNOPSIS
    Removes a manually installed Java JDK and cleans up system PATH.
.DESCRIPTION
    Deletes the JDK installation folder and removes it (and its bin
    subdirectory) from the system-level PATH. Requires Administrator.
    Auto-detects the install directory from Get-Command if not specified.

    This is for JDK installations (Oracle, AdoptOpenJDK, etc.) that
    are not managed by winget/brew/apt. If Java is managed by the
    tooling system, use Uninstall-Java instead.
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

    # Gate: managed by our tooling system → refuse, redirect to Uninstall-Java (ADR-REMOVE:3).
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Java is managed by the tooling system. Use Uninstall-Java instead.'
    }

    # Linux: evict an off-config install by the mechanism that placed it (apt / uv-Python pip / stray binary);
    # elevation is scoped to the mechanism (ADR-REMOVE:6). macOS eviction is a stub (ADR-REMOVE:7).
    if ($IsLinux) {
        if (-not $Force) {
            Write-Message 'Would evict an off-config Java (apt package / uv-Python pip / stray binary). Run with -Force to execute.'
            return
        }
        if (-not (Remove-LinuxToolInstall -Config $config)) {
            Write-Message 'No off-config Java found — nothing to remove.'
        }
        return
    }
    if ($IsMacOS) {
        Remove-MacToolInstall -Config $config | Out-Null
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
