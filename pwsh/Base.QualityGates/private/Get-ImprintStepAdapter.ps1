<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ImprintStepAdapter.ps1.md"
  header: "generated"
---
#>

function Get-ImprintStepAdapter {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Step
    )

    $adapters = switch -CaseSensitive ($Step) {
        'file-meta' {
            'Invoke-FileMetaEngine', 'Save-FileMetaResult'
        }
        'bcl-namespace' {
            'Format-Types'
        }
        'ps-help' {
            'Get-CommentPage', 'Get-HelpPageFinding'
        }
        'comments' {
            'Export-Comments'
        }
        'plan-counts' {
            'Update-PlanStepCount'
        }
        default {
            throw "Get-ImprintStepAdapter: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
    , [string[]] @('Invoke-ImprintStep') + @($adapters)
}
