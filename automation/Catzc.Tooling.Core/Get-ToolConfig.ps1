<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolConfig.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
  config:
    synopsis: Returns the locked configuration for a CLI tool as a validated ToolConfig.
    description: |-
      Looks one tool's locked definition up in configs/tools.yml, read through Get-Config — which constructs the
      typed Catzc.Base.Execution.ToolsConfig once per session (validating every entry) and caches it, so repeated
      calls return the same ToolConfig instance.
    parameters:
      Tool: The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').
    examples:
      - '$config = Get-ToolConfig -Tool ''python'''
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
