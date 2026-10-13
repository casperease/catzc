# The coverage gate ([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4))
# over the real tree: every function that reads an internal asset through
# Get-CatzcModuleRoot has a test citing
# [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) that is not
# source-only, so the read is exercised in
# both the source run and the build run. It scans the source files (per-function .ps1 and tests/), which
# only the source tree has — so the gate itself is source-only.
Describe 'Internal asset dependency coverage (real tree)' -Tag 'L1', 'integrity', 'source-only', 'ADR-AUTO-ASSETDEP#4' {
    It 'every Get-CatzcModuleRoot call site passes literal -ChildPath and -Module values (ADR-AUTO-ASSETDEP:2)' {
        $violations = @(Get-InternalAssetDependency -Violation)
        $report = ($violations | ForEach-Object { "$($_.File):$($_.Line) $($_.Function) — $($_.Reason)" }) -join '; '
        $violations | Should -HaveCount 0 -Because "non-literal call sites cannot be inventoried: $report"
    }

    It 'every function with an internal asset dependency has a both-suites test citing ADR-AUTO-ASSETDEP#3' {
        $uncovered = @(InModuleScope Catzc.Base.ModuleSystem { Get-UncoveredInternalAssetDependency })
        $report = ($uncovered | ForEach-Object { "$($_.Module)/$($_.Function) [$($_.ChildPath -join ', ')] — $($_.Reason)" }) -join '; '
        $uncovered | Should -HaveCount 0 -Because "uncovered internal asset dependencies: $report"
    }
}
