<#
---
catzc:
  immutable:
    with_body_sha: c98632fb4bc4
  edges:
    docs: "[Uninstall-Terraform.ps1.md](../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Terraform.ps1.md)"
---
#>

function Uninstall-Terraform {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'terraform' -Version $Version
}
