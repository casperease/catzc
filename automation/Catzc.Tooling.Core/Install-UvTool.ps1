<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Install-UvTool.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Installs a CLI as an isolated uv tool.
.DESCRIPTION
    Each tool gets its own isolated uv environment in user space, so installs never pollute a shared one.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (must declare uv_tool).
.PARAMETER Version
    Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).
.PARAMETER Force
    Uninstall a wrong version before installing the correct one.
#>
function Install-UvTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool,
        [string] $Version = (Get-ToolConfig -Tool $Tool).version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool $Tool
    $command = Get-ToolCommandSuffix -Tool $Tool
    Assert-NotNullOrWhitespace $config.uv_tool -ErrorText "$Tool has no uv_tool in tools.yml — cannot install via uv tool"


    # Idempotent: skip if already installed at the correct version (no uv needed to notice this).
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
            Invoke-Uv "tool uninstall $($config.uv_tool)"
        }
        else {
            $location = (Get-Command $config.command).Source
            throw "$Tool version mismatch: expected $Version.x, found $installed at '$location'. Run Install-$command -Force to replace, or uninstall manually."
        }
    }

    # Pre-release resolution, for packages that pin a beta dependency, goes through Invoke-Uv, which warns.
    # [comment:2](/docs/references/automation/catzc-tooling-core/Install-UvTool.ps1.md#comment2)
    Invoke-Uv "tool install $($config.uv_tool)==$Version.*" -Prerelease:$config.uv_allow_prerelease

    Sync-SessionPath

    Assert-Command $config.command -ErrorText "$Tool was installed but '$($config.command)' is not on PATH. You may need to restart your shell (or run 'uv tool update-shell')."

    # Verify the actual installed version matches what we asked for.
    $actualVersion = Get-ToolVersion -Config $config

    if ($actualVersion -and $actualVersion.StartsWith($Version)) {
        Write-Message "$Tool $actualVersion installed successfully"
    }
    elseif ($actualVersion) {
        Write-Message "$Tool installed but version $actualVersion does not match expected $Version.x — uv may have installed a different version"
    }
    else {
        Write-Message "$Tool installed but could not verify version"
    }
}
