Describe 'Invoke-WithRetry' -Tag 'L0', 'logic', 'ADR-AUTO-RETRY-BOUNDEDANDVISIBLE', 'ADR-AUTO-RETRY-DEDICATEDWRAPPER' {
    BeforeAll {
        . (Join-Path $PSScriptRoot '../assets/builder/Invoke-WithRetry.ps1')
        Mock Start-Sleep { }
        Mock Write-Message { }
    }

    It 'returns the operation''s result on the first attempt without a message' {
        Invoke-WithRetry -Name 'widget' -Operation { 'gadget' } | Should -Be 'gadget'
        Should -Invoke Write-Message -Times 0 -Exactly
    }

    It 'repeats a transient failure with one warning message per retry, then returns the result' {
        $script:calls = 0
        $result = Invoke-WithRetry -Name 'widget move' -Attempts 5 -DelayMilliseconds 1 -Operation {
            $script:calls++
            if ($script:calls -lt 3) {
                throw [System.IO.IOException]::new("busy $script:calls")
            }
            'landed'
        }
        $result | Should -Be 'landed'
        $script:calls | Should -Be 3
        Should -Invoke Write-Message -Times 2 -Exactly
        Should -Invoke Write-Message -Times 1 -Exactly -ParameterFilter {
            $Warning -and $Message -eq 'widget move failed on attempt 1 of 5 (busy 1); retrying in 1 ms.'
        }
        Should -Invoke Start-Sleep -Times 2 -Exactly
    }

    It 'throws the last failure as it is once the attempts are spent' {
        $script:calls = 0
        { Invoke-WithRetry -Name 'widget' -Attempts 3 -DelayMilliseconds 1 -Operation { $script:calls++; throw [System.UnauthorizedAccessException]::new('denied') } } |
            Should -Throw -ExceptionType ([System.UnauthorizedAccessException])
        $script:calls | Should -Be 3
    }

    It 'reads a denied .NET call through its method-invocation wrapper as transient' {
        $script:calls = 0
        $missing = Join-Path $TestDrive 'nowhere'
        { Invoke-WithRetry -Name 'widget' -Attempts 2 -DelayMilliseconds 1 -Operation { $script:calls++; [System.IO.Directory]::Move($missing, "$missing-2") } } |
            Should -Throw
        $script:calls | Should -Be 2
    }

    It 'never repeats a failure outside the transient types' {
        $script:calls = 0
        { Invoke-WithRetry -Name 'widget' -Attempts 5 -Operation { $script:calls++; throw [System.InvalidOperationException]::new('broken') } } |
            Should -Throw -ExceptionType ([System.InvalidOperationException])
        $script:calls | Should -Be 1
        Should -Invoke Write-Message -Times 0 -Exactly
    }
}
