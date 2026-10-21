<#
---
catzc:
  immutable:
    with_body_sha: "05aef5dac1ab"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-CatzcRunMode.Tests.ps1
    docs: "[Get-CatzcRunMode.ps1.md](docs/references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md)"
    cites:
      - DDR-RUNMODE-MODEISDERIVED
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
