<#
.SYNOPSIS
    Spell-checks the repository's known file types with cspell and writes a report under out/.
.DESCRIPTION
    A scan that matched no files throws before the report, since there is no verdict to report.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-AUTO-CONSOLE#6](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console6)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment1)
.PARAMETER Path
    cspell still applies ignorePaths from cspell.yml, so an explicit path can still be skipped.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment2)
.PARAMETER Exclude
    Content scope only: non-authored noise such as vendor or compiled output belongs in cspell.yml ignorePaths.
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

        # Content scope, not third-party noise: that lives in cspell.yml ignorePaths.
        # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment4)
        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            '.unordered/**'
            'infrastructure/templates/**/configuration/**'
            # The gitignored copy double-reports its docs/ source, and its banner holds a kebab filename, not a word.
            # [ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)
            # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment5)
            '**/README.md'
            # Derived from adrs.yml, so its source and the generator prose are reviewed, not the projection.
            # [comment:6](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment6)
            'docs/adr/index.md'
            # Derived from the glossary sources, which are what is spell-checked.
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

    # cspell ignorePaths rejects negation globs, so the gate's content scope is passed as --exclude instead.
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment8)
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

        # cspell globs are relative to the working directory, so zero files checked means a bad -Path.
        # [comment:9](/docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md#comment9)
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
