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
        $script:widgetCheck = "### 1. Widget integrity`n`n**Test file:** ``widget-modules/Widget/tests/Get-Widget.Tests.ps1`` (L1), block ``Widget integrity``.`n"
        $script:gadgetCheck = "### 2. Gadget check`n`n**Test file:** ``widget-modules/Widget/tests/Get-Widget.Tests.ps1`` (L1), block ``Gadget check``.`n"
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

    It 'passes when every integrity block has exactly one check section' {
        Set-FixtureFile $planPath "# Plan`n`n## Checks`n`n$widgetCheck`n$gadgetCheck"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['IntegrityBlocks'] | Should -Be 2
        $result.Facts['PlanChecks'] | Should -Be 2
        $result.Facts['CategoryFiles'] | Should -Be 1
    }

    It 'collects the checks across every category file' {
        Set-FixtureFile $planPath "## Checks`n`n$widgetCheck"
        Set-FixtureFile "$planFolder/gadgets.md" "## Checks`n`n$gadgetCheck"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['PlanChecks'] | Should -Be 2
        $result.Facts['CategoryFiles'] | Should -Be 2
    }

    It 'reads a Test file paragraph the formatter wrapped onto a second line' {
        $wrapped = "### 2. A gadget check under another heading`n`n**Test file:** ``widget-modules/Widget/tests/Get-Widget.Tests.ps1`` (L1), block`n``Gadget check``.`n"
        Set-FixtureFile $planPath "## Checks`n`n$widgetCheck`n$wrapped"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['PlanChecks'] | Should -Be 2
    }

    It 'reports a check section with no Test file line' {
        Set-FixtureFile $planPath "## Checks`n`n$widgetCheck`n$gadgetCheck`n### 3. Gizmo check`n`n**Guards:** nothing named.`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues |
            Should -Contain "${planPath}: section '### 3. Gizmo check' has no **Test file:** line naming its test file and block"
    }

    It 'no longer reads an index row as a check' {
        Set-FixtureFile $planPath "| 1 | widget-modules/Widget/tests/Get-Widget.Tests.ps1 | Widget integrity |`n| 2 | widget-modules/Widget/tests/Get-Widget.Tests.ps1 | Gadget check |`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Facts['PlanChecks'] | Should -Be 0
        $result.Issues |
            Should -Contain "${planFolder}: 0 checks for 2 integrity blocks — a stale or duplicate check, or a renamed or removed block"
    }

    It 'reports more than 13 category files' {
        Set-FixtureFile $planPath "## Checks`n`n$widgetCheck`n$gadgetCheck"
        foreach ($n in 1..13) {
            Set-FixtureFile "$planFolder/widget-$n.md" "# Widgets $n`n"
        }
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -Match '14 category files, at most 13'
    }

    It 'throws once naming the uncovered block and the check-count mismatch' {
        Set-FixtureFile $planPath "## Checks`n`n$widgetCheck"
        $thrown = { Test-ManualTestPlan -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ManualTestPlan failed: 2 issue(s)*'
        $message | Should -Match 'Get-Widget.Tests.ps1 :: Gadget check: no manual-test-plan check'
        $message | Should -Match '1 checks for 2 integrity blocks'
    }

    It 'names the category page that holds the uncovered block''s test file, so the fix is one edit' {
        Set-FixtureFile "$planFolder/gadgets.md" "## Checks`n`n$widgetCheck"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues | Should -Contain ('widget-modules/Widget/tests/Get-Widget.Tests.ps1 :: Gadget check: no manual-test-plan check — add one to ' +
            "$planFolder/gadgets.md (or remove the integrity tag)")
    }

    It 'names no page when no check holds the block''s test file' {
        Set-FixtureFile $planPath "# Plan`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues | Where-Object { $_ -like '*Gadget check: no manual-test-plan check — add one to a category page*' } | Should -HaveCount 1
    }

    It 'reports a stale check as a count mismatch' {
        Set-FixtureFile $planPath "## Checks`n`n$widgetCheck`n$gadgetCheck`n### 3. Gone`n`n**Test file:** ``widget-modules/Widget/tests/Get-Gone.Tests.ps1`` (L1), block ``Gone``.`n"
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Issues | Should -HaveCount 1
        $result.Issues[0] | Should -Match '3 checks for 2 integrity blocks'
    }

    It 'reports a missing plan' {
        $result = Test-ManualTestPlan -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'manual-test-plan'
        $result.Issues | Should -Contain "${planFolder}/: the manual test plan has no category files"
    }
}
