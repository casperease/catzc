<#
.SYNOPSIS
    Spell-checks the repository's known file types with cspell and writes a report under out/.
.DESCRIPTION
    Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown, PowerShell,...
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-AUTO-CONSOLE#6](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console6)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment1)
.PARAMETER Path
    Repository-relative paths or globs to check (cspell expands a glob).
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment2)
.PARAMETER Exclude
    Globs the spelling QUALITY GATE skips, passed to cspell as --exclude.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment3)
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
        [string[]] $Path = @(
            '**/*.md'
            '**/*.ps1'
            '**/*.psm1'
            '**/*.psd1'
            '**/*.yml'
            '**/*.yaml'
            '**/*.json'
            '**/*.cs'
            '**/*.bicep'
            '**/*.go'
            '**/*.py'
        ),

        # Content the spelling quality gate does NOT check (authored/generated text, not third-party noise — that...
        # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment4)
        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            'infrastructure/templates/**/configuration/**'
            # Generated README copy-ins (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored and...
            # [ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)
            # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment5)
            '**/README.md'
            # is generated from adrs.yml (Build-AdrIndex) — a derived artifact; its source (adrs.yml + the...
            # [comment:6](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment6)
            'docs/adr/index.md'
            # is generated from the configs/glossary.yml sources (Build-Glossary) — likewise derived; the sources are...
            # [comment:7](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment7)
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

    $quotedPaths = foreach ($p in $Path) {
        "'$p'"
    }
    # Content-scope exclusions (out/, docs/notes, generated config trees) — cspell ignorePaths rejects negation...
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment8)
    $excludeArgs = foreach ($e in $Exclude) {
        "--exclude '$e'"
    }
    $command = (
        "cspell lint $($quotedPaths -join ' ') $($excludeArgs -join ' ') " +
        "--config '$configPath' --no-progress --no-color --relative"
    )

    # -Silent: capture cspell's output instead of streaming it to the console; the report prints the issues.
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent

    # cspell exit codes: 0 = clean, 1 = spelling issues found, >1 = tool error.
    if ($result.ExitCode -gt 1) {
        throw "cspell failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # cspell prints a summary ("Files checked: N, Issues found: M in K file(s)").
    # [comment:9](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment9)
    $checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')
    if ($result.ExitCode -ne 0 -and $checkedMatch.Success -and [int]$checkedMatch.Groups['n'].Value -eq 0) {
        throw "Test-Spelling matched no files for the given paths: $($Path -join ', ')."
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
