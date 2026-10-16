<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    visibility: public
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
    adrs:
      - ADR-AUTO-ASSETDEP#{2-4}
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Quality gate: every internal asset dependency is inventoried and covered by a test that runs in both run modes.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) enforcing the
      coverage rule [ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4) over the module
      code. It collects an issue for:

        - every Get-CatzcModuleRoot call site whose -ChildPath or -Module is not a string literal
          ([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)) — such a
          site cannot be inventoried (Get-InternalAssetDependency -Violation);
        - every function with an internal asset dependency that no test citing
          [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) and not
          source-only covers, so the read is exercised in the source run and the build run
          (Get-UncoveredInternalAssetDependency).

      It scans the per-function source files and tests, which exist only in the source tree.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-internal-asset-dependency/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-InternalAssetDependency
---
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
