<#
.SYNOPSIS
    Returns the full, normalized path to a folder relative to the repository root.
.DESCRIPTION
    Resolves against the repository root, not the working directory, so a leading './' never leaks into the result.
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
