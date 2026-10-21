<#
---
catzc:
  immutable:
    with_body_sha: "44dce6b929c1"
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Get-ToolCommandSuffix.Tests.ps1
    docs: "[Get-ToolCommandSuffix.ps1.md](../../docs/references/pwsh/catzc-tooling-core/Get-ToolCommandSuffix.ps1.md)"
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
