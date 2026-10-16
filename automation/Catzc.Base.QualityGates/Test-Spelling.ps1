<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Spelling.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
    adrs:
      - ADR-AUTO-CONSOLE#6
      - ADR-AUTO-TEST#35
      - ADR-REPO-README#7
  config:
    synopsis: Spell-checks the repository's known file types with cspell and writes a report under out/.
    description: |-
      Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown,
      PowerShell, YAML, JSON, C#, and Bicep — applying the single repo dictionary at /cspell.yml.

      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every
      cspell issue line ('<path>:<line>:<col> - Unknown word (<word>) …') is an issue, and the gate ends through
      Write-QualityGateReport, which writes out/test-spelling/, prints every issue, and throws once listing them all
      — so the misspelled words are named in the failure itself
      ([ADR-AUTO-CONSOLE#6](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console6)).
      -PassThru returns the result object instead. A cspell tool error (exit > 1) or a scan that matched no files
      throws before the report: there is no verdict to report.

      cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).
    parameters:
      Path: |-
        Repository-relative paths or globs to check (cspell expands a glob). Defaults to the repository's known file types.
        cspell still applies the ignorePaths from cspell.yml.
      Exclude: |-
        Globs the spelling QUALITY GATE skips, passed to cspell as --exclude. Defaults to the authored/generated trees
        that are out of scope to spell-check (out/, docs/notes, the machine-derived configuration/**
        trees). Non-authored noise (vendor, install scripts, compiled output, binaries) lives in cspell.yml
        ignorePaths instead — this parameter is for content scope, not third-party noise.
        Content the spelling quality gate does NOT check (authored/generated text, not third-party noise — that
        lives in cspell.yml ignorePaths). Passed to cspell as --exclude globs.
      OutputFolder: The report base folder. Defaults to <out>/test-spelling.
      PassThru: Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, ExitCode }) instead of throwing.
    examples:
      - Test-Spelling
      - |-
        $result = Test-Spelling -PassThru
        $result.IssueCount
---
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

        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            '.unordered/**'
            'infrastructure/templates/**/configuration/**'
            '**/README.md'
            'docs/adr/index.md'
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

    $excludeArgs = foreach ($e in $Exclude) {
        "--exclude '$e'"
    }

    # Batches keep each command line short: one call with hundreds of paths overflows the OS command-line limit.
    $batchSize = 50
    $exitCode = 0
    $outputs = [System.Collections.Generic.List[string]]::new()
    for ($start = 0; $start -lt $Path.Count; $start += $batchSize) {
        $batch = @($Path[$start..([Math]::Min($start + $batchSize, $Path.Count) - 1)])
        $quotedPaths = foreach ($p in $batch) {
            "'$p'"
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

        $checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')
        if ($result.ExitCode -ne 0 -and $checkedMatch.Success -and [int]$checkedMatch.Groups['n'].Value -eq 0) {
            throw "Test-Spelling matched no files for the given paths: $($batch -join ', ')."
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
    $fileCount = @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count

    $facts = [ordered]@{
        FileCount = $fileCount
        ExitCode  = $exitCode
    }
    Write-QualityGateReport -Subject spelling -Title Test-Spelling -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
