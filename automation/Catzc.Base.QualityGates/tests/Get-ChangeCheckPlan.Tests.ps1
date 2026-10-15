<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
---
#>

# Get-ChangeCheckPlan over fixture files, with the file-language registry mocked to fixture languages.
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md#comment1)
Describe 'Get-ChangeCheckPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($relative in 'a.wdg', 'b.wdg', 'c.gdg', 'd.txt', 'e.none') {
            [System.IO.File]::WriteAllText((Join-Path ([System.IO.Directory]::CreateDirectory($script:root).FullName) $relative), '')
        }
        $widget = [Catzc.Base.Languages.FileLanguage]::new('widget', @('.wdg'), $null, 'fixture', $null, $null, @('Test-WidgetLint', 'Test-Spelling'))
        $gadget = [Catzc.Base.Languages.FileLanguage]::new('gadget', @('.gdg'), $null, 'fixture', $null, $null, @('Test-Spelling'))
        $silent = [Catzc.Base.Languages.FileLanguage]::new('silent', @('.txt'), $null, 'fixture', $null, $null, @())
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.wdg' } { $widget }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.gdg' } { $gadget }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.txt' } { $silent }
        Mock Get-FileLanguage -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Path -like '*.none' } { }
        $script:plan = {
            param([string[]] $Changed)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Changed; R = $script:root } {
                param($C, $R)
                Get-ChangeCheckPlan -Path $C -RepositoryRoot $R
            }
        }
    }

    It 'groups the changed files under each gate their language names, gates in first-appearance order' {
        $plan = @(& $script:plan @('a.wdg', 'c.gdg', 'b.wdg'))
        $plan.Check | Should -Be @('Test-WidgetLint', 'Test-Spelling')
        $plan[0].Path | Should -Be @('a.wdg', 'b.wdg')
        $plan[1].Path | Should -Be @('a.wdg', 'c.gdg', 'b.wdg')
    }

    It 'skips a deleted file, a file with no language, and a language that names no check' {
        @(& $script:plan @('gone.wdg', 'e.none', 'd.txt')) | Should -HaveCount 0
    }
}
