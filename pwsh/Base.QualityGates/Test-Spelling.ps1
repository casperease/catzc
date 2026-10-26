<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-Spelling.ps1.md"
  header: "generated"
---
#>

function Test-Spelling {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path = @((Get-Config -Config languages).ExtensionsCheckedBy('Test-Spelling') | ForEach-Object { "**/*$_" }),

        [string[]] $Exclude = @(),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $configPath = [Catzc.Base.RootConfig.RootConfigFiles]::SpellingConfigPath($root)
    Assert-PathExist $configPath

    if (-not (Test-Command 'cspell')) {
        throw (
            'cspell is not installed. Install it with:  Install-Cspell   (or: npm install -g cspell), ' +
            'then re-run Test-Spelling.'
        )
    }

    $excludeArgs = foreach ($e in $Exclude) {
        "--exclude '$e'"
    }

    $groups = [System.Collections.Generic.List[string[]]]::new()
    $defaultScope = -not $PSBoundParameters.ContainsKey('Path')
    if ($defaultScope) {
        # One shard per extension glob, run side by side; a longer extension ending with a listed one (.accosted.yml) joins its shard.
        $extensions = @(foreach ($glob in $Path) {
                $glob -replace '^\*\*/\*', ''
            })
        $byShard = [ordered]@{}
        foreach ($glob in $Path) {
            $extension = $glob -replace '^\*\*/\*', ''
            $shard = $extensions | Where-Object { $extension.EndsWith($_, [System.StringComparison]::OrdinalIgnoreCase) } |
                Sort-Object Length | Select-Object -First 1
            if (-not $byShard.Contains($shard)) {
                $byShard[$shard] = [System.Collections.Generic.List[string]]::new()
            }
            $byShard[$shard].Add($glob)
        }
        foreach ($shard in $byShard.Values) {
            $groups.Add([string[]] $shard.ToArray())
        }
    }
    else {
        # Batches keep each command line short: one call with hundreds of paths overflows the OS command-line limit.
        $batchSize = 50
        for ($start = 0; $start -lt $Path.Count; $start += $batchSize) {
            $groups.Add([string[]] @($Path[$start..([Math]::Min($start + $batchSize, $Path.Count) - 1)]))
        }
    }
    $commands = @(foreach ($group in $groups) {
            $quotedPaths = foreach ($p in $group) {
                "'$p'"
            }
            # --dot reaches tracked files under dot folders; --gitignore keeps the untracked ones out.
            $command = (
                "cspell lint $($quotedPaths -join ' ') $($excludeArgs -join ' ') " +
                "--config '$configPath' --dot --gitignore --no-progress --no-color --relative"
            )
            # A default shard may match no file at all; the run as a whole still fails when nothing was checked.
            if ($defaultScope) {
                "$command --no-must-find-files"
            }
            else {
                $command
            }
        })

    $exitCode = 0
    $checked = 0
    $noSummary = $false
    $outputs = [System.Collections.Generic.List[string]]::new()
    # -Silent: capture cspell's output instead of streaming it to the console; the report prints the issues.
    foreach ($result in @(Invoke-ExecutableParallel -Command $commands -NoAssert -Silent)) {

        # cspell exit codes: 0 = clean, 1 = spelling issues found, >1 = tool error.
        if ($result.ExitCode -gt 1) {
            throw "cspell failed (exit $($result.ExitCode)): $($result.Full)"
        }

        # cspell's globs are root-relative, so no "Files checked" summary means a bad -Path.
        $checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')
        if ($checkedMatch.Success) {
            $checked += [int]$checkedMatch.Groups['n'].Value
        }
        else {
            # No summary line to count from: never read as zero files, and never covered by a later batch's count.
            $noSummary = $true
        }
        $exitCode = [Math]::Max($exitCode, $result.ExitCode)
        $outputs.Add($result.Full)
    }
    $full = $outputs -join "`n"

    $issues = @($full -split '\r?\n' | Where-Object { $_ -match ':\d+:\d+ - ' })
    if ($exitCode -ne 0 -and $issues.Count -eq 0) {
        # A failing exit with no parsable issue line: the wording changed — report the raw output, never pass.
        $issues = @("cspell exited $exitCode with no parsable issue line: $full")
    }
    if ($noSummary) {
        # An uncounted run proves nothing: the wording changed, or cspell stopped before its summary.
        $issues = @($issues) + "Test-Spelling could not count the files checked: cspell printed no 'Files checked' summary, so the run proves nothing."
    }
    elseif ($checked -eq 0) {
        # A run that spelled nothing proves nothing: a folder or a glob that matched no file is a finding, never a pass.
        $issues = @($issues) + "Test-Spelling checked no file: the paths matched no files to spell: $($Path -join ', ')."
    }
    $fileCount = @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count

    $facts = [ordered]@{
        FileCount = $fileCount
        ExitCode  = $exitCode
    }
    Write-QualityGateReport -Subject spelling -Title Test-Spelling -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
