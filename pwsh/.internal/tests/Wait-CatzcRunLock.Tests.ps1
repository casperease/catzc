<#
---
catzc:
  immutable:
    with_body_sha: "4c37ed01205b"
  edges:
    docs: "[Wait-CatzcRunLock.Tests.ps1.md](../../../docs/references/pwsh/internal/tests/Wait-CatzcRunLock.Tests.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

Describe 'Wait-CatzcRunLock' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:waiter = Join-Path $PSScriptRoot '../assets/Wait-CatzcRunLock.ps1'
        . $script:waiter
        # Waits for the lock on another thread, the way another run would; on taking it, records its name in the shared order and lets go.
        function script:Start-Waiter {
            param([string] $Name, [string] $Waiter, [System.Collections.Concurrent.ConcurrentQueue[string]] $Order)
            $shell = [powershell]::Create().AddScript({
                    param($Path, $Name, $Waiter, $Order)
                    . $Path
                    $taken = [ref] $null
                    $null = Wait-CatzcRunLock -LockName $Name -LockSeconds 5 -Caller $Waiter -Busy 'nothing ran' -Lock $taken
                    if ($taken.Value) {
                        $Order.Enqueue($Waiter)
                        Start-Sleep -Milliseconds 50
                        $taken.Value.ReleaseMutex()
                        $taken.Value.Dispose()
                    }
                }).AddArgument($script:waiter).AddArgument($Name).AddArgument($Waiter).AddArgument($Order)
            [pscustomobject]@{ Shell = $shell; Handle = $shell.BeginInvoke() }
        }
        function script:Stop-Waiter {
            param($Waiter)
            $null = $Waiter.Shell.EndInvoke($Waiter.Handle)
            $Waiter.Shell.Dispose()
        }
        function script:Start-LockHolder {
            param([string] $Name, [int] $Milliseconds, [System.Threading.EventWaitHandle] $Burst)
            $taken = [System.Threading.ManualResetEventSlim]::new($false)
            $shell = [powershell]::Create().AddScript({
                    param($Name, $Milliseconds, $Taken, $Burst)
                    $held = [System.Threading.Mutex]::new($false, $Name)
                    $null = $held.WaitOne()
                    $Taken.Set()
                    Start-Sleep -Milliseconds $Milliseconds
                    if ($Burst) {
                        $Burst.Dispose()
                    }
                    $held.ReleaseMutex()
                    $held.Dispose()
                }).AddArgument($Name).AddArgument($Milliseconds).AddArgument($taken).AddArgument($Burst)
            $handle = $shell.BeginInvoke()
            [pscustomobject]@{ Shell = $shell; Handle = $handle; Taken = $taken.Wait(2000) }
        }
        function script:Stop-LockHolder {
            param($Holder)
            $null = $Holder.Shell.EndInvoke($Holder.Handle)
            $Holder.Shell.Dispose()
        }
        function script:Get-QueueFolder {
            param([string] $Name)
            Join-Path ([System.IO.Path]::GetTempPath()) "catzc-run-queue/$($Name -replace '[\\/:*?"<>|]', '_')"
        }
    }

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
    }

    It 'takes a free lock with no waiting line, and leaves no queue folder' {
        $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
        $out.Count | Should -Be 0
        $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        Test-Path (Get-QueueFolder $script:lockName) | Should -BeFalse
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

    It 'drops the ticket of a waiter whose process is gone, so the queue does not stall behind it' {
        $queue = Get-QueueFolder $script:lockName
        [System.IO.Directory]::CreateDirectory($queue) | Out-Null
        # The oldest ticket, of a process id no process has.
        $dead = Join-Path $queue ('{0:D20}-{1}-{2}.ticket' -f ([datetime]::UtcNow.AddSeconds(-5).Ticks), 2147483646, ([guid]::NewGuid().ToString('N')))
        [System.IO.File]::WriteAllText($dead, '')
        $null = Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken
        $script:taken.Value | Should -BeOfType [System.Threading.Mutex]
        Test-Path $dead | Should -BeFalse
    }

    It 'waits as long as a burst holds the lock, past its own wait, and takes it once the burst ends' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset, "$script:lockName-burst")
        # The burst lasts 2 s, twice the waiter's own 1 s.
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 2000 -Burst $burst
        try {
            $holder.Taken | Should -BeTrue
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
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
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
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
}
