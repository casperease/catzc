[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The contended-hold helper''s Mutex/HeldSignal/HoldMilliseconds parameters are consumed via $using: inside its Start-ThreadJob scriptblock, which this rule does not trace')]
param()

Describe 'Wait-Mutex' -Tag 'L0', 'logic' {
    BeforeAll {
        # The writer is the observable boundary (ADR-AUTO-PESTER:3): assert which message shape each path emits.
        Mock Write-Message { } -ModuleName Catzc.Base.Execution
    }

    It 'acquires an uncontended mutex and leaves only the verbose breadcrumb' {
        $mutex = [System.Threading.Mutex]::new($false)
        try {
            Wait-Mutex $mutex
            { $mutex.ReleaseMutex() } | Should -Not -Throw   # ownership proves the acquire
        }
        finally {
            $mutex.Dispose()
        }

        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -like 'Awaited the mutex in*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 0 -ParameterFilter {
            $Message -like 'Waiting for the*' -or $Message -like 'Acquired the*'
        }
    }

    It 'treats an abandoned mutex as acquired, with an ownership-transfer breadcrumb' {
        $mutex = [System.Threading.Mutex]::new($false)
        $holder = Start-ThreadJob {
            [void]($using:mutex).WaitOne()   # acquire and exit without releasing -> abandoned
        }
        try {
            $holder | Wait-Job -Timeout 10 | Out-Null
            Wait-Mutex $mutex
            { $mutex.ReleaseMutex() } | Should -Not -Throw
        }
        finally {
            $holder | Remove-Job -Force
            $mutex.Dispose()
        }

        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -like '*ownership transferred*'
        }
    }

    It 'rejects a null mutex at parameter binding' {
        { Wait-Mutex -Mutex $null } | Should -Throw
    }
}

Describe 'Wait-Mutex (contended)' -Tag 'L1', 'logic' {
    BeforeAll {
        Mock Write-Message { } -ModuleName Catzc.Base.Execution

        # Hold the mutex on another thread, signal once owned, release after a fixed hold — so the
        # main thread's Wait-Mutex reliably crosses a tiny announce threshold before acquiring.
        $script:startContendedHold = {
            param([System.Threading.Mutex] $Mutex, [System.Threading.ManualResetEventSlim] $HeldSignal, [int] $HoldMilliseconds)
            Start-ThreadJob {
                $sharedMutex = $using:Mutex
                [void]$sharedMutex.WaitOne()
                ($using:HeldSignal).Set()
                Start-Sleep -Milliseconds $using:HoldMilliseconds
                $sharedMutex.ReleaseMutex()
            }
        }
    }

    It 'announces once and reports the acquisition when the wait crosses the threshold' {
        $mutex = [System.Threading.Mutex]::new($false)
        $heldSignal = [System.Threading.ManualResetEventSlim]::new($false)
        $holder = & $script:startContendedHold -Mutex $mutex -HeldSignal $heldSignal -HoldMilliseconds 250
        try {
            $heldSignal.Wait(10000) | Should -BeTrue
            Wait-Mutex $mutex -Name 'fixture mutex' -AnnounceAfterSeconds 0.05 -DotIntervalSeconds 0.05
            { $mutex.ReleaseMutex() } | Should -Not -Throw
        }
        finally {
            $holder | Wait-Job -Timeout 10 | Remove-Job -Force
            $mutex.Dispose()
            $heldSignal.Dispose()
        }

        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -like 'Waiting for the fixture mutex*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -like 'Acquired the fixture mutex after*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 0 -ParameterFilter {
            $Message -like 'Awaited the*'
        }
    }

    It 'announces with the custom -AnnounceText' {
        $mutex = [System.Threading.Mutex]::new($false)
        $heldSignal = [System.Threading.ManualResetEventSlim]::new($false)
        $holder = & $script:startContendedHold -Mutex $mutex -HeldSignal $heldSignal -HoldMilliseconds 250
        try {
            $heldSignal.Wait(10000) | Should -BeTrue
            Wait-Mutex $mutex -AnnounceText 'the fixture holder is busy' -AnnounceAfterSeconds 0.05 -DotIntervalSeconds 0.05
            { $mutex.ReleaseMutex() } | Should -Not -Throw
        }
        finally {
            $holder | Wait-Job -Timeout 10 | Remove-Job -Force
            $mutex.Dispose()
            $heldSignal.Dispose()
        }

        Should -Invoke Write-Message -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Message -eq 'the fixture holder is busy'
        }
    }

    It 'throws when -TimeoutSeconds expires while the mutex stays held' {
        $mutex = [System.Threading.Mutex]::new($false)
        $heldSignal = [System.Threading.ManualResetEventSlim]::new($false)
        $releaseSignal = [System.Threading.ManualResetEventSlim]::new($false)
        $holder = Start-ThreadJob {
            $sharedMutex = $using:mutex
            [void]$sharedMutex.WaitOne()
            ($using:heldSignal).Set()
            [void]($using:releaseSignal).Wait(10000)
            $sharedMutex.ReleaseMutex()
        }
        try {
            $heldSignal.Wait(10000) | Should -BeTrue
            {
                Wait-Mutex $mutex -TimeoutSeconds 0.15 -AnnounceAfterSeconds 0.02 -DotIntervalSeconds 0.02
            } | Should -Throw '*Timed out waiting for the mutex*'
        }
        finally {
            $releaseSignal.Set()
            $holder | Wait-Job -Timeout 10 | Remove-Job -Force
            $mutex.Dispose()
            $heldSignal.Dispose()
            $releaseSignal.Dispose()
        }
    }
}
