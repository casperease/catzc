Describe 'Assert-CompletesWithin' -Tag 'L0', 'logic' {
    It 'passes, with no output, when the block finishes in time' {
        Assert-CompletesWithin { 'widget' } -Seconds 5 | Should -BeNullOrEmpty
    }

    It 'throws a TimeoutException when the block outlives the limit' {
        { Assert-CompletesWithin { Start-Sleep -Seconds 10 } -Seconds 1 -Activity 'gadget import' } |
            Should -Throw -ExceptionType ([System.TimeoutException]) -ExpectedMessage "*'gadget import'*1-second limit*"
    }

    It "throws the block's own error when it fails in time" {
        { Assert-CompletesWithin { throw 'widget broke' } -Seconds 5 } | Should -Throw 'widget broke'
    }
}
