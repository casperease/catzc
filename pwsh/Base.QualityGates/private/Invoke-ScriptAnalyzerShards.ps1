function Invoke-ScriptAnalyzerShards {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The analyzer import runs inside each background Start-Job shard process, never in this session')]
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [object[]] $Batch,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # The vendored analyzer ships inside the code tree, so it resolves from the code root.
    $analyzerPath = Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer'
    $total = @($Batch | ForEach-Object { $_.Files.Count } | Measure-Object -Sum).Sum
    # Tracks the CPU, capped where process setup outweighs the work, never above the file count.
    $budget = [Math]::Min([Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10)), $total)

    $worker = {
        param($shardFiles, $root, $analyzer, $settingsPath, $includeRule, $excludeRule)
        Import-Module $analyzer -Force
        # Read here, not passed in: job arguments are serialized and the parser wants its own types.
        $settings = Import-PowerShellDataFile $settingsPath
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
                $entry.SettingsPath, $entry.IncludeRule, $entry.ExcludeRule)
            $jobs.Add([pscustomobject]@{ Label = $entry.Label; Job = $job })
        }
    }

    # A dot per interval while shards run, never a progress bar.
    $dotted = $false
    try {
        # Poll for shard completion so the user sees the run is alive rather than a silent wait.
        while (@($jobs | Where-Object { $_.Job.State -notin 'Completed', 'Failed', 'Stopped' }).Count -gt 0) {
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
            foreach ($diagnostic in @(Receive-Job -Job $item.Job -ErrorAction Stop)) {
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
