<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Timeouts/tests/Test-CompletesWithin.Tests.ps1
    folder: tests
    name: test-completes-within-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-CompletesWithin' -Tag 'L0', 'logic' {
    It 'returns $true, with no other output, when the block finishes in time' {
        $result = @(Test-CompletesWithin { 'widget' } -Seconds 5)
        $result.Count | Should -Be 1
        $result[0] | Should -BeTrue
    }

    It 'returns $false when the safeguard stops the block' {
        Mock Invoke-WithTimeout -ModuleName Catzc.Base.Timeouts { throw [System.TimeoutException]::new('gadget stopped') }
        Test-CompletesWithin { 'gadget' } -Seconds 1 | Should -BeFalse
    }

    It "throws the block's own error, which is not a timeout" {
        { Test-CompletesWithin { throw 'widget broke' } -Seconds 5 } | Should -Throw 'widget broke'
    }

    It "defaults the limit to the budget's resolved limit" {
        Mock Get-TimeoutSeconds -ModuleName Catzc.Base.Timeouts { 42 }
        Mock Invoke-WithTimeout -ModuleName Catzc.Base.Timeouts { }
        # A fixture GUID built at runtime (not a literal), so it needs no managed-GUID registry entry.
        $widgetBudget = [guid] ('a1d6e700-0000-0000-0000-' + '000000000000')
        Test-CompletesWithin { 'widget' } -Budget $widgetBudget | Should -BeTrue
        Should -Invoke Get-TimeoutSeconds -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Budget -eq $widgetBudget }
        Should -Invoke Invoke-WithTimeout -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Seconds -eq 42 }
    }
}
