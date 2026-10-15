<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
    kind: pester-test
---
#>

# Test-ManualTestPlan over a fixture repository in $TestDrive: the repository root is mocked, and each test writes the
# test files and the plan rows it needs. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-ManualTestPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        function Set-FixtureFile {
            param([string] $Path, [string] $Content)
            $full = Join-Path $TestDrive "repo/$Path"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, $Content)
        }
        $script:planFolder = 'docs/how-to/automation/manual-test-plan'
        $script:planPath = "$planFolder/widgets.md"
        $script:widgetRow = '| 1 | automation/Widget/tests/Get-Widget.Tests.ps1 | Widget integrity |'
        $script:gadgetRow = '| 2 | automation/Widget/tests/Get-Widget.Tests.ps1 | Gadget check |'
    }

    BeforeEach {
        Remove-Item (Join-Path $TestDrive 'repo') -Recurse -Force -ErrorAction Ignore
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Set-FixtureFile 'automation/Widget/tests/Get-Widget.Tests.ps1' (@(
                "Describe 'Widget integrity' -Tag 'L1', 'integrity' {"
                "    It 'Gadget check' -Tag:@('integrity') { }"
                "    It 'plain logic' -Tag 'L0', 'logic' { }"
                '}'
            ) -join "`n")
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes when every integrity block has exactly one row' {
        Set-FixtureFile $planPath "# Plan`n`n$widgetRow`n$gadgetRow`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.IntegrityBlocks | Should -Be 2
        $result.PlanRows | Should -Be 2
        $result.CategoryFiles | Should -Be 1
    }

    It 'collects the rows across every category file' {
        Set-FixtureFile $planPath "$widgetRow`n"
        Set-FixtureFile "$planFolder/gadgets.md" "$gadgetRow`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.PlanRows | Should -Be 2
        $result.CategoryFiles | Should -Be 2
    }

    It 'reports more than 13 category files' {
        Set-FixtureFile $planPath "$widgetRow`n$gadgetRow`n"
        foreach ($n in 1..13) {
            Set-FixtureFile "$planFolder/widget-$n.md" "# Widgets $n`n"
        }
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -Match '14 category files, at most 13'
    }

    It 'throws once naming the uncovered block and the row-count mismatch' {
        Set-FixtureFile $planPath "$widgetRow`n"
        $thrown = { Test-ManualTestPlan -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ManualTestPlan failed: 2 issue(s)*'
        $message | Should -Match 'Get-Widget.Tests.ps1 :: Gadget check: no manual-test-plan row'
        $message | Should -Match '1 index rows for 2 integrity blocks'
    }

    It 'reports a stale row as a count mismatch' {
        Set-FixtureFile $planPath "$widgetRow`n$gadgetRow`n| 3 | automation/Widget/tests/Get-Gone.Tests.ps1 | Gone |`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -Match '3 index rows for 2 integrity blocks'
    }

    It 'reports a missing plan' {
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'manual-test-plan'
        $result.Issues | Should -Contain "${planFolder}/: the manual test plan has no category files"
    }
}
