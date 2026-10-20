<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/private/Install-PipTool.ps1
    folder: private
    name: install-pip-tool
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1
    docs: "[Install-PipTool.ps1.md](docs/references/pwsh/catzc-tooling-python/private/Install-PipTool.ps1.md)"
    cites:
      - ADR-AUTO-UVPY-TWOINSTALLSHAPES
---
#>

function Install-PipTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool,
        [string] $Version = (Get-ToolConfig -Tool $Tool).version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool
    Assert-NotNullOrWhitespace $config.pip_package -ErrorText "$Tool has no pip_package in tools.yml — cannot install via uv pip"


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
            Invoke-Pip "uninstall --python $pythonVersion --system --break-system-packages $($config.pip_package)"
        }
        else {
            $location = (Get-Command $config.command).Source
            throw "$Tool version mismatch: expected $Version.x, found $installed at '$location'. Run Install-$command -Force to replace, or uninstall manually."
        }
    }

    Invoke-Pip "install --python $pythonVersion --system --break-system-packages $($config.pip_package)==$Version.*"

    Sync-SessionPath

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
