<#
.SYNOPSIS
    Installs a pip-managed tool.
.DESCRIPTION
    Private helper for Install-Poetry and Install-AzCli. Mirrors
    Install-Tool's contract but uses pip instead of platform package
    managers. Handles idempotency, scope validation, and Force.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml.
.PARAMETER Version
    Version override. Defaults to the locked version.
.PARAMETER Force
    Automatically uninstall the wrong version before installing the correct one.
#>
function Install-PipTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool,
        [string] $Version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool
    Assert-NotNullOrWhitespace $config.pip_package -ErrorText "$Tool has no pip_package in tools.yml — cannot install via pip"

    if (-not $Version) {
        $Version = $config.version
    }

    # Dependency: pip-managed tools require Python
    Assert-Tool 'python'

    # Scope check: pip writes to Python's Scripts directory. If Python is
    # machine-wide, that directory is read-only without admin.
    $pythonConfig = Get-ToolConfig -Tool 'python'
    $pythonLocation = (Get-Command python).Source
    $scope = Get-InstallScope -Config $pythonConfig -Location $pythonLocation
    if ($scope -eq 'machine' -and -not (Test-IsAdministrator)) {
        throw "Python is installed machine-wide at '$pythonLocation'. " +
        'pip cannot write to its Scripts directory without admin. ' +
        'Either run as Administrator, or uninstall Python and run Install-Python to install user-scope.'
    }

    # Idempotent: skip if already installed at the correct version
    if (Test-Command $config.command) {
        $installed = Get-ToolVersion -Config $config

        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "$Tool $Version is already installed"
            return
        }

        if (-not $installed) {
            Write-Verbose "Could not parse version from '$((Get-Command $config.command).Source)' — treating as not installed"
        }
        elseif ($Force) {
            Write-Verbose "$Tool $installed found — uninstalling before installing $Version"
            Invoke-Pip "uninstall $($config.pip_package) -y"
        }
        else {
            $location = (Get-Command $config.command).Source
            throw "$Tool version mismatch: expected $Version.x, found $installed at '$location'. Run Install-$command -Force to replace, or uninstall manually."
        }
    }

    Invoke-Pip "install -q $($config.pip_package)==$Version.*"

    Sync-SessionPath

    Assert-Command $config.command -ErrorText "$Tool was installed but '$($config.command)' is not on PATH. You may need to restart your shell."

    # Verify the actual installed version matches what we asked for.
    $actualVersion = Get-ToolVersion -Config $config

    if ($actualVersion -and $actualVersion.StartsWith($Version)) {
        Write-Message "$Tool $actualVersion installed successfully"
    }
    elseif ($actualVersion) {
        Write-Message "$Tool installed but version $actualVersion does not match expected $Version.x — package manager may have installed a different version"
    }
    else {
        Write-Message "$Tool installed but could not verify version"
    }
}
