<#
---
catzc:
  immutable:
    with_body_sha: c0df781a81ee
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Test-ToolRequiresElevation.Tests.ps1
    docs: "[Test-ToolRequiresElevation.ps1.md](../../docs/references/pwsh/catzc-tooling-core/Test-ToolRequiresElevation.ps1.md)"
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
