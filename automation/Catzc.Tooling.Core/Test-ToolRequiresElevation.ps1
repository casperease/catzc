<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Test-ToolRequiresElevation.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
---
#>

<#
.SYNOPSIS
    Tests whether installing (or uninstalling) a tool on the current platform requires elevation.
.DESCRIPTION
    Asks about the install path only, never whether the tool is present; linux_admin_only counts on Linux alone.
    [comment:1](/docs/references/automation/catzc-tooling-core/Test-ToolRequiresElevation.ps1.md#comment1)
.PARAMETER Config
    The tool's parsed tools.yml entry (from Get-ToolConfig).
.OUTPUTS
    [bool]
.EXAMPLE
    Test-ToolRequiresElevation (Get-ToolConfig -Tool node_js)
#>
function Test-ToolRequiresElevation {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if ($Config.admin_only) {
        return $true
    }
    [bool] ($IsLinux -and $Config.linux_admin_only)
}
