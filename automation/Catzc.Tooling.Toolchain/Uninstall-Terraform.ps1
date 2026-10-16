<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Terraform.ps1
    name: uninstall-terraform
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Uninstalls Terraform via the platform package manager.
    parameters:
      Version: Terraform version to uninstall. Defaults to the locked version in Get-ToolConfig.
    examples:
      - Uninstall-Terraform
---
#>

function Uninstall-Terraform {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'terraform' -Version $Version
}
