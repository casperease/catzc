<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
    kind: test
---
#>

# Write-QualityGateReport is every quality gate's output. The settings come from the real ReportsConfig type over a
# mocked reports config, and the report goes to $TestDrive, so each test pins one part of the uniform shape
# ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). Neutral fixture subjects
# (widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Write-QualityGateReport' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Reports -ParameterFilter { $Config -eq 'reports' } -MockWith {
            [Catzc.Base.Reports.ReportsConfig]::new(@{})
        }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-OutputRoot -ModuleName Catzc.Base.Reports { $TestDrive }
    }

    It 'writes the report and latest.txt under the subject''s folder and passes when there are no issues' -Tag 'ADR-AUTO-TEST#35' {
        { Write-QualityGateReport -Subject widget -Title Test-Widget -Issues @() } | Should -Not -Throw
        $folder = Join-Path $TestDrive 'test-widget'
        $latest = ([System.IO.File]::ReadAllText((Join-Path $folder 'latest.txt'))).Trim()
        $report = [System.IO.File]::ReadAllText((Join-Path $folder "$latest/widget.md"))
        $report | Should -Match '# Test-Widget report'
        $report | Should -Match '- Result: no widget issues'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq 'No widget issues found.' }
    }

    It 'throws once with every issue and the report path' -Tag 'ADR-AUTO-TEST#35' {
        $thrown = { Write-QualityGateReport -Subject widget -Title Test-Widget -Issues @('first problem', 'second problem') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Widget failed: 2 issue(s) — see *'
        $thrown.Exception.Message | Should -Match 'first problem'
        $thrown.Exception.Message | Should -Match 'second problem'
    }

    It 'returns the result with its facts instead of throwing under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $result = Write-QualityGateReport -Subject gadget -Title Test-Gadget -Issues @('one problem') `
            -Facts ([ordered]@{ Files = 3 }) -PassThru
        $result.Subject | Should -Be 'gadget'
        $result.IssueCount | Should -Be 1
        $result.Issues | Should -Be @('one problem')
        $result.Files | Should -Be 3
        [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'gadget.md')) | Should -Match '- Files: 3'
    }

    It 'keeps two runs in the same second apart' -Tag 'ADR-AUTO-TEST#35' {
        $first = Write-QualityGateReport -Subject widget -Title Test-Widget -PassThru
        $second = Write-QualityGateReport -Subject widget -Title Test-Widget -PassThru
        $first.ReportPath | Should -Not -Be $second.ReportPath
    }

    It 'rejects a subject that is not kebab-case' {
        { Write-QualityGateReport -Subject 'Widget Gate' -Title Test-Widget } | Should -Throw
    }
}
