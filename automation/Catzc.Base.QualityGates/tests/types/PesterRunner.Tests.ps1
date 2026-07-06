# cspell:ignore nexit  -- the escape-sequence artifact in the "`nexit" fixture strings
Describe 'PesterRunner' -Tag 'logic' {
    Context 'argument validation' -Tag 'L0' {
        It 'rejects an empty script list' {
            { [Catzc.Base.QualityGates.PesterRunner]::Run(@(), @(), 1, $null, 60, $true) } |
                Should -Throw -ExpectedMessage '*at least one script*'
        }

        It 'rejects a label list of a different length' {
            { [Catzc.Base.QualityGates.PesterRunner]::Run(@('a.ps1', 'b.ps1'), @('only-one'), 1, $null, 60, $true) } |
                Should -Throw -ExpectedMessage '*one entry per runner script*'
        }

        It 'rejects maxParallel below 1' {
            { [Catzc.Base.QualityGates.PesterRunner]::Run(@('a.ps1'), @('a'), 0, $null, 60, $true) } |
                Should -Throw -ExpectedMessage '*maxParallel*'
        }

        It 'rejects timeoutSeconds below 1' {
            { [Catzc.Base.QualityGates.PesterRunner]::Run(@('a.ps1'), @('a'), 1, $null, 0, $true) } |
                Should -Throw -ExpectedMessage '*timeoutSeconds*'
        }
    }

    # serial: runs real pwsh worker pools of its own — stacked on the parallel pool that
    # oversubscribes the box (see the test-automation ADR's serial tag).
    Context 'execution (real pwsh workers)' -Tag 'L2', 'serial' {
        It 'captures stdout, stderr, exit code, and a handed-off env var per worker, in submission order' {
            # One pool run covers capture, submission-order results, env hand-off, and exit codes.
            $alpha = Join-Path $TestDrive 'alpha.ps1'
            $bravo = Join-Path $TestDrive 'bravo.ps1'
            $charlie = Join-Path $TestDrive 'charlie.ps1'
            [System.IO.File]::WriteAllText($alpha, "Write-Output 'alpha-out'")
            [System.IO.File]::WriteAllText($bravo, "[Console]::Error.Write('bravo-err')`nexit 3")
            [System.IO.File]::WriteAllText($charlie, 'Write-Output "env=$env:CATZC_TEST_VALUE"')

            $environment = @{ CATZC_TEST_VALUE = 'hand-off' }
            $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                @($alpha, $bravo, $charlie), @('alpha', 'bravo', 'charlie'), 3, $environment, 120, $true)

            $runner.Results.Count | Should -Be 3
            $runner.Results[0].Label | Should -Be 'alpha'
            $runner.Results[0].ScriptPath | Should -Be $alpha
            $runner.Results[0].Stdout | Should -Match 'alpha-out'
            $runner.Results[0].ExitCode | Should -Be 0
            $runner.Results[1].Stderr | Should -Match 'bravo-err'
            $runner.Results[1].ExitCode | Should -Be 3
            $runner.Results[2].Stdout | Should -Match 'env=hand-off'

            # Wall-clock timing per worker: started at/after the pool's start, ran for a measured duration
            # (reap-loop granularity means small, never negative, values).
            foreach ($result in $runner.Results) {
                $result.StartOffsetMs | Should -BeGreaterOrEqual 0
                $result.DurationMs | Should -BeGreaterThan 0
            }
        }

        It 'runs workers concurrently up to maxParallel' {
            # Each worker drops its own marker, then waits for the OTHER's marker: only a genuinely
            # concurrent pool lets both exit 0 — a serial pool would spin out and exit 9. No timing
            # assertions, so the proof cannot flake on a slow machine.
            $firstMarker = Join-Path $TestDrive 'first.marker'
            $secondMarker = Join-Path $TestDrive 'second.marker'
            $first = Join-Path $TestDrive 'first.ps1'
            $second = Join-Path $TestDrive 'second.ps1'

            foreach ($pair in @(@($first, $firstMarker, $secondMarker), @($second, $secondMarker, $firstMarker))) {
                $scriptPath, $mine, $other = $pair
                $content = @"
[System.IO.File]::WriteAllText('$mine', 'here')
`$deadline = [DateTime]::UtcNow.AddSeconds(30)
while (-not (Test-Path '$other')) {
    if ([DateTime]::UtcNow -gt `$deadline) { exit 9 }
    Start-Sleep -Milliseconds 100
}
exit 0
"@
                [System.IO.File]::WriteAllText($scriptPath, $content)
            }

            $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                @($first, $second), @('first', 'second'), 2, $null, 120, $true)

            $runner.Results[0].ExitCode | Should -Be 0
            $runner.Results[1].ExitCode | Should -Be 0
        }

        It 'starts workers strictly in submission order when maxParallel is 1' {
            $leadEnd = Join-Path $TestDrive 'lead-end.txt'
            $tailStart = Join-Path $TestDrive 'tail-start.txt'
            $lead = Join-Path $TestDrive 'lead.ps1'
            $tail = Join-Path $TestDrive 'tail.ps1'
            [System.IO.File]::WriteAllText($lead, "[System.IO.File]::WriteAllText('$leadEnd', [DateTimeOffset]::UtcNow.Ticks.ToString())")
            [System.IO.File]::WriteAllText($tail, "[System.IO.File]::WriteAllText('$tailStart', [DateTimeOffset]::UtcNow.Ticks.ToString())")

            $null = [Catzc.Base.QualityGates.PesterRunner]::Run(
                @($lead, $tail), @('lead', 'tail'), 1, $null, 120, $true)

            # With one slot, the second worker starts only after the first has fully exited.
            [long][System.IO.File]::ReadAllText($tailStart) |
                Should -BeGreaterOrEqual ([long][System.IO.File]::ReadAllText($leadEnd))
        }

        It 'replays a buffered worker after the live worker, preserving submission order on the console' {
            # Worker 0 is live but slow; worker 1 finishes first and must buffer. The pooled console
            # output still reads in submission order. Console.Out is redirected to observe it —
            # SetOut redirection survives the runner's OutputEncoding save/restore.
            $slow = Join-Path $TestDrive 'slow.ps1'
            $fast = Join-Path $TestDrive 'fast.ps1'
            [System.IO.File]::WriteAllText($slow, "Start-Sleep -Milliseconds 1500`nWrite-Output 'ALPHA-MARK'")
            [System.IO.File]::WriteAllText($fast, "Write-Output 'BRAVO-MARK'")

            $writer = [System.IO.StringWriter]::new()
            $originalOut = [Console]::Out
            try {
                [Console]::SetOut($writer)
                $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                    @($slow, $fast), @('slow', 'fast'), 2, $null, 120, $false)
            }
            finally {
                [Console]::SetOut($originalOut)
            }

            $console = $writer.ToString()
            $console | Should -Match 'ALPHA-MARK'
            $console | Should -Match 'BRAVO-MARK'
            $console.IndexOf('ALPHA-MARK') | Should -BeLessThan $console.IndexOf('BRAVO-MARK')

            # Capture is independent of the pooling: the buffered worker's result is complete.
            $runner.Results[1].Stdout | Should -Match 'BRAVO-MARK'
        }

        It 'kills the pool and throws on timeout' {
            $stuck = Join-Path $TestDrive 'stuck.ps1'
            [System.IO.File]::WriteAllText($stuck, 'Start-Sleep -Seconds 60')

            { [Catzc.Base.QualityGates.PesterRunner]::Run(@($stuck), @('stuck'), 1, $null, 2, $true) } |
                Should -Throw -ExpectedMessage '*timed out after 2s*'
        }
    }
}
