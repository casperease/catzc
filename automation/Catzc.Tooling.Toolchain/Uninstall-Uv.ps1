<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    visibility: public
  config:
    synopsis: Uninstalls uv.
    description: |-
      Removes the managed install via the platform package manager: winget (Windows) or brew (macOS).
      Delegates to Uninstall-Tool. Idempotent — skips if not installed.
    parameters:
      Version: uv version to uninstall. Defaults to the locked version in Get-ToolConfig.
    examples:
      - Uninstall-Uv
---
#>

function Uninstall-Uv {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'uv' -Version $Version
}
