<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
    kind: test
---
#>

# Keeps the manual test plan's category files (docs/how-to/automation/manual-test-plan/) in sync with the tests, through its quality gate
# (Test-ManualTestPlan — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The gate
# derives the integrity blocks by PARSING the test files, never by booting Pester discovery
# ([ADR-AUTO-TEST#16](/docs/adr/automation/test-automation.md#rule-adr-auto-test16)). It is self-referential: this
# Describe is integrity-tagged, so the plan lists it too. source-only: it reads the repository's test files and the
# plan document, which give the same answer in both run modes.
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
