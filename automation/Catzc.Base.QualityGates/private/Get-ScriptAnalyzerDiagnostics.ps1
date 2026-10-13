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
      - Each shard imports the vendored analyzer from the loaded code root (Get-CatzcModulesRoot/.vendor).
      - Shards run from the repo root (Push-Location/Pop-Location) so the settings' relative CustomRulePath
        entries resolve (ADR working-directory-mechanics, rule
        [ADR-AUTO-PSPWD#2](/docs/adr/automation/powershell/working-directory-mechanics.md#rule-adr-auto-pspwd2)/[ADR-AUTO-PSPWD#3](/docs/adr/automation/powershell/working-directory-mechanics.md#rule-adr-auto-pspwd3)).

    A dot is printed per interval while shards run so the run never looks hung — a progress bar is banned
    (ADR console-output-matters, rule
    [ADR-AUTO-CONSOLE#8](/docs/adr/automation/powershell/console-output-matters.md#rule-adr-auto-console8)). The
    external Invoke-ScriptAnalyzer progress bar is suppressed
    inside the worker for the same reason.
.PARAMETER Path
    The files to analyze.
.PARAMETER SettingsPath
    Path to the PSScriptAnalyzerSettings.psd1 to apply.
.OUTPUTS
    The PSScriptAnalyzer diagnostic records (empty when there are no violations).
#>
function Get-ScriptAnalyzerDiagnostics {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The analyzer import runs inside each background Start-Job shard process, never in this session')]
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

    # The vendored analyzer ships inside the code tree, so it resolves from the code root
    # ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
    # The shards still run from the repository root: the settings' CustomRulePath entries are relative to it.
    $root = Get-RepositoryRoot
    $analyzerPath = Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer'

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
        # console-output-matters, rule
        # [ADR-AUTO-CONSOLE#8](/docs/adr/automation/powershell/console-output-matters.md#rule-adr-auto-console8)) and
        # reports shard progress with dots instead. Suppress the
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
            # fails loudly (ADR diagnostics-over-retry; we never retry,
            # [ADR-AUTO-RETRY#1](/docs/adr/automation/retry-as-last-resort.md#rule-adr-auto-retry1)).
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
    # rule [ADR-AUTO-CONSOLE#8](/docs/adr/automation/powershell/console-output-matters.md#rule-adr-auto-console8)). The
    # dots go through the writer chokepoint
    # ([ADR-AUTO-ANNOUNCE#1](/docs/adr/automation/powershell/announce-state-changes.md#rule-adr-auto-announce1)), so a
    # Pester run
    # silences them with everything else. $dotted tracks whether any dot was written so the closing newline only
    # fires when it is needed.
    $dotted = $false
    try {
        # Poll for shard completion so the user sees the run is alive rather than a silent wait.
        while ($true) {
            $completed = @($jobs | Where-Object { $_.State -in 'Completed', 'Failed', 'Stopped' }).Count
            if ($completed -eq $shardCount) {
                break
            }
            Write-Message '.' -NoHeader -NoNewline
            $dotted = $true
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
            Write-Message '' -NoHeader   # newline to close the dot line
        }
        $jobs | Remove-Job -Force
    }
}
