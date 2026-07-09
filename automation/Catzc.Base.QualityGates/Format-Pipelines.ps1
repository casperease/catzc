<#
.SYNOPSIS
    Formats the repository's Azure Pipelines YAML with Prettier (the canonical YAML formatter).
.DESCRIPTION
    Runs Prettier over the repository's ADO pipeline YAML, applying the root .prettierrc.yml. Scope is
    every `**/*.yaml` — the pipeline-naming ADR (ADR-PIPE-NAME:6) makes `.yaml` the executable-artifact
    extension (pipelines and template fragments) and `.yml` config data our code parses, so `.yaml` is
    exactly the ADO-pipeline set and `.yml` config is deliberately out of scope. Third-party noise
    (automation/.vendor/, node_modules/) is excluded by the root .prettierignore.

    This is the companion to Assert-Pipelines (naming/placement) the way Format-Markdown pairs with
    Test-Markdownlint: Format-Pipelines brings the YAML INTO Prettier's deterministic shape; Format-Pipelines
    -Check verifies it. Idempotent — re-running formats nothing new. It shares the one Prettier engine
    (Invoke-Prettier) with Format-Markdown, so its modes and result shape are identical.

    Two first-class names for one command, neither deprecated. `Format-Pipelines` is the generic
    house-convention name, matching the other formatters (Format-Markdown, Format-Automation, Format-Types).
    `Invoke-PipelinePrettier` is the precise `Invoke-<tool>` name for the engine — the accurate name when you
    mean specifically Prettier. The precise name routes through the generic (it is the alias), so the
    behaviour is identical whichever you call.

    Prettier must be on PATH — install it once with Install-Prettier (or: npm install -g prettier).
.PARAMETER Glob
    Globs/paths to format. Defaults to all ADO pipeline YAML (`**/*.yaml`); Prettier additionally applies
    .prettierignore (vendor, node_modules).
.PARAMETER Check
    Check-only (verify) mode — do NOT write. Runs prettier --check, which names every unformatted file and
    keeps Prettier's [warn]/[error] diagnostics (surfaced via -PassThru's Warnings). This is the gate mode
    (wired into Test-Automation L2). -Check supersedes -DryRun if both are given.
.PARAMETER DryRun
    Do not write. List the files Prettier WOULD reformat (via prettier --list-different) and return them.
    Quieter than -Check: it returns the changed-file list without Prettier's [warn]/[error] diagnostics.
.PARAMETER PassThru
    Return a result object ({ ChangedCount, ChangedFiles, Warnings, DryRun, Check, ExitCode }) instead of
    only logging. Warnings carries Prettier's raw [warn]/[error] lines (populated under -Check).
.EXAMPLE
    Format-Pipelines
.EXAMPLE
    Format-Pipelines -Check -PassThru     # verify-only: surfaces Prettier's warnings, writes nothing
#>
function Format-Pipelines {
    [CmdletBinding()]
    [Alias('Invoke-PipelinePrettier')]
    param(
        # All ADO pipeline YAML. `.yaml` is the executable-artifact extension (ADR-PIPE-NAME:6), so this is the
        # pipeline set; `.yml` config data is out of scope. Third-party noise lives in .prettierignore.
        [string[]] $Glob = @('**/*.yaml'),

        [switch] $Check,

        [switch] $DryRun,

        [switch] $PassThru
    )

    # The shared Prettier engine (private) owns the invocation, output parsing, and result shape; this
    # function is the pipeline-scoped wrapper — its default -Glob above and the 'Pipeline' label.
    $result = Invoke-Prettier -Glob $Glob -Label 'Pipeline' -Check:$Check -DryRun:$DryRun

    if ($PassThru) {
        return $result
    }
}
