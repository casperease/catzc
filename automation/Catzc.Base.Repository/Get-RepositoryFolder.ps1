<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-PATH#7
---
#>

<#
.SYNOPSIS
    Returns the full, normalized path to a folder relative to the repository root.
.DESCRIPTION
    Resolves against the repository root, not the working directory, so a leading './' never leaks into the result.
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
