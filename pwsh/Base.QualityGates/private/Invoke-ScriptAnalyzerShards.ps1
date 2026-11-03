function Invoke-ScriptAnalyzerShards {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The analyzer import runs inside each background Start-Job shard process, never in this session')]
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [object[]] $Batch,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $CodeRoot,

        # Called as each shard ends with -Label, -File and -Diagnostic, so a caller records a shard's result before the last shard is in.
        [scriptblock] $OnShardComplete
    )

    # The vendored analyzer ships inside the code tree, so it resolves from the code root.
    $analyzerPath = Join-Path $CodeRoot '.vendor/PSScriptAnalyzer'
    $total = @($Batch | ForEach-Object { $_.Files.Count } | Measure-Object -Sum).Sum
    # Tracks the CPU, capped where process setup outweighs the work, never above the file count.
    $budget = [Math]::Min([Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10)), $total)

    $worker = {
        param($shardFiles, $root, $analyzer, $settingsPath, $includeRule, $excludeRule, $codeRoot)
        Import-Module $analyzer -Force
        # Read here, not passed in: job arguments are serialized and the parser wants its own types.
        $settings = Import-PowerShellDataFile $settingsPath
        # The rules the bundle ships are the ones that run: each entry resolves to the code root's rule folder by its leaf name.
        $settings.CustomRulePath = [string[]] @($settings.CustomRulePath | ForEach-Object {
                Join-Path $codeRoot ".scriptanalyzer/$([System.IO.Path]::GetFileName($_))"
            })
        if ($includeRule) {
            $settings.IncludeRules = [string[]] $includeRule
        }
        if ($excludeRule) {
            $settings.ExcludeRules = [string[]] (@($settings.ExcludeRules) + $excludeRule)
        }

        Push-Location $root
        # The analyzer draws its own progress bar, which the console rules ban.
        $savedProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        try {
            # Non-terminating analyzer errors fail the shard, so none drops its files' diagnostics.
            $err = $null
            $diagnostics = $shardFiles |
                Invoke-ScriptAnalyzer -Settings $settings -ErrorVariable err -ErrorAction SilentlyContinue
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

    # Each batch's share of the budget follows its file count; round-robin spreads the heavy modules.
    $jobs = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $Batch) {
        $shardCount = [Math]::Min($entry.Files.Count, [Math]::Max(1,
                [int][Math]::Round($budget * $entry.Files.Count / $total)))
        $shards = @(for ($i = 0; $i -lt $shardCount; $i++) {
                , [System.Collections.Generic.List[string]]::new()
            })
        for ($i = 0; $i -lt $entry.Files.Count; $i++) {
            $shards[$i % $shardCount].Add($entry.Files[$i])
        }
        foreach ($shard in $shards) {
            $job = Start-Job -ScriptBlock $worker -ArgumentList @($shard, $RepositoryRoot, $analyzerPath,
                $entry.SettingsPath, $entry.IncludeRule, $entry.ExcludeRule, $CodeRoot)
            $jobs.Add([pscustomobject]@{ Label = $entry.Label; Job = $job; Files = [string[]] $shard.ToArray(); Diagnostics = $null; Done = $false })
        }
    }

    # A dot per interval while shards run, never a progress bar.
    $dotted = $false
    try {
        # Each shard is received as it ends, so its result reaches the caller before the last shard is in.
        while ($true) {
            $pending = $false
            foreach ($item in $jobs) {
                if ($item.Done) {
                    continue
                }
                if ($item.Job.State -eq 'Completed') {
                    $item.Diagnostics = @(Receive-Job -Job $item.Job -ErrorAction Stop)
                    $item.Done = $true
                    if ($OnShardComplete) {
                        & $OnShardComplete -Label $item.Label -File $item.Files -Diagnostic $item.Diagnostics
                    }
                }
                elseif ($item.Job.State -in 'Failed', 'Stopped') {
                    $item.Done = $true
                }
                else {
                    $pending = $true
                }
            }
            if (-not $pending) {
                break
            }
            Write-Message '.' -NoHeader -NoNewline
            $dotted = $true
            Start-Sleep -Seconds 1
        }

        $ret = @{}
        foreach ($entry in $Batch) {
            $ret[$entry.Label] = [System.Collections.Generic.List[object]]::new()
        }
        foreach ($item in $jobs) {
            # A silently failed shard would let violations pass, so it fails loudly.
            if ($item.Job.State -ne 'Completed') {
                $reason = ($item.Job.ChildJobs.JobStateInfo.Reason.Message) -join '; '
                throw "PSScriptAnalyzer shard job $($item.Job.Id) ($($item.Label) pass) ended in state '$($item.Job.State)': $reason"
            }
            foreach ($diagnostic in @($item.Diagnostics)) {
                $ret[$item.Label].Add($diagnostic)
            }
        }
        $ret
    }
    finally {
        if ($dotted) {
            Write-Message '' -NoHeader   # newline to close the dot line
        }
        $jobs | ForEach-Object { $_.Job } | Remove-Job -Force
    }
}
