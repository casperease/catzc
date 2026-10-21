<#
---
catzc:
  immutable:
    with_body_sha: aca099b42d0b
  edges:
    docs: "[Write-QualityGateReport.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Reports/Write-QualityGateReport.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Write-QualityGateReport' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Reports -ParameterFilter { $Config -eq 'reports' } -MockWith {
            [Catzc.Base.Reports.ReportsConfig]::new(@{})
        }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-OutputRoot -ModuleName Catzc.Base.Reports { $TestDrive }
    }

    It 'writes the report and latest.txt under the subject''s folder and passes when there are no issues' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        { Write-QualityGateReport -Subject widget -Title Test-Widget -Issues @() } | Should -Not -Throw
        $folder = Join-Path $TestDrive 'test-widget'
        $latest = ([System.IO.File]::ReadAllText((Join-Path $folder 'latest.txt'))).Trim()
        $report = [System.IO.File]::ReadAllText((Join-Path $folder "$latest/widget.md"))
        $report | Should -Match '# Test-Widget report'
        $report | Should -Match '- Result: no widget issues'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -ParameterFilter { $Message -eq 'No widget issues found.' }
    }

    It 'throws once with every issue and the report path' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $thrown = { Write-QualityGateReport -Subject widget -Title Test-Widget -Issues @('first problem', 'second problem') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Widget failed: 2 issue(s) — see *'
        $thrown.Exception.Message | Should -Match 'first problem'
        $thrown.Exception.Message | Should -Match 'second problem'
        # The throw carries the findings, so the summary does not print them again.
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -Times 0 -Exactly -ParameterFilter { $Message -in 'first problem', 'second problem' }
    }

    It 'prints each finding once when it returns the result instead of throwing' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $null = Write-QualityGateReport -Subject widget -Title Test-Widget -Issues @('first problem', 'second problem') -PassThru
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -Times 1 -Exactly -ParameterFilter { $Message -eq 'first problem' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Reports -Times 1 -Exactly -ParameterFilter { $Message -eq 'second problem' }
    }

    It 'returns the result with its facts instead of throwing under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Write-QualityGateReport -Subject gadget -Title Test-Gadget -Issues @('one problem') `
            -Facts ([ordered]@{ Files = 3 }) -PassThru
        $result | Should -BeOfType ([Catzc.Base.Reports.QualityGateResult])
        $result.Subject | Should -Be 'gadget'
        $result.IssueCount | Should -Be 1
        $result.Issues | Should -Be @('one problem')
        $result.Facts['Files'] | Should -Be 3
        [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'gadget.md')) | Should -Match '- Files: 3'
    }

    It 'writes a list-valued fact into the report as its count and returns the list itself' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Write-QualityGateReport -Subject gadget -Title Test-Gadget -Facts ([ordered]@{ Widgets = [string[]] @('one', 'two') }) -PassThru
        $result.Facts['Widgets'] | Should -Be @('one', 'two')
        [System.IO.File]::ReadAllText((Join-Path $result.ReportPath 'gadget.md')) | Should -Match '- Widgets: 2 item\(s\)'
    }

    It 'keeps two runs in the same second apart' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $first = Write-QualityGateReport -Subject widget -Title Test-Widget -PassThru
        $second = Write-QualityGateReport -Subject widget -Title Test-Widget -PassThru
        $first.ReportPath | Should -Not -Be $second.ReportPath
    }

    It 'rejects a subject that is not kebab-case' {
        { Write-QualityGateReport -Subject 'Widget Gate' -Title Test-Widget } | Should -Throw
    }
}
