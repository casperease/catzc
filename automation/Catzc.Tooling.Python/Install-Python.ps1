<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Install-Python.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Provisions Python via uv.
.DESCRIPTION
    Developer workstations only: in CI pipelines the native UsePythonVersion task activates cached versions instead.
    [comment:1](/docs/references/automation/catzc-tooling-python/Install-Python.ps1.md#comment1)
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
        [string] $Version = (Get-ToolConfig -Tool 'python').version,
        [switch] $Force
    )

    Assert-False (Test-IsRunningInPipeline) -ErrorText (
        'Install-Python is for developer workstations, not CI. ' +
        "In ADO pipelines, use the native task: - task: UsePythonVersion@0 inputs: versionSpec: '3.11'"
    )

    $config = Get-ToolConfig -Tool 'python'

    # Idempotent: skip if already at the correct version (unless forcing a reinstall).
    if (-not $Force -and (Test-Command $config.command)) {
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "python $Version is already installed"
            return
        }
    }

    # --default is still a uv preview feature: without the opt-in flag uv warns, and WarningPreference=Stop would halt.
    # [comment:2](/docs/references/automation/catzc-tooling-python/Install-Python.ps1.md#comment2)
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
