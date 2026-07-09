<#
.SYNOPSIS
    Spell-checks the repository's known file types with cspell and writes a report under out/.
.DESCRIPTION
    Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown,
    PowerShell, YAML, JSON, C#, and Bicep — applying the single repo dictionary at /cspell.yml.

    Mirrors Test-Automation's reporting: each run writes a timestamped folder under out/test-spelling/
    (spelling.md), updates latest.txt, and prints the report path — rather than dumping every issue to the
    console. Throws when issues are found (so it can gate CI); -PassThru returns a result object instead.

    cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).
.PARAMETER Glob
    Globs/paths to check. Defaults to the repository's known file types. cspell still applies the
    ignorePaths from cspell.yml.
.PARAMETER Exclude
    Globs the spelling GATE skips, passed to cspell as --exclude. Defaults to the authored/generated trees
    that are out of scope to spell-check (out/, docs/notes, the machine-derived configuration/**
    trees). Non-authored noise (vendor, install scripts, compiled output, binaries) lives in cspell.yml
    ignorePaths instead — this parameter is for content scope, not third-party noise.
.PARAMETER OutputFolder
    Base directory for the run report. Each run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/). Defaults to <out>/test-spelling.
.PARAMETER PassThru
    Return a result object ({ IssueCount, FileCount, ExitCode, ReportPath }) instead of throwing.
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

        # Content the spelling gate does NOT check (authored/generated text, not third-party noise — that
        # lives in cspell.yml ignorePaths). Passed to cspell as --exclude globs.
        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            'infrastructure/templates/**/configuration/**'
            # Generated README copy-ins (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
            # and their authored source under docs/ is what is spell-checked (mirrors Test-Markdownlint's
            # '!**/README.md'). Their banner embeds the source's kebab filename, which is not a word. See
            # docs/adr/repository/generated-readmes.md (ADR-REPO-README:7).
            '**/README.md'
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

    # -Silent: capture cspell's output instead of streaming it to the console (no per-issue screen dump).
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent

    # cspell exit codes: 0 = clean, 1 = spelling issues found, >1 = tool error.
    if ($result.ExitCode -gt 1) {
        throw "cspell failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # cspell prints an authoritative summary ("Files checked: N, Issues found: M in K file(s)"); parse that,
    # falling back to counting the per-issue detail lines if the wording ever changes. cspell globs are
    # relative to the working directory (the repo root here), so an empty match means a bad -Glob.
    $checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')
    $filesChecked = if ($checkedMatch.Success) {
        [int]$checkedMatch.Groups['n'].Value
    }
    else {
        -1
    }
    if ($result.ExitCode -ne 0 -and $filesChecked -eq 0) {
        throw "Test-Spelling matched no files for the given globs: $($Glob -join ', ')."
    }

    $issueLines = @($result.Full -split '\r?\n' | Where-Object { $_ -match ':\d+:\d+ - ' })
    $issuesMatch = [regex]::Match($result.Full, 'Issues found:\s*(?<issues>\d+)\s+in\s+(?<files>\d+)\s+files?')
    if ($issuesMatch.Success) {
        $issueCount = [int]$issuesMatch.Groups['issues'].Value
        $fileCount = [int]$issuesMatch.Groups['files'].Value
    }
    else {
        $issueCount = $issueLines.Count
        $fileCount = @($issueLines | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count
    }

    # Resolve the run directory — a timestamped subfolder under the report base (mirrors Test-Automation),
    # so each run's report is preserved and cleared with the rest of out/.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-spelling'
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
    $lines.Add('# Spelling report')
    $lines.Add('')
    $lines.Add("- Generated: $stamp")
    if ($issueCount -eq 0) {
        $lines.Add('- Result: no spelling issues')
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
    Set-Content -Path (Join-Path $runDir 'spelling.md') -Value $lines -Encoding utf8
    Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8

    # Console — one line per file with its issue count; full per-issue detail is saved in the report.
    if ($issueCount -eq 0) {
        Write-Message 'No spelling issues found.'
    }
    else {
        $perFile = $issueLines |
            Group-Object -Property { ($_ -split ':')[0] } |
            Sort-Object @{ Expression = 'Count'; Descending = $true }, Name
        foreach ($file in $perFile) {
            Write-Message ('{0}: {1}' -f $file.Name, $file.Count) -NoHeader
        }
        Write-Message "$issueCount spelling issue(s) across $fileCount file(s)."
    }
    Write-Message "Spelling report: $runDir" -ForegroundColor Cyan -NoHeader

    if ($PassThru) {
        return [pscustomobject]@{
            IssueCount = $issueCount
            FileCount  = $fileCount
            ExitCode   = $result.ExitCode
            ReportPath = $runDir
        }
    }

    if ($issueCount -gt 0) {
        # Name the offending words in the throw itself, so the failure is diagnosable from the message
        # alone (ADR-AUTO-CONSOLE:6) — the report still carries the full per-issue detail. An issue line reads
        # '<path>:<line>:<col> - Unknown word (word) [fix: (suggestion)]'; take the first parenthesized
        # token after the ' - ' separator.
        $issueWords = foreach ($issueLine in $issueLines) {
            $wordMatch = [regex]::Match($issueLine, ' - [^(]*\((?<word>[^)]+)\)')
            if ($wordMatch.Success) {
                $wordMatch.Groups['word'].Value
            }
        }
        $words = @($issueWords | Select-Object -Unique)
        $preview = @($words | Select-Object -First 5)
        $wordSummary = if ($preview.Count -eq 0) {
            ''
        }
        elseif ($words.Count -gt $preview.Count) {
            " — first $($preview.Count) misspelled words: $($preview -join ', '), ... $($words.Count - $preview.Count) more"
        }
        else {
            " — misspelled word(s): $($preview -join ', ')"
        }
        throw "Test-Spelling failed: $issueCount spelling issue(s) found$wordSummary — see $runDir"
    }
}
