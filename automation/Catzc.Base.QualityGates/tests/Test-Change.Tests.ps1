# Test-Change wiring: the plan's two halves (Get-ChangeTestFile, Get-ChangeCheckPlan) are their own units and are mocked
# here; Invoke-TestFile is the mocked test-run boundary; the gates are fixture functions, so the real Get-Command lookup
# and the [string[]] -Path test decide how each is called. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The fixture gates declare -PassThru so they take the call a real quality gate takes; what they return does not depend on it')]
param()

Describe 'Test-Change' -Tag 'L1', 'logic' {
    BeforeAll {
        # A gate that takes the changed files, one that only runs whole, and one that throws.
        # It names every path it was given, so its issue shows what Test-Change passed.
        function global:Test-WidgetLint {
            param([string[]] $Path, [switch] $PassThru)
            [pscustomobject]@{ Issues = @("$($Path -join ', '): widget too wide") }
        }
        function global:Test-GadgetScan {
            param([switch] $PassThru)
            [pscustomobject]@{ Issues = @('widget/a.wdg:3: gadget loose', 'gizmo/elsewhere.wdg: not ours', 'registry: gadget missing') }
        }
        function global:Test-GizmoProbe {
            param([switch] $PassThru)
            throw 'gizmo tool missing'
        }
        $script:report = Join-Path $TestDrive 'test-change'
    }

    AfterAll {
        Remove-Item Function:\Test-WidgetLint, Function:\Test-GadgetScan, Function:\Test-GizmoProbe -ErrorAction Ignore
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-ChangeTestFile -ModuleName Catzc.Base.QualityGates { 'widget/tests/Get-Widget.Tests.ps1' }
        Mock Get-ChangeCheckPlan -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Check = 'Test-WidgetLint'; Path = @('widget/a.wdg') }
            [pscustomobject]@{ Check = 'Test-GadgetScan'; Path = @('widget/a.wdg') }
        }
        Mock Invoke-TestFile -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                Result       = 'Failed'
                Rows         = @(
                    [pscustomobject]@{ Result = 'Passed'; File = (Join-Path $TestDrive 'widget/tests/Get-Widget.Tests.ps1'); ExpandedPath = 'Get-Widget.spins'; ErrorMessage = $null }
                    [pscustomobject]@{ Result = 'Failed'; File = (Join-Path $TestDrive 'widget/tests/Get-Widget.Tests.ps1'); ExpandedPath = 'Get-Widget.fits'; ErrorMessage = ('Expected 2, but got 1.', 'more detail') -join "`n" }
                )
                RunDirectory = 'C:\widget-run'
            }
        }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Base.QualityGates { 'widget/tests/Get-Widget.Tests.ps1' }
    }

    It 'reports each failed test, every issue of a gate given the changed files, and only the issues naming a changed file of a whole-run gate' {
        $result = Test-Change -Path 'widget/a.wdg' -PassThru -OutputFolder $script:report
        $result.Issues | Should -Be @(
            'widget/tests/Get-Widget.Tests.ps1: Get-Widget.fits — Expected 2, but got 1.'
            'Test-WidgetLint: widget/a.wdg: widget too wide'
            'Test-GadgetScan: widget/a.wdg:3: gadget loose'
        ) -Because 'Test-WidgetLint names exactly the paths it was given'
        $result.Unattributed | Should -Be 2
    }

    It 'runs the covering test files once, through Invoke-TestFile' {
        Test-Change -Path 'widget/a.wdg' -PassThru -OutputFolder $script:report | Out-Null
        Should -Invoke Invoke-TestFile -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            "$Path" -eq 'widget/tests/Get-Widget.Tests.ps1'
        }
    }

    It 'turns a gate that throws, and a check that names no command, into one issue each' {
        Mock Get-ChangeCheckPlan -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Check = 'Test-GizmoProbe'; Path = @('widget/a.wdg') }
            [pscustomobject]@{ Check = 'Test-NoSuchGizmo'; Path = @('widget/a.wdg') }
        }
        $result = Test-Change -Path 'widget/a.wdg' -PassThru -OutputFolder $script:report
        $result.Issues | Should -Contain 'Test-GizmoProbe: gizmo tool missing'
        $result.Issues | Should -Contain 'Test-NoSuchGizmo: no such command — languages.yml names it as a check'
    }

    It 'reports a failed test run with no failed test as one issue, naming the run' {
        Mock Invoke-TestFile -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Result = 'Failed'; Rows = @(); RunDirectory = 'C:\widget-run' }
        }
        Mock Get-ChangeCheckPlan -ModuleName Catzc.Base.QualityGates { }
        $result = Test-Change -Path 'widget/a.wdg' -PassThru -OutputFolder $script:report
        @($result.Issues) | Should -HaveCount 1
        $result.Issues[0] | Should -BeLike 'tests: the run of 1 test file(s) failed with no failed test*C:\widget-run*'
    }

    It 'asks for every test file of the touched modules under -WholeModule' {
        Test-Change -Path 'widget/a.wdg' -WholeModule -DryRun | Out-Null
        Should -Invoke Get-ChangeTestFile -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Module }
    }

    It 'plans without running anything under -DryRun' {
        $plan = Test-Change -Path 'widget\a.wdg' -DryRun
        $plan.Path | Should -Be @('widget/a.wdg')
        $plan.Tests | Should -Be @('widget/tests/Get-Widget.Tests.ps1')
        $plan.Checks.Check | Should -Be @('Test-WidgetLint', 'Test-GadgetScan')
        Should -Invoke Invoke-TestFile -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
