<#
.SYNOPSIS
    Installs Poetry as an isolated uv tool.
.DESCRIPTION
    Skips when the right version is already on PATH, so reruns are safe; needs uv, which owns the isolated environment.
    [comment:1](/docs/references/automation/catzc-tooling-python/Install-Poetry.ps1.md#comment1)
.PARAMETER Version
    Poetry version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Replace an existing installation at the wrong version.
.EXAMPLE
    Install-Poetry
.EXAMPLE
    Install-Poetry -Version '2.0'
#>
function Install-Poetry {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'poetry').version,
        [switch] $Force
    )

    Install-UvTool -Tool 'poetry' -Version $Version -Force:$Force
}
