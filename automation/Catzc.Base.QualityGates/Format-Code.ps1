<#
.SYNOPSIS
    Formats the repository's files, each with the formatter engine languages.yml names for its file language.
.DESCRIPTION
    Formatting is configured, not programmed ([ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)): the
    file-language registry (Catzc.Base.Languages configs/languages.yml) names each language's formatter engine —
    prettier, gofmt, ruff, psscriptanalyzer, dotnet-format, bicep — and this one command runs it. Supporting a language on an existing
    engine is one line in that file; a new engine is one adapter (Invoke-FormatterEngine).

    The files are every file git tracks, fixtures included, or the given -Path; vendored third-party code and contract
    assets (`catzc-contract`, byte-frozen) are never formatted (Get-FormatScope). Each file belongs to the language its extension names (Get-FileLanguage); a
    language without a formatter (`no_formatter:`) is left as it is. Each engine reads the repository's layout
    settings — .editorconfig, .prettierrc.yml, the analyzer settings, the pinned ruff configuration
    ([ADR-REPO-FORMAT#4](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format4)).

    For each language it announces how many files it checked and changed, and names every changed file. With
    -PassThru it returns one FormatResult per language; Test-Formatting runs it with -DryRun -PassThru.

    Without -Path it formats the source tree, so it throws in build mode (Assert-SourceTree); with -Path it formats
    the given files wherever they are (a built module manifest, for one).
.PARAMETER Language
    The file languages to format. Defaults to every language with a formatter. A language that is not declared, or
    has no formatter, throws.
.PARAMETER Path
    Files or folders to format (a folder: its tracked files). Defaults to every tracked file.
.PARAMETER DryRun
    Report which files would change without writing them.
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

        [switch] $PassThru
    )

    if (-not $Path) {
        Assert-SourceTree
    }
    $root = Get-RepositoryRoot
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

    foreach ($entry in $selected) {
        $files = @(if ($byLanguage.ContainsKey($entry.name)) {
                $byLanguage[$entry.name].ToArray()
            })
        # Announce before the engine runs: a whole-repository pass takes seconds and prints nothing until it ends
        # ([ADR-AUTO-CONSOLE#10](/docs/adr/automation/powershell/console-output-matters.md#rule-adr-auto-console10)).
        $verb = $DryRun ? 'Checking' : 'Formatting'
        Write-Message "$verb $($files.Count) $($entry.name) file(s) with $($entry.formatter)..."
        $changed = @(Invoke-FormatterEngine -Engine $entry.formatter -File $files -DryRun:$DryRun | ForEach-Object { $_ })
        foreach ($file in $changed) {
            Write-Message "$($DryRun ? 'would format' : 'formatted'): $file"
        }
        Write-Message "$($entry.name): $($changed.Count) of $($files.Count) file(s) $($DryRun ? 'would change' : 'changed')."

        if ($PassThru) {
            [Catzc.Base.QualityGates.FormatResult]::new($entry.name, $entry.formatter, [string[]] $files, [string[]] $changed, [bool] $DryRun)
        }
    }
}
