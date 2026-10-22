<#
---
catzc:
  immutable:
    with_body_sha: f3e7233fc31e
  edges:
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

Describe 'Enter-CatzcBurst' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:enter = Join-Path $PSScriptRoot '../assets/Enter-CatzcBurst.ps1'
        $script:exit = Join-Path $PSScriptRoot '../assets/Exit-CatzcBurst.ps1'
        $script:entry = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        $script:importer = Join-Path $TestDrive 'importer.ps1'
        [System.IO.File]::WriteAllText($script:importer, "function Get-Widget { 'widget' }`n")
        # Runs a burst on another thread, the way a session's background call would, and waits until it holds the lock.
        function script:Start-Burst {
            param([string] $Name, [int] $Seconds)
            $shell = [powershell]::Create().AddScript({
                    param($Enter, $Name, $Seconds)
                    & $Enter -Seconds $Seconds -LockName $Name -LockSeconds 1
                }).AddArgument($script:enter).AddArgument($Name).AddArgument($Seconds)
            $handle = $shell.BeginInvoke()
            $deadline = [datetime]::UtcNow.AddSeconds(2)
            $event = $null
            while (-not [System.Threading.EventWaitHandle]::TryOpenExisting("$Name-burst", [ref] $event) -and [datetime]::UtcNow -lt $deadline) {
                Start-Sleep -Milliseconds 10
            }
            if ($event) {
                $event.Dispose()
            }
            [pscustomobject]@{ Shell = $shell; Handle = $handle }
        }
        function script:Stop-Burst {
            param($Burst)
            $lines = @($Burst.Shell.EndInvoke($Burst.Handle))
            $Burst.Shell.Dispose()
            $lines
        }
    }

    BeforeEach {
        # Each test takes a lock of its own, so a real run or burst on the machine never touches it.
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
    }

    It 'holds the lock against every other run until Exit-CatzcBurst ends the burst' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $burst = Start-Burst -Name $script:lockName -Seconds 5
        $run = @(& $script:entry 'Get-Widget' -Importer $script:importer -LockName $script:lockName -LockSeconds 1)
        $LASTEXITCODE | Should -Be 1
        $run[-1] | Should -BeExactly '[Invoke-CatzcCommand] run lock busy: another run held it for 1 s, so nothing ran'
        & $script:exit -LockName $script:lockName | Should -BeExactly "[Exit-CatzcBurst] ended the burst on $script:lockName"
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

    It 'stops with run lock busy, starting no burst, when another run keeps the lock past its wait' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $other = Start-Burst -Name $script:lockName -Seconds 5
        try {
            $lines = @(& $script:enter -Seconds 1 -LockName $script:lockName -LockSeconds 1)
            $LASTEXITCODE | Should -Be 1
            $lines | Should -Be @(
                '[Enter-CatzcBurst] waiting for the run lock: another run holds it (up to 1 s)'
                '[Enter-CatzcBurst] run lock busy: another run held it for 1 s, so no burst started'
            )
        }
        finally {
            & $script:exit -LockName $script:lockName
            $null = Stop-Burst $other
        }
    }
}
