<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1
    kind: gate-function
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Test-Markdownlint.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-README#7
  config:
    synopsis: Lints the repository's Markdown with markdownlint-cli2 and writes a report under out/.
    description: |-
      Runs markdownlint-cli2 over the repository's in-scope Markdown, applying the single root rule set at
      /.markdownlint.yml (auto-discovered by markdownlint-cli2). Excludes transient and out-of-scope trees
      (out/, automation/.vendor/ and every other .vendor/ tree, node_modules/, docs/notes/) and the generated README
      copy-ins (**/README.md, a derived artifact linted at its docs/ source instead) via negation globs — markdownlint-cli2 does not
      apply .markdownlintignore to globs passed on the command line, so the exclusions are passed explicitly.
      The root .markdownlintignore mirrors these for the editor extension's benefit.

      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every
      violation line ('<path>:<line>:<col> <rule id>/<rule name> …') is an issue, and the gate ends through
      Write-QualityGateReport, which writes out/test-markdownlint/, prints every issue, and throws once listing them
      all; -PassThru returns the result object instead. A tool error (exit > 1) throws before the report.

      markdownlint-cli2 must be on PATH — install it once with Install-Markdownlint (or: npm install -g
      markdownlint-cli2).
    parameters:
      Path: |-
        Repository-relative paths or globs to lint (markdownlint-cli2 expands a glob). Defaults to the repository's
        in-scope Markdown, with the out-of-scope trees excluded via '!'-negation globs.
      OutputFolder: The report base folder. Defaults to <out>/test-markdownlint.
      PassThru: Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, ExitCode }) instead of throwing.
    examples:
      - Test-Markdownlint
      - |-
        $result = Test-Markdownlint -PassThru
        $result.IssueCount
---
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
            '!.unordered'
            '!**/node_modules'
            '!**/README.md'
            '!docs/adr/index.md'
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

    # Batches keep each command line short; every batch carries all the '!' exclusions so each one is scoped alike.
    $exclusions = @($Path | Where-Object { $_.StartsWith('!') } | ForEach-Object { "'$_'" })
    $targets = @($Path | Where-Object { -not $_.StartsWith('!') })
    $batchSize = 50
    $exitCode = 0
    $outputs = [System.Collections.Generic.List[string]]::new()
    for ($start = 0; $start -lt $targets.Count; $start += $batchSize) {
        $batch = @($targets[$start..([Math]::Min($start + $batchSize, $targets.Count) - 1)])
        $quotedPaths = foreach ($p in $batch) {
            "'$p'"
        }
        $command = "markdownlint-cli2 $(@($quotedPaths) + $exclusions -join ' ')"

        # -Silent: capture markdownlint-cli2's output instead of streaming it to the console; the report prints the issues.
        $result = Invoke-Executable $command -PassThru -NoAssert -Silent

        # markdownlint-cli2 exit codes: 0 = clean, 1 = lint violations found, >1 = tool error.
        if ($result.ExitCode -gt 1) {
            throw "markdownlint-cli2 failed (exit $($result.ExitCode)): $($result.Full)"
        }
        $exitCode = [Math]::Max($exitCode, $result.ExitCode)
        $outputs.Add($result.Full)
    }
    $full = $outputs -join "`n"

    # Violation lines look like:  path/to/file.md:12:5 MD013/line-length Line length [Expected: 140; ...]
    $issues = @($full -split '\r?\n' | Where-Object { $_ -match ' MD\d{3}/' })
    if ($exitCode -ne 0 -and $issues.Count -eq 0) {
        # A failing exit with no parsable violation line: the wording changed — report the raw output, never pass.
        $issues = @("markdownlint-cli2 exited $exitCode with no parsable violation line: $full")
    }

    $facts = [ordered]@{
        FileCount = @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count
        ExitCode  = $exitCode
    }
    Write-QualityGateReport -Subject markdownlint -Title Test-Markdownlint -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
