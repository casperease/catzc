<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Uv.ps1.md"
  header: "generated"
---
#>

function Uninstall-Uv {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'uv' -Version $Version
}
