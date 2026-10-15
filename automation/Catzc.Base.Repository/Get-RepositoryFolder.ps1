<#
.SYNOPSIS
    Returns the full, normalized path to a folder relative to the repository root.
.DESCRIPTION
    A binding helper (see ): it takes a repo-relative path and returns the normalized absolute path to bind against —...
    [ADR-AUTO-PATH#7](/docs/adr/automation/path-representation.md#rule-adr-auto-path7)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-RepositoryFolder.ps1.md#comment1)
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
