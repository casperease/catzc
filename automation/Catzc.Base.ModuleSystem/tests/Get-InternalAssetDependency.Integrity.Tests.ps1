# The coverage rule ([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4))
# over the real tree, through its quality gate (Test-InternalAssetDependency —
# [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every Get-CatzcModuleRoot call site
# passes literal values, and every function that reads an internal asset has a test citing
# [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) that is not
# source-only, so the read is exercised in both the source run and the build run. It scans the source files
# (per-function .ps1 and tests/), which only the source tree has — so the gate itself is source-only.
Describe 'Internal asset dependency coverage (real tree)' -Tag 'L1', 'integrity', 'source-only', 'ADR-AUTO-ASSETDEP#4' {
    It 'every call site is literal and every internal asset dependency has a both-runs test citing ADR-AUTO-ASSETDEP#3' {
        $result = Test-InternalAssetDependency -PassThru -OutputFolder (Join-Path $TestDrive 'internal-asset-dependency')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
