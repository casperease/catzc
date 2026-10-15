<#
.SYNOPSIS
    The fingerprint of everything besides a file's own bytes that decides what a formatter engine writes.
.DESCRIPTION
    The settings include the tool registry whose pin names the engine's version, so a new pin is a new stamp.
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FormatEngineStamp.ps1.md#comment1)
.PARAMETER Engine
    The engine name, as languages.yml spells it.
.PARAMETER Settings
    The engine's settings files, repository-relative.
.PARAMETER RepositoryRoot
    The repository root.
.OUTPUTS
    [string] A hex SHA-256.
#>
function Get-FormatEngineStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine,

        [AllowEmptyCollection()]
        [string[]] $Settings = @(),

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $inputs = @($Settings | ForEach-Object { Join-Path $RepositoryRoot $_ })
    Get-ContentStamp -Label "format:$Engine" -File $inputs -RepositoryRoot $RepositoryRoot
}
