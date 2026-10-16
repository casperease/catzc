<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
    folder: tests
    name: get-internal-asset-dependency-integrity-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md
    cites:
      - ADR-AUTO-ASSETDEP#{3,4}
      - ADR-AUTO-TEST#35
---
#>

Describe 'Internal asset dependency coverage (real tree)' -Tag 'L1', 'integrity', 'source-only', 'ADR-AUTO-ASSETDEP#4' {
    It 'every call site is literal and every internal asset dependency has a both-runs test citing ADR-AUTO-ASSETDEP#3' {
        $result = Test-InternalAssetDependency -PassThru -OutputFolder (Join-Path $TestDrive 'internal-asset-dependency')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
