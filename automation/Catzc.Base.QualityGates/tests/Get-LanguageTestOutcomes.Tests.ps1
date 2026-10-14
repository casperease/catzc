# Get-LanguageTestOutcomes with the language runners mocked: every discovered test takes the outcome of its result,
# or skips with tool_<tool>_missing when the run's source session handed down no managed tool. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-LanguageTestOutcomes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:package = 'catzc/go/tests/catzc-widget'
        $script:goPath = 'C:\widget\go\bin\go.exe'
        $script:uvPath = 'C:\widget\uv\uv.exe'
        function New-Case {
            param([string] $Name, [string] $Package = $script:package)
            [pscustomobject]@{ Key = "$Package $Name"; Package = $Package; Name = $Name; Category = 'logic'; Title = $Name }
        }
        $script:cases = @((New-Case 'TestWidgetSpins'), (New-Case 'TestWidgetJams'), (New-Case 'TestWidgetNaps'), (New-Case 'TestWidgetVanishes'))
        function Invoke-Outcomes {
            param([string] $Language = 'go', [object[]] $Case = $script:cases, [string] $EntryScript, [string] $Executable = $script:goPath)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Language = $Language; Case = $Case; EntryScript = $EntryScript; Executable = $Executable } {
                param($Language, $Case, $EntryScript, $Executable)
                Get-LanguageTestOutcomes -Language $Language -Module 'Catzc.Widget' -Case $Case -EntryScript $EntryScript -Executable $Executable
            }
        }
    }

    BeforeEach {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates { throw 'the worker never locates a tool itself' }
        Mock Invoke-GoTest -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Languages.GoTestResult]::new('catzc/go/tests/catzc-widget', 'TestWidgetSpins', 'pass', 0.1, '')
            [Catzc.Base.Languages.GoTestResult]::new('catzc/go/tests/catzc-widget', 'TestWidgetJams', 'fail', 0.2, 'widget_test.go:9: jammed')
            [Catzc.Base.Languages.GoTestResult]::new('catzc/go/tests/catzc-widget', 'TestWidgetNaps', 'skip', 0.0, 'widget_test.go:12: asleep')
        }
        Mock Invoke-PythonTest -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_spins', 'pass', 0.1, '')
            [Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_naps', 'skip', 0.0, 'asleep')
        }
    }

    It 'passes, fails with the test output, or skips as the test did' {
        $outcomes = Invoke-Outcomes
        $outcomes["$script:package TestWidgetSpins"].Outcome | Should -Be 'pass'
        $outcomes["$script:package TestWidgetJams"].Outcome | Should -Be 'fail'
        $outcomes["$script:package TestWidgetJams"].Message | Should -BeLike '*TestWidgetJams failed:*jammed*'
        $outcomes["$script:package TestWidgetNaps"].Outcome | Should -Be 'skip'
        $outcomes["$script:package TestWidgetNaps"].Reason | Should -Be 'go_test_skipped'
        $outcomes["$script:package TestWidgetNaps"].Message | Should -BeLike '*asleep*'
    }

    It 'fails a discovered test that the run reported no result for' {
        $outcomes = Invoke-Outcomes
        $outcomes["$script:package TestWidgetVanishes"].Outcome | Should -Be 'fail'
        $outcomes["$script:package TestWidgetVanishes"].Message | Should -BeLike '*no result*TestWidgetVanishes*'
    }

    It 'throws when the run reports a test the discovery did not list' {
        { Invoke-Outcomes -Case @($script:cases[0]) } | Should -Throw '*did not discover*TestWidgetJams*'
    }

    It 'hands the go it was given to Invoke-GoTest, never locating one itself' {
        $null = Invoke-Outcomes
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $GoExecutable -eq $script:goPath }
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }

    It 'runs Python tests through Invoke-PythonTest with the uv it was given' {
        $cases = @((New-Case 'test_widget_spins' 'test_widget'), (New-Case 'test_widget_naps' 'test_widget'))
        $outcomes = Invoke-Outcomes -Language python -Case $cases -Executable $script:uvPath
        $outcomes['test_widget test_widget_spins'].Outcome | Should -Be 'pass'
        $outcomes['test_widget test_widget_naps'].Reason | Should -Be 'python_test_skipped'
        Should -Invoke Invoke-PythonTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $UvExecutable -eq $script:uvPath }
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'hands the build run''s entry script to the runner, and none for the source run' {
        $null = Invoke-Outcomes -EntryScript 'C:\build\Import-Catzc.ps1'
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Module -eq 'Catzc.Widget' -and $EntryScript -eq 'C:\build\Import-Catzc.ps1'
        }
        $null = Invoke-Outcomes
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { -not $EntryScript }
    }

    It 'skips every test with <Reason>, running nothing, when no <Language> tool was handed down' -ForEach @(
        @{ Language = 'go'; Reason = 'tool_go_missing' }
        @{ Language = 'python'; Reason = 'tool_uv_missing' }
    ) {
        $outcomes = Invoke-Outcomes -Language $Language -Executable ''
        @($outcomes.Values.Outcome | Select-Object -Unique) | Should -Be @('skip')
        @($outcomes.Values.Reason | Select-Object -Unique) | Should -Be @($Reason)
        $outcomes.Count | Should -Be 4
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        Should -Invoke Invoke-PythonTest -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
