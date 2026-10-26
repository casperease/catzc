<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Uninstall-UvVenvTool.ps1.md"
  header: "generated"
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
