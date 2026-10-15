<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-RepositoryFile.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-PATH#7
---
#>

<#
.SYNOPSIS
    Returns the full, normalized path to a file relative to the repository root.
.DESCRIPTION
    Resolves against the repository root, not the working directory, so a leading './' never leaks into the result.
    [ADR-AUTO-PATH#7](/docs/adr/automation/path-representation.md#rule-adr-auto-path7)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-RepositoryFile.ps1.md#comment1)
.PARAMETER Path
    Relative path from the repository root.
.EXAMPLE
    Get-RepositoryFile 'importer.ps1'
#>
function Get-RepositoryFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Resolve-RepoPath $Path
}
