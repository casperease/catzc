function Uninstall-Terraform {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'terraform' -Version $Version
}
