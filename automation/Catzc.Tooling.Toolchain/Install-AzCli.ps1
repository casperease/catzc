<#
.SYNOPSIS
    Installs the Azure CLI, user-space into a dedicated uv venv.
.DESCRIPTION
    Installs az into its own uv venv (`uv venv` + `uv pip install azure-cli`) on every platform — user-space,
    no admin. az's launcher runs the python beside it, so it needs a venv with its own interpreter rather than
    a uv-tool shim. Requires uv. Idempotent — skips if the correct version is already on PATH.
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

    Install-UvVenvTool -Tool 'az_cli' -Version $Version -Force:$Force
}
