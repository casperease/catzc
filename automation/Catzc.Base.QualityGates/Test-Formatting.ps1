<#
.SYNOPSIS
    Quality gate: checks that every formatter would leave the repository unchanged.
.DESCRIPTION
    One gate for every formatter's check ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
    Each formatter runs in its report-only mode over its default scope, and every file it would change is one
    issue naming the file and the formatter that fixes it:

      Format-Markdown    the in-scope Markdown (Prettier, -Check)
      Format-Pipelines   the pipeline YAML, **/*.yaml (Prettier, -Check)
      Format-Automation  the gated PowerShell set (Invoke-Formatter + the .editorconfig rules, -DryRun)
      Format-Types       the C# type sources' file-scoped namespace (-DryRun)

    Collects every unformatted file and ends with Write-QualityGateReport: the report lands in
    out/test-formatting/, and the gate throws once listing every issue (or returns the result with -PassThru).
    The Prettier formatters need prettier on PATH and throw without it; the default scopes are the source tree,
    so the gate needs source mode (Assert-SourceTree).
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
        [ValidateSet('Format-Markdown', 'Format-Pipelines', 'Format-Automation', 'Format-Types')]
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
            'Format-Markdown', 'Format-Pipelines', 'Format-Automation', 'Format-Types'
        })

    $issues = [System.Collections.Generic.List[string]]::new()
    # A formatter reports absolute or repository-relative paths; an issue names the repository-relative one.
    $addUnformatted = {
        param([string] $Path, [string] $Name)
        $relative = if ([System.IO.Path]::IsPathRooted($Path)) {
            ConvertTo-RepoRelativePath $Path
        }
        else {
            $Path -replace '\\', '/'
        }
        $issues.Add("${relative}: not formatted — run $Name")
    }

    # The Prettier formatters: -Check names every file Prettier would reformat.
    foreach ($name in 'Format-Markdown', 'Format-Pipelines') {
        if ($name -in $selected) {
            $result = & $name -Check -PassThru
            foreach ($file in @($result.ChangedFiles)) {
                & $addUnformatted $file $name
            }
        }
    }

    # The in-process formatters: -DryRun returns every file they would rewrite.
    if ('Format-Automation' -in $selected) {
        foreach ($file in @(Format-Automation -DryRun)) {
            & $addUnformatted $file 'Format-Automation'
        }
    }
    if ('Format-Types' -in $selected) {
        foreach ($file in @((Format-Types -DryRun -PassThru).ChangedFiles)) {
            & $addUnformatted $file 'Format-Types'
        }
    }

    Write-QualityGateReport -Subject formatting -Title Test-Formatting -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Formatters = $selected.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
