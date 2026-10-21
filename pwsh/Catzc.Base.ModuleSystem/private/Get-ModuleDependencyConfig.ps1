<#
---
catzc:
  immutable:
    with_body_sha: f7b9b5494457
  edges:
    docs: "[Get-ModuleDependencyConfig.ps1.md](docs/references/pwsh/catzc-base-modulesystem/private/Get-ModuleDependencyConfig.ps1.md)"
---
#>

function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
