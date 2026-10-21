<#
---
catzc:
  immutable:
    with_body_sha: e95ae81edbe8
  edges:
    code: pwsh/Catzc.Base.Languages/types/PythonTestResult.cs
---
#>

Describe 'PythonTestResult' -Tag 'L0', 'logic' {
    It 'derives the category from the name: test_integrity* is integrity, the rest logic' {
        [Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_integrity_widget_ships', 'pass', 0.5, '').Category | Should -Be 'integrity'
        [Catzc.Base.Languages.PythonTestResult]::new('test_widget', 'test_widget_spins', 'pass', 0.5, '').Category | Should -Be 'logic'
    }

    It 'keeps every field, with no output as empty' {
        $result = [Catzc.Base.Languages.PythonTestResult]::new('nested.test_widget', 'test_widget_jams', 'fail', 1.25, $null)
        $result.Package | Should -Be 'nested.test_widget'
        $result.Name | Should -Be 'test_widget_jams'
        $result.Outcome | Should -Be 'fail'
        $result.DurationSeconds | Should -Be 1.25
        $result.Output | Should -BeExactly ''
        "$result" | Should -Be 'nested.test_widget test_widget_jams: fail'
    }

    It 'rejects <Case>, naming it' -ForEach @(
        @{ Case = 'a parametrised name'; Package = 'test_widget'; Name = 'test_widget[1]'; Outcome = 'pass'; Seconds = 0.0; Message = '*is not a top-level Python test name*' }
        @{ Case = 'a name that is not a test'; Package = 'test_widget'; Name = 'widget_spins'; Outcome = 'pass'; Seconds = 0.0; Message = "*'widget_spins' is not a top-level*" }
        @{ Case = 'an unknown outcome'; Package = 'test_widget'; Name = 'test_widget'; Outcome = 'error'; Seconds = 0.0; Message = "*Outcome 'error'*" }
        @{ Case = 'a negative duration'; Package = 'test_widget'; Name = 'test_widget'; Outcome = 'pass'; Seconds = -1.0; Message = '*DurationSeconds*' }
        @{ Case = 'an empty package'; Package = ''; Name = 'test_widget'; Outcome = 'pass'; Seconds = 0.0; Message = '*Package is required*' }
    ) {
        { [Catzc.Base.Languages.PythonTestResult]::new($Package, $Name, $Outcome, $Seconds, '') } | Should -Throw $Message
    }
}
