<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Uninstall-UvTool.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Uninstalls a uv-managed tool.
.DESCRIPTION
    A tool that is not installed is a no-op, not an error, and uv is only reached when something is to remove.
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
