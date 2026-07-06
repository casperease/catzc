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

    # The shared Prettier engine (private) owns the invocation, output parsing, and result shape; this
    # function is the Markdown-scoped wrapper — its default -Glob above and the 'Markdown' label.
    $result = Invoke-Prettier -Glob $Glob -Label 'Markdown' -Check:$Check -DryRun:$DryRun

    if ($PassThru) {
        return $result
    }
}
