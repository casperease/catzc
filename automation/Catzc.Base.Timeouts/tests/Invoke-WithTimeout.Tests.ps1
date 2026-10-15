<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/tests/Invoke-WithTimeout.Tests.ps1
    kind: test
---
#>

Describe 'Invoke-WithTimeout' -Tag 'L0', 'logic' {
    It "returns the block's output and sees the caller's variables" {
        $widget = 'widget'
        Invoke-WithTimeout { "$widget ready"; 2 } -Seconds 5 | Should -Be @('widget ready', 2)
    }

    # L1: waits out a real 1-second limit, over the L0 time budget.
    It 'stops a block past its limit and throws a TimeoutException naming the limit' -Tag 'L1' {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $err = { Invoke-WithTimeout { Start-Sleep -Seconds 10 } -Seconds 1 -Activity 'gadget sync' } | Should -Throw -PassThru
        $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 5
        $err.Exception | Should -BeOfType [System.TimeoutException]
        $err.Exception.Message | Should -BeLike "*'gadget sync' did not finish within its 1-second limit*timeouts.yml*"
    }

    # L2: drives a real child pwsh that outlives the limit.
    It 'stops a native command the block is waiting on' -Tag 'L2' {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        { Invoke-WithTimeout { & pwsh -NoProfile -Command 'Start-Sleep -Seconds 10' } -Seconds 1 } | Should -Throw -ExceptionType ([System.TimeoutException])
        $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 8
    }

    It "rethrows the block's own terminating error" {
        { Invoke-WithTimeout { throw 'widget broke' } -Seconds 5 } | Should -Throw 'widget broke'
    }

    It 'passes on non-terminating errors and keeps the output' {
        # The block runs in this scope, so it follows this scope's preference — as it would if called directly.
        $ErrorActionPreference = 'Continue'
        $missing = Join-Path $TestDrive 'no-such-gadget'
        $output = Invoke-WithTimeout { Get-Item -LiteralPath $missing; 'after' } -Seconds 5 -ErrorVariable errors -ErrorAction SilentlyContinue
        $output | Should -Be 'after'
        $errors.Count | Should -Be 1
        "$($errors[0])" | Should -BeLike '*no-such-gadget*'
    }

    # L1: waits out a real 1-second limit, over the L0 time budget.
    It 'defaults the limit to Get-TimeoutSeconds' -Tag 'L1' {
        Mock Get-TimeoutSeconds -ModuleName Catzc.Base.Timeouts { 1 }
        { Invoke-WithTimeout { Start-Sleep -Seconds 10 } } | Should -Throw '*1-second limit*'
    }
}
