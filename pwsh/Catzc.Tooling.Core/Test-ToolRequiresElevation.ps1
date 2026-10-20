<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Test-ToolRequiresElevation.ps1
    name: test-tool-requires-elevation
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Test-ToolRequiresElevation.Tests.ps1
    docs: "[Test-ToolRequiresElevation.ps1.md](docs/references/pwsh/catzc-tooling-core/Test-ToolRequiresElevation.ps1.md)"
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
