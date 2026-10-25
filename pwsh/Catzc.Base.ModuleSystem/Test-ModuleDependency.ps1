<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Test-ModuleDependency.ps1.md"
  warning: "Generated Header"
---
#>

function Test-ModuleDependency {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Write-QualityGateReport -Subject module-dependency -Title Test-ModuleDependency `
        -Issues @(Get-ModuleDependencyViolations) -OutputFolder $OutputFolder -PassThru:$PassThru
}
