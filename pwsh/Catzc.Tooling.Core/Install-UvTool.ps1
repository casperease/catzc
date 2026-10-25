<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Install-UvTool.ps1.md"
  warning: "Generated Header"
---
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
