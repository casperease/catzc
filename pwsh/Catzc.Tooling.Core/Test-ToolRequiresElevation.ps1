<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Test-ToolRequiresElevation.ps1.md"
  warning: "Generated Header"
---
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
