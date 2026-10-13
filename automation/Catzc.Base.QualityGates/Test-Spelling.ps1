<#
.SYNOPSIS
    Spell-checks the repository's known file types with cspell and writes a report under out/.
.DESCRIPTION
    Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown,
    PowerShell, YAML, JSON, C#, and Bicep — applying the single repo dictionary at /cspell.yml.

    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every
    cspell issue line ('<path>:<line>:<col> - Unknown word (<word>) …') is an issue, and the gate ends through
    Write-QualityGateReport, which writes out/test-spelling/, prints every issue, and throws once listing them all
    — so the misspelled words are named in the failure itself
    ([ADR-AUTO-CONSOLE#6](/docs/adr/automation/powershell/console-output-matters.md#rule-adr-auto-console6)).
    -PassThru returns the result object instead. A cspell tool error (exit > 1) or a scan that matched no files
    throws before the report: there is no verdict to report.

    cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).
.PARAMETER Glob
    Globs/paths to check. Defaults to the repository's known file types. cspell still applies the
    ignorePaths from cspell.yml.
.PARAMETER Exclude
    Globs the spelling QUALITY GATE skips, passed to cspell as --exclude. Defaults to the authored/generated trees
    that are out of scope to spell-check (out/, docs/notes, the machine-derived configuration/**
    trees). Non-authored noise (vendor, install scripts, compiled output, binaries) lives in cspell.yml
    ignorePaths instead — this parameter is for content scope, not third-party noise.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-spelling.
.PARAMETER PassThru
    Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, ExitCode }) instead of throwing.
.EXAMPLE
    Test-Spelling
.EXAMPLE
    $result = Test-Spelling -PassThru
    $result.IssueCount
#>
function Test-Spelling {
    [CmdletBinding()]
    param(
        [string[]] $Glob = @(
            '**/*.md'
            '**/*.ps1'
            '**/*.psm1'
            '**/*.psd1'
            '**/*.yml'
            '**/*.yaml'
            '**/*.json'
            '**/*.cs'
            '**/*.bicep'
        ),

        # Content the spelling quality gate does NOT check (authored/generated text, not third-party noise — that
        # lives in cspell.yml ignorePaths). Passed to cspell as --exclude globs.
        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            'infrastructure/templates/**/configuration/**'
            # Generated README copy-ins (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
            # and their authored source under docs/ is what is spell-checked (mirrors Test-Markdownlint's
            # '!**/README.md'). Their banner embeds the source's kebab filename, which is not a word. See
            # [ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7).
            '**/README.md'
            # [index](/docs/adr/index.md) is generated from adrs.yml (Build-AdrIndex) — a derived artifact; its source
            # (adrs.yml + the generator's prose) is what is reviewed, not the projection.
            'docs/adr/index.md'
            # [glossary](/docs/adr/glossary.md) is generated from the configs/glossary.yml sources (Build-Glossary) — likewise
            # derived; the sources are what is spell-checked.
            'docs/adr/glossary.md'
        ),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $configPath = Join-Path $root 'cspell.yml'
    Assert-PathExist $configPath

    if (-not (Test-Command 'cspell')) {
        throw (
            'cspell is not installed. Install it with:  Install-Cspell   (or: npm install -g cspell), ' +
            'then re-run Test-Spelling.'
        )
    }

    $quotedGlobs = foreach ($g in $Glob) {
        "'$g'"
    }
    # Content-scope exclusions (out/, docs/notes, generated config trees) — cspell ignorePaths rejects
    # negation globs, so the gate's content scope is expressed here as --exclude on the command line.
    $excludeArgs = foreach ($e in $Exclude) {
        "--exclude '$e'"
    }
    $command = (
        "cspell lint $($quotedGlobs -join ' ') $($excludeArgs -join ' ') " +
        "--config '$configPath' --no-progress --no-color --relative"
    )

    # -Silent: capture cspell's output instead of streaming it to the console; the report prints the issues.
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent

    # cspell exit codes: 0 = clean, 1 = spelling issues found, >1 = tool error.
    if ($result.ExitCode -gt 1) {
        throw "cspell failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # cspell prints a summary ("Files checked: N, Issues found: M in K file(s)"). cspell globs are relative to the
    # working directory (the repo root here), so an empty match means a bad -Glob.
    $checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')
    if ($result.ExitCode -ne 0 -and $checkedMatch.Success -and [int]$checkedMatch.Groups['n'].Value -eq 0) {
        throw "Test-Spelling matched no files for the given globs: $($Glob -join ', ')."
    }

    $issues = @($result.Full -split '\r?\n' | Where-Object { $_ -match ':\d+:\d+ - ' })
    if ($result.ExitCode -ne 0 -and $issues.Count -eq 0) {
        # A failing exit with no parsable issue line: the wording changed — report the raw output, never pass.
        $issues = @("cspell exited $($result.ExitCode) with no parsable issue line: $($result.Full)")
    }
    $issuesMatch = [regex]::Match($result.Full, 'Issues found:\s*(?<issues>\d+)\s+in\s+(?<files>\d+)\s+files?')
    $fileCount = if ($issuesMatch.Success) {
        [int]$issuesMatch.Groups['files'].Value
    }
    else {
        @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count
    }

    $facts = [ordered]@{
        FileCount = $fileCount
        ExitCode  = $result.ExitCode
    }
    Write-QualityGateReport -Subject spelling -Title Test-Spelling -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
