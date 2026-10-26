function Get-FormatEngineVersion {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine
    )

    # ruff and PSScriptAnalyzer run from pins their stamp already reads (python.yml, the vendored module's folder), so they probe nothing.
    $tool = switch -CaseSensitive ($Engine) {
        'prettier' {
            'prettier'
        }
        'gofmt' {
            'go'
        }
        'dotnet-format' {
            'dotnet'
        }
        'bicep' {
            'bicep'
        }
        default {
            $null
        }
    }
    if (-not $tool) {
        return ''
    }
    $probe = Resolve-ToolExecutable -Tool $tool
    if ($probe.Found) {
        [string] $probe.Version
    }
    else {
        'missing'
    }
}
