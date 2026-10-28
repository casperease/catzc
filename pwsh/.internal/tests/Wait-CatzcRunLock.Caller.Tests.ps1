BeforeAll {
    . (Join-Path $PSScriptRoot 'RunLock.Fixture.ps1')
}

Describe 'Wait-CatzcRunLock — with a real caller process' -Tag 'L2', 'logic' {
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
    }

    It 'never takes the lock once the caller that started it is gone, though the lock falls free after' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        # A stand-in caller the waiter answers to, killed while the waiter is queued behind a plain holder.
        $caller = Start-Process -FilePath (Get-Process -Id $PID).Path -ArgumentList '-NoProfile', '-Command', 'Start-Sleep -Seconds 30' -PassThru -WindowStyle Hidden
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 2000
        try {
            $holder.Taken | Should -BeTrue
            $shell = [powershell]::Create().AddScript({
                    param($Path, $Name, $ParentId)
                    . $Path
                    $taken = [ref] $null
                    $lines = @(Wait-CatzcRunLock -LockName $Name -LockSeconds 10 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $taken -ParentId $ParentId)
                    [pscustomobject]@{ Lines = $lines; Taken = $null -ne $taken.Value }
                    if ($taken.Value) {
                        Remove-CatzcRunLockHolder -LockName $Name
                        $taken.Value.ReleaseMutex()
                        $taken.Value.Dispose()
                    }
                }).AddArgument($script:waiter).AddArgument($script:lockName).AddArgument($caller.Id)
            $handle = $shell.BeginInvoke()
            Start-Sleep -Milliseconds 500
            Stop-Process -Id $caller.Id -Force
            $result = @($shell.EndInvoke($handle))[-1]
            $shell.Dispose()
            $result.Taken | Should -BeFalse
            $result.Lines[-1] |
                Should -Be "[Widget] run lock not taken: the caller that started this run (pid $($caller.Id)) is gone, so nothing ran"
        }
        finally {
            Stop-Process -Id $caller.Id -Force -ErrorAction Ignore
            Stop-LockHolder $holder
        }
    }

    It 'counts a live holder as gone once the caller that started it is gone, and stops waiting for it' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        $caller = Start-Process -FilePath (Get-Process -Id $PID).Path -ArgumentList '-NoProfile', '-Command', 'Start-Sleep -Seconds 30' -PassThru -WindowStyle Hidden
        $holder = Start-LockHolder -Name $script:lockName -Milliseconds 3000
        try {
            $holder.Taken | Should -BeTrue
            $path = Get-CatzcRunLockHolderPath -LockName $script:lockName
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
            $self = (Get-Process -Id $PID).StartTime.ToUniversalTime().Ticks
            $callerStart = $caller.StartTime.ToUniversalTime().Ticks
            [System.IO.File]::WriteAllText($path,
                "$PID|$self|$([datetime]::UtcNow.AddSeconds(120).Ticks)|$($caller.Id)|$callerStart|Get-Gadget")
            (Get-CatzcRunLockHolder -LockName $script:lockName).Holding | Should -Be 'Get-Gadget'
            Stop-Process -Id $caller.Id -Force
            $caller.WaitForExit(5000) | Should -BeTrue
            Get-CatzcRunLockHolder -LockName $script:lockName | Should -BeNullOrEmpty
            $timer = [System.Diagnostics.Stopwatch]::StartNew()
            $out = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 1 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $timer.Elapsed.TotalSeconds | Should -BeLessThan 2.5
            $out[-1] | Should -Be '[Widget] run lock busy: another run held it for 1 s, so nothing ran'
            $script:taken.Value | Should -BeNullOrEmpty
        }
        finally {
            Stop-Process -Id $caller.Id -Force -ErrorAction Ignore
            Stop-LockHolder $holder
        }
    }

    It 'takes the lock at once after an Invoke-CatzcCommand holder is stopped with its caller' -Tag 'ADR-AUTO-FAILFAST-BOUNDEVERYWAIT' {
        # A real run holds the lock under a stand-in caller; stopping the caller leaves the run with no one to serve.
        $importer = Join-Path $TestDrive 'widget-importer.ps1'
        [System.IO.File]::WriteAllText($importer, 'function Write-Message { param([string] $Message, [switch] $NoHeader) }')
        $callerScript = Join-Path $TestDrive 'widget-caller.ps1'
        [System.IO.File]::WriteAllText($callerScript, @'
param([string] $Run, [string] $Importer, [string] $LockName)
$info = [System.Diagnostics.ProcessStartInfo]::new((Get-Process -Id $PID).Path)
foreach ($argument in '-NoProfile', '-File', $Run, '-Importer', $Importer, '-LockName', $LockName, '-LockSeconds', '5', 'Start-Sleep -Seconds 30') {
    $info.ArgumentList.Add($argument)
}
$info.UseShellExecute = $false
$info.CreateNoWindow = $true
$null = [System.Diagnostics.Process]::Start($info)
Start-Sleep -Seconds 60
'@)
        $run = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        # Start-Process joins its arguments with spaces, so each path goes quoted.
        $arguments = "-NoProfile -File `"$callerScript`" -Run `"$run`" -Importer `"$importer`" -LockName `"$($script:lockName)`""
        $caller = Start-Process -FilePath (Get-Process -Id $PID).Path -ArgumentList $arguments -PassThru -WindowStyle Hidden
        $holder = $null
        try {
            $limit = [datetime]::UtcNow.AddSeconds(20)
            while ($null -eq $holder -and [datetime]::UtcNow -lt $limit) {
                Start-Sleep -Milliseconds 250
                $holder = Get-CatzcRunLockHolder -LockName $script:lockName
            }
            $holder.Holding | Should -Be 'Invoke-CatzcCommand Start-Sleep -Seconds 30'
            Stop-Process -Id $caller.Id -Force
            $caller.WaitForExit(5000) | Should -BeTrue
            $timer = [System.Diagnostics.Stopwatch]::StartNew()
            $null = @(Wait-CatzcRunLock -LockName $script:lockName -LockSeconds 5 -BudgetSeconds 60 -StaleSeconds 720 -Holding 'Get-Widget' -Caller 'Widget' -Busy 'nothing ran' -Lock $script:taken)
            $script:taken.Value | Should -Not -BeNullOrEmpty
            $timer.Elapsed.TotalSeconds | Should -BeLessThan 3
        }
        finally {
            Stop-Process -Id $caller.Id -Force -ErrorAction Ignore
            if ($holder) {
                Stop-Process -Id $holder.ProcessId -Force -ErrorAction Ignore
            }
        }
    }
}
