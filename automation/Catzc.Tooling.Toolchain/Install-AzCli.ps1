<#
.SYNOPSIS
    Installs the Azure CLI, user-space into a dedicated uv venv.
.DESCRIPTION
    Installs az into its own uv venv (`uv venv` + `uv pip install azure-cli`) on every platform — user-space, no admin.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Install-AzCli.ps1.md#comment1)
.PARAMETER Version
    Azure CLI version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-AzCli
.EXAMPLE
    Install-AzCli -Version '2.74'
#>
function Install-AzCli {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'az_cli').version,
        [switch] $Force
    )

    Install-UvVenvTool -Tool 'az_cli' -Version $Version -Force:$Force
}
