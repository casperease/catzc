<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md"
  warning: "Generated Header"
---
#>

function Get-CatzcRunMode {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $modulesRoot = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot)).TrimEnd('\', '/')
    $sourceRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) 'pwsh')).TrimEnd('\', '/')

    if ($modulesRoot -ieq $sourceRoot) {
        return 'source'
    }
    'build'
}
