Describe 'Write-TestAutomationRuleCoverage' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-COVERAGEREPORTEDONLY' {
    BeforeAll {
        # A fake rule universe keeps the writer a pure function of its inputs.
        $script:allRuleIds = @('ADR-FAKE-TURN', 'ADR-FAKE-PULL', 'ADR-FAKE-FOLD', 'ADR-FAKE-SPIN', 'ADR-FAKE-TWIST')
        $script:rows = @(
            [pscustomobject]@{ ExpandedPath = 'M.a cites error'; Rules = 'ADR-FAKE-TURN' }
            [pscustomobject]@{ ExpandedPath = 'M.b cites error and idem'; Rules = 'ADR-FAKE-TURN;ADR-FAKE-SPIN' }
            [pscustomobject]@{ ExpandedPath = 'M.c cites nothing'; Rules = '' }
        )
        $script:analyzer = @(
            [pscustomobject]@{ AdrId = 'ADR-FAKE-FOLD'; Enforcer = 'Measure-FakeRule2'; Kind = 'pssa-rule' }
            [pscustomobject]@{ AdrId = 'ADR-FAKE-PULL'; Enforcer = 'Measure-FakeRule4'; Kind = 'pssa-rule' }
        )

        $script:dir = Join-Path $TestDrive 'coverage'
        InModuleScope Catzc.Base.QualityGates -Parameters @{
            Dir = $script:dir; R = $script:rows; A = $script:analyzer; Ids = $script:allRuleIds
        } {
            param($Dir, $R, $A, $Ids)
            Write-TestAutomationRuleCoverage -Rows $R -AnalyzerCoverage $A -AllRuleIds $Ids -OutputFolder $Dir
        }
        $script:md = Get-Content (Join-Path $script:dir 'rule-coverage.md') -Raw
        $script:csv = @(Import-Csv (Join-Path $script:dir 'rule-coverage.csv'))
    }

    It 'summarizes the counts, splitting covered-by-test from covered-by-analyzer' {
        $script:md | Should -Match '- Rules total: 5'
        $script:md | Should -Match 'by a tagged test: 2, by an analyzer rule: 2'
        $script:md | Should -Match '- Uncovered: 1'
    }

    It 'lists the rule enforced by neither a test nor an analyzer as uncovered' {
        $script:md | Should -Match '## Uncovered rules \(1\)'
        $script:md | Should -Match '- ADR-FAKE-TWIST'
    }

    It 'counts every tagged test that cites a rule as an enforcer' {
        $script:md | Should -Match '\| ADR-FAKE-TURN \| 2 \|'
        # the ADR-FAKE-TURN pester-test enforcers are both cited rows
        @($script:csv | Where-Object { $_.AdrId -eq 'ADR-FAKE-TURN' -and $_.Kind -eq 'pester-test' }).Count |
            Should -Be 2
    }

    It 'credits an analyzer rule as a pssa-rule enforcer' {
        $script:md | Should -Match 'Measure-FakeRule2'
        ($script:csv | Where-Object { $_.AdrId -eq 'ADR-FAKE-FOLD' }).Kind | Should -Be 'pssa-rule'
    }

    It 'writes an uncovered csv row for a rule with no enforcer' {
        ($script:csv | Where-Object { $_.AdrId -eq 'ADR-FAKE-TWIST' }).Kind | Should -Be 'uncovered'
    }
}
