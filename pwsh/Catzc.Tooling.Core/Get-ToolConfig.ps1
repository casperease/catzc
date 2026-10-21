<#
---
catzc:
  immutable:
    with_body_sha: c840ad9118a6
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
    docs: "[Get-ToolConfig.ps1.md](docs/references/pwsh/catzc-tooling-core/Get-ToolConfig.ps1.md)"
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
