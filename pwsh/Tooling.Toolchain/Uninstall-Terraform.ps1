<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Terraform.ps1.md"
  header: "generated"
---
#>

function Uninstall-Terraform {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'terraform' -Version $Version
}
