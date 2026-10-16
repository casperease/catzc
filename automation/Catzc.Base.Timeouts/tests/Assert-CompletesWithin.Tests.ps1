<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/tests/Assert-CompletesWithin.Tests.ps1
    folder: tests
    name: assert-completes-within-tests
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

Describe 'Assert-CompletesWithin' -Tag 'L0', 'logic' {
    It 'passes, with no output, when the block finishes in time' {
        Assert-CompletesWithin { 'widget' } -Seconds 5 | Should -BeNullOrEmpty
    }

    # L1: waits out a real 1-second limit, over the L0 time budget.
    It 'throws a TimeoutException when the block outlives the limit' -Tag 'L1' {
        { Assert-CompletesWithin { Start-Sleep -Seconds 10 } -Seconds 1 -Activity 'gadget import' } |
            Should -Throw -ExceptionType ([System.TimeoutException]) -ExpectedMessage "*'gadget import'*1-second limit*"
    }

    It "throws the block's own error when it fails in time" {
        { Assert-CompletesWithin { throw 'widget broke' } -Seconds 5 } | Should -Throw 'widget broke'
    }

    It "defaults the limit to the budget's resolved limit" {
        Mock Get-TimeoutSeconds -ModuleName Catzc.Base.Timeouts { 42 }
        Mock Invoke-WithTimeout -ModuleName Catzc.Base.Timeouts { }
        # A fixture GUID built at runtime (not a literal), so it needs no managed-GUID registry entry.
        $widgetBudget = [guid] ('a1d6e700-0000-0000-0000-' + '000000000000')
        Assert-CompletesWithin { 'widget' } -Budget $widgetBudget
        Should -Invoke Get-TimeoutSeconds -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Budget -eq $widgetBudget }
        Should -Invoke Invoke-WithTimeout -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Seconds -eq 42 }
    }
}
