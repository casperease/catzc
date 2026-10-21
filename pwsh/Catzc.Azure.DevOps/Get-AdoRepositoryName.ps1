<#
---
catzc:
  immutable:
    with_body_sha: "1253b4c62171"
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Get-AdoRepositoryName.Tests.ps1
    docs: "[Get-AdoRepositoryName.ps1.md](docs/references/pwsh/catzc-azure-dev-ops/Get-AdoRepositoryName.ps1.md)"
    cites:
      - ADR-PWSH-PARAM-RESOLUTIONORDER
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
