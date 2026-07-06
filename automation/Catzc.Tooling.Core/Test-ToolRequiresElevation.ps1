<#
.SYNOPSIS
    Tests whether installing (or uninstalling) a tool on the current platform requires elevation.
.DESCRIPTION
    Answers the per-platform elevation question the provisioning loops skip-and-report on. A tool is
    elevation-bound when its tools.yml entry declares admin_only (a machine-scope installer on every
    platform, e.g. Microsoft.OpenJDK), or linux_admin_only while the session runs on Linux (the tool
    installs through apt-get, which needs root, while its Windows and macOS installs are user-space —
    node_js and terraform are this shape). Pure logic over the entry and the platform: it asks about
    the install path, never about whether the tool is present.
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
