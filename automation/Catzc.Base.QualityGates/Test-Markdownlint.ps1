<#
.SYNOPSIS
    Lints the repository's Markdown with markdownlint-cli2 and writes a report under out/.
.DESCRIPTION
    Runs markdownlint-cli2 over the repository's in-scope Markdown, applying the single root rule set at...
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md#comment1)
.PARAMETER Path
    Repository-relative paths or globs to lint (markdownlint-cli2 expands a glob).
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md#comment2)
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-markdownlint.
.PARAMETER PassThru
    Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, ExitCode }) instead of throwing.
.EXAMPLE
    Test-Markdownlint
.EXAMPLE
    $result = Test-Markdownlint -PassThru
    $result.IssueCount
#>
function Test-Markdownlint {
    [CmdletBinding()]
    param(
        [string[]] $Path = @(
            '**/*.md'
            '!out'
            '!automation/.vendor'
            '!**/.vendor'
            '!docs/notes'
            '!**/node_modules'
            # Generated READMEs (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored copies whose...
            # [ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)
            # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md#comment3)
            '!**/README.md'
            # is generated from adrs.yml (Build-AdrIndex) — a derived artifact whose source (adrs.yml + the...
            # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md#comment4)
            '!docs/adr/index.md'
            # is generated from the configs/glossary.yml sources (Build-Glossary) — likewise derived; the generator...
            # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md#comment5)
            '!docs/adr/glossary.md'
        ),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $configPath = Join-Path $root '.markdownlint.yml'
    Assert-PathExist $configPath

    if (-not (Test-Command 'markdownlint-cli2')) {
        throw (
            'markdownlint-cli2 is not installed. Install it with:  Install-Markdownlint   ' +
            '(or: npm install -g markdownlint-cli2), then re-run Test-Markdownlint.'
        )
    }

    $quotedPaths = foreach ($p in $Path) {
        "'$p'"
    }
    $command = "markdownlint-cli2 $($quotedPaths -join ' ')"

    # -Silent: capture markdownlint-cli2's output instead of streaming it to the console; the report prints the issues.
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent

    # markdownlint-cli2 exit codes: 0 = clean, 1 = lint violations found, >1 = tool error.
    if ($result.ExitCode -gt 1) {
        throw "markdownlint-cli2 failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # Violation lines look like:  path/to/file.md:12:5 MD013/line-length Line length [Expected: 140; ...]
    $issues = @($result.Full -split '\r?\n' | Where-Object { $_ -match ' MD\d{3}/' })
    if ($result.ExitCode -ne 0 -and $issues.Count -eq 0) {
        # A failing exit with no parsable violation line: the wording changed — report the raw output, never pass.
        $issues = @("markdownlint-cli2 exited $($result.ExitCode) with no parsable violation line: $($result.Full)")
    }

    $facts = [ordered]@{
        FileCount = @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count
        ExitCode  = $result.ExitCode
    }
    Write-QualityGateReport -Subject markdownlint -Title Test-Markdownlint -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
