<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Terraform.ps1.md"
  warning: "Generated Header"
---
#>

function Uninstall-Terraform {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'terraform' -Version $Version
}
