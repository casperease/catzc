<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
    name: test-internal-asset-dependency
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
    docs: "[Test-InternalAssetDependency.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Test-InternalAssetDependency.ps1.md)"
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
