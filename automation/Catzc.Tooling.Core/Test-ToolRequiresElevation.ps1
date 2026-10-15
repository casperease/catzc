<#
.SYNOPSIS
    Tests whether installing (or uninstalling) a tool on the current platform requires elevation.
.DESCRIPTION
    Answers the per-platform elevation question the provisioning loops skip-and-report on.
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
