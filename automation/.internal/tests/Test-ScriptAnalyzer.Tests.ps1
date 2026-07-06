# serial: the analysis shards across min(ProcessorCount - 1, 10) background pwsh processes of its own —
# stacked on the parallel worker pool that fan-out oversubscribes the machine (and inflates neighbouring
# tests' wall clock against the level time limits); in the serial phase it lands on an idle box instead.
Describe 'PSScriptAnalyzer' -Tag 'L2', 'integrity', 'serial' {
    BeforeAll {
        $repositoryRoot = $env:RepositoryRoot
        $automationRoot = Join-Path $repositoryRoot 'automation'
        $settingsPath = Join-Path $repositoryRoot 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
        $analyzerPath = Join-Path $automationRoot '.vendor/PSScriptAnalyzer'

        # Draw the exact files from the one shared selector (Get-AutomationSourceFiles), so this gate cannot
        # drift from Format-Automation / Test-ScriptAnalyzer (ADR-PSFORMAT:5). The selector covers module *.ps1
        # (root, private/), tests/**/*.Tests.ps1 recursively (so tests/types/ is included), the
        # .internal/.scriptanalyzer infrastructure folders (bootstrap, TestKit, custom analyzer rules, and
        # their tests), the root importer.ps1, and authored .psd1 config; .vendor, .compiled, and generated
        # manifests are excluded as build output. Sorted here for stable, reproducible shard assignment.
        $script:targetFiles = [System.Collections.Generic.List[string]]::new()
        foreach ($file in (& (Get-Module Catzc.Base.QualityGates) { Get-AutomationSourceFiles } | Sort-Object)) {
            $script:targetFiles.Add($file)
        }

        # PSScriptAnalyzer's Helper.Initialize is not thread-safe, so we cannot parallelize across
        # runspaces (ForEach-Object -Parallel) — it races and throws "same key … ForEach-Object".
        # Separate PROCESSES are fully isolated, so we shard the file list across background pwsh
        # jobs instead. Each job imports the analyzer once and pipes its whole shard through a single
        # Invoke-ScriptAnalyzer call (so the ~3s per-process setup is paid once per shard, not per
        # file). This turns a ~90s serial run into ~15s. Shard count tracks CPU but is capped so we
        # don't spawn more setup overhead than the work can amortize.
        $shardCount = [Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10))
        $shardCount = [Math]::Min($shardCount, [Math]::Max(1, $script:targetFiles.Count))

        $shards = @{}
        for ($i = 0; $i -lt $shardCount; $i++) {
            $shards[$i] = [System.Collections.Generic.List[string]]::new()
        }
        for ($i = 0; $i -lt $script:targetFiles.Count; $i++) {
            $shards[$i % $shardCount].Add($script:targetFiles[$i])
        }  # round-robin spreads the heavy modules across shards

        $worker = {
            param($shardFiles, $root, $analyzer, $settings)
            Import-Module $analyzer -Force

            # The settings' relative CustomRulePath entries resolve against the working directory. Set it
            # with Push-Location/Pop-Location in try/finally so $PWD is always restored — never a bare
            # Set-Location (ADR never-depend-on-pwd, rule ADR-NOPWD:2/ADR-NOPWD:3).
            Push-Location $root
            try {
                # Capture non-terminating analyzer errors and surface any as a shard failure — a silently
                # failed shard would drop its files' diagnostics and let violations pass. This used to
                # special-case an intermittent NullReferenceException and tell the user to re-run; that flake
                # was root-caused to the built-in PSReservedCmdletChar rule dereferencing PSScriptAnalyzer's
                # thread-unsafe helper runspace under concurrent load, and eliminated by excluding that rule in
                # PSScriptAnalyzerSettings.psd1. So any error now is real and fails loudly (ADR
                # diagnostics-over-retry; never retry in a test, ADR-RETRY:1).
                $err = $null
                $diagnostics = $shardFiles | Invoke-ScriptAnalyzer -Settings $settings -ErrorVariable err -ErrorAction SilentlyContinue
                if ($err) {
                    throw "PSScriptAnalyzer error analysing this shard: $($err[0].Exception.Message)"
                }
                $diagnostics
            }
            finally {
                Pop-Location
            }
        }

        $jobs = for ($i = 0; $i -lt $shardCount; $i++) {
            Start-Job -ScriptBlock $worker -ArgumentList @($shards[$i], $repositoryRoot, $analyzerPath, $settingsPath)
        }

        $null = $jobs | Wait-Job
        $allDiagnostics = @()
        foreach ($job in $jobs) {
            # A silently-failed shard would drop its files' diagnostics and let violations pass
            # unnoticed — fail loudly instead.
            if ($job.State -ne 'Completed') {
                $reason = ($job.ChildJobs.JobStateInfo.Reason.Message) -join '; '
                throw "PSScriptAnalyzer shard job $($job.Id) ended in state '$($job.State)': $reason"
            }
            $allDiagnostics += Receive-Job -Job $job -ErrorAction Stop
        }
        $jobs | Remove-Job

        # Index diagnostics as strings by file path — only files WITH violations get an entry.
        $script:diagnosticsByFile = @{}
        foreach ($d in $allDiagnostics) {
            if (-not $script:diagnosticsByFile.ContainsKey($d.ScriptPath)) {
                $script:diagnosticsByFile[$d.ScriptPath] = [System.Collections.Generic.List[string]]::new()
            }
            $script:diagnosticsByFile[$d.ScriptPath].Add("$($d.RuleName): $($d.Message) (line $($d.Line))")
        }
    }

    It 'analyzed the module file set (guards against a silent no-op)' {
        # The violation check below passes vacuously if nothing was analyzed, so prove the scan + shards ran.
        $script:targetFiles.Count | Should -BeGreaterThan 50
    }

    It 'has no PSScriptAnalyzer violations' {
        $offenders = foreach ($entry in ($script:diagnosticsByFile.GetEnumerator() | Sort-Object Key)) {
            "$([System.IO.Path]::GetFileName($entry.Key)):`n  " + ($entry.Value -join "`n  ")
        }
        $offenders | Should -BeNullOrEmpty -Because "PSScriptAnalyzer reported violations:`n$($offenders -join "`n")"
    }
}
