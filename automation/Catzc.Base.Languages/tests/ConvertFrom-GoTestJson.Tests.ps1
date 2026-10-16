<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/ConvertFrom-GoTestJson.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-languages/tests/ConvertFrom-GoTestJson.Tests.ps1.md
---
#>

Describe 'ConvertFrom-GoTestJson' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/go-test-widget.jsonl')
        $script:buildFailedStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/go-test-gadget-build-failed.jsonl')
        $script:convert = {
            param([string] $Text)
            InModuleScope Catzc.Base.Languages -Parameters @{ Text = $Text } { param($Text) ConvertFrom-GoTestJson -Text $Text }
        }
    }

    Context 'outcomes' {
        It 'maps pass, fail and skip to one record per top-level test, in run order' {
            $results = @(& $script:convert $script:widgetStream)
            $results.Name | Should -Be @('TestPass', 'TestFail', 'TestSkip', 'TestIntegrityTable')
            $results.Outcome | Should -Be @('pass', 'fail', 'skip', 'fail')
            ($results.Package | Sort-Object -Unique) | Should -Be 'catzc/go/tests/catzc-widget'
        }

        It 'takes the duration from the test''s Elapsed seconds' {
            $stream = @(
                '{"Action":"run","Package":"p/widget","Test":"TestWidget"}'
                '{"Action":"pass","Package":"p/widget","Test":"TestWidget","Elapsed":1.5}'
            ) -join "`n"
            (& $script:convert $stream).DurationSeconds | Should -Be 1.5
        }

        It 'fails a test that started but never reached an outcome' {
            $stream = @(
                '{"Action":"run","Package":"p/widget","Test":"TestCrash"}'
                '{"Action":"output","Package":"p/widget","Test":"TestCrash","Output":"panic: gadget\n"}'
                '{"Action":"fail","Package":"p/widget","Elapsed":0.1}'
            ) -join "`n"
            $result = & $script:convert $stream
            $result.Outcome | Should -Be 'fail'
            $result.Output | Should -Be "panic: gadget`n"
        }

        It 'returns nothing for an empty stream' {
            @(& $script:convert '').Count | Should -Be 0
        }
    }

    Context 'subtests and output' {
        It 'folds subtests into their top-level test, joining their output in event order' {
            $table = @(& $script:convert $script:widgetStream) | Where-Object Name -EQ 'TestIntegrityTable'
            $expected = @(
                '=== RUN   TestIntegrityTable'
                '=== RUN   TestIntegrityTable/one'
                '--- PASS: TestIntegrityTable/one (0.00s)'
                '=== RUN   TestIntegrityTable/two'
                '    widget_test.go:13: two broke'
                '--- FAIL: TestIntegrityTable/two (0.00s)'
                '--- FAIL: TestIntegrityTable (0.00s)'
            ) -join "`n"
            $table.Output | Should -BeExactly ($expected + "`n")
        }

        It 'keeps the parent''s own outcome, not a subtest''s' {
            $stream = @(
                '{"Action":"run","Package":"p/widget","Test":"TestWidget"}'
                '{"Action":"run","Package":"p/widget","Test":"TestWidget/gadget"}'
                '{"Action":"skip","Package":"p/widget","Test":"TestWidget/gadget","Elapsed":0}'
                '{"Action":"pass","Package":"p/widget","Test":"TestWidget","Elapsed":0.2}'
            ) -join "`n"
            $result = & $script:convert $stream
            $result.Outcome | Should -Be 'pass'
            $result.DurationSeconds | Should -Be 0.2
        }

        It 'collects a test''s printed lines into its output' {
            (@(& $script:convert $script:widgetStream) | Where-Object Name -EQ 'TestFail').Output |
                Should -BeExactly "=== RUN   TestFail`n    widget_test.go:9: boom`n--- FAIL: TestFail (0.00s)`n"
        }
    }

    Context 'categories' {
        It 'is integrity for a TestIntegrity* name and logic for any other' {
            $results = @(& $script:convert $script:widgetStream)
            ($results | Where-Object Name -EQ 'TestIntegrityTable').Category | Should -Be 'integrity'
            ($results | Where-Object Name -NE 'TestIntegrityTable').Category | Sort-Object -Unique | Should -Be 'logic'
        }
    }

    Context 'failures outside the tests' {
        It 'throws with the compiler output when the test package does not build' {
            { & $script:convert $script:buildFailedStream } |
                Should -Throw '*catzc/go/tests/catzc-gadget * did not build:*gadget_test.go:5:33: undefined: undefinedThing*'
        }

        It 'throws when a package fails with no failing test' {
            $stream = @(
                '{"Action":"run","Package":"p/widget","Test":"TestWidget"}'
                '{"Action":"pass","Package":"p/widget","Test":"TestWidget","Elapsed":0}'
                '{"Action":"output","Package":"p/widget","Output":"TestMain: gadget setup failed\n"}'
                '{"Action":"fail","Package":"p/widget","Elapsed":0.1}'
            ) -join "`n"
            { & $script:convert $stream } | Should -Throw '*package p/widget failed outside any test*gadget setup failed*'
        }

        It 'throws on a line that is not a JSON event' {
            { & $script:convert 'FAIL p/widget [setup failed]' } | Should -Throw '*not a JSON event: FAIL p/widget*'
        }
    }
}
