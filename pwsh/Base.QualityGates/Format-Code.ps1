function Format-Code {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.FormatResult])]
    param(
        [ArgumentCompleter({ Get-FileLanguage | Where-Object formatter | ForEach-Object name })]
        [string[]] $Language,

        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [switch] $DryRun,

        [switch] $NoCache,

        [switch] $PassThru
    )

    if (-not $Path) {
        Assert-SourceTree
    }
    $root = [System.IO.Path]::GetFullPath((Get-RepositoryRoot))
    $config = Get-Config -Config languages

    $selected = @(if ($Language) {
            foreach ($name in $Language) {
                $match = @($config.languages | Where-Object { $_.name -ceq $name })
                Assert-True ($match.Count -eq 1) -ErrorText "Format-Code: unknown file language '$name' (languages.yml declares: $(@($config.languages | ForEach-Object name) -join ', '))."
                Assert-True ([bool] $match[0].formatter) -ErrorText "Format-Code: the file language '$name' has no formatter ($($match[0].no_formatter))."
                $match[0]
            }
        }
        else {
            $config.languages | Where-Object { $_.formatter }
        })

    $byLanguage = @{}
    # Get-FormatScope returns its paths as one array: assign it, so foreach walks the paths, not the array.
    $scope = Get-FormatScope -RepositoryRoot $root -Path $Path
    foreach ($file in $scope) {
        $fileLanguage = $config.ForPath($file)
        if ($null -ne $fileLanguage) {
            if (-not $byLanguage.ContainsKey($fileLanguage.name)) {
                $byLanguage[$fileLanguage.name] = [System.Collections.Generic.List[string]]::new()
            }
            $byLanguage[$fileLanguage.name].Add($file)
        }
    }

    $cachePath = Join-Path (Get-OutputRoot) 'cache/format-code.json'
    $cache = if ($NoCache) {
        @{}
    }
    else {
        Get-ResultCache -Path $cachePath
    }

    $results = [System.Collections.Generic.List[object]]::new()
    $outcomes = [ordered]@{}
    $wrapFree = @{}
    $verb = $DryRun ? 'Checking' : 'Formatting'
    foreach ($engineGroup in @($selected | Group-Object -Property formatter)) {
        $engine = $engineGroup.Name
        $settings = @(if ($config.formatters.ContainsKey($engine)) {
                @($config.formatters[$engine].settings)
            }
            else {
                @()
            })
        $stamp = Get-FormatEngineStamp -Engine $engine -Settings $settings -RepositoryRoot $root

        $languageFiles = [ordered]@{}
        $engineFiles = [System.Collections.Generic.List[string]]::new()
        foreach ($entry in $engineGroup.Group) {
            $files = @(if ($byLanguage.ContainsKey($entry.name)) {
                    $byLanguage[$entry.name].ToArray()
                })
            $languageFiles[$entry.name] = $files
            $engineFiles.AddRange([string[]] $files)
        }
        $split = Split-CachedFile -File $engineFiles.ToArray() -Cache $cache -Stamp $stamp -RepositoryRoot $root
        $pending = @($split.Pending)

        # Announced before the engine runs, since a whole-repository pass is silent for seconds.
        Write-Message "$verb $($pending.Count) $(@($engineGroup.Group | ForEach-Object name) -join ', ') file(s) with $engine ($($split.CachedCount) unchanged since their last check)..."
        # The text before the engine, whitespace collapsed, tells a change of content from a change of wrapping alone.
        if (-not $DryRun) {
            foreach ($file in $pending) {
                $wrapFree[$file] = Get-WrapFreeStamp -Path $file
            }
        }
        # An engine answers with the changed paths, plus a { Path, Problem } for each file it could not format at all.
        $answer = @(Invoke-FormatterEngine -Engine $engine -File $pending -DryRun:$DryRun | ForEach-Object { $_ })
        $changed = [string[]] @($answer | Where-Object { $_ -is [string] })
        $problems = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($item in @($answer | Where-Object { $_ -isnot [string] })) {
            $problems[[System.IO.Path]::GetFullPath($item.Path)] = $item.Problem
        }
        $changedSet = [System.Collections.Generic.HashSet[string]]::new($changed, [System.StringComparer]::OrdinalIgnoreCase)

        # A file left formatted is recorded; under -DryRun one it would still change is not.
        if ($DryRun) {
            Update-ResultCache -Cache $cache -Key $split.Key -Checked $pending -Flagged @(@($changed) + @($problems.Keys))
        }
        else {
            Update-ResultCache -Cache $cache -Key $split.Key -Checked @($pending | Where-Object {
                    -not $problems.ContainsKey([System.IO.Path]::GetFullPath($_)) }) -Stamp $stamp -RekeyFromDisk
        }

        foreach ($name in $languageFiles.Keys) {
            $files = $languageFiles[$name]
            $outcomes[$name] = [pscustomobject]@{
                Engine    = $engine
                Files     = $files
                Changed   = [System.Collections.Generic.List[string]]::new([string[]] @($files | Where-Object { $changedSet.Contains($_) }))
                Unfixable = [System.Collections.Generic.Dictionary[string, string]]::new()
            }
            foreach ($file in $files) {
                $full = [System.IO.Path]::GetFullPath($file)
                if ($problems.ContainsKey($full)) {
                    $outcomes[$name].Unfixable[$file] = $problems[$full]
                }
            }
        }
    }

    # Imprint steps run after every formatter, so no step works on text a formatter will rewrite.
    $inScope = @(if ($Language) {
            @($selected | ForEach-Object name)
        }
        else {
            @($config.languages | ForEach-Object name)
        })
    $plan = [ordered]@{}
    foreach ($step in $config.imprint) {
        $plan[$step] = [System.Collections.Generic.List[string]]::new([string[]] $inScope)
    }
    foreach ($entry in @($config.languages | Where-Object { $_.name -in $inScope })) {
        foreach ($step in $entry.imprint) {
            if (-not $plan.Contains($step)) {
                $plan[$step] = [System.Collections.Generic.List[string]]::new()
            }
            $plan[$step].Add($entry.name)
        }
    }
    foreach ($step in $plan.Keys) {
        $covered = $plan[$step]
        # Get-ImprintStepFile returns its paths as one array: assign it, so the pipeline walks the paths, not the array.
        $stepFiles = Get-ImprintStepFile -Step $step -RepositoryRoot $root -Path $Path
        $candidates = @($stepFiles | Where-Object {
                $owner = $config.ForPath($_)
                $null -ne $owner -and $owner.name -in $covered
            })
        $stamp = Get-FormatEngineStamp -Engine "imprint:$step" -Settings @($config.steps[$step].settings) -RepositoryRoot $root

        # One cache file per step: a file passes several steps, and a cache keeps one slot per file.
        $stepCachePath = Join-Path (Get-OutputRoot) "cache/format-code-$step.json"
        $stepCache = if ($NoCache) {
            @{}
        }
        else {
            Get-ResultCache -Path $stepCachePath
        }
        # The file-meta step's verdict also reads the files beside each file, so their stamp joins its key.
        $fileStamp = if ($step -ceq 'file-meta') {
            Get-FileMetaInputStamp -File $candidates -RepositoryRoot $root
        }
        elseif ($step -ceq 'plan-counts') {
            # The plans' open-step counts join this step's key.
            $stamps = @{}
            foreach ($candidate in $candidates) {
                $counts = Get-PlanOpenStepCount ([System.IO.Path]::GetDirectoryName($candidate)) -Config (Get-Config -Config plans)
                $stamps[$candidate] = @($counts.Keys | ForEach-Object { "${_}=$($counts[$_])" }) -join ';'
            }
            $stamps
        }
        else {
            @{}
        }
        $split = Split-CachedFile -File $candidates -Cache $stepCache -Stamp $stamp -RepositoryRoot $root -FileStamp $fileStamp
        $pending = @($split.Pending)
        Write-Message "$verb $($pending.Count) file(s) with the $step imprint step ($($split.CachedCount) unchanged since their last check)..."
        $outcome = Invoke-ImprintStep -Step $step -File $pending -RepositoryRoot $root -DryRun:$DryRun
        $unfixable = @($outcome.Unfixable.Keys)

        # A file a person must still repair is never recorded as done, so the next run reports it again.
        if ($DryRun) {
            Update-ResultCache -Cache $stepCache -Key $split.Key -Checked $pending -Flagged @(@($outcome.Changed) + $unfixable)
        }
        else {
            Update-ResultCache -Cache $stepCache -Key $split.Key -Checked @($pending | Where-Object { $_ -notin $unfixable }) -Stamp $stamp -RekeyFromDisk
        }
        Save-ResultCache -Path $stepCachePath -Cache $stepCache

        foreach ($file in @($outcome.Changed) + $unfixable) {
            $owner = $config.ForPath($file)
            if ($null -eq $owner -or -not $outcomes.Contains($owner.name)) {
                Write-Message "$($DryRun ? 'would format' : 'formatted'): $file"
                continue
            }
            if ($file -in @($outcome.Changed) -and -not $outcomes[$owner.name].Changed.Contains($file)) {
                $outcomes[$owner.name].Changed.Add($file)
            }
            if ($outcome.Unfixable.ContainsKey($file)) {
                $outcomes[$owner.name].Unfixable[$file] = $outcome.Unfixable[$file]
            }
        }
    }

    foreach ($name in $outcomes.Keys) {
        $languageOutcome = $outcomes[$name]
        foreach ($file in $languageOutcome.Changed) {
            Write-Message "$($DryRun ? 'would format' : 'formatted'): $file"
        }
        foreach ($file in $languageOutcome.Unfixable.Keys) {
            Write-Message "needs a hand edit: $file — $($languageOutcome.Unfixable[$file])" -Warning
        }
        $kinds = ''
        if (-not $DryRun -and $languageOutcome.Changed.Count -gt 0) {
            $wrapOnly = @($languageOutcome.Changed | Where-Object {
                    $before = $wrapFree[$_]
                    $null -ne $before -and $before -ceq (Get-WrapFreeStamp -Path $_)
                }).Count
            $kinds = " ($($languageOutcome.Changed.Count - $wrapOnly) in content, $wrapOnly only in wrapping)"
        }
        Write-Message "${name}: $($languageOutcome.Changed.Count) of $($languageOutcome.Files.Count) file(s) $($DryRun ? 'would change' : 'changed')$kinds."
        $results.Add([Catzc.Base.QualityGates.FormatResult]::new($name, $languageOutcome.Engine,
                [string[]] $languageOutcome.Files, $languageOutcome.Changed.ToArray(), [bool] $DryRun,
                $languageOutcome.Unfixable))
    }
    Save-ResultCache -Path $cachePath -Cache $cache

    if ($PassThru) {
        # One result per language, in the order the languages were selected.
        foreach ($entry in $selected) {
            $results | Where-Object { $_.Language -eq $entry.name }
        }
    }
}
