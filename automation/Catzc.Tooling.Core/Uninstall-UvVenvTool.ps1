<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/Uninstall-UvVenvTool.ps1
    name: uninstall-uv-venv-tool
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
