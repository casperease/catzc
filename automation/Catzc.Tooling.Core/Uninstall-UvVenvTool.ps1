<#
.SYNOPSIS
    Uninstalls a CLI installed into a dedicated uv venv.
.DESCRIPTION
    Removes the tool's dedicated venv (see Install-UvVenvTool). Idempotent — skips if the venv is absent.
.PARAMETER Tool
    The snake_case tool key (must declare uv_venv).
#>
function Uninstall-UvVenvTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool
    )

    $config = Get-ToolConfig -Tool $Tool
    Assert-NotNullOrWhitespace $config.uv_venv -ErrorText "$Tool has no uv_venv in tools.yml — cannot uninstall a uv venv"

    $venvDir = Get-UvVenvDir -Tool $Tool
    if (-not (Test-Path -LiteralPath $venvDir)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    [System.IO.Directory]::Delete($venvDir, $true)
    Write-Message "$Tool uninstalled"
}
