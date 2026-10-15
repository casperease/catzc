<#
.SYNOPSIS
    Formats the repository's files, each with the formatter engine languages.yml names for its file language.
.DESCRIPTION
    Adding a language on an existing engine is one line in languages.yml; a new engine is one adapter.
    [ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md),
    [ADR-REPO-FORMAT#4](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format4),
    [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md#comment1)
.PARAMETER Language
    Defaults to every language with a formatter; an undeclared or formatter-less language throws.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md#comment2)
.PARAMETER Path
    Files or folders to format (a folder: its tracked files). Defaults to every tracked file.
.PARAMETER DryRun
    Report which files would change without writing them.
.PARAMETER NoCache
    Check every file, ignoring the result cache (which is still refreshed).
.PARAMETER PassThru
    Return one Catzc.Base.QualityGates.FormatResult per language.
.OUTPUTS
    [Catzc.Base.QualityGates.FormatResult] With -PassThru only.
.EXAMPLE
    Format-Code
.EXAMPLE
    Format-Code -Language markdown -Path docs/adr/principles
.EXAMPLE
    (Format-Code -DryRun -PassThru).ChangedFiles
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
    foreach ($engineGroup in @($selected | Group-Object -Property formatter)) {
        $engine = $engineGroup.Name
        $settings = if ($config.engines.ContainsKey($engine)) {
            @($config.engines[$engine].settings)
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

        # The engine is silent for seconds on a whole-repository pass, hence this line before it starts.
        # [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)
        # [comment:3](/docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md#comment3)
        $verb = $DryRun ? 'Checking' : 'Formatting'
        Write-Message "$verb $($pending.Count) $(@($engineGroup.Group | ForEach-Object name) -join ', ') file(s) with $engine ($($split.CachedCount) unchanged since their last check)..."
        $changed = @(Invoke-FormatterEngine -Engine $engine -File $pending -DryRun:$DryRun | ForEach-Object { $_ })
        $changedSet = [System.Collections.Generic.HashSet[string]]::new([string[]] $changed, [System.StringComparer]::OrdinalIgnoreCase)

        # A dry run caches only files already formatted; a real run caches every file under its new bytes.
        # [comment:4](/docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md#comment4)
        if ($DryRun) {
            Update-ResultCache -Cache $cache -Key $split.Key -Checked $pending -Flagged $changed
        }
        else {
            Update-ResultCache -Cache $cache -Key $split.Key -Checked $pending -Stamp $stamp -RekeyFromDisk
        }

        foreach ($name in $languageFiles.Keys) {
            $files = $languageFiles[$name]
            $languageChanged = @($files | Where-Object { $changedSet.Contains($_) })
            foreach ($file in $languageChanged) {
                Write-Message "$($DryRun ? 'would format' : 'formatted'): $file"
            }
            Write-Message "${name}: $($languageChanged.Count) of $($files.Count) file(s) $($DryRun ? 'would change' : 'changed')."
            $results.Add([Catzc.Base.QualityGates.FormatResult]::new($name, $engine, [string[]] $files, [string[]] $languageChanged, [bool] $DryRun))
        }
    }
    Save-ResultCache -Path $cachePath -Cache $cache

    if ($PassThru) {
        # One result per language, in the order the languages were selected.
        foreach ($entry in $selected) {
            $results | Where-Object { $_.Language -eq $entry.name }
        }
    }
}
