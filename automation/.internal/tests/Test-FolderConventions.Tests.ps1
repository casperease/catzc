<#
---
catzc:
  derived:
    path: automation/.internal/tests/Test-FolderConventions.Tests.ps1
    kind: pester-test
---
#>

# The folder and file conventions over the real tree, through their quality gate (Test-FolderConventions,
# Catzc.Base.ModuleSystem — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The gate
# scans the tree once and lists every offender; this block runs it at its tier and guards it against a silent no-op.
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
