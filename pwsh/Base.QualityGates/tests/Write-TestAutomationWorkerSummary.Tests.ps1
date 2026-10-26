Describe 'Write-TestAutomationWorkerSummary' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Write-Header -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Footer -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { param($Message) $script:lines.Add("$Message") }

        $script:summaries = @(
            [pscustomobject]@{ QueueNumber = 1; Label = 'shard-0'; Files = 10; Tests = 40; Passed = 39
                Failed = 0; Skipped = 1; StartSeconds = 5.0; DurationSeconds = 60.0
            }
            [pscustomobject]@{ QueueNumber = 2; Label = 'shard-1'; Files = 9; Tests = 35; Passed = 30
                Failed = 5; Skipped = 0; StartSeconds = 0.1; DurationSeconds = 55.0
            }
            [pscustomobject]@{ QueueNumber = 3; Label = 'shard-2 (serial)'; Files = 4; Tests = 12; Passed = 12
                Failed = 0; Skipped = 0; StartSeconds = 62.0; DurationSeconds = 20.0
            }
        )
    }

    BeforeEach {
        $script:lines = [System.Collections.Generic.List[string]]::new()
    }

    It 'writes one row per worker, ordered by wall-clock start, with the queue number leading' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Summaries = $script:summaries } {
            param($Summaries)
            Write-TestAutomationWorkerSummary -WorkerSummaries $Summaries -DurationSeconds 82.5
        }

        $workerRows = @($script:lines | Where-Object { $_ -match 'shard-' })
        $workerRows | Should -HaveCount 3
        # shard-1 started first (0.1s) despite queue number 2 — start-time order, queue number visible.
        $workerRows[0] | Should -Match '^\s*2\s+shard-1'
        $workerRows[1] | Should -Match '^\s*1\s+shard-0'
        $workerRows[2] | Should -Match '^\s*3\s+shard-2 \(serial\)'
        $workerRows[2] | Should -Match '62[.,]0s'
    }

    It 'sums the tallies and worker durations, and names the run wall clock separately' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Summaries = $script:summaries } {
            param($Summaries)
            Write-TestAutomationWorkerSummary -WorkerSummaries $Summaries -DurationSeconds 82.5
        }

        $summation = @($script:lines | Where-Object { $_ -match '3 worker\(s\)' })
        $summation | Should -HaveCount 1
        $summation[0] | Should -Match '\b23\b'      # files: 10 + 9 + 4
        $summation[0] | Should -Match '\b87\b'      # tests: 40 + 35 + 12
        $summation[0] | Should -Match '135[.,]0s'   # worker durations: 60 + 55 + 20
        @($script:lines | Where-Object { $_ -match 'Wall clock: 82[.,]5s' }) | Should -HaveCount 1
    }

    It 'writes nothing at all for an empty summary set' {
        InModuleScope Catzc.Base.QualityGates {
            Write-TestAutomationWorkerSummary -WorkerSummaries @() -DurationSeconds 0
        }
        $script:lines | Should -HaveCount 0
        Should -Invoke Write-Header -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }
}
