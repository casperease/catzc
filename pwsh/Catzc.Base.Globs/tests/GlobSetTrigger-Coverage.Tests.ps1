<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Native-trigger projection coverage' -Tag 'L2', 'integrity', 'source-only' {
    It 'ADO includes cover every member of every pipeline-bound set (include-only is a safe superset)' {
        $result = Test-GlobSetTriggerCoverage -PassThru -OutputFolder (Join-Path $TestDrive 'glob-set-trigger-coverage')
        $result.Facts['GlobSets'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
