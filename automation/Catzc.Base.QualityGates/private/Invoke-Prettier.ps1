<#
.SYNOPSIS
    Runs Prettier over a set of globs and returns a structured result — the shared engine behind the
    Format-<language> formatters (Format-Markdown, Format-Pipelines).
.DESCRIPTION
    The one copy of "invoke Prettier and make sense of its output" (ADR-ONELIVE): mode selection
    (--write / --list-different / --check), the tool-missing guard, the >1 exit-code tool-error throw, ANSI
    stripping, and the per-mode changed-file parsing. Each public formatter is a thin wrapper that supplies
    its default -Glob and a -Label for the messages; the parsing and result shape live here, once.

    Applies the root .prettierrc.yml (Prettier auto-discovers it) — so printWidth/proseWrap and the per-type
    behaviour are the same whichever formatter calls in. Third-party trees (automation/.vendor/,
    node_modules/) are excluded by the root .prettierignore.

    Prettier must be on PATH — install it once with Install-Prettier (or: npm install -g prettier).
.PARAMETER Glob
    Globs/paths to format (already resolved by the caller — each formatter owns its default scope).
.PARAMETER Label
    The language label for the user-facing messages ('Markdown', 'Pipeline', …).
.PARAMETER Check
    Check-only mode — prettier --check (no write); names every unformatted file and keeps Prettier's
    [warn]/[error] diagnostics (surfaced via Warnings). -Check supersedes -DryRun if both are given.
.PARAMETER DryRun
    Do not write; list the files Prettier WOULD reformat (prettier --list-different). Quieter than -Check.
.OUTPUTS
    [pscustomobject] { ChangedCount, ChangedFiles, Warnings, DryRun, Check, ExitCode }
#>
function Invoke-Prettier {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Glob,

        [Parameter(Mandatory)]
        [string] $Label,

        [switch] $Check,

        [switch] $DryRun
    )

    $root = Get-RepositoryRoot
    $configPath = Join-Path $root '.prettierrc.yml'
    Assert-PathExist $configPath

    if (-not (Test-Command 'prettier')) {
        throw (
            'Prettier is not installed. Install it with:  Install-Prettier   (or: npm install -g prettier), ' +
            "then re-run the ${Label} formatter."
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
    # error here), >1 = tool error (e.g. a file Prettier cannot parse).
    $result = Invoke-Executable $command -PassThru -NoAssert -Silent
    if ($result.ExitCode -gt 1) {
        throw "Prettier failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # Strip the ANSI colour codes Prettier wraps around its [warn]/[error] tags, then split into lines.
    $plain = $result.Full -replace '\x1b\[[0-9;]*m', ''
    $lines = @($plain -split '\r?\n' | Where-Object { $_ })

    # The raw [warn]/[error] diagnostic lines. Prettier emits these only under --check; kept verbatim so
    # callers see exactly what Prettier reported (the file lines below are derived from them).
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
            Write-Message "All ${Label} is already formatted."
        }
        else {
            Write-Message "$($changed.Count) ${Label} file(s) are not formatted (run the ${Label} formatter to fix)."
        }
    }
    elseif ($DryRun) {
        if ($changed.Count -eq 0) {
            Write-Message "All ${Label} is already formatted."
        }
        else {
            Write-Message "$($changed.Count) ${Label} file(s) would be reformatted (run the ${Label} formatter)."
        }
    }
    else {
        if ($changed.Count -eq 0) {
            Write-Message "No ${Label} files needed reformatting."
        }
        else {
            Write-Message "Formatted $($changed.Count) ${Label} file(s)."
        }
    }

    [pscustomobject]@{
        ChangedCount = $changed.Count
        ChangedFiles = $changed
        Warnings     = $warnings
        DryRun       = [bool] $DryRun
        Check        = [bool] $Check
        ExitCode     = $result.ExitCode
    }
}
