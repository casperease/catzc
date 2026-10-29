BeforeAll {
    . (Join-Path $PSScriptRoot 'RunLock.Fixture.ps1')
}

Describe 'Wait-CatzcRunLock' -Tag 'L0', 'logic' {
    BeforeEach {
        # Each test takes a lock of its own, so a real run on the machine never touches it.
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
        $script:taken = [ref] $null
    }

    AfterEach {
        if ($script:taken.Value) {
            $script:taken.Value.ReleaseMutex()
            $script:taken.Value.Dispose()
        }
        Remove-CatzcRunLockHolder -LockName $script:lockName
        Remove-Item -LiteralPath (Get-QueueFolder $script:lockName) -Recurse -Force -ErrorAction Ignore
    }

    It 'takes a free lock with no waiting line, and leaves no queue folder' {
        $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
        $out.Count | Should -Be 0
        $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        Test-Path (Get-QueueFolder $script:lockName) | Should -BeFalse
    }

    It 'reads a hold in its own lock''s variable only, named by the holder''s process id and start time' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $inherit = Get-CatzcRunLockInheritName -LockName $script:lockName
        $inherit | Should -Match '^CATZC_RUN_LOCK_HOLD_[A-Za-z0-9_]+$'
        Get-CatzcRunLockHoldValue | Should -BeExactly "$PID|$(Get-CatzcRunLockProcessStart -ProcessId $PID)"
        # This process's own hold never counts (its other threads queue like any run); its parent's does.
        [System.Environment]::SetEnvironmentVariable($inherit, (Get-CatzcRunLockHoldValue))
        Test-CatzcRunLockInherited -LockName $script:lockName | Should -BeFalse
        $parent = (Get-Process -Id $PID).Parent.Id
        [System.Environment]::SetEnvironmentVariable($inherit, "$parent|$(Get-CatzcRunLockProcessStart -ProcessId $parent)")
        try {
            Test-CatzcRunLockInherited -LockName $script:lockName | Should -BeTrue
            Test-CatzcRunLockInherited -LockName "$script:lockName-gadget" | Should -BeFalse
        }
        finally {
            [System.Environment]::SetEnvironmentVariable($inherit, $null)
        }
        Test-CatzcRunLockInherited -LockName $script:lockName | Should -BeFalse
    }

    It 'counts a hold for a live ancestor, never for a gone or reused holder: <case>' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' -ForEach @(
        # Windows process ids are multiples of four, so an odd id names no process.
        @{ case = 'gone'; Value = '4194303|1'; Expected = $false }
        @{ case = 'reused'; Value = 'own|1'; Expected = $false }
        @{ case = 'unreadable'; Value = 'widget'; Expected = $false }
        @{ case = 'ancestor'; Value = 'parent'; Expected = $true }
    ) {
        $inherit = Get-CatzcRunLockInheritName -LockName $script:lockName
        $parent = (Get-Process -Id $PID).Parent.Id
        $text = switch ($Value) {
            'own|1' {
                "$PID|1"
            }
            'parent' {
                "$parent|$(Get-CatzcRunLockProcessStart -ProcessId $parent)"
            }
            default {
                $Value
            }
        }
        [System.Environment]::SetEnvironmentVariable($inherit, $text)
        try {
            Test-CatzcRunLockInherited -LockName $script:lockName | Should -Be $Expected
        }
        finally {
            [System.Environment]::SetEnvironmentVariable($inherit, $null)
        }
    }

    It 'serves waiters in the order they came, not as the lock falls free' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $held = [System.Threading.Mutex]::new($true, $script:lockName)
        $order = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
        $waiters = foreach ($name in 'widget', 'gadget', 'sprocket') {
            Start-Waiter -Name $script:lockName -Waiter $name -Order $order
            Start-Sleep -Milliseconds 150
        }
        $held.ReleaseMutex()
        $held.Dispose()
        foreach ($waiter in $waiters) {
            Stop-Waiter $waiter
        }
        @($order) | Should -Be @('widget', 'gadget', 'sprocket')
    }

    It 'leaves a queue folder that still holds a peer ticket, and adds nothing to $Error' {
        $queue = Get-QueueFolder $script:lockName
        [System.IO.Directory]::CreateDirectory($queue) | Out-Null
        # A live peer queued behind this waiter: a later ticket of this process.
        $peer = Join-Path $queue ('{0:D20}-{1}-{2}.ticket' -f ([datetime]::UtcNow.AddMinutes(5).Ticks), $PID,
            ([guid]::NewGuid().ToString('N')))
        [System.IO.File]::WriteAllText($peer, '')
        $before = $global:Error.Count
        $null = Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken
        $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        $global:Error.Count | Should -Be $before
        Test-Path $peer | Should -BeTrue
        [System.IO.Directory]::Delete($queue, $true)
    }

    It 'drops the ticket of a waiter whose process is gone, so the queue does not stall behind it' {
        $queue = Get-QueueFolder $script:lockName
        [System.IO.Directory]::CreateDirectory($queue) | Out-Null
        # The oldest ticket, of a process id no process has.
        $dead = Join-Path $queue ('{0:D20}-{1}-{2}.ticket' -f ([datetime]::UtcNow.AddSeconds(-5).Ticks), 2147483646,
            ([guid]::NewGuid().ToString('N')))
        [System.IO.File]::WriteAllText($dead, '')
        $null = Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken
        $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        Test-Path $dead | Should -BeFalse
    }

    It 'waits as long as a burst holds the lock, past its own wait, and takes it once the burst ends' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset,
            "$script:lockName-burst")
        # The burst lasts 2 s, twice the waiter's own 1 s.
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 2000 -Burst $burst
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $out | Should -Be @(
                '[Widget] waiting for the run lock: another run holds it (up to 1 s)'
                '[Widget] a burst holds the run lock: waiting until it ends, then up to 1 s'
            )
            $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'says run lock busy and sets no lock when a plain run keeps it past the wait' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $out | Should -Be @(
                '[Widget] waiting for the run lock: another run holds it (up to 1 s)'
                '[Widget] run lock busy: another run held it for 1 s, so nothing ran'
            )
            $script:taken.Value | Should -BeNullOrEmpty
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'waits past its own wait while a live plain holder is inside its deadline, and takes the lock once it is let go' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 2500 -RecordSeconds 30
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $out[0] | Should -Be '[Widget] waiting for the run lock: another run holds it (up to 1 s)'
            $out[1] |
                Should -Match "^\[Widget\] Get-Gadget \(pid $PID\) holds the run lock until \d\d:\d\d:\d\d: waiting for it, then up to 1 s$"
            $out.Count | Should -Be 2
            $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
            (Get-CatzcRunLockHolder -LockName $script:lockName).Holding | Should -Be 'Get-Widget'
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'waits for a freshly started holder whose deadline is still its budget, not yet declared, and takes the lock once it is let go' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500 -RecordSeconds 120
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 10 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            ($out -join "`n") | Should -Not -BeLike '*run lock busy*'
            $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'stops while its budget still leaves its own wait for its work, when an undeclared holder keeps the lock' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 4000 -RecordSeconds 120
        try {
            $holder.Taken | Should -BeTrue
            $timer = [System.Diagnostics.Stopwatch]::StartNew()
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 3 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $timer.Elapsed.TotalSeconds | Should -BeLessThan 3
            $out[-1] |
                Should -Match "^\[Widget\] run lock busy: Get-Gadget \(pid $PID\) holds it until \d\d:\d\d:\d\d, past this run's budget of 3 s, so nothing ran; retry after it$"
            $script:taken.Value | Should -BeNullOrEmpty
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'waits for a live holder whose declared deadline lies past its own budget, and takes the lock once it is let go inside the budget' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500 -RecordSeconds 120
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 5 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            ($out -join "`n") | Should -Not -BeLike '*run lock busy*'
            $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'never stops for a plain holder whose process is gone, though its record runs past its own budget' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 1500
        try {
            $holder.Taken | Should -BeTrue
            $path = Get-CatzcRunLockHolderPath -LockName $script:lockName
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
            [System.IO.File]::WriteAllText($path,
                "2147483646|0|$([datetime]::UtcNow.AddSeconds(120).Ticks)|0|0|Get-Gadget")
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 3 -BudgetSeconds 5 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $out | Should -Be @('[Widget] waiting for the run lock: another run holds it (up to 3 s)')
            $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'gives up on a burst that outlasts its own budget instead of waiting for it forever' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset,
            "$script:lockName-burst")
        # The burst hangs 3 s; the waiter's whole budget is 1 s.
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 3000 -Burst $burst
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 1 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $out[-1] |
                Should -Be "[Widget] run lock busy: a burst held it past this run's budget of 1 s, so nothing ran; retry after it"
            $script:taken.Value | Should -BeNullOrEmpty
        }
        finally {
            Stop-LockHolder $holder
        }
    }

    It 'ships a budget a waiter spends inside a 300 s background call, so it stops with its own line before the call is killed' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        (Get-CatzcRunLockSetting).budget_seconds | Should -BeLessThan 300
    }

    It 'does not wait for a burst whose holder is gone: <case>' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' -ForEach @(
        @{ case = 'its process is dead'; Record = { "2147483646|0|$([datetime]::UtcNow.AddSeconds(120).Ticks)|0|0|a burst (Enter-CatzcBurst)" } }
        @{ case = 'past its declared length'; Record = { "$PID|$((Get-Process -Id $PID).StartTime.ToUniversalTime().Ticks)|$([datetime]::UtcNow.AddSeconds(-5).Ticks)|0|0|a burst (Enter-CatzcBurst)" } }
    ) {
        $burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset,
            "$script:lockName-burst")
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 3000
        try {
            $holder.Taken | Should -BeTrue
            $path = Get-CatzcRunLockHolderPath -LockName $script:lockName
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
            [System.IO.File]::WriteAllText($path, (& $Record))
            $timer = [System.Diagnostics.Stopwatch]::StartNew()
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $timer.Elapsed.TotalSeconds | Should -BeLessThan 2.5
            $out |
                Should -Contain "[Widget] a burst's holder is gone or past its declared length: not waiting for it, up to 1 s"
            $out[-1] | Should -Be '[Widget] run lock busy: another run held it for 1 s, so nothing ran'
            $script:taken.Value | Should -BeNullOrEmpty
        }
        finally {
            Stop-LockHolder $holder
            $burst.Dispose()
        }
    }

    It 'reads a holder record that is torn while its writer still writes once more, and counts one that stays torn as no holder' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $path = Get-CatzcRunLockHolderPath -LockName $script:lockName
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
        $self = (Get-Process -Id $PID).StartTime.ToUniversalTime().Ticks
        $whole = "$PID|$self|$([datetime]::UtcNow.AddSeconds(120).Ticks)|0|0|Get-Gadget"
        [System.IO.File]::WriteAllText($path, "$PID|$self")
        # The read starts once the writer runs, so a slow runspace start under load never outlasts the reader's one retry.
        $ready = [System.Threading.ManualResetEventSlim]::new($false)
        $writer = [powershell]::Create().AddScript({
                param($Path, $Text, $Ready)
                $Ready.Set()
                Start-Sleep -Milliseconds 15
                [System.IO.File]::WriteAllText($Path, $Text)
            }).AddArgument($path).AddArgument($whole).AddArgument($ready)
        $handle = $writer.BeginInvoke()
        try {
            $ready.Wait(10000) | Should -BeTrue
            Get-CatzcRunLockHolder -LockName $script:lockName | ForEach-Object Holding | Should -Be 'Get-Gadget'
        }
        finally {
            $null = $writer.EndInvoke($handle)
            $writer.Dispose()
            $ready.Dispose()
        }
        [System.IO.File]::WriteAllText($path, "$PID|$self")
        Get-CatzcRunLockHolder -LockName $script:lockName | Should -BeNullOrEmpty
    }

    It 'reads the run-lock settings from the timeouts file without an import, and fails naming a missing key' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $file = Join-Path $TestDrive 'timeouts.yml'
        [System.IO.File]::WriteAllText($file,
            "tests:`n  run_seconds: 180`nrun_lock:`n  wait_seconds: 30 # a comment`n  stale_seconds: 600`n  budget_seconds: 300`nwait:`n  seconds: 1`n")
        $settings = Get-CatzcRunLockSetting -Path $file
        $settings.wait_seconds | Should -Be 30
        $settings.stale_seconds | Should -Be 600
        $settings.budget_seconds | Should -Be 300
        [System.IO.File]::WriteAllText($file, "run_lock:`n  wait_seconds: 30`n")
        { Get-CatzcRunLockSetting -Path $file } | Should -Throw '*declares no run_lock.stale_seconds*'
    }
}
