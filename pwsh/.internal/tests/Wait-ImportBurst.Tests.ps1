# Only a burst's swap window holds an import back: no burst means no wait, a burst is waited out, and one that outlasts the limit fails by name.
Describe 'Wait-ImportBurst' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot '../assets/importer/Wait-ImportBurst.ps1')
        # A burst held for a while on a thread of its own, the way Enter-CatzcBurst holds the event in its own process.
        $script:holdBurst = {
            param([string] $Name, [int] $Milliseconds)
            Start-ThreadJob -ArgumentList $Name, $Milliseconds -ScriptBlock {
                param($Name, $Milliseconds)
                $event = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset, "$Name-burst")
                Start-Sleep -Milliseconds $Milliseconds
                $event.Dispose()
            }
        }
    }

    BeforeEach {
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid().ToString('n'))"
        $script:inBurst = $env:CATZC_IN_BURST
        $env:CATZC_IN_BURST = $null
    }

    AfterEach {
        $env:CATZC_IN_BURST = $script:inBurst
        Get-Job | Remove-Job -Force
    }

    It 'goes on at once when no burst holds the lock' {
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        Wait-ImportBurst -LockName $script:lockName -Seconds 5
        $watch.Elapsed.TotalMilliseconds | Should -BeLessThan 200
    }

    It 'waits while a burst holds the lock, then goes on once it ends' {
        $job = & $script:holdBurst $script:lockName 1200
        Start-Sleep -Milliseconds 300
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        Wait-ImportBurst -LockName $script:lockName -Seconds 10 -PollMilliseconds 50 -InformationAction SilentlyContinue
        $watch.Elapsed.TotalMilliseconds | Should -BeGreaterThan 500
        $job | Wait-Job | Out-Null
    }

    It 'fails, naming the lock, when the burst outlasts the wait' {
        $job = & $script:holdBurst $script:lockName 4000
        Start-Sleep -Milliseconds 300
        { Wait-ImportBurst -LockName $script:lockName -Seconds 1 -PollMilliseconds 50 -InformationAction SilentlyContinue } |
            Should -Throw "*waited 1 s for a burst on $($script:lockName)*"
        $job | Stop-Job
    }

    It 'lets a burst''s own import through without waiting' {
        $job = & $script:holdBurst $script:lockName 3000
        Start-Sleep -Milliseconds 300
        $env:CATZC_IN_BURST = '1'
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        Wait-ImportBurst -LockName $script:lockName -Seconds 5
        $watch.Elapsed.TotalMilliseconds | Should -BeLessThan 200
        $job | Stop-Job
    }
}
