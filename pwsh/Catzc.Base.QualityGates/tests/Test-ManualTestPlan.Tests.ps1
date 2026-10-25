<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-ManualTestPlan.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Test-ManualTestPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        function Set-FixtureFile {
            param([string] $Path, [string] $Content)
            $full = Join-Path $TestDrive "repo/$Path"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, $Content)
        }
        $script:planFolder = 'docs/how-to/pwsh/manual-test-plan'
        $script:planPath = "$planFolder/widgets.md"
        $script:widgetRow = '| 1 | widget-modules/Widget/tests/Get-Widget.Tests.ps1 | Widget integrity |'
        $script:gadgetRow = '| 2 | widget-modules/Widget/tests/Get-Widget.Tests.ps1 | Gadget check |'
    }

    BeforeEach {
        Remove-Item (Join-Path $TestDrive 'repo') -Recurse -Force -ErrorAction Ignore
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widget-modules' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Set-FixtureFile 'widget-modules/Widget/tests/Get-Widget.Tests.ps1' (@(
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
        $result.Facts['IntegrityBlocks'] | Should -Be 2
        $result.Facts['PlanRows'] | Should -Be 2
        $result.Facts['CategoryFiles'] | Should -Be 1
    }

    It 'collects the rows across every category file' {
        Set-FixtureFile $planPath "$widgetRow`n"
        Set-FixtureFile "$planFolder/gadgets.md" "$gadgetRow`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['PlanRows'] | Should -Be 2
        $result.Facts['CategoryFiles'] | Should -Be 2
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
        Set-FixtureFile $planPath "$widgetRow`n$gadgetRow`n| 3 | widget-modules/Widget/tests/Get-Gone.Tests.ps1 | Gone |`n"
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
