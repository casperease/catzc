<#
.SYNOPSIS
    Quality gate: checks that every formatter would leave the repository unchanged.
.DESCRIPTION
    One gate for every formatter's check ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
    Each formatter runs in its report-only mode over its default scope, and every file it would change is one
    issue naming the file and the formatter that fixes it:

      Format-Markdown    the in-scope Markdown (Prettier, -Check)
      Format-Pipelines   the pipeline YAML, **/*.yaml (Prettier, -Check)
      Format-Automation  the checked PowerShell set (Invoke-Formatter + the .editorconfig rules, -DryRun)
      Format-Types       the C# type sources' file-scoped namespace (-DryRun): a missing or wrong one, and a
                         block-scoped one, which Format-Types cannot fix and the gate reports for a hand edit
      Format-Go          the Go test modules (gofmt -l, -DryRun); needs the managed go only when Go tests exist
      Format-Python      the Python test folders (ruff format --check, -DryRun); needs uv only when Python tests exist

    Collects every unformatted file and ends with Write-QualityGateReport: the report lands in
    out/test-formatting/, and the gate throws once listing every issue (or returns the result with -PassThru).
    The Prettier formatters need prettier on PATH and throw without it; the default scopes are the source tree,
    so the gate needs the source mode (Assert-SourceTree).
.PARAMETER Formatter
    Check only these formatters (default: every one).
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-formatting).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Formatters } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-Formatting
.EXAMPLE
    (Test-Formatting -Formatter Format-Pipelines -PassThru).Issues
#>
function Test-Formatting {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ValidateSet('Format-Markdown', 'Format-Pipelines', 'Format-Automation', 'Format-Types', 'Format-Go', 'Format-Python')]
        [string[]] $Formatter,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    # @() around the whole if: a one-formatter selection must stay an array (.Count under strict mode).
    $selected = @(if ($Formatter) {
            $Formatter
        }
        else {
            'Format-Markdown', 'Format-Pipelines', 'Format-Automation', 'Format-Types', 'Format-Go', 'Format-Python'
        })

    $issues = [System.Collections.Generic.List[string]]::new()
    # A formatter reports absolute or repository-relative paths; an issue names the repository-relative one.
    $addIssue = {
        param([string] $Path, [string] $Problem)
        $relative = if ([System.IO.Path]::IsPathRooted($Path)) {
            ConvertTo-RepoRelativePath $Path
        }
        else {
            $Path -replace '\\', '/'
        }
        $issues.Add("${relative}: $Problem")
    }

    # The Prettier formatters: -Check names every file Prettier would reformat.
    foreach ($name in 'Format-Markdown', 'Format-Pipelines') {
        if ($name -in $selected) {
            $result = & $name -Check -PassThru
            foreach ($file in @($result.ChangedFiles)) {
                & $addIssue $file "not formatted — run $name"
            }
        }
    }

    # The in-process formatters: -DryRun returns every file they would rewrite.
    if ('Format-Automation' -in $selected) {
        foreach ($file in @(Format-Automation -DryRun)) {
            & $addIssue $file 'not formatted — run Format-Automation'
        }
    }
    if ('Format-Types' -in $selected) {
        $types = Format-Types -DryRun -PassThru
        foreach ($file in @($types.ChangedFiles)) {
            & $addIssue $file 'not formatted — run Format-Types'
        }
        # A block-scoped namespace is the one drift Format-Types leaves alone: it needs a hand edit.
        foreach ($file in @($types.BlockScopedFiles)) {
            & $addIssue $file "block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
        }
    }
    if ('Format-Go' -in $selected) {
        foreach ($file in @((Format-Go -DryRun -PassThru).ChangedFiles)) {
            & $addIssue $file 'not formatted — run Format-Go'
        }
    }
    if ('Format-Python' -in $selected) {
        foreach ($file in @((Format-Python -DryRun -PassThru).ChangedFiles)) {
            & $addIssue $file 'not formatted — run Format-Python'
        }
    }

    Write-QualityGateReport -Subject formatting -Title Test-Formatting -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Formatters = $selected.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
