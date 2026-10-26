<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Invoke-FormatterEngine.ps1.md"
  header: "generated"
---
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
            return Invoke-PsScriptAnalyzerFormat -File $File -DryRun:$DryRun
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
