<#
.SYNOPSIS
    Returns the locked configuration for a CLI tool as a validated ToolConfig.
.DESCRIPTION
    Looks one tool's locked definition up in configs/tools.yml, read through Get-Config — which constructs the
    typed Catzc.Tooling.Core.ToolsConfig once per session (validating every entry) and caches it, so repeated
    calls return the same ToolConfig instance.
.PARAMETER Tool
    The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
.EXAMPLE
    $config = Get-ToolConfig -Tool 'python'
#>
function Get-ToolConfig {
    [CmdletBinding()]
    [OutputType([Catzc.Tooling.Core.ToolConfig])]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    $allTools = Get-Config -Config tools
    if (-not $allTools.Contains($Tool)) {
        throw "Unknown tool '$Tool'. Known tools: $($allTools.Keys -join ', ')"
    }
    $allTools[$Tool]
}
