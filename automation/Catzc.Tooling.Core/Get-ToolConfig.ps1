<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolConfig.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the locked configuration for a CLI tool as a validated ToolConfig.
.DESCRIPTION
    The config is built and validated once per session, so repeated calls return the same cached ToolConfig instance.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
.EXAMPLE
    $config = Get-ToolConfig -Tool 'python'
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
