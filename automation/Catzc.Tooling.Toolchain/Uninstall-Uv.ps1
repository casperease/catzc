# catzc:
#   path: automation/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1
#   module: Catzc.Tooling.Toolchain
#   visibility: public

<#
.SYNOPSIS
    Uninstalls uv.
.DESCRIPTION
    Idempotent through Uninstall-Tool, which skips when uv is not installed instead of failing.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Uninstall-Uv.ps1.md#comment1)
.PARAMETER Version
    uv version to uninstall. Defaults to the locked version in Get-ToolConfig.
.EXAMPLE
    Uninstall-Uv
#>
function Uninstall-Uv {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'uv' -Version $Version
}
