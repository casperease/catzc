<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/Uninstall-UvTool.ps1
    name: uninstall-uv-tool
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
---
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
