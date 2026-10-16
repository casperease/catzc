<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
    adrs:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#3
---
#>

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

    It 'runs Bash tests through Invoke-BashTest under the bash it was given, whatever engine is named' {
        Mock Invoke-BashTest -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Languages.BashTestResult]::new('widget.bats', 'widget spins', 'pass', 0.1, '')
            [Catzc.Base.Languages.BashTestResult]::new('widget.bats', 'widget naps', 'skip', 0.0, 'asleep')
        }
        $cases = @((New-Case 'widget spins' 'widget.bats'), (New-Case 'widget naps' 'widget.bats'))
        $outcomes = InModuleScope Catzc.Base.QualityGates -Parameters @{ Case = $cases } {
            param($Case)
            Get-LanguageTestOutcomes -Language bash -Module 'Catzc.Widget' -Case $Case -Executable 'C:\widget\bash\bash.exe' -Engine bash `
                -EngineExecutable 'C:\widget\bash\bash.exe'
        }
        $outcomes['widget.bats widget spins'].Outcome | Should -Be 'pass'
        $outcomes['widget.bats widget naps'].Reason | Should -Be 'bash_test_skipped'
        Should -Invoke Invoke-BashTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Module -eq 'Catzc.Widget' -and $EngineExecutable -eq 'C:\widget\bash\bash.exe'
        }
    }

    It 'hands the build run''s entry script to the runner, and none for the source run' {
        $null = Invoke-Outcomes -EntryScript 'C:\build\Import-Catzc.ps1'
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Module -eq 'Catzc.Widget' -and $EntryScript -eq 'C:\build\Import-Catzc.ps1'
        }
        $null = Invoke-Outcomes
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { -not $EntryScript }
    }

    It 'runs the tests under the <Engine> engine with the executable handed down' -ForEach @(
        @([Catzc.Base.Engines.ExecutionEngines]::Names | Where-Object { $_ -ne [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name } | ForEach-Object { @{ Engine = $_ } })
    ) {
        $script:engine = $Engine
        $null = InModuleScope Catzc.Base.QualityGates -Parameters @{ Case = $script:cases; Go = $script:goPath; Engine = $Engine } {
            param($Case, $Go, $Engine)
            Get-LanguageTestOutcomes -Language go -Module 'Catzc.Widget' -Case $Case -Executable $Go -Engine $Engine -EngineExecutable "C:\widget\$Engine\$Engine.exe"
        }
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Engine -eq $script:engine -and $EngineExecutable -eq "C:\widget\$($script:engine)\$($script:engine).exe"
        }
    }

    It 'skips every test with tool_<Engine>_missing, running nothing, when the <Engine> engine was not handed down' -ForEach @(
        @([Catzc.Base.Engines.ExecutionEngines]::Names | Where-Object { $_ -ne [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name } | ForEach-Object { @{ Engine = $_ } })
    ) {
        $outcomes = InModuleScope Catzc.Base.QualityGates -Parameters @{ Case = $script:cases; Go = $script:goPath; Engine = $Engine } {
            param($Case, $Go, $Engine)
            Get-LanguageTestOutcomes -Language go -Module 'Catzc.Widget' -Case $Case -Executable $Go -Engine $Engine -EngineExecutable ''
        }
        @($outcomes.Values.Outcome | Select-Object -Unique) | Should -Be @('skip')
        @($outcomes.Values.Reason | Select-Object -Unique) | Should -Be @("tool_$($Engine)_missing")
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }

    It 'skips every test with <Reason>, running nothing, when no <Language> tool was handed down' -ForEach @(
        @{ Language = 'go'; Reason = 'tool_go_missing' }
        @{ Language = 'python'; Reason = 'tool_uv_missing' }
        @{ Language = 'bash'; Reason = 'tool_bash_missing' }
    ) {
        $outcomes = Invoke-Outcomes -Language $Language -Executable ''
        @($outcomes.Values.Outcome | Select-Object -Unique) | Should -Be @('skip')
        @($outcomes.Values.Reason | Select-Object -Unique) | Should -Be @($Reason)
        $outcomes.Count | Should -Be 4
        Should -Invoke Invoke-GoTest -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
        Should -Invoke Invoke-PythonTest -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
