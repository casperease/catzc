<#
.SYNOPSIS
    Runs one formatter engine over the given files and returns the files it changed.
.DESCRIPTION
    The one place an engine name from languages.yml becomes code: each engine LanguagesConfig.FormatterEngines...
    [ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-FormatterEngine.ps1.md#comment1)
.PARAMETER Engine
    The engine name, as languages.yml spells it.
.PARAMETER File
    Absolute paths of the files to format.
.PARAMETER DryRun
    List the files the engine would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-FormatterEngine {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    switch -CaseSensitive ($Engine) {
        'prettier' {
            return Invoke-Prettier -File $File -DryRun:$DryRun
        }
        'gofmt' {
            return Invoke-Gofmt -File $File -DryRun:$DryRun
        }
        'ruff' {
            return Invoke-RuffFormat -File $File -DryRun:$DryRun
        }
        'psscriptanalyzer' {
            return Invoke-PSScriptAnalyzerFormat -File $File -DryRun:$DryRun
        }
        'dotnet-format' {
            return Invoke-DotnetFormat -File $File -DryRun:$DryRun
        }
        'bicep' {
            return Invoke-BicepFormat -File $File -DryRun:$DryRun
        }
        default {
            throw "Invoke-FormatterEngine: no adapter for the formatter engine '$Engine' (declared: $([Catzc.Base.Languages.LanguagesConfig]::FormatterEngines -join ', '))."
        }
    }
}
