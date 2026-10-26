<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Get-ToolCommandSuffix.ps1.md"
  header: "generated"
---
#>

function Get-ToolCommandSuffix {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Tool
    )

    $textInfo = [cultureinfo]::InvariantCulture.TextInfo
    (($Tool -split '_') | ForEach-Object { $textInfo.ToTitleCase($_) }) -join ''
}
