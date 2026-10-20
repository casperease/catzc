<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Get-ToolConfig.ps1
    name: get-tool-config
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
