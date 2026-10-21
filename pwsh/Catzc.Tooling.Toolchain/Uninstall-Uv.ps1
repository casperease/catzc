<#
---
catzc:
  immutable:
    with_body_sha: ef362777b366
  edges:
    docs: "[Uninstall-Uv.ps1.md](../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Uv.ps1.md)"
---
#>

function Uninstall-Uv {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'uv' -Version $Version
}
