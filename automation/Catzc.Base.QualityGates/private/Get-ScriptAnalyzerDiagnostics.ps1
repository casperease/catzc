# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Runs PSScriptAnalyzer over a file list, sharded across background processes, returning diagnostics.
.DESCRIPTION
    Shards are separate processes, not runspaces, because the analyzer's helper initialization is not thread-safe.
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10),
    [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8),
    [ADR-PWSH-PWD#2](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd2),
    [ADR-PWSH-PWD#3](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment1)
.PARAMETER Path
    The files to analyze.
.PARAMETER SettingsPath
    Path to the PSScriptAnalyzerSettings.psd1 to apply.
.PARAMETER NoCache
    Analyze every file, ignoring the result cache (which is still refreshed).
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
        [string] $SettingsPath,

        [switch] $NoCache
    )

    # Drop any null/empty entries; an empty list means nothing to analyze (no shards spawned).
    $requested = @($Path | Where-Object { $_ })
    if ($requested.Count -eq 0) {
        return @()
    }

    # The shards still run from the repository root, because the settings' CustomRulePath entries are relative to it.
    # [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment2)
    $root = Get-RepositoryRoot

    # Only clean files are cached, so a cached run reports exactly the diagnostics a full run would.
    # [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment3)
    $fullRoot = [System.IO.Path]::GetFullPath($root)
    $stamp = Get-ContentStamp -Label 'script-analyzer' -File (Get-ScriptAnalyzerInputs -RepositoryRoot $fullRoot -SettingsPath $SettingsPath) -RepositoryRoot $fullRoot
    $cachePath = Join-Path (Get-OutputRoot) 'cache/script-analyzer.json'
    $cache = if ($NoCache) {
        @{}
    }
    else {
        Get-ResultCache -Path $cachePath
    }
    $split = Split-CachedFile -File $requested -Cache $cache -Stamp $stamp -RepositoryRoot $fullRoot
    $files = @($split.Pending)
    Write-Message "$($split.CachedCount) of $($requested.Count) file(s) unchanged since the analyzer last found them clean."
    if ($files.Count -eq 0) {
        return @()
    }
    $analyzerPath = Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer'

    # Capped at ten and at the file count, so no shard pays process setup the work cannot amortize.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment4)
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
        # The analyzer draws its own progress bar, which is banned here, so it is silenced and restored in finally.
        # [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)
        # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment5)
        $savedProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        try {
            # Every analyzer error is real, as the flaky rule is excluded in settings, so none is retried or tolerated.
            # [ADR-AUTO-RETRY#1](/docs/adr/automation/retry-as-last-resort.md#rule-adr-auto-retry1)
            # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment6)
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

    # The dots go through the writer chokepoint, so a Pester run silences them with everything else.
    # [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8),
    # [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment7)
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
            # A failed shard would silently drop its files' diagnostics and let violations pass, so fail loudly.
            # [comment:8](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment8)
            if ($job.State -ne 'Completed') {
                $reason = ($job.ChildJobs.JobStateInfo.Reason.Message) -join '; '
                throw "PSScriptAnalyzer shard job $($job.Id) ended in state '$($job.State)': $reason"
            }
            $allDiagnostics += Receive-Job -Job $job -ErrorAction Stop
        }

        # Record every analyzed file without a diagnostic as clean; a file with one is checked again next time.
        $flagged = @($allDiagnostics | Where-Object { $_.ScriptPath } | ForEach-Object { $_.ScriptPath })
        Update-ResultCache -Cache $cache -Key $split.Key -Checked $files -Flagged $flagged
        Save-ResultCache -Path $cachePath -Cache $cache

        $allDiagnostics
    }
    finally {
        if ($dotted) {
            Write-Message '' -NoHeader   # newline to close the dot line
        }
        $jobs | Remove-Job -Force
    }
}
