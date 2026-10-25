<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-RepositoryFolder.ps1.md"
  warning: "Generated Header"
---
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
