<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-dev-ops/Get-AdoRepositoryName.ps1.md"
  header: "generated"
---
#>

function Get-AdoRepositoryName {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ($env:BUILD_REPOSITORY_NAME) {
        return $env:BUILD_REPOSITORY_NAME
    }
    Split-Path (Get-RepositoryRoot) -Leaf
}
