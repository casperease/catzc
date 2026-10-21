<#
---
catzc:
  immutable:
    with_body_sha: d95ce35f4a64
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
    docs: "[Test-InternalAssetDependency.ps1.md](docs/references/pwsh/catzc-base-module-system/Test-InternalAssetDependency.ps1.md)"
    cites:
      - ADR-AUTO-ASSETDEP-LITERALCHILDPATH
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

function Test-InternalAssetDependency {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($violation in @(Get-InternalAssetDependency -Violation)) {
        $issues.Add("$($violation.File):$($violation.Line) $($violation.Function): $($violation.Reason) — a non-literal call site cannot be inventoried")
    }
    foreach ($uncovered in @(Get-UncoveredInternalAssetDependency)) {
        $issues.Add("$($uncovered.Module)/$($uncovered.Function) [$($uncovered.ChildPath -join ', ')]: $($uncovered.Reason)")
    }

    Write-QualityGateReport -Subject 'internal-asset-dependency' -Title 'Test-InternalAssetDependency' -Issues $issues `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
