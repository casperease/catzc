<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-CatzcRunMode.ps1
    name: get-catzc-run-mode
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-CatzcRunMode.Tests.ps1
    docs: "[Get-CatzcRunMode.ps1.md](docs/references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md)"
    cites:
      - ADR-DSGN-RUNMODE-MODEISDERIVED
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
