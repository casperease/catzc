<#
.SYNOPSIS
    The fingerprint of everything besides a file's own bytes that decides what a formatter engine writes.
.DESCRIPTION
    Format-Code's result cache keys a file on its SHA-256 and this stamp (Get-ContentStamp): the engine's name and each
    settings file languages.yml lists for the engine — including the tool registry whose pin names the engine's version,
    so a new pin is a new stamp ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). No input
    is known here that languages.yml does not declare.
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
