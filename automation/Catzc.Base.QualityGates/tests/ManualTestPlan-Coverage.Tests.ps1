<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#16
      - ADR-AUTO-TEST#35
---
#>

# Keeps the manual test plan's category files (docs/how-to/automation/manual-test-plan/) in sync with the tests,...
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md#comment1)
Describe 'Manual test plan covers every integrity check' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-ManualTestPlan -PassThru -OutputFolder (Join-Path $TestDrive 'manual-test-plan')
    }

    It 'the AST scan found the integrity blocks (guards against a silent no-op)' {
        $result.IntegrityBlocks | Should -BeGreaterThan 30
    }

    It 'every integrity block has exactly one index row (matched on file + block name)' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
