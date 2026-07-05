<#
.SYNOPSIS
    Uninstalls uv.
.DESCRIPTION
    Removes the managed install via the platform package manager: winget (Windows) or brew (macOS).
    Delegates to Uninstall-Tool. Idempotent — skips if not installed.
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
