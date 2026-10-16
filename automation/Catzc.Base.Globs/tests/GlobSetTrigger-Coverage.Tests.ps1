<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#1
---
#>

Describe 'Native-trigger projection coverage' -Tag 'L2', 'integrity', 'source-only' {
    It 'ADO includes cover every member of every pipeline-bound set (include-only is a safe superset)' {
        $result = Test-GlobSetTriggerCoverage -PassThru -OutputFolder (Join-Path $TestDrive 'glob-set-trigger-coverage')
        $result.GlobSets | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
