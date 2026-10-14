<#
.SYNOPSIS
    Formats the repository's files, each with the formatter engine languages.yml names for its file language.
.DESCRIPTION
    Formatting is configured, not programmed ([ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)): the
    file-language registry (Catzc.Base.Languages configs/languages.yml) names each language's formatter engine —
    prettier, gofmt, ruff, psscriptanalyzer, dotnet-format, bicep — and this one command runs it. Supporting a
    language on an existing engine is one line in that file; a new engine is one adapter (Invoke-FormatterEngine).

    The files are every file git tracks, fixtures included, or the given -Path; vendored third-party code and contract
    assets (`catzc-contract`, byte-frozen) are never formatted (Get-FormatScope). Each file belongs to the language its
    extension names (Get-FileLanguage); a language without a formatter (`no_formatter:`) is left as it is. Each engine
    reads the repository's layout settings — .editorconfig, .prettierrc.yml, the analyzer settings, the pinned ruff
    configuration ([ADR-REPO-FORMAT#4](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format4)).

    Each engine runs once over the files of every selected language it formats, so a tool that starts slowly starts
    once. A result cache under out/ remembers, per file, that the engine last found it formatted, keyed on the file's
    SHA-256 and a stamp of the engine's settings files and the tool pins (Get-FormatEngineStamp): a file whose key still
    matches is not handed to the engine again, so a run after a small change checks only what changed
    ([ADR-AUTO-CACHE](/docs/adr/automation/caching.md)). A pipeline starts without the cache and checks everything;
    -NoCache does the same on a devbox.

    For each language it announces how many files it checked and changed, and names every changed file. With
    -PassThru it returns one FormatResult per language; Test-Formatting runs it with -DryRun -PassThru.

    Without -Path it formats the source tree, so it throws in build mode (Assert-SourceTree); with -Path it formats
    the given files wherever they are (a built module manifest, for one; files outside the repository are never
    cached).
.PARAMETER Language
    The file languages to format. Defaults to every language with a formatter. A language that is not declared, or
    has no formatter, throws.
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

        # Announce before the engine runs: a whole-repository pass takes seconds and prints nothing until it ends
        # ([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
        $verb = $DryRun ? 'Checking' : 'Formatting'
        Write-Message "$verb $($pending.Count) $(@($engineGroup.Group | ForEach-Object name) -join ', ') file(s) with $engine ($($split.CachedCount) unchanged since their last check)..."
        $changed = @(Invoke-FormatterEngine -Engine $engine -File $pending -DryRun:$DryRun | ForEach-Object { $_ })
        $changedSet = [System.Collections.Generic.HashSet[string]]::new([string[]] $changed, [System.StringComparer]::OrdinalIgnoreCase)

        # A file the engine left formatted is recorded; under -DryRun a file it would still change is not. Writing,
        # the engine has just formatted every file, so each is recorded under the key of its bytes now.
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
