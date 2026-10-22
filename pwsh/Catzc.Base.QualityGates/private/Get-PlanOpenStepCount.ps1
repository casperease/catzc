<#
---
catzc:
  immutable:
    with_body_sha: f494985b5fab
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-PlanOpenStepCount.Tests.ps1
    docs: "[Get-PlanOpenStepCount.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-PlanOpenStepCount.ps1.md)"
---
#>

function Get-PlanOpenStepCount {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.PlansConfig] $Config
    )

    $files = [string[]] @([System.IO.Directory]::GetFiles($Folder, 'plan-*.md'))
    [Array]::Sort($files, [System.StringComparer]::Ordinal)
    $counts = [ordered]@{}
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileName($file)
        if ($name -ceq $Config.master_file) {
            continue
        }
        $lines = [System.IO.File]::ReadAllText($file) -split "`r?`n"
        $counts[$name] = @(Get-MarkdownListItem -Line $lines | Where-Object { $_.First -match '^\s*(-|\d+\.) \[ \]' }).Count
    }
    , $counts
}
