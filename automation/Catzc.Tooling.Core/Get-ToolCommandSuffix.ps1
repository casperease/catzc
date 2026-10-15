<#
.SYNOPSIS
    Maps a snake_case tool key from tools.yml to its PascalCase command suffix.
.DESCRIPTION
    Tool identities in tools.yml are snake_case (e.g.
    [comment:1](/docs/references/automation/catzc-tooling-core/Get-ToolCommandSuffix.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key (e.g. 'py_spark').
.EXAMPLE
    Get-ToolCommandSuffix -Tool 'az_cli'   # -> 'AzCli'
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
