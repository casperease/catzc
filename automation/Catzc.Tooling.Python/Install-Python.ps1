<#
.SYNOPSIS
    Provisions Python via uv.
.DESCRIPTION
    Installs a uv-managed CPython (`uv python install <version> --default`) — user-space, cross-platform, with
    a global python/python3 shim in uv's bin (~/.local/bin). Requires uv. Idempotent — skips if the correct
    version is already on PATH.

    NOT for CI pipelines. In Azure DevOps, use the native UsePythonVersion task which activates pre-cached
    versions instantly:

        - task: UsePythonVersion@0
          inputs:
            versionSpec: '3.11'
.PARAMETER Version
    Python version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Reinstall even when a build is already present (uv --reinstall).
.EXAMPLE
    Install-Python
.EXAMPLE
    Install-Python -Version '3.12'
#>
function Install-Python {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    Assert-False (Test-IsRunningInPipeline) -ErrorText (
        'Install-Python is for developer workstations, not CI. ' +
        "In ADO pipelines, use the native task: - task: UsePythonVersion@0 inputs: versionSpec: '3.11'"
    )

    $config = Get-ToolConfig -Tool 'python'
    if (-not $Version) {
        $Version = $config.version
    }

    # Idempotent: skip if already at the correct version (unless forcing a reinstall).
    if (-not $Force -and (Test-Command $config.command)) {
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "python $Version is already installed"
            return
        }
    }

    # uv resolves the newest matching CPython, installs it, and (--default) writes the global python/python3
    # shims into its bin dir. --default is still preview-gated, so opt in explicitly with
    # --preview-features to keep it (and silence uv's experimental warning, which WarningPreference=Stop
    # would otherwise turn into a halt). --reinstall replaces an existing build of the same version under -Force.
    $reinstall = if ($Force) {
        ' --reinstall'
    }
    else {
        ''
    }
    Invoke-Uv "python install $Version --default --preview-features python-install-default$reinstall"

    Sync-SessionPath

    Assert-Command $config.command -ErrorText "python was installed but '$($config.command)' is not on PATH. You may need to restart your shell (or run 'uv python update-shell')."

    $actual = Get-ToolVersion -Config $config
    if ($actual -and $actual.StartsWith($Version)) {
        Write-Message "python $actual installed successfully"
    }
    else {
        Write-Message "python installed but could not verify version as $Version.x"
    }
}
