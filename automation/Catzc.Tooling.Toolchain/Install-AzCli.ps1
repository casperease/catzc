<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-AzCli.ps1
    kind: public-function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Installs the Azure CLI, user-space into a dedicated uv venv.
.DESCRIPTION
    A venv, not a uv tool shim: az's launcher runs the python beside it, so it needs its own interpreter.
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
