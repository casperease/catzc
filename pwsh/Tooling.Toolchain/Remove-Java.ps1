function Remove-Java {
    [CmdletBinding()]
    param(
        [string] $InstallDir,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'java'

    # A tool our manager owns is refused and redirected to Uninstall-Java.
    if (Test-ExpectedPackageManager -Config $config) {
        throw 'Java is managed by the tooling system. Use Uninstall-Java instead.'
    }

    # An off-config install is evicted by the mechanism that placed it, and elevation is scoped to that mechanism, so no admin assert here.
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
