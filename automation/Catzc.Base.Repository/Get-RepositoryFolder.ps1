<#
.SYNOPSIS
    Returns the full, normalized path to a folder relative to the repository root.
.DESCRIPTION
    A binding helper (see docs/adr/automation/path-representation.md#rule-adr-path7): it takes a
    repo-relative path and returns the normalized absolute path to bind against — '.\', '..', and mixed
    separators collapse, so a leading './' never leaks into the result. Resolution is against the
    repository root, not $PWD. Delegates to Resolve-RepoPath so the normalization lives in one place.
.PARAMETER Path
    Relative path from the repository root.
.EXAMPLE
    Get-RepositoryFolder 'automation/Catzc.Base.Repository'
#>
function Get-RepositoryFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Resolve-RepoPath $Path
}
