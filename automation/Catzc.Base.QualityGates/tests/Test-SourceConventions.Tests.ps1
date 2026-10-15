<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
    kind: pester-test
---
#>

# Test-SourceConventions over fixture trees in $TestDrive: the repository root is mocked, so each test writes the
# source and test files it needs and pins one convention. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): widget, gadget and sprocket stand
# in for the engines, and ADR-WIDGET-GADGET for a code the ADR registry declares.
Describe 'Test-SourceConventions' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Path, [string] $Content = '')
            $full = Join-Path $TestDrive "repo/automation/$Path"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, $Content)
        }
        # Sets the source-conventions config for the next run: both checks in the given mode, the engine-set check
        # with one name phrase and the given exempt globs.
        $script:useMode = {
            param([string] $Mode, [System.Collections.IDictionary] $Exempt = [ordered]@{})
            $engineSet = [ordered]@{ mode = $Mode; exempt = $Exempt; name_phrases = @('\b{name}(?: and {name})+\b') }
            $config = [Catzc.Base.QualityGates.SourceConventionsConfig]::new([ordered]@{ engine_set = $engineSet; neutral_codes = [ordered]@{ mode = $Mode } })
            Mock Get-Config -ParameterFilter { $Config -eq 'source-conventions' } -ModuleName Catzc.Base.QualityGates -MockWith { $config }.GetNewClosure()
        }
        # Writes the files both source checks find: a ValidateSet of engines, a partial engine set in prose, and a real
        # code in an L0 test's fixture data.
        $script:writeCheckFixtures = {
            New-FixtureFile 'Widget/Set-Widget.ps1' "function Set-Widget { param([ValidateSet('widget', 'gadget')] [string] `$Engine) }"
            New-FixtureFile 'Widget/README.md' "Runs under widget and gadget.`n"
            New-FixtureFile 'Widget/tests/Set-Widget.Tests.ps1' "Describe 'Set-Widget' -Tag 'L0', 'logic' { It 'x' { Set-Widget -Rule 'ADR-WIDGET-GADGET#1' } }"
        }
    }

    BeforeEach {
        Remove-Item (Join-Path $TestDrive 'repo') -Recurse -Force -ErrorAction Ignore
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            $root = Join-Path $TestDrive 'repo'
            foreach ($file in [System.IO.Directory]::EnumerateFiles($root, '*', [System.IO.SearchOption]::AllDirectories)) {
                [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            }
        }
        Mock Get-ContentExemptPath -ModuleName Catzc.Base.QualityGates { , [string[]] @() }
        Mock Get-ExecutionEngine -ModuleName Catzc.Base.QualityGates {
            foreach ($name in 'widget', 'gadget', 'sprocket') {
                [pscustomobject]@{ Name = $name }
            }
        }
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Docs.AdrCitationMap]::new(@{ 'ADR-WIDGET-GADGET' = @{ path = 'docs/adr/widget/gadget.md'; rules = @(1) } }, @())
        }
        & $script:useMode 'gate'
        New-FixtureFile 'Widget/Get-Widget.ps1' 'function Get-Widget { }'
        New-FixtureFile 'Widget/private/Get-WidgetPart.ps1' 'function Get-WidgetPart { }'
        New-FixtureFile 'Widget/private/_helpers.ps1' 'function a { }; function b { }'
        New-FixtureFile 'Widget/types/WidgetConfig.cs'
        New-FixtureFile 'Widget/tests/Get-Widget.Tests.ps1' "It 'x' { Set-ItResult -Skipped -Because 'tool_widget_missing' }"
        New-FixtureFile 'Widget/tests/types/WidgetConfig.Tests.ps1'
        New-FixtureFile '.internal/tests/Get-Gadget.Tests.ps1'
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes a conventional tree and counts what it scanned' {
        $result = Test-SourceConventions -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.SourceFiles | Should -Be 2
        $result.TestFiles | Should -Be 3
        $result.SkipReasons | Should -Be 1
    }

    It 'throws once listing every source and test file convention break' {
        New-FixtureFile 'Widget/Widget.ps1' 'function Widget { }'
        New-FixtureFile 'Widget/Get-Gadget.ps1' 'function Get-Gadget { }; function Get-Sprocket { }'
        New-FixtureFile 'Widget/Set-Widget.ps1' 'function Set-Gadget { }'
        New-FixtureFile 'Widget/private/Get-Widget2.ps1' 'function Get-Widget { }'
        New-FixtureFile 'Widget/tests/Widget.Tests.ps1'
        New-FixtureFile 'Widget/tests/types/GadgetConfig.Tests.ps1'
        New-FixtureFile 'Widget/tests/Get-WidgetPart.Tests.ps1' "It 'y' { Set-ItResult -Skipped -Because 'Not on this box' }"

        $thrown = { Test-SourceConventions -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -Match 'Widget/Widget.ps1: the source file is not named Verb-Noun'
        $message | Should -Match 'Widget/Get-Gadget.ps1: holds 2 top-level functions'
        $message | Should -Match "Widget/Set-Widget.ps1: defines 'Set-Gadget'"
        $message | Should -Match 'Get-Widget: defined in more than one file \(Widget/Get-Widget.ps1, Widget/private/Get-Widget2.ps1\)'
        $message | Should -Match 'Widget/tests/Widget.Tests.ps1: the test file is not named Verb-Noun'
        $message | Should -Match 'Widget/tests/types/GadgetConfig.Tests.ps1: names no C# type'
        $message | Should -Match "Set-ItResult -Because 'Not on this box' is not a constrained skip key"
    }

    It 'returns the issues under -PassThru instead of throwing' {
        New-FixtureFile 'Widget/Widget.ps1' 'function Widget { }'
        $result = Test-SourceConventions -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'source-conventions'
        $result.Issues | Should -HaveCount 1
    }

    It 'fails on the engine-set and neutral-code findings in gate mode, with file and line' -Tag 'ADR-AUTO-ENGINE#1', 'ADR-AUTO-TEST#3', 'ADR-PRIN-CONFIG#4' {
        & $writeCheckFixtures
        $result = Test-SourceConventions -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 3
        $result.Issues | Should -Contain "automation/Widget/README.md:1: 'widget and gadget' names 2 of the 3 engines (widget, gadget, sprocket); say 'every engine' or name them all"
        @($result.Issues | Where-Object { $_ -like 'automation/Widget/Set-Widget.ps1:1: a ValidateSet lists engine names*' }) | Should -HaveCount 1
        @($result.Issues | Where-Object { $_ -like "automation/Widget/tests/Set-Widget.Tests.ps1:1: L0 fixture data uses the real ADR code 'ADR-WIDGET-GADGET'*" }) | Should -HaveCount 1
        $result.EngineSetCount | Should -Be 2
        $result.NeutralCodeCount | Should -Be 1
    }

    It 'lists the same findings in report mode and passes' -Tag 'ADR-AUTO-ENGINE#1', 'ADR-AUTO-TEST#3', 'ADR-PRIN-CONFIG#4' {
        & $writeCheckFixtures
        & $useMode 'report'
        { Test-SourceConventions -OutputFolder $out } | Should -Not -Throw
        $result = Test-SourceConventions -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.EngineSet | Should -HaveCount 2
        $result.NeutralCodes | Should -HaveCount 1
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like '`[engine_set`] automation/Widget/README.md:1:*' }
    }

    It 'leaves out a file a check exempts' -Tag 'ADR-PRIN-CONFIG#4' {
        & $writeCheckFixtures
        & $useMode 'gate' ([ordered]@{ 'automation/Widget/*.md' = 'widget notes' })
        $result = Test-SourceConventions -OutputFolder $out -PassThru
        $result.EngineSetCount | Should -Be 1
    }
}
