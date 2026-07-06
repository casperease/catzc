<#
.SYNOPSIS
    Installs a Python-library tool into the uv-managed Python via `uv pip`.
.DESCRIPTION
    Private helper for Install-PySpark. Mirrors Install-Tool's contract but installs the package INTO the
    uv-managed Python with `uv pip install --system` (so it stays importable, unlike an isolated `uv tool`).
    Handles idempotency, -Force, and version verification. uv presence is asserted by Invoke-Pip.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (must declare pip_package).
.PARAMETER Version
    Version override. Defaults to the locked version.
.PARAMETER Force
    Uninstall a wrong version before installing the correct one.
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
    Assert-NotNullOrWhitespace $config.pip_package -ErrorText "$Tool has no pip_package in tools.yml — cannot install via uv pip"

    if (-not $Version) {
        $Version = $config.version
    }

    # Target the uv-managed Python explicitly (by its locked version), not `--system`: `uv pip --system` installs
    # into whatever interpreter uv discovers on PATH, which can be a stray system Python that shadows the managed
    # one. `--python <pin>` always lands in the interpreter the toolchain provisions.
    $pythonVersion = (Get-ToolConfig -Tool 'python').version

    # Idempotent: skip if already installed at the correct version.
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
            Invoke-Pip "uninstall --python $pythonVersion $($config.pip_package)"
        }
        else {
            $location = (Get-Command $config.command).Source
            throw "$Tool version mismatch: expected $Version.x, found $installed at '$location'. Run Install-$command -Force to replace, or uninstall manually."
        }
    }

    # Install into the uv-managed Python (by locked version) so the package is importable in the interpreter the
    # toolchain provisions, not trapped in an isolated tool env or a stray system Python.
    Invoke-Pip "install --python $pythonVersion $($config.pip_package)==$Version.*"

    Sync-SessionPath

    # A pip-installed library may expose no PATH executable (PySpark's launcher lives inside the package), so
    # confirm it through the version probe (an import/metadata read against the managed Python) rather than
    # asserting a command on PATH.
    $actualVersion = Get-ToolVersion -Config $config

    if (-not $actualVersion) {
        throw "$Tool was installed but its version probe ('$($config.version_command)') did not confirm it — check that the managed Python resolves on PATH."
    }

    if ($actualVersion.StartsWith($Version)) {
        Write-Message "$Tool $actualVersion installed successfully"
    }
    else {
        Write-Message "$Tool installed but version $actualVersion does not match expected $Version.x — uv may have installed a different version"
    }
}
