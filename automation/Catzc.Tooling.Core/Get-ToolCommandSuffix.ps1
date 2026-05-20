<#
.SYNOPSIS
    Maps a snake_case tool key from tools.yml to its PascalCase command suffix.
.DESCRIPTION
    Tool identities in tools.yml are snake_case (e.g. 'az_cli', 'node_js', 'py_spark'),
    matching the config-naming ADR. The per-tool commands, however, follow the module's
    Verb-Noun convention (Install-AzCli, Remove-NodeJs, Uninstall-PySpark). This converts
    the config key to that command suffix so name-based dispatch and user-facing
    "Run Install-<x>" messages resolve correctly: 'az_cli' -> 'AzCli'.
.PARAMETER Tool
    The snake_case tool key (e.g. 'py_spark').
.EXAMPLE
    Get-ToolCommandSuffix -Tool 'az_cli'   # -> 'AzCli'
#>
function Get-ToolCommandSuffix {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    $textInfo = [cultureinfo]::InvariantCulture.TextInfo
    (($Tool -split '_') | ForEach-Object { $textInfo.ToTitleCase($_) }) -join ''
}
