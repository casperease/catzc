<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/private/Get-ModuleDependencyConfig.ps1.md"
  warning: "Generated Header"
---
#>

function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
