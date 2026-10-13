# Test-SourceConventions over fixture trees in $TestDrive: the repository root is mocked, so each test writes the
# source and test files it needs and pins one convention. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-SourceConventions' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile([string] $Path, [string] $Content = '') {
            $full = Join-Path $TestDrive "repo/automation/$Path"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, $Content)
        }
    }

    BeforeEach {
        Remove-Item (Join-Path $TestDrive 'repo') -Recurse -Force -ErrorAction Ignore
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
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
}
