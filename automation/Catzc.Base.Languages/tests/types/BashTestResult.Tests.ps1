<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/tests/types/BashTestResult.Tests.ps1
    folder: tests/types
    name: bash-test-result-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'BashTestResult' -Tag 'L0', 'logic' {
    It 'derives the category from the name: "integrity:" is integrity, the rest logic' {
        [Catzc.Base.Languages.BashTestResult]::new('widget.bats', 'integrity: widget ships', 'pass', 0.5, '').Category | Should -Be 'integrity'
        [Catzc.Base.Languages.BashTestResult]::new('widget.bats', 'widget spins', 'pass', 0.5, '').Category | Should -Be 'logic'
    }

    It 'keeps every field, with no output as empty' {
        $result = [Catzc.Base.Languages.BashTestResult]::new('nested/widget.bats', 'widget jams', 'fail', 1.25, $null)
        $result.Package | Should -Be 'nested/widget.bats'
        $result.Name | Should -Be 'widget jams'
        $result.Outcome | Should -Be 'fail'
        $result.DurationSeconds | Should -Be 1.25
        $result.Output | Should -BeExactly ''
        "$result" | Should -Be 'nested/widget.bats widget jams: fail'
    }

    It 'rejects <Case>, naming it' -ForEach @(
        @{ Case = 'a package that is no .bats file'; Package = 'widget.sh'; Name = 'widget'; Outcome = 'pass'; Seconds = 0.0; Message = "*Package 'widget.sh'*" }
        @{ Case = 'a backslashed package'; Package = 'nested\widget.bats'; Name = 'widget'; Outcome = 'pass'; Seconds = 0.0; Message = "*'/'-separated*" }
        @{ Case = 'an empty name'; Package = 'widget.bats'; Name = ''; Outcome = 'pass'; Seconds = 0.0; Message = '*is not a Bash test name*' }
        @{ Case = 'a name with a trailing space'; Package = 'widget.bats'; Name = 'widget '; Outcome = 'pass'; Seconds = 0.0; Message = '*is not a Bash test name*' }
        @{ Case = 'an unknown outcome'; Package = 'widget.bats'; Name = 'widget'; Outcome = 'error'; Seconds = 0.0; Message = "*Outcome 'error'*" }
        @{ Case = 'a negative duration'; Package = 'widget.bats'; Name = 'widget'; Outcome = 'pass'; Seconds = -1.0; Message = '*DurationSeconds*' }
    ) {
        { [Catzc.Base.Languages.BashTestResult]::new($Package, $Name, $Outcome, $Seconds, '') } | Should -Throw $Message
    }
}
