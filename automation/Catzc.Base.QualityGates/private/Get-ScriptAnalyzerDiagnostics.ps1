<#
.SYNOPSIS
    Runs PSScriptAnalyzer over a file list, sharded across background processes, returning diagnostics.
.DESCRIPTION
    The analysis engine behind Test-ScriptAnalyzer. A single serial Invoke-ScriptAnalyzer pass over the whole
    module tree takes ~90s and prints nothing until it finishes (it looks hung). This shards the file list
    across background pwsh PROCESSES — the same approach, and for the same reasons, as the L2 'PSScriptAnalyzer'
    test (automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1):

      - PSScriptAnalyzer's Helper.Initialize is not thread-safe, so ForEach-Object -Parallel (shared runspaces)
        races and throws. Separate processes are fully isolated.
      - Each shard imports the analyzer once and pipes its whole file list through a SINGLE
        Invoke-ScriptAnalyzer call, so the ~3s per-process setup is paid once per shard, not per file.
      - Shards run from the repo root (Push-Location/Pop-Location) so the settings' relative CustomRulePath
        entries resolve (ADR working-directory-mechanics, rule ADR-PSPWD:2/ADR-PSPWD:3).

    A dot is printed per interval while shards run so the run never looks hung — a progress bar is banned
    (ADR console-output-matters, rule ADR-CONSOLE:8). The external Invoke-ScriptAnalyzer progress bar is suppressed
    inside the worker for the same reason.
.PARAMETER Path
    The files to analyze.
.PARAMETER SettingsPath
    Path to the PSScriptAnalyzerSettings.psd1 to apply.
.OUTPUTS
    The PSScriptAnalyzer diagnostic records (empty when there are no violations).
#>
function Get-ScriptAnalyzerDiagnostics {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress the dot output during test runs; Write-Host bypasses the information stream so the writer chokepoint guard cannot silence it — the same global guard is required here, and global is needed to cross module session-state boundaries')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'ADR console-output-matters rule ADR-CONSOLE:8 prescribes Write-Host ''.'' -NoNewline for per-interval progress dots — the information stream cannot emit an inline (no-newline) dot, so Write-Host is the sanctioned tool for exactly this case')]
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $SettingsPath
    )

    # Drop any null/empty entries; an empty list means nothing to analyze (no shards spawned).
    $files = @($Path | Where-Object { $_ })
    if ($files.Count -eq 0) {
        return @()
    }

    $root = Get-RepositoryRoot
    $analyzerPath = Join-Path $root 'automation/.vendor/PSScriptAnalyzer'

    # Shard count tracks CPU but is capped so we don't spawn more process setup than the work can amortize,
    # and never exceeds the file count.
    $shardCount = [Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10))
    $shardCount = [Math]::Min($shardCount, $files.Count)

    $shards = @{}
    for ($i = 0; $i -lt $shardCount; $i++) {
        $shards[$i] = [System.Collections.Generic.List[string]]::new()
    }
    # Round-robin spreads the heavy modules across shards.
    for ($i = 0; $i -lt $files.Count; $i++) {
        $shards[$i % $shardCount].Add($files[$i])
    }

    $worker = {
        param($shardFiles, $root, $analyzer, $settings)
        Import-Module $analyzer -Force

        Push-Location $root
        # Invoke-ScriptAnalyzer draws its own Write-Progress bar; this repo bans progress bars (ADR
        # console-output-matters, rule ADR-CONSOLE:8) and reports shard progress with dots instead. Suppress the
        # external bar for the duration of the call and restore the preference in finally.
        $savedProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        try {
            # Capture non-terminating analyzer errors (-ErrorAction SilentlyContinue + -ErrorVariable) and
            # surface any as a shard failure, rather than letting a shard silently drop its files' diagnostics.
            # This used to special-case an intermittent NullReferenceException and tell the user to re-run; that
            # flake was root-caused to the built-in PSReservedCmdletChar rule dereferencing PSScriptAnalyzer's
            # thread-unsafe helper runspace under concurrent load, and eliminated by excluding that rule in
            # PSScriptAnalyzerSettings.psd1. So there is no transient case to tolerate — any error is real and
            # fails loudly (ADR diagnostics-over-retry; we never retry, ADR-RETRY:1).
            $err = $null
            $diagnostics = $shardFiles | Invoke-ScriptAnalyzer -Settings $settings -ErrorVariable err -ErrorAction SilentlyContinue
            if ($err) {
                throw "PSScriptAnalyzer error analysing this shard: $($err[0].Exception.Message)"
            }
            $diagnostics
        }
        finally {
            $ProgressPreference = $savedProgress
            Pop-Location
        }
    }

    $jobs = for ($i = 0; $i -lt $shardCount; $i++) {
        Start-Job -ScriptBlock $worker -ArgumentList @($shards[$i], $root, $analyzerPath, $SettingsPath)
    }

    # Print a dot per interval while shards run, rather than a progress bar (ADR console-output-matters,
    # rule ADR-CONSOLE:8). Suppressed during a Pester run via the same $global:__PesterRunning chokepoint guard the
    # writers use (Write-Host bypasses the information stream, so it needs its own guard to stay out of test
    # output). $dotted tracks whether any dot was printed so the closing newline only fires when it is needed.
    $showProgress = -not $global:__PesterRunning
    $dotted = $false
    try {
        # Poll for shard completion so the user sees the run is alive rather than a silent wait.
        while ($true) {
            $completed = @($jobs | Where-Object { $_.State -in 'Completed', 'Failed', 'Stopped' }).Count
            if ($completed -eq $shardCount) {
                break
            }
            if ($showProgress) {
                Write-Host '.' -NoNewline
                $dotted = $true
            }
            Start-Sleep -Seconds 1
        }

        $allDiagnostics = @()
        foreach ($job in $jobs) {
            # A silently-failed shard would drop its files' diagnostics and let violations pass unnoticed —
            # fail loudly instead.
            if ($job.State -ne 'Completed') {
                $reason = ($job.ChildJobs.JobStateInfo.Reason.Message) -join '; '
                throw "PSScriptAnalyzer shard job $($job.Id) ended in state '$($job.State)': $reason"
            }
            $allDiagnostics += Receive-Job -Job $job -ErrorAction Stop
        }
        $allDiagnostics
    }
    finally {
        if ($dotted) {
            Write-Host ''   # newline to close the dot line
        }
        $jobs | Remove-Job -Force
    }
}
