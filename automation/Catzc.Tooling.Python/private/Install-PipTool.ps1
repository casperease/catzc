<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/private/Install-PipTool.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: private
---
#>

<#
.SYNOPSIS
    Installs a Python-library tool into the uv-managed Python via `uv pip`.
.DESCRIPTION
    Unlike an isolated uv tool, the package lands in the shared managed Python, so it stays importable.
    [comment:1](/docs/references/automation/catzc-tooling-python/private/Install-PipTool.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (must declare pip_package).
.PARAMETER Version
    Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).
.PARAMETER Force
    Uninstall a wrong version before installing the correct one.
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


    # All three flags are needed: pin the interpreter, allow a non-virtual install, and override uv's PEP-668 marker.
    # [ADR-AUTO-UVPY#2](/docs/adr/automation/uv-python-handler.md#rule-adr-auto-uvpy2)
    # [comment:2](/docs/references/automation/catzc-tooling-python/private/Install-PipTool.ps1.md#comment2)
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

    # The package must be importable in the toolchain's own interpreter, not trapped in an isolated environment.
    # [comment:3](/docs/references/automation/catzc-tooling-python/private/Install-PipTool.ps1.md#comment3)
    Invoke-Pip "install --python $pythonVersion --system --break-system-packages $($config.pip_package)==$Version.*"

    Sync-SessionPath

    # A pip library may expose no PATH executable, so the version probe, not a command check, confirms the install.
    # [comment:4](/docs/references/automation/catzc-tooling-python/private/Install-PipTool.ps1.md#comment4)
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
