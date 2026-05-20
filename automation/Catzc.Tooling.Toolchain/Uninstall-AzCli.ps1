<#
.SYNOPSIS
    Uninstalls the Azure CLI.
.DESCRIPTION
    Removes the managed install via the platform package manager: brew (macOS), winget (Windows), or
    apt-get (Linux — the official install script registered azure-cli with dpkg). Delegates to Uninstall-Tool.
    Idempotent — skips if not installed. For an Azure CLI installed outside the tooling system, use Remove-AzCli.
.PARAMETER Version
    Azure CLI version to uninstall. Defaults to the locked version in Get-ToolConfig.
.EXAMPLE
    Uninstall-AzCli
.EXAMPLE
    Uninstall-AzCli -Version '2.74'
#>
function Uninstall-AzCli {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'az_cli' -Version $Version
}
