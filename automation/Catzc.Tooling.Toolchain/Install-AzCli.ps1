<#
.SYNOPSIS
    Installs the Azure CLI, user-space via uv.
.DESCRIPTION
    Installs az as an isolated uv tool (`uv tool install azure-cli`) on every platform — user-space, no admin,
    with az's dependency graph kept off the shared toolchain Python. Requires uv (Install-UvTool asserts it).
    Idempotent — skips if the correct version is already on PATH.
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
        [string] $Version,
        [switch] $Force
    )

    Install-UvTool -Tool 'az_cli' -Version $Version -Force:$Force
}
