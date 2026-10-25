<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-git/Test-RepositorySnapshot.ps1.md"
  warning: "Generated Header"
---
#>

function Test-RepositorySnapshot {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0)]
        [string] $Path = (Get-RepositoryRoot)
    )

    [Catzc.Base.Git.GitWorkTree]::IsSnapshot($Path)
}
