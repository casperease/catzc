<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-CONSOLE#8
      - ADR-AUTO-RETRY#1
      - ADR-PWSH-ANNOUNCE#1
      - ADR-PWSH-PWD#2
      - ADR-PWSH-PWD#3
  config:
    synopsis: Runs PSScriptAnalyzer over a file list, sharded across background processes, returning diagnostics.
    description: |-
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
          [ADR-PWSH-PWD#2](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd2)/[ADR-PWSH-PWD#3](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd3)).

      A dot is printed per interval while shards run so the run never looks hung — a progress bar is banned
      (ADR console-output-matters, rule
      [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)). The
      external Invoke-ScriptAnalyzer progress bar is suppressed
      inside the worker for the same reason.
      A result cache under out/cache/ skips every file the analyzer last found clean whose bytes and analyzer inputs
      (Get-ScriptAnalyzerInputs: the settings, the custom rules, the vendored analyzer, the spelling oracle's word lists)
      are unchanged since ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)); only clean files
      are recorded, so a cached run reports exactly the diagnostics a full run would. A pipeline starts without the cache.
    parameters:
      Path: The files to analyze.
      SettingsPath: Path to the PSScriptAnalyzerSettings.psd1 to apply.
      NoCache: Analyze every file, ignoring the result cache (which is still refreshed).
    outputs: The PSScriptAnalyzer diagnostic records (empty when there are no violations).
---
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
    # [comment:9](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment9)
    $root = Get-RepositoryRoot

    # The result cache: a file the analyzer last found clean, whose bytes and analyzer inputs...
    # [comment:10](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment10)
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
    # [comment:11](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment11)
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
        # [comment:12](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment12)
        $savedProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        try {
            # Capture non-terminating analyzer errors (-ErrorAction SilentlyContinue + -ErrorVariable) and surface...
            # [comment:13](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment13)
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
    # [comment:14](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment14)
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
            # [comment:15](/docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md#comment15)
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
