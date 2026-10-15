<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Uninstalls uv.
.DESCRIPTION
    Idempotent through Uninstall-Tool, which skips when uv is not installed instead of failing.
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
