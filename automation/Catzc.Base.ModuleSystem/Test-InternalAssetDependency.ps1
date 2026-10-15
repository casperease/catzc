<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
---
#>

<#
.SYNOPSIS
    Quality gate: every internal asset dependency is inventoried and covered by a test that runs in both run modes.
.DESCRIPTION
    A test must cite the rule and not be source-only, so the read is exercised in both the source and build run.
    [ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2),
    [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3),
    [ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Test-InternalAssetDependency.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-internal-asset-dependency/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-InternalAssetDependency
#>
function Test-InternalAssetDependency {
    [CmdletBinding()]
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
