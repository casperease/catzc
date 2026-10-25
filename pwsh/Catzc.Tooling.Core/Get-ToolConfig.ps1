<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Get-ToolConfig.ps1.md"
  header: "generated"
---
#>

function Get-ToolConfig {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Execution.ToolConfig])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool
    )

    $allTools = Get-Config -Config tools
    if (-not $allTools.Contains($Tool)) {
        throw "Unknown tool '$Tool'. Known tools: $($allTools.Keys -join ', ')"
    }
    $allTools[$Tool]
}
