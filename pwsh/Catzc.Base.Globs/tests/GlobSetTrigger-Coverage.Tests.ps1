<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
    folder: tests
    name: glob-set-trigger-coverage-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
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
