<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Invoke-FormatterEngine.ps1
    folder: private
    name: invoke-formatter-engine
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Invoke-FormatterEngine.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Invoke-FormatterEngine.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-NEWINSTANCEISCONFIGCHANGE
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
