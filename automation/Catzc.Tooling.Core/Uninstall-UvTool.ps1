<#
.SYNOPSIS
    Uninstalls a uv-managed tool.
.DESCRIPTION
    Removes a CLI installed via Install-UvTool (`uv tool uninstall <uv_tool>`). Idempotent — skips if the
    tool is not installed.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (must declare uv_tool).
#>
function Uninstall-UvTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool
    )

    $config = Get-ToolConfig -Tool $Tool
    Assert-NotNullOrWhitespace $config.uv_tool -ErrorText "$Tool has no uv_tool in tools.yml — cannot uninstall via uv tool"

    # Idempotent: skip if not installed.
    if (-not (Test-Command $config.command)) {
        Write-Message "$Tool is not installed — nothing to do"
        return
    }

    Invoke-Uv "tool uninstall $($config.uv_tool)"
    Write-Message "$Tool uninstalled"
}
