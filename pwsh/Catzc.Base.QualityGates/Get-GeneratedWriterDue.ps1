function Get-GeneratedWriterDue {
    <#
    .SYNOPSIS
        Says which generated-file writers a changed set makes due: the one reading of the inputs and outputs lists in generated-files.yml.
    .DESCRIPTION
        A writer is due when a path git reports changed matches one of its inputs or outputs globs, or when an output named without a wildcard
        is missing. A writer with neither list is due whenever anything changed, and HasLists tells the caller it has none (the import
        janitor runs such a writer as it always has). Test-GeneratedFiles -Changed and the import janitors both ask here, so what a writer
        depends on is declared once, in generated-files.yml.
    .PARAMETER ChangedPath
        The repository-relative paths that changed. Default: git's changed set against HEAD (Get-GitChangedPath).
    .PARAMETER RepositoryRoot
        The root a missing output is looked for under. Default: the repository root.
    .OUTPUTS
        [pscustomobject] @{ Name; Due; HasLists } per writer of generated-files.yml, in declaration order.
    .EXAMPLE
        Get-GeneratedWriterDue | Where-Object Due
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $ChangedPath = @(Get-GitChangedPath),

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $changed = [string[]] @($ChangedPath)
    foreach ($writer in (Get-Config -Config generated-files).writers.Values) {
        $inputs = @($writer.inputs | Where-Object { $_ })
        $outputs = @($writer.outputs | Where-Object { $_ })
        $due = $false
        foreach ($glob in @($inputs + $outputs)) {
            $pattern = [Catzc.Base.Globs.GlobPattern]::new($glob)
            foreach ($path in $changed) {
                if ($pattern.Matches($path)) {
                    $due = $true
                    break
                }
            }
            if ($due) {
                break
            }
        }
        if (-not $due) {
            foreach ($output in $outputs) {
                if ($output.IndexOfAny([char[]] '*?[') -lt 0 -and -not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $output))) {
                    $due = $true
                }
            }
        }
        $hasLists = ($inputs.Count + $outputs.Count) -gt 0
        if (-not $hasLists) {
            $due = $changed.Count -gt 0
        }
        [pscustomobject]@{ Name = $writer.name; Due = $due; HasLists = $hasLists }
    }
}
