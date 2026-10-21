<#
---
catzc:
  immutable:
    with_body_sha: f67014498636
  edges:
    docs: "[Test-FolderConventions.Tests.ps1.md](../../../docs/references/pwsh/internal/tests/Test-FolderConventions.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Folder & file conventions' -Tag 'L0', 'integrity' {
    BeforeAll {
        $script:result = Test-FolderConventions -PassThru -OutputFolder (Join-Path $TestDrive 'folder-conventions')
    }

    It 'the scan found modules (guards the checks below against a silent no-op)' {
        $result.Facts['Modules'] | Should -BeGreaterThan 3
    }

    It 'reports no folder or file convention issues' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
