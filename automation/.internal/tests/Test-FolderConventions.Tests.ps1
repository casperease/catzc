<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/.internal/tests/Test-FolderConventions.Tests.ps1
    name: test-folder-conventions-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Internal.Tests
    moduletype: pwsh-folder
    catzc_bundle: minimal
  edges:
    page: docs/references/automation/internal/tests/Test-FolderConventions.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#35
---
#>

Describe 'Folder & file conventions' -Tag 'L0', 'integrity' {
    BeforeAll {
        $script:result = Test-FolderConventions -PassThru -OutputFolder (Join-Path $TestDrive 'folder-conventions')
    }

    It 'the scan found modules (guards the checks below against a silent no-op)' {
        $result.Modules | Should -BeGreaterThan 3
    }

    It 'reports no folder or file convention issues' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
