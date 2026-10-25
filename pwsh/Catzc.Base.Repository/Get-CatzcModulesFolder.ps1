<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-CatzcModulesFolder.ps1.md"
  header: "generated"
---
#>

function Get-CatzcModulesFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $relative = [System.IO.Path]::GetRelativePath((Get-RepositoryRoot), (Get-CatzcModulesRoot)) -replace '\\', '/'
    Assert-False ($relative -eq '..' -or $relative.StartsWith('../') -or [System.IO.Path]::IsPathRooted($relative)) `
        -ErrorText "Get-CatzcModulesFolder: the modules root '$(Get-CatzcModulesRoot)' lies outside the repository; only the source tree has a modules folder."
    $relative
}
