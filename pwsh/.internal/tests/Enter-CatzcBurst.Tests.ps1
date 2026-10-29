Describe 'Enter-CatzcBurst' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:enter = Join-Path $PSScriptRoot '../assets/Enter-CatzcBurst.ps1'
        $script:exit = Join-Path $PSScriptRoot '../assets/Exit-CatzcBurst.ps1'
        $script:entry = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        $script:importer = Join-Path $TestDrive 'widget-importer.ps1'
        [System.IO.File]::WriteAllText($script:importer,
            "function Get-Widget { 'widget' }`nfunction Write-Message { param([AllowEmptyString()] [string] `$Message, [switch] `$NoHeader) Write-Information `$Message -InformationAction Continue }`n")
        # Runs a burst on another thread, the way a session's background call would, and waits until it holds the lock.
        function script:Start-Burst {
            param([string] $Name, [int] $Seconds)
            $shell = [powershell]::Create().AddScript({
                    param($Enter, $Name, $Seconds)
                    & $Enter -Seconds $Seconds -LockName $Name -LockSeconds 1
                }).AddArgument($script:enter).AddArgument($Name).AddArgument($Seconds)
            $handle = $shell.BeginInvoke()
            $deadline = [datetime]::UtcNow.AddSeconds(2)
            $opened = $null
            while (-not [System.Threading.EventWaitHandle]::TryOpenExisting("$Name-burst", [ref] $opened) -and
                [datetime]::UtcNow -lt $deadline) {
                Start-Sleep -Milliseconds 10
            }
            if ($opened) {
                $opened.Dispose()
            }
            [pscustomobject]@{ Shell = $shell; Handle = $handle }
        }
        function script:Stop-Burst {
            param($Burst)
            $lines = @($Burst.Shell.EndInvoke($Burst.Handle))
            $Burst.Shell.Dispose()
            $lines
        }
        # Runs Invoke-CatzcCommand on another thread, the way another session's run would queue behind the burst.
        function script:Start-Run {
            param([string] $Name, [int] $LockSeconds)
            $shell = [powershell]::Create().AddScript({
                    param($Entry, $Importer, $Name, $LockSeconds)
                    & $Entry 'Get-Widget' -Importer $Importer -LockName $Name -LockSeconds $LockSeconds
                }).AddArgument($script:entry).AddArgument($script:importer).AddArgument($Name).AddArgument($LockSeconds)
            [pscustomobject]@{ Shell = $shell; Handle = $shell.BeginInvoke() }
        }
        # Holds the lock on another thread for the given milliseconds, the way a plain run (no burst) would.
        function script:Start-LockHolder {
            param([string] $Name, [int] $Milliseconds)
            $taken = [System.Threading.ManualResetEventSlim]::new($false)
            $shell = [powershell]::Create().AddScript({
                    param($Name, $Milliseconds, $Taken)
                    $held = [System.Threading.Mutex]::new($false, $Name)
                    $null = $held.WaitOne()
                    $Taken.Set()
                    Start-Sleep -Milliseconds $Milliseconds
                    $held.ReleaseMutex()
                    $held.Dispose()
                }).AddArgument($Name).AddArgument($Milliseconds).AddArgument($taken)
            $handle = $shell.BeginInvoke()
            [pscustomobject]@{ Shell = $shell; Handle = $handle; Taken = $taken.Wait(2000) }
        }
    }

    BeforeEach {
        # Each test takes a lock of its own, so a real run or burst on the machine never touches it.
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
    }

    It 'holds the lock against every other run until Exit-CatzcBurst ends the burst' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $burst = Start-Burst -Name $script:lockName -Seconds 5
        $run = Start-Run -Name $script:lockName -LockSeconds 1
        Start-Sleep -Milliseconds 1500
        $run.Handle.IsCompleted | Should -BeFalse
        & $script:exit -LockName $script:lockName |
            Should -BeExactly "[Exit-CatzcBurst] ended the burst on $script:lockName"
        $lines = @($run.Shell.EndInvoke($run.Handle))
        $run.Shell.Dispose()
        $lines | Should -Be @(
            '[Invoke-CatzcCommand] waiting for the run lock: another run holds it (up to 1 s)'
            '[Invoke-CatzcCommand] a burst holds the run lock: waiting until it ends, then up to 1 s'
            '[Invoke-CatzcCommand] passed: Get-Widget'
            '[Invoke-CatzcCommand] 1 of 1 passed'
        )
        Stop-Burst $burst | Should -Be @(
            '[Enter-CatzcBurst] holding the run lock for up to 5 s; end the burst with Exit-CatzcBurst.ps1'
            '[Enter-CatzcBurst] released the run lock: Exit-CatzcBurst ended the burst'
        )
    }

    It 'lets the burst''s own checks run under its lock with -InBurst' {
        $burst = Start-Burst -Name $script:lockName -Seconds 5
        try {
            $run = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -InBurst)
            $LASTEXITCODE | Should -Be 0
            $run | Should -Be @('[Invoke-CatzcCommand] passed: Get-Widget', '[Invoke-CatzcCommand] 1 of 1 passed')
        }
        finally {
            & $script:exit -LockName $script:lockName
            $null = Stop-Burst $burst
        }
    }

    It 'releases the lock when its limit passes, and the next run takes it' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $burst = Start-Burst -Name $script:lockName -Seconds 1
        (Stop-Burst $burst)[-1] | Should -BeExactly '[Enter-CatzcBurst] released the run lock: the 1 s limit passed'
        $run = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
        $run[0] | Should -BeExactly '[Invoke-CatzcCommand] passed: Get-Widget'
    }

    It 'runs its -Run steps inside the burst, then releases the lock' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $inside = "& '$script:entry' 'Get-Widget' -Importer '$script:importer' -LockName '$script:lockName' -InBurst"
        $burst = [powershell]::Create().AddScript({
                param($Enter, $Name, $Steps)
                & $Enter -Seconds 5 -LockName $Name -LockSeconds 1 -Run $Steps
                "exit $LASTEXITCODE"
            }).AddArgument($script:enter).AddArgument($script:lockName).AddArgument(@($inside, "'second'"))
        try {
            @($burst.Invoke()) | Should -Be @(
                '[Enter-CatzcBurst] holding the run lock for up to 5 s; running 2 -Run steps'
                '[Invoke-CatzcCommand] passed: Get-Widget'
                '[Invoke-CatzcCommand] 1 of 1 passed'
                'second'
                '[Enter-CatzcBurst] released the run lock: the 2 -Run steps passed'
                'exit 0'
            )
        }
        finally {
            $burst.Dispose()
        }
        # The lock is free again and no burst is left: the next plain run takes it at once.
        $run = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
        $run[0] | Should -BeExactly '[Invoke-CatzcCommand] passed: Get-Widget'
        { & $script:exit -LockName $script:lockName } | Should -Throw '*no burst holds*'
    }

    It 'leaves the lock''s inherit variable absent, not empty, after the burst when it was unset before' {
        . (Join-Path $PSScriptRoot '../assets/Wait-CatzcRunLock.ps1')
        $inherit = Get-CatzcRunLockInheritName -LockName $script:lockName
        Remove-Item -LiteralPath "Env:$inherit" -ErrorAction Ignore
        $burst = [powershell]::Create().AddScript({
                param($Enter, $Name)
                & $Enter -Seconds 5 -LockName $Name -LockSeconds 1 -Run @("'widget'")
            }).AddArgument($script:enter).AddArgument($script:lockName)
        try {
            $null = $burst.Invoke()
        }
        finally {
            $burst.Dispose()
        }
        Test-Path -LiteralPath "Env:$inherit" | Should -BeFalse
    }

    It 'stops at a failing -Run step, runs none after it, releases the lock and exits 1: <case>' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' -ForEach @(
        @{ case = 'a throw'; Step = "throw 'broken gadget'"; Reason = 'broken gadget' }
        @{ case = 'a non-zero exit code'; Step = '$global:LASTEXITCODE = 3'; Reason = 'exit code 3' }
    ) {
        $burst = [powershell]::Create().AddScript({
                param($Enter, $Name, $Steps)
                & $Enter -Seconds 5 -LockName $Name -LockSeconds 1 -Run $Steps
                "exit $LASTEXITCODE"
            }).AddArgument($script:enter).AddArgument($script:lockName).AddArgument(@("'first'", $Step, "'never'"))
        try {
            @($burst.Invoke()) | Should -Be @(
                '[Enter-CatzcBurst] holding the run lock for up to 5 s; running 3 -Run steps'
                'first'
                "[Enter-CatzcBurst] released the run lock: step 2 of 3 failed: $Reason"
                'exit 1'
            )
        }
        finally {
            $burst.Dispose()
        }
        $run = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
        $run[0] | Should -BeExactly '[Invoke-CatzcCommand] passed: Get-Widget'
    }

    It 'stops with run lock busy, starting no burst, when another run keeps the lock past its wait' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $other = Start-LockHolder -Name $script:lockName -Milliseconds 2500
        try {
            $other.Taken | Should -BeTrue
            $lines = @(& $script:enter -Seconds 1 -LockName $script:lockName -LockSeconds 1)
            $LASTEXITCODE | Should -Be 1
            $lines | Should -Be @(
                '[Enter-CatzcBurst] waiting for the run lock: another run holds it (up to 1 s)'
                '[Enter-CatzcBurst] run lock busy: another run held it for 1 s, so no burst started'
            )
        }
        finally {
            $other.Shell.EndInvoke($other.Handle)
            $other.Shell.Dispose()
        }
    }
}

Describe 'Enter-CatzcBurst — in a child pwsh process' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:enter = Join-Path $PSScriptRoot '../assets/Enter-CatzcBurst.ps1'
        $script:entry = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        $script:importer = Join-Path $TestDrive 'widget-importer.ps1'
        [System.IO.File]::WriteAllText($script:importer,
            "function Get-Widget { 'widget' }`nfunction Write-Message { param([AllowEmptyString()] [string] `$Message, [switch] `$NoHeader) Write-Information `$Message -InformationAction Continue }`n")
    }

    BeforeEach {
        # Each test takes a lock of its own, so a real run or burst on the machine never touches it.
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
    }

    It 'lets a -Run step in a child process run its checks under the burst' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $child = "pwsh -NoProfile -File '$script:entry' -InBurst -LockName '$script:lockName' -Importer '$script:importer' Get-Widget"
        $lines = @(& $script:enter -Seconds 30 -LockName $script:lockName -LockSeconds 1 $child)
        $LASTEXITCODE | Should -Be 0
        $lines | Should -Contain '[Invoke-CatzcCommand] passed: Get-Widget'
        $lines[-1] | Should -BeExactly '[Enter-CatzcBurst] released the run lock: the 1 -Run steps passed'
    }

    It 'lets a run a -Run step starts without -InBurst, such as a writer''s stamp call, run under the burst''s hold' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $child = "pwsh -NoProfile -File '$script:entry' -LockName '$script:lockName' -LockSeconds 1 -BudgetSeconds 5 -Importer '$script:importer' Get-Widget"
        $lines = @(& $script:enter -Seconds 30 -LockName $script:lockName -LockSeconds 1 $child)
        $LASTEXITCODE | Should -Be 0
        $lines | Should -Contain '[Invoke-CatzcCommand] passed: Get-Widget'
        $lines[-1] | Should -BeExactly '[Enter-CatzcBurst] released the run lock: the 1 -Run steps passed'
    }

    It 'binds each step given through pwsh -File as its own step, never as the lock''s name' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $lines = @(& pwsh -NoProfile -File $script:enter -Seconds 30 -LockName $script:lockName -LockSeconds 1 "'one'" "'two'")
        $LASTEXITCODE | Should -Be 0
        $lines | Should -Be @(
            '[Enter-CatzcBurst] holding the run lock for up to 30 s; running 2 -Run steps'
            'one'
            'two'
            '[Enter-CatzcBurst] released the run lock: the 2 -Run steps passed'
        )
    }
}
