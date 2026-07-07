<#
.SYNOPSIS
    Tests whether anything under the given repository paths differs from HEAD.
.DESCRIPTION
    A thin, read-only predicate over `git status --porcelain -- <paths>`: true when git reports any
    modified, new, or deleted entry under the paths, false when they match HEAD. This is the one
    "did these paths change?" question both the pathspec-limited committer (Invoke-GitCommit's
    idempotent no-op) and its policy callers (which paths deserve a commit at all) ask, so it lives
    in one function instead of two porcelain parses.

    Runs through Invoke-Executable -Silent: read-only, no console output, throws on a git failure.
.PARAMETER Path
    The repository-relative, '/'-separated paths (files or folders) to check.
.OUTPUTS
    [bool]
.EXAMPLE
    Test-GitPathChanged 'automation/.compiled'
.EXAMPLE
    Test-GitPathChanged 'automation/.compiled', 'out'
#>
function Test-GitPathChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path
    )

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $status = Invoke-Executable "git status --porcelain -- $($quotedPaths -join ' ')" -PassThru -Silent
    -not [string]::IsNullOrWhiteSpace($status.Output)
}
