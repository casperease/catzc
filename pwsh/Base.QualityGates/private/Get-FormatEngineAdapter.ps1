<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-FormatEngineAdapter.ps1.md"
  header: "generated"
---
#>

function Get-FormatEngineAdapter {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine
    )

    switch -CaseSensitive ($Engine) {
        'prettier' {
            'Invoke-Prettier'
        }
        'gofmt' {
            'Invoke-Gofmt'
        }
        'ruff' {
            'Invoke-RuffFormat'
        }
        'psscriptanalyzer' {
            'Invoke-PsScriptAnalyzerFormat'
        }
        'dotnet-format' {
            'Invoke-DotnetFormat'
        }
        'bicep' {
            'Invoke-BicepFormat'
        }
        default {
            throw "Get-FormatEngineAdapter: no adapter for the formatter engine '$Engine' (declared: $([Catzc.Base.Languages.LanguagesConfig]::FormatterEngines -join ', '))."
        }
    }
}
