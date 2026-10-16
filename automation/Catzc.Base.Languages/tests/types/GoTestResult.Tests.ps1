<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/types/GoTestResult.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    relatives:
      source: automation/Catzc.Base.Languages/types/GoTestResult.cs
---
#>

Describe 'GoTestResult' -Tag 'L0', 'logic' {
    It 'carries its fields and derives the logic category' {
        $result = [Catzc.Base.Languages.GoTestResult]::new('p/widget', 'TestWidget', 'pass', 0.5, "ok`n")
        $result.Package | Should -Be 'p/widget'
        $result.Name | Should -Be 'TestWidget'
        $result.Outcome | Should -Be 'pass'
        $result.DurationSeconds | Should -Be 0.5
        $result.Output | Should -Be "ok`n"
        $result.Category | Should -Be 'logic'
    }

    It 'derives the integrity category from a TestIntegrity* name' {
        [Catzc.Base.Languages.GoTestResult]::new('p/widget', 'TestIntegrityGadget', 'skip', 0, $null).Category | Should -Be 'integrity'
    }

    It 'treats a missing output as empty' {
        [Catzc.Base.Languages.GoTestResult]::new('p/widget', 'TestWidget', 'fail', 0, $null).Output | Should -Be ''
    }

    It 'throws on an unknown outcome' {
        { [Catzc.Base.Languages.GoTestResult]::new('p/widget', 'TestWidget', 'PASS', 0, '') } | Should -Throw "*Outcome 'PASS'*"
    }

    It 'throws on a name that is not a top-level Go test' -ForEach @('Widget', 'TestWidget/gadget', '') {
        { [Catzc.Base.Languages.GoTestResult]::new('p/widget', $_, 'pass', 0, '') } | Should -Throw '*not a top-level Go test name*'
    }

    It 'reports every violation in one throw' {
        $err = { [Catzc.Base.Languages.GoTestResult]::new('', 'Widget', 'ok', -1, '') } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike '*Package is required*'
        $err.Exception.Message | Should -BeLike "*Name 'Widget'*"
        $err.Exception.Message | Should -BeLike "*Outcome 'ok'*"
        $err.Exception.Message | Should -BeLike '*DurationSeconds*'
    }
}
