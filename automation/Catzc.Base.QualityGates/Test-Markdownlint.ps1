<#
.SYNOPSIS
    Lints the repository's Markdown with markdownlint-cli2 and writes a report under out/.
.DESCRIPTION
    Runs markdownlint-cli2 over the repository's in-scope Markdown, applying the single root rule set at
    /.markdownlint.yml (auto-discovered by markdownlint-cli2). Excludes transient and out-of-scope trees
    (out/, automation/.vendor/, node_modules/, docs/notes/) and the generated README copy-ins (**/README.md,
    a derived artifact linted at its docs/ source instead) via negation globs — markdownlint-cli2 does not
    apply .markdownlintignore to globs passed on the command line, so the exclusions are passed explicitly.
    The root .markdownlintignore mirrors these for the editor extension's benefit.

    Mirrors Test-Automation's reporting: each run writes a timestamped folder under out/test-markdownlint/
    (markdownlint.md), updates latest.txt, and prints the report path — rather than dumping every issue to
    the console. Throws when issues are found (so it can gate CI); -PassThru returns a result object instead.

    markdownlint-cli2 must be on PATH — install it once with Install-Markdownlint (or: npm install -g
    markdownlint-cli2).
.PARAMETER Glob
    Globs/paths to lint. Defaults to the repository's in-scope Markdown, with the out-of-scope trees excluded
    via '!'-negation globs.
.PARAMETER OutputFolder
    Base directory for the run report. Each run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/). Defaults to <out>/test-markdownlint.
.PARAMETER PassThru
    Return a result object ({ IssueCount, FileCount, ExitCode, ReportPath }) instead of throwing.
.EXAMPLE
    Test-Markdownlint
.EXAMPLE
    $result = Test-Markdownlint -PassThru
    $result.IssueCount
#>
function Test-Markdownlint {
    [CmdletBinding()]
    param(
        [string[]] $Glob = @(
            '**/*.md'
            '!out'
            '!automation/.vendor'
            '!docs/notes'
            '!**/node_modules'
            # Generated README links (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
            # links whose authored source under docs/ is what is linted — linting through the link would
            # double-report the source. See docs/adr/repository/generated-readmes.md (ADR-REPO-README:7).
            '!**/README.md'
            # docs/adr/index.md is generated from adrs.yml (Build-AdrIndex) — a derived artifact whose source
            # (adrs.yml + the generator's prose) is what is linted, not the projection.
            '!docs/adr/index.md'
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

    $quotedGlobs = foreach ($g in $Glob) {
        "'$g'"
    }
    $command = "markdownlint-cli2 $($quotedGlobs -join ' ')"

    # -Silent: capture markdownlint-cli2's output instead of streaming it to the console (no per-issue dump).
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent

    # markdownlint-cli2 exit codes: 0 = clean, 1 = lint violations found, >1 = tool error.
    if ($result.ExitCode -gt 1) {
        throw "markdownlint-cli2 failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # Violation lines look like:  path/to/file.md:12:5 MD013/line-length Line length [Expected: 140; ...]
    $issueLines = @($result.Full -split '\r?\n' | Where-Object { $_ -match ' MD\d{3}/' })
    $issueCount = $issueLines.Count
    $fileCount = @($issueLines | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count

    # Resolve the run directory — a timestamped subfolder under the report base (mirrors Test-Automation),
    # so each run's report is preserved and cleared with the rest of out/.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-markdownlint'
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDir = Join-Path $OutputFolder $stamp
    $i = 2
    while (Test-Path $runDir) {
        $runDir = Join-Path $OutputFolder "$stamp-$i"
        $i++
    }
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null

    # Write the markdown report — the issues land here, not on the console.
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# Markdownlint report')
    $lines.Add('')
    $lines.Add("- Generated: $stamp")
    if ($issueCount -eq 0) {
        $lines.Add('- Result: no markdownlint issues')
    }
    else {
        $lines.Add("- Issues: $issueCount across $fileCount file(s)")
        $lines.Add('')
        $lines.Add('## Issues')
        $lines.Add('')
        foreach ($line in $issueLines) {
            $lines.Add("- $line")
        }
    }
    Set-Content -Path (Join-Path $runDir 'markdownlint.md') -Value $lines -Encoding utf8
    Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8

    # Console — one line per file with its issue count; full per-issue detail is saved in the report.
    if ($issueCount -eq 0) {
        Write-Message 'No markdownlint issues found.'
    }
    else {
        $perFile = $issueLines |
            Group-Object -Property { ($_ -split ':')[0] } |
            Sort-Object @{ Expression = 'Count'; Descending = $true }, Name
        foreach ($file in $perFile) {
            Write-Message ('{0}: {1}' -f $file.Name, $file.Count) -NoHeader
        }
        Write-Message "$issueCount markdownlint issue(s) across $fileCount file(s)."
    }
    Write-Message "Markdownlint report: $runDir" -ForegroundColor Cyan -NoHeader

    if ($PassThru) {
        return [pscustomobject]@{
            IssueCount = $issueCount
            FileCount  = $fileCount
            ExitCode   = $result.ExitCode
            ReportPath = $runDir
        }
    }

    if ($result.ExitCode -ne 0) {
        throw "Test-Markdownlint failed: $issueCount markdownlint issue(s) found — see $runDir"
    }
}
