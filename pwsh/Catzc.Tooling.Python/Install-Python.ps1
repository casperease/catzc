<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Install-Python.ps1
    name: install-python
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Install-Python.Tests.ps1
    docs: "[Install-Python.ps1.md](docs/references/pwsh/catzc-tooling-python/Install-Python.ps1.md)"
---
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
