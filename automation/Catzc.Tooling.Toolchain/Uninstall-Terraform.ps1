<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Terraform.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
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
