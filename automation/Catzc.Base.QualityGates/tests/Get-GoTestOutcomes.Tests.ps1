# Get-GoTestOutcomes with the tool probe and Invoke-GoTest mocked: every discovered Go test takes the outcome of its
# Go result, or skips with tool_go_missing when no managed go at the pinned version is found. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-GoTestOutcomes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:package = 'catzc/go/tests/catzc-widget'
        function New-Case {
            param([string] $Name)
            [pscustomobject]@{ Key = "$script:package $Name"; Package = $script:package; Name = $Name; Category = 'logic'; Title = $Name }
        }
        $script:cases = @((New-Case 'TestWidgetSpins'), (New-Case 'TestWidgetJams'), (New-Case 'TestWidgetNaps'), (New-Case 'TestWidgetVanishes'))
        function Invoke-Outcomes {
            param([object[]] $Case = $script:cases, [string] $EntryScript)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Case = $Case; EntryScript = $EntryScript } {
                param($Case, $EntryScript)
                Get-GoTestOutcomes -Module 'Catzc.Widget' -Case $Case -EntryScript $EntryScript
            }
        }
    }

    BeforeEach {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Found = $true; VersionOk = $true } }
        Mock Invoke-GoTest -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Languages.GoTestResult]::new('catzc/go/tests/catzc-widget', 'TestWidgetSpins', 'pass', 0.1, '')
            [Catzc.Base.Languages.GoTestResult]::new('catzc/go/tests/catzc-widget', 'TestWidgetJams', 'fail', 0.2, 'widget_test.go:9: jammed')
            [Catzc.Base.Languages.GoTestResult]::new('catzc/go/tests/catzc-widget', 'TestWidgetNaps', 'skip', 0.0, 'widget_test.go:12: asleep')
        }
    }

    It 'passes, fails with the Go output, or skips as Go did' {
        $outcomes = Invoke-Outcomes
        $outcomes["$script:package TestWidgetSpins"].Outcome | Should -Be 'pass'
        $outcomes["$script:package TestWidgetJams"].Outcome | Should -Be 'fail'
        $outcomes["$script:package TestWidgetJams"].Message | Should -BeLike '*TestWidgetJams failed:*jammed*'
        $outcomes["$script:package TestWidgetNaps"].Outcome | Should -Be 'skip'
        $outcomes["$script:package TestWidgetNaps"].Reason | Should -Be 'go_test_skipped'
        $outcomes["$script:package TestWidgetNaps"].Message | Should -BeLike '*asleep*'
    }

    It 'fails a discovered test that go reported no result for' {
        $outcomes = Invoke-Outcomes
        $outcomes["$script:package TestWidgetVanishes"].Outcome | Should -Be 'fail'
        $outcomes["$script:package TestWidgetVanishes"].Message | Should -BeLike '*no result*TestWidgetVanishes*'
    }

    It 'throws when go reports a test the discovery did not list' {
        { Invoke-Outcomes -Case @($script:cases[0]) } | Should -Throw '*did not discover*TestWidgetJams*'
    }

    It 'hands the build run''s entry script to Invoke-GoTest, and none for the source run' {
        $null = Invoke-Outcomes -EntryScript 'C:\build\Import-Catzc.ps1'
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Module -eq 'Catzc.Widget' -and $EntryScript -eq 'C:\build\Import-Catzc.ps1'
        }
        $null = Invoke-Outcomes
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { -not $EntryScript }
    }

    It 'skips every test with tool_go_missing, running nothing, when <Case>' -ForEach @(
        @{ Case = 'go is not found'; Probe = @{ Found = $false; VersionOk = $false } }
        @{ Case = 'go misses the pinned version'; Probe = @{ Found = $true; VersionOk = $false } }
    ) {
        $script:probe = $Probe
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'go' } { [pscustomobject]$script:probe }
        $outcomes = Invoke-Outcomes
        @($outcomes.Values.Outcome | Select-Object -Unique) | Should -Be @('skip')
        @($outcomes.Values.Reason | Select-Object -Unique) | Should -Be @('tool_go_missing')
        $outcomes.Count | Should -Be 4
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
