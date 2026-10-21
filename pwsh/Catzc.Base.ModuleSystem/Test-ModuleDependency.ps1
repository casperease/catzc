<#
---
catzc:
  immutable:
    with_body_sha: "5189eef65780"
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
    docs: "[Test-ModuleDependency.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Test-ModuleDependency.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
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
