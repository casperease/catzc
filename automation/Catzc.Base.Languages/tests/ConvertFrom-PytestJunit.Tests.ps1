<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
    kind: test
---
#>

# ConvertFrom-PytestJunit over a canned pytest JUnit report in tests/assets: one result per top-level test function,
# parametrised cases folded in. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'ConvertFrom-PytestJunit' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:report = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/pytest-widget.xml')
        function Convert-Report {
            param([string] $Text)
            InModuleScope Catzc.Base.Languages -Parameters @{ Text = $Text } { param($Text) ConvertFrom-PytestJunit -Text $Text }
        }
    }

    It 'returns one result per test function, in report order' {
        $results = @(Convert-Report $script:report)
        @($results | ForEach-Object { "$($_.Package) $($_.Name) $($_.Outcome)" }) | Should -Be @(
            'test_widget test_widget_spins pass'
            'test_widget test_widget_sizes fail'
            'test_widget test_widget_naps skip'
            'nested.test_gadget test_integrity_gadget_ships pass'
            'test_widget test_widget_breaks fail'
        )
    }

    It 'folds parametrised cases into one result: any failure fails it, times add up, output joins' {
        $sizes = @(Convert-Report $script:report) | Where-Object Name -EQ 'test_widget_sizes'
        $sizes.Outcome | Should -Be 'fail'
        $sizes.DurationSeconds | Should -Be 0.5
        $sizes.Output | Should -BeLike '*size 2 jammed*widget measured 2*'
    }

    It 'carries the skip and error messages, and the category from the name' {
        $results = @(Convert-Report $script:report)
        ($results | Where-Object Name -EQ 'test_widget_naps').Output | Should -BeLike 'asleep*'
        ($results | Where-Object Name -EQ 'test_widget_breaks').Output | Should -BeLike "*fixture 'gizmo' not found*"
        ($results | Where-Object Name -EQ 'test_integrity_gadget_ships').Category | Should -Be 'integrity'
        ($results | Where-Object Name -EQ 'test_widget_spins').Category | Should -Be 'logic'
    }

    It 'returns nothing for an empty report' {
        @(Convert-Report '') | Should -HaveCount 0
    }

    It 'throws on a failure outside any test (a collection error)' {
        $collection = '<testsuites><testsuite><testcase classname="" name="test_widget"><error message="collection failure">SyntaxError</error></testcase></testsuite></testsuites>'
        { Convert-Report $collection } | Should -Throw '*outside any test*SyntaxError*'
    }
}
