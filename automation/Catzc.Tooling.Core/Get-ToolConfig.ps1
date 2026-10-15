<#
.SYNOPSIS
    Returns the locked configuration for a CLI tool as a validated ToolConfig.
.DESCRIPTION
    Looks one tool's locked definition up in configs/tools.yml, read through Get-Config — which constructs the typed...
    [comment:1](/docs/references/automation/catzc-tooling-core/Get-ToolConfig.ps1.md#comment1)
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
