<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-RepositoryFile.ps1.md"
  header: "generated"
---
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
