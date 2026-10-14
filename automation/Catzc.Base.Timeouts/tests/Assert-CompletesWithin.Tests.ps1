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
        Assert-CompletesWithin { 'widget' } -Budget 'widget-budget'
        Should -Invoke Get-TimeoutSeconds -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Budget -eq 'widget-budget' }
        Should -Invoke Invoke-WithTimeout -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $Seconds -eq 42 }
    }
}
