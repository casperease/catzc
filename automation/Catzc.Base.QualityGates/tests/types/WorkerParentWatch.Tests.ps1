Describe 'WorkerParentWatch' -Tag 'logic' {
    Context 'liveness check' -Tag 'L0' {
        It 'reports this process alive at its own start time' {
            $ticks = [Catzc.Base.QualityGates.WorkerParentWatch]::CurrentStartTicks()
            [Catzc.Base.QualityGates.WorkerParentWatch]::IsAlive($PID, $ticks) | Should -BeTrue
        }

        It 'reports a live PID with a different start time as gone (PID reuse)' {
            $ticks = [Catzc.Base.QualityGates.WorkerParentWatch]::CurrentStartTicks()
            [Catzc.Base.QualityGates.WorkerParentWatch]::IsAlive($PID, $ticks - [TimeSpan]::FromMinutes(5).Ticks) | Should -BeFalse
        }

        It 'reports a PID with no process as gone' {
            [Catzc.Base.QualityGates.WorkerParentWatch]::IsAlive([int]::MaxValue, 0) | Should -BeFalse
        }
    }

    Context 'starting a watch' -Tag 'L0' {
        BeforeAll {
            # Process-scope only, snapshot and restore (ADR-AUTO-PSENV:4): under the harness these hold the real
            # parent, and only the absent/malformed cases run here — a watch that starts in THIS process would
            # watch whatever the variables name.
            $script:savedPid = $env:CATZC_TEST_PARENT_PID
            $script:savedStart = $env:CATZC_TEST_PARENT_START
        }
        AfterAll {
            $env:CATZC_TEST_PARENT_PID = $script:savedPid
            $env:CATZC_TEST_PARENT_START = $script:savedStart
        }

        It 'rejects an interval below 1' {
            { [Catzc.Base.QualityGates.WorkerParentWatch]::Start(0) } | Should -Throw -ExpectedMessage '*intervalMilliseconds*'
        }

        It 'watches nothing when the parent variables are absent' {
            $env:CATZC_TEST_PARENT_PID = $null
            $env:CATZC_TEST_PARENT_START = $null
            [Catzc.Base.QualityGates.WorkerParentWatch]::Start(1000) | Should -BeFalse
        }

        It 'watches nothing when the parent variables are malformed' {
            $env:CATZC_TEST_PARENT_PID = 'widget'
            $env:CATZC_TEST_PARENT_START = '42'
            [Catzc.Base.QualityGates.WorkerParentWatch]::Start(1000) | Should -BeFalse
        }
    }

    # greedy: starts real pwsh processes of its own (see the test-automation ADR's greedy tag).
    Context 'a real worker whose parent dies' -Tag 'L2', 'greedy' {
        BeforeAll {
            $script:started = [System.Collections.Generic.List[System.Diagnostics.Process]]::new()
            $script:workRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-parent-watch-' +[guid]::NewGuid().ToString('N'))
            [System.IO.Directory]::CreateDirectory($script:workRoot) | Out-Null

            function script:Start-Pwsh {
                param([string] $ScriptPath, [hashtable] $Environment = @{})
                $psi = [System.Diagnostics.ProcessStartInfo]::new('pwsh')
                $psi.UseShellExecute = $false
                $psi.CreateNoWindow = $true
                $psi.ArgumentList.Add('-NoProfile')
                $psi.ArgumentList.Add('-File')
                $psi.ArgumentList.Add($ScriptPath)
                foreach ($key in $Environment.Keys) {
                    $psi.Environment[$key] = $Environment[$key]
                }
                $process = [System.Diagnostics.Process]::Start($psi)
                $script:started.Add($process)
                $process
            }
        }
        AfterAll {
            foreach ($process in $script:started) {
                if (-not $process.HasExited) {
                    $process.Kill($true)
                }
                $process.Dispose()
            }
            Remove-Item -LiteralPath $script:workRoot -Recurse -Force -ErrorAction SilentlyContinue
        }

        It 'kills itself once its parent is gone' {
            $parentScript = Join-Path $script:workRoot 'widget-parent.ps1'
            [System.IO.File]::WriteAllText($parentScript, 'Start-Sleep -Seconds 120')
            $parent = Start-Pwsh $parentScript
            $parentTicks = $parent.StartTime.ToUniversalTime().Ticks

            # The worker loads the same compiled types this session has, starts the watch, signals, then waits.
            $marker = Join-Path $script:workRoot 'widget-watching.txt'
            $typesPath = [Catzc.Base.QualityGates.WorkerParentWatch].Assembly.Location
            $workerScript = Join-Path $script:workRoot 'widget-worker.ps1'
            [System.IO.File]::WriteAllText($workerScript, @"
Add-Type -Path '$($typesPath -replace "'", "''")'
if (-not [Catzc.Base.QualityGates.WorkerParentWatch]::Start(100)) { exit 7 }
[System.IO.File]::WriteAllText('$($marker -replace "'", "''")', 'watching')
Start-Sleep -Seconds 120
"@)
            $worker = Start-Pwsh $workerScript @{
                CATZC_TEST_PARENT_PID   = "$($parent.Id)"
                CATZC_TEST_PARENT_START = "$parentTicks"
            }

            $deadline = [DateTime]::UtcNow.AddSeconds(30)
            while (-not [System.IO.File]::Exists($marker) -and -not $worker.HasExited -and [DateTime]::UtcNow -lt $deadline) {
                Start-Sleep -Milliseconds 100
            }
            [System.IO.File]::Exists($marker) | Should -BeTrue -Because 'the worker must start its watch before the parent is killed'
            $worker.HasExited | Should -BeFalse -Because 'a live parent keeps the worker running'

            $parent.Kill()
            $worker.WaitForExit(10000) | Should -BeTrue -Because 'the worker must end itself within a few watch intervals of its parent dying'
        }
    }
}
