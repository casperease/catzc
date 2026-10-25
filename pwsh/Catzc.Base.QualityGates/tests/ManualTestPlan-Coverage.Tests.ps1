<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/ManualTestPlan-Coverage.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Manual test plan covers every integrity check' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-ManualTestPlan -PassThru -OutputFolder (Join-Path $TestDrive 'manual-test-plan')
    }

    It 'the AST scan found the integrity blocks (guards against a silent no-op)' {
        $result.Facts['IntegrityBlocks'] | Should -BeGreaterThan 30
    }

    It 'every integrity block has exactly one index row (matched on file + block name)' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
