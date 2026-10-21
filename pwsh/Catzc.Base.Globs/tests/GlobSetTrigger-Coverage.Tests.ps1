<#
---
catzc:
  immutable:
    with_body_sha: "3c0090d19372"
  edges:
    docs: "[GlobSetTrigger-Coverage.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-FLOW-CD-GLOBS-NAMEDGLOBSETS
---
#>

Describe 'Native-trigger projection coverage' -Tag 'L2', 'integrity', 'source-only' {
    It 'ADO includes cover every member of every pipeline-bound set (include-only is a safe superset)' {
        $result = Test-GlobSetTriggerCoverage -PassThru -OutputFolder (Join-Path $TestDrive 'glob-set-trigger-coverage')
        $result.Facts['GlobSets'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
