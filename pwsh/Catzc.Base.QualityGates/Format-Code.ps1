<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Format-Code.ps1
    name: format-code
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
    docs: "[Format-Code.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Format-Code.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING
      - ADR-PRIN-CONFIG
      - ADR-REPO-FORMAT-BASELINEISFLOOR
---
#>

function Format-Code {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.FormatResult])]
    param(
        [ArgumentCompleter({ Get-FileLanguage | Where-Object formatter | ForEach-Object name })]
        [string[]] $Language,

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
    $verb = $DryRun ? 'Checking' : 'Formatting'
    foreach ($engineGroup in @($selected | Group-Object -Property formatter)) {
        $engine = $engineGroup.Name
        $settings = if ($config.formatters.ContainsKey($engine)) {
            @($config.formatters[$engine].settings)
        }
        else {
            @()
        }
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

        Write-Message "$verb $($pending.Count) $(@($engineGroup.Group | ForEach-Object name) -join ', ') file(s) with $engine ($($split.CachedCount) unchanged since their last check)..."
        $changed = @(Invoke-FormatterEngine -Engine $engine -File $pending -DryRun:$DryRun | ForEach-Object { $_ })
        $changedSet = [System.Collections.Generic.HashSet[string]]::new([string[]] $changed, [System.StringComparer]::OrdinalIgnoreCase)

        if ($DryRun) {
            Update-ResultCache -Cache $cache -Key $split.Key -Checked $pending -Flagged $changed
        }
        else {
            Update-ResultCache -Cache $cache -Key $split.Key -Checked $pending -Stamp $stamp -RekeyFromDisk
        }

        foreach ($name in $languageFiles.Keys) {
            $files = $languageFiles[$name]
            $outcomes[$name] = [pscustomobject]@{
                Engine    = $engine
                Files     = $files
                Changed   = [System.Collections.Generic.List[string]]::new([string[]] @($files | Where-Object { $changedSet.Contains($_) }))
                Unfixable = [System.Collections.Generic.Dictionary[string, string]]::new()
            }
        }
    }

    $inScope = if ($Language) {
        @($selected | ForEach-Object name)
    }
    else {
        @($config.languages | ForEach-Object name)
    }
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

        # A step has its own cache file: one file passes through an engine and several steps, and the cache keeps one slot per file.
        $stepCachePath = Join-Path (Get-OutputRoot) "cache/format-code-$step.json"
        $stepCache = if ($NoCache) {
            @{}
        }
        else {
            Get-ResultCache -Path $stepCachePath
        }
        $split = Split-CachedFile -File $candidates -Cache $stepCache -Stamp $stamp -RepositoryRoot $root
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
        Write-Message "${name}: $($languageOutcome.Changed.Count) of $($languageOutcome.Files.Count) file(s) $($DryRun ? 'would change' : 'changed')."
        $results.Add([Catzc.Base.QualityGates.FormatResult]::new($name, $languageOutcome.Engine, [string[]] $languageOutcome.Files, $languageOutcome.Changed.ToArray(), [bool] $DryRun, $languageOutcome.Unfixable))
    }
    Save-ResultCache -Path $cachePath -Cache $cache

    if ($PassThru) {
        # One result per language, in the order the languages were selected.
        foreach ($entry in $selected) {
            $results | Where-Object { $_.Language -eq $entry.name }
        }
    }
}
