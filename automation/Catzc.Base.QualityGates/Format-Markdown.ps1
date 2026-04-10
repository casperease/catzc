<#
.SYNOPSIS
    Formats the repository's Markdown with Prettier (the canonical Markdown formatter).
.DESCRIPTION
    Runs Prettier over the repository's in-scope Markdown, applying the root .prettierrc.yml — which pins
    printWidth 140 and proseWrap: always, so the formatter wraps prose to satisfy markdownlint MD013
    (line-length 140). Third-party noise (automation/.vendor/, node_modules/) is excluded by the root
    .prettierignore; the content the bulk formatter skips by default (out/, docs/notes — the same content
    scope the Test-Markdownlint / Test-Spelling gates use) is coded into the -Glob default as '!'-negation
    globs, NOT the root config. Pass -Glob to format those on demand (e.g. a plan under out/).

    This is the companion to Test-Markdownlint: Format-Markdown brings files INTO compliance with the
    style/format rules; Test-Markdownlint verifies them. Idempotent — re-running formats nothing new.

    Two first-class names for one command, neither deprecated. `Format-Markdown` is the generic
    house-convention name, matching the other formatters (Format-Automation, Format-Types) so the Markdown
    formatter is reachable the same way. `Invoke-MarkdownPrettier` is the precise `Invoke-<tool>` name for
    the engine — the accurate name when you mean specifically Prettier. The precise name routes through the
    generic (it is the alias), so the behaviour is identical whichever you call.

    Prettier must be on PATH — install it once with Install-Prettier (or: npm install -g prettier).
.PARAMETER Glob
    Globs/paths to format. Defaults to all Markdown minus the out-of-scope content trees (out/, docs/notes)
    via '!'-negation globs; Prettier additionally applies .prettierignore (vendor, node_modules).
.PARAMETER Check
    Check-only (verify) mode — do NOT write. Runs prettier --check, which names every unformatted file and
    keeps Prettier's [warn]/[error] diagnostics (surfaced via -PassThru's Warnings). This is the "report,
    change nothing" mode every formatter exposes (prettier --check, gofmt -l, black --check). Use it to gate
    CI or preview drift; -DryRun is the quieter variant that returns only the file list. -Check supersedes
    -DryRun if both are given.
.PARAMETER DryRun
    Do not write. List the files Prettier WOULD reformat (via prettier --list-different) and return them.
    Quieter than -Check: it returns the changed-file list without Prettier's [warn]/[error] diagnostics.
.PARAMETER PassThru
    Return a result object ({ ChangedCount, ChangedFiles, Warnings, DryRun, Check, ExitCode }) instead of
    only logging. Warnings carries Prettier's raw [warn]/[error] lines (populated under -Check).
.EXAMPLE
    Format-Markdown
.EXAMPLE
    Format-Markdown -DryRun -PassThru   # preview which files would change
.EXAMPLE
    Format-Markdown -Check -PassThru     # verify-only: surfaces Prettier's warnings, writes nothing
#>
function Format-Markdown {
    [CmdletBinding()]
    [Alias('Invoke-MarkdownPrettier')]
    param(
        # All Markdown minus the content the bulk formatter skips by default (out/, docs/notes — the same
        # content scope the gates use). Third-party noise (vendor, node_modules) lives in .prettierignore.
        [string[]] $Glob = @(
            '**/*.md'
            '!out'
            '!docs/notes'
        ),

        [switch] $Check,

        [switch] $DryRun,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $configPath = Join-Path $root '.prettierrc.yml'
    Assert-PathExist $configPath

    if (-not (Test-Command 'prettier')) {
        throw (
            'Prettier is not installed. Install it with:  Install-Prettier   (or: npm install -g prettier), ' +
            'then re-run Format-Markdown.'
        )
    }

    $quotedGlobs = foreach ($g in $Glob) {
        "'$g'"
    }
    # Mode select: --check verifies + keeps Prettier's [warn]/[error] diagnostics (no write);
    # --list-different is the quiet dry-run file list (no write); --write formats in place. -Check
    # supersedes -DryRun when both are given.
    $action = if ($Check) {
        '--check'
    }
    elseif ($DryRun) {
        '--list-different'
    }
    else {
        '--write'
    }
    $command = "prettier $action $($quotedGlobs -join ' ')"

    # Prettier exit codes: 0 = clean, 1 = files differ (expected under --check / --list-different, not an
    # error here), >1 = tool error (e.g. a Markdown file Prettier cannot parse).
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent
    if ($result.ExitCode -gt 1) {
        throw "Prettier failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # Strip the ANSI colour codes Prettier wraps around its [warn]/[error] tags, then split into lines.
    $plain = $result.Full -replace '\x1b\[[0-9;]*m', ''
    $lines = @($plain -split '\r?\n' | Where-Object { $_ })

    # The raw [warn]/[error] diagnostic lines. Prettier emits these only under --check; kept verbatim so
    # -PassThru callers see exactly what Prettier reported (the file lines below are derived from them).
    $warnings = @($lines | Where-Object { $_ -match '^\[(warn|error)\]' })

    if ($Check) {
        # --check prints "[warn] <path>" once per unformatted file, plus a "Checking formatting..." header
        # and a trailing "[warn] Code style issues found ..." / "All matched files ..." summary. The changed
        # files are the per-file [warn] lines with that summary line removed.
        $changed = foreach ($w in $warnings) {
            $path = ($w -replace '^\[(warn|error)\]\s*', '').Trim()
            if ($path -match '^(Code style issues|All matched files)') {
                continue
            }
            $path
        }
    }
    elseif ($DryRun) {
        # --list-different prints only the differing file paths, one per line (no [warn] prefix).
        $changed = @($lines | Where-Object { $_ -notmatch '^\[' })
    }
    else {
        # --write prints "<path> <ms>" or "<path> <ms> (unchanged)"; changed = lines without (unchanged).
        $fileLines = @($lines | Where-Object { $_ -notmatch '^\[' })
        $changedLines = @($fileLines | Where-Object { $_ -notmatch '\(unchanged\)' })
        $changed = foreach ($line in $changedLines) {
            ($line -replace '\s+\d+ms.*$', '').Trim()
        }
    }
    $changed = @($changed | Where-Object { $_ })

    if ($Check) {
        if ($changed.Count -eq 0) {
            Write-Message 'All Markdown is already formatted.'
        }
        else {
            Write-Message "$($changed.Count) Markdown file(s) are not formatted (run Format-Markdown to fix)."
        }
    }
    elseif ($DryRun) {
        if ($changed.Count -eq 0) {
            Write-Message 'All Markdown is already formatted.'
        }
        else {
            Write-Message "$($changed.Count) Markdown file(s) would be reformatted (run Format-Markdown)."
        }
    }
    else {
        if ($changed.Count -eq 0) {
            Write-Message 'No Markdown files needed reformatting.'
        }
        else {
            Write-Message "Formatted $($changed.Count) Markdown file(s)."
        }
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changed.Count
            ChangedFiles = $changed
            Warnings     = $warnings
            DryRun       = [bool] $DryRun
            Check        = [bool] $Check
            ExitCode     = $result.ExitCode
        }
    }
}
