<#
.SYNOPSIS
    Runs PSScriptAnalyzer over a file list, sharded across background processes, returning diagnostics.
.DESCRIPTION
    The analysis engine behind Test-ScriptAnalyzer.
    [ADR-PWSH-PWD#2](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd2),
    [ADR-PWSH-PWD#3](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd3),
    [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8),
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
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

    # The vendored analyzer ships inside the code tree, so it resolves from the code root.
    # [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment2)
    $root = Get-RepositoryRoot

    # The result cache: a file the analyzer last found clean, whose bytes and analyzer inputs...
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

    # Shard count tracks CPU but is capped so we don't spawn more process setup than the work can amortize, and never...
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
        # Invoke-ScriptAnalyzer draws its own Write-Progress bar; this repo bans progress bars (ADR...
        # [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)
        # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment5)
        $savedProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        try {
            # Capture non-terminating analyzer errors (-ErrorAction SilentlyContinue + -ErrorVariable) and surface...
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

    # Print a dot per interval while shards run, rather than a progress bar (ADR console-output-matters, rule ).
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
            # A silently-failed shard would drop its files' diagnostics and let violations pass unnoticed — fail...
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
