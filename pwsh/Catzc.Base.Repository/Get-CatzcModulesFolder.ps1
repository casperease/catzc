<#
---
catzc:
  immutable:
    with_body_sha: ebe1c235990a
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-CatzcModulesFolder.Tests.ps1
    docs: "[Get-CatzcModulesFolder.ps1.md](../../docs/references/pwsh/catzc-base-repository/Get-CatzcModulesFolder.ps1.md)"
    cites:
      - ADR-AUTO-LAYERS
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
